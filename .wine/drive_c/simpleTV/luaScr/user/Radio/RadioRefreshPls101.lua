-- script for 101.ru (08/11/2019)

--load images from local disc - '', source - 1, cloud.mail.ru - 2 
local source = 1
-----------------------------------

 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36 OPR/63.0.3368.94")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,10000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,10000,0)

 --m_simpleTV.OSD.ShowMessage("101RU - начало обновления плейлиста" ,0xFF00,10)

local weblink_view = ''

if source == 2 then

 local rc,answer=m_simpleTV.WinInet.Request(session,{url='https://cloud.mail.ru/public/4KYo/55jc6Vrvn/RadioAddonLogo/101RU/'})
--m_simpleTV.WinInet.Close(session)
 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
	   return
 end

--debug_in_file(answer .. '\n')

weblink_view = string.match(answer,'weblink_view.-url":.-"(.-)"') or ''

end
--debug_in_file(weblink_view .. '\n')
--do return end

 local rc,answer=m_simpleTV.WinInet.Request(session,{url='http://101.ru/radio-top'})
 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
	   return
 end

--debug_in_file(answer .. '\n')
--do return end

local function trim(str)
str = string.match(str,'^%s*(.-)%s*$')
  return str
end

 local host = 'http://101.ru'
 local UpdateID='101RU01'

local function GetChannels(answer)
   m_simpleTV.OSD.ShowMessage("101RU - начало обновления плейлиста" ,0xFF00,10)
   local name, adr
   local m3ustr=''
   local group = string.match(answer,'class="channel%-groups__link active"(.-)/a>') or ''
   group = string.match(group,'>(.-)<')
   if group==nil then return end
   group = trim(group)
   group = '101RU ' .. group
   local img=''

   local tmp = findpattern(answer, 'class="grid__item"(.-)<div class="section__head">', 1,0,0)
   if tmp==nil then return end

   local desc=group
   for w in string.gmatch(tmp, 'class="grid__item"(.-)loading="lazy"') do
        w=w:gsub('\n','')
--debug_in_file(w .. '\n\n')

   	adr = findpattern (w,'href="(.-)"',400,6,1)
   	name = findpattern (w,'alt="(.-)"',500,5,1)

--debug_in_file(name .. '  '  .. adr .. '\n')
--do return end
           if name == nil or adr == nil then break end
   
           adr = host .. adr
           name = trim(name)

       if source==1 then
          img = findpattern (w,'logo" href="(.-)"',1,12,1) or ''
          if img=='' then img=findpattern (w,'data%-src="(.-)"',500,10,1) or '' end
        elseif source == 2 then
          if weblink_view~='' then 
             img = weblink_view .. '4KYo/55jc6Vrvn/RadioAddonLogo/101RU/' .. name:gsub(' ', '%%20') .. '.png'
          end
       end
     -- m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" group-title="' .. group .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'

      m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" update-code="' .. UpdateID .. group .. adr .. '" group-title="' .. group .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'

   
   end
    return m3ustr
end

local m3ustr = '#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\101RU\\"\n' .. GetChannels(answer)
--debug_in_file(m3ustr .. '\n')
--do return end

local tmp = findpattern(answer,'<ul class="channel%-groups">(.-)/ul>',1,0,0)
if tmp==nil then  m_simpleTV.OSD.ShowMessage("101RU script error " ,255,5)
       return
 end

--debug_in_file(tmp .. '\n')
--do return end

local str=''
for w in string.gmatch(tmp, "<a(.-)/a>") do
   
   	local url = findpattern (w,'href="(.-)"',1,6,1)
        if url == nil then break end
   if not string.match(url, 'radio%-top$') and not string.match(url, '%#$') then
        url = host .. url
        --debug_in_file(url .. '\n')

        rc,answer=m_simpleTV.WinInet.Request(session,{url=url})
        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("Connection error 2 - " .. rc ,255,10)
       	   return
        end

     str  = str .. GetChannels(answer)
     m_simpleTV.Common.Wait(200)
   end
end
m3ustr = m3ustr .. str
--debug_in_file(m3ustr .. '\n')
--do return end

rc,answer=m_simpleTV.WinInet.Request(session,{url='http://101.ru/personal-top'})
 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
	   return
 end

--debug_in_file(answer .. '\n')

m3ustr = m3ustr .. GetChannels(answer)

tmp = findpattern(answer,'<ul class="channel%-groups">(.-)/ul>',1,0,0)
if tmp==nil then  m_simpleTV.OSD.ShowMessage("101RU script error " ,255,5)
       return
 end

--debug_in_file(tmp .. '\n')
--do return end

str=''
for w in string.gmatch(tmp, "<a(.-)/a>") do
   
   	local url = findpattern (w,'href="(.-)"',1,6,1)
        if url == nil then break end
   if not string.match(url, 'personal%-top$') and not string.match(url, '%#$') then
        url = host .. url
       -- debug_in_file(url .. '\n')

        rc,answer=m_simpleTV.WinInet.Request(session,{url=url})
        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("Connection error 2 - " .. rc ,255,10)
       	   return
        end

     str  = str .. GetChannels(answer)
     m_simpleTV.Common.Wait(200)
   end
end
m3ustr = m3ustr .. str
--debug_in_file(m3ustr .. '\n')

m_simpleTV.WinInet.Close(session)


  --опции  для загрузки плейлиста 
local p={}
p.Data = m3ustr
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
p.ExtFilterLogo =  '..\\Channel\\logo\\icons\\radio.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = '101RU playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,m_simpleTV.User.Radio.TypeMedia,true,false)

if err==true then
     local mess = "101RU - radiostations updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0xFF00,5)
	 
end
