--script for https://promodj.com/radio/ (03/10/2019)

--load images from local disc - '', source - 1, cloud.mail.ru - 2 
local source = 1
-----------------------------------

   local UpdateID='PromoDJ_R01'

--------------------------------------------------------------------------
 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.108 Safari/537.36 OPR/50.0.2762.45")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)
--INTERNET_FLAG_SECURE
m_simpleTV.WinInet.SetOpenRequestFlags(session, 0x00800000 + 0x00002000 + 0x00001000)
-------------------------------------------

  m_simpleTV.OSD.ShowMessage("PromoDJ: start updating" ,0xFF00,10)

local weblink_view = ''

if source == 2 then

 local rc,answer=m_simpleTV.WinInet.Request(session,{url='https://cloud.mail.ru/public/4KYo/55jc6Vrvn/RadioAddonLogo/PromoDJ/'})
--m_simpleTV.WinInet.Close(session)
 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
	   return
 end

--debug_in_file(answer .. '\n')

weblink_view = string.match(answer,'weblink_view.-url":.-"(.-)"') or ''

end

 local rc,answer=m_simpleTV.WinInet.Request(session,{url='https://promodj.com/radio#channel5'})
--m_simpleTV.WinInet.Close(session)
 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
	   return
 end

answer = findpattern(answer, '#radio_top100(.-)</style>',1,0,0) or ''
--debug_in_file(answer .. '\n')

local t={}
local name, adr
local i=1
for w in string.gmatch(answer, 'after(.-)after') do 
    name = findpattern(w, '#radio_(.-)%.',1,7,1) or ''
    adr = findpattern(w, 'url(.-);',1,4,2) or ''

  t[i]={}
  t[i].Id=1
  t[i].Name=name
  t[i].Adress=adr
  --debug_in_file(t[i].Name .. '  ' .. t[i].Adress .. '\n' )

i=i+1
end

local function getImg(name)
  local img=''
  name=name:gsub(' ','')
  name=name:gsub('-','')
  name=name:gsub('\r','')
  name=name:gsub('\n','')
  name=name:lower(name)
  name=name:gsub('djgroove','groove')

  for i, v in ipairs(t) do 
    if name==v.Name then img=v.Adress end
  end
  return img
end

 local url = 'https://promodj.com/radio/channels-hq.m3u'
 local rc,answer=m_simpleTV.WinInet.Get(session,url)
 m_simpleTV.WinInet.Close(session)
 
  if rc~=200 then
 	   m_simpleTV.WinInet.Close(session)
 	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
 	   return
  end

 --debug_in_file(answer .. '\n')

 local m3ustr = '#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\PromoDJ\\"\n'
 local grp = 'PromoDJ'
 local img=''
 local desc='PromoDJ'

 if not string.match(answer,'#EXTM3U') then return end

 for name, adr in string.gmatch(answer, ',(.-)\n(.-)\n') do

     if source == 1 then
        img = getImg(name)
      elseif source == 2 then
          if weblink_view~='' then 
             name = name:gsub(' ', '%%20')
             name = name:gsub(',', '%%2C')
             name = name:gsub('&', '%%26')
             img = weblink_view .. '4KYo/55jc6Vrvn/RadioAddonLogo/PromoDJ/' .. name .. '.png'
          end
      end

      m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '$OPT:http-user-agent=Mozilla/5.0\n'


 end

--[[
 answer = string.gsub(answer,'#EXTM3U','#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\\promodj\\"\n')
 answer = string.gsub(answer,'1,','1,PromoDJ:')
 answer = string.gsub(answer,'(http.-)\r\n','%1$OPT:http-user-agent=Mozilla/5.0\n')
]]
-- debug_in_file(m3ustr .. '\n')
--do return end
 
 local  tmpName = m_simpleTV.Common.GetTmpName()
 if tmpName == nil then return end 
 
  local tfile = io.open(tmpName,'w+')
  if tfile == nil then 
      os.remove(tmpName)
      return
  end
  
  tfile:write(m3ustr)
  tfile:close() 
 


  --опции  для загрузки плейлиста 
local p={}
p.TypeSourse = 1
p.DeleteBeforeLoad = 0
p.TypeSkip   = 1
p.TypeFind =   0
p.AutoSearch = 1
p.NumberM3U =  1
p.Find_Group = 1
p.TypeCoding = 1  --  -1-auto  0 - plane text  1- UTF8  2- unicode
p.BorpasFileFormat=1
p.AutoNumber = 0
p.ExtFilter = 'Radio'
p.ExtFilterLogo =  '..\\Channel\\logo\\icons\\radio.png'    -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'PromoDJ playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList_UTF8 (tmpName,p,m_simpleTV.User.Radio.TypeMedia,true,false)
os.remove(tmpName)

if err==true then
     local mess = "PromoDJ: playlist updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0xFF00,5)
	 
end
