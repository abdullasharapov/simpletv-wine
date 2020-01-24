--script for http://www.di.fm/ (03/10/2019)

--load images from local disc - '', source - 1, cloud.mail.ru - 2 
local source = 1
-----------------------------------

require('json')

 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.108 Safari/537.36 OPR/50.0.2762.45")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)
-------------------------------------------
 m_simpleTV.OSD.ShowMessage("Digitally Imported - start updating playlist" ,0xFF00,10)

local weblink_view = ''

if source == 2 then

 local rc,answer=m_simpleTV.WinInet.Request(session,{url='https://cloud.mail.ru/public/4KYo/55jc6Vrvn/RadioAddonLogo/DigitallyImported/'})
--m_simpleTV.WinInet.Close(session)
 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
	   return
 end

--debug_in_file(answer .. '\n')

weblink_view = string.match(answer,'weblink_view.-url":.-"(.-)"') or ''

end

 local rc,answer=m_simpleTV.WinInet.Request(session,{url='http://www.di.fm/channels'})
 --m_simpleTV.WinInet.Close(session)
 
 if rc~=200 then
 	   m_simpleTV.WinInet.Close(session)
 	   m_simpleTV.OSD.ShowMessage("Digitally Imported ñonnection error - " .. rc ,255,10)
 	   return
  end
 --debug_in_file(answer .. '\n')
 
 answer = findpattern( answer,'di%.app%.start(.-)</script>',1,13,11)
 if answer == nil then 
    m_simpleTV.OSD.ShowMessage("Error di.fm - json not found, abort"  ,255,5)
    return
 end
 
 answer = answer:gsub('%[%]','""')
 local t = json.decode(answer)
 
 if t == nil or t.channels == nil then return end
 
 local i=1
 local m3ustr = '#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\DigitallyImported\\"\n'
 local name, adr, desc
 local grp = 'Digitally Imported Web'
 local img=''
 local UpdateID='DigitallyImported'
 
 while true do
   if t.channels[i] == nil then break end
     name =  t.channels[i].name
     adr  = 'difmid=' .. t.channels[i].id  
     desc  = t.channels[i].description  
     desc = desc:gsub('\r','')
     desc = desc:gsub('\n','')
     name = name:gsub('\'', '')

     if source == 1 then
        img = 'https:' .. t.channels[i].asset_url .. '?size=178x178' or ''
      elseif source == 2 then
          if weblink_view~='' then 
             name = name:gsub(' ', '%%20')
             name = name:gsub(',', '%%2C')
             name = name:gsub('&', '%%26')
             img = weblink_view .. '4KYo/55jc6Vrvn/RadioAddonLogo/DigitallyImported/' .. name .. '.png'
          end
     end
   	
      m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'

 
     --m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '",'..grp..':'.. name..'\n'..adr..'\n'
 
   i = i+1
 end
--[[
 local url = 'https://api.friezy.ru/playlists/m3u/DI.m3u'

 local rc,answer=m_simpleTV.WinInet.Request(session,{url=url})
 m_simpleTV.WinInet.Close(session)

 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Digitally Imported ñonnection error - " .. rc ,255,3)
	   return
 end
 --debug_in_file(answer .. '\n')

 if not findpattern(answer, '#EXTM3U',1,0,0) then
	   m_simpleTV.OSD.ShowMessage("Digitally Imported - unable to load premium playlist" ,255,3)
    answer=''
 end

if findpattern(answer, '#EXTM3U',1,0,0) then
   answer = findpattern(answer, '^(.+)',129,0,0) or ''
   answer = string.gsub (answer, '#EXTINF.-,','#EXTINF:-1 skipepg="1" group-title="Digitally Imported 320kbps",')
end

m3ustr = m3ustr .. answer
]]

local  tmpName = m_simpleTV.Common.GetTmpName()
if tmpName == nil then return end 

 local tfile = io.open(tmpName,'w+')
 if tfile == nil then 
     os.remove(tmpName)
     return
 end
 
 tfile:write(m3ustr)
 tfile:close() 

  --îïöèè  äëÿ çàãðóçêè ïëåéëèñòà 
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
p.ExtFilter = 'Radio'
p.AutoNumber = 0
p.ExtFilterLogo =  '..\\Channel\\logo\\icons\\radio.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'Digitally Imported playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList_UTF8 (tmpName,p,m_simpleTV.User.Radio.TypeMedia,true,false)
os.remove(tmpName)

if err==true then
     local mess = "Digitally Imported - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage(mess,0xFF00,5)
	 
end





