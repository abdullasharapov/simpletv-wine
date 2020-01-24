-- script for MyRadio - radio.obozrevatel.com (04/10/2019)

--load images from local disc - '', source - 1, cloud.mail.ru - 2 
local source = 1
-----------------------------------

 local UpdateID='MYRADIO01'

 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36 OPR/63.0.3368.94")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)
---------------------------------------------------------------------------
function unescape_html(str)
  str = string.gsub( str, '&raquo;', '»' )
  str = string.gsub( str, '&laquo;', '«' )
  str = string.gsub( str, '&#8217;', "'" )
  str = string.gsub( str, '&ndash;', '-' ) 
  str = string.gsub( str, '&lt;', '<' )
  str = string.gsub( str, '&gt;', '>' )
  str = string.gsub( str, '&quot;', '"' )
  str = string.gsub( str, '&apos;', "'" )
  str = string.gsub( str, '&#(%d+);', function(n) return string.char(n) end )
  str = string.gsub( str, '&#x(%d+);', function(n) return string.char(tonumber(n,16)) end )
  str = string.gsub( str, '&amp;', '&' ) -- Be sure to do this after all others
  return str
end
--------------------------------------------------------------------------------------- 
local function trim(str)
str = string.match(str,'^%s*(.-)%s*$')
  return str
end
--------------------------------------------------------------------------------------- 

local weblink_view = ''

if source == 2 then

 local rc,answer=m_simpleTV.WinInet.Request(session,{url='https://cloud.mail.ru/public/4KYo/55jc6Vrvn/RadioAddonLogo/MyRadio/'})
--m_simpleTV.WinInet.Close(session)
 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
	   return
 end

--debug_in_file(answer .. '\n')

weblink_view = string.match(answer,'weblink_view.-url":.-"(.-)"') or ''

end

local m3ustr='#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\MyRadio\\"\n'

local function getChannels(url,grp)

    local name,adr
    local img=''
    local desc=''

    local rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
    if rc~=200 then return end

    local str=answer
    local dataUrl = findpattern(answer, 'data%-url="(.-)"',1,10,1) or ''
    if dataUrl~='' then
       while true do
          rc,answer = m_simpleTV.WinInet.Request(session,{url=dataUrl})
          if rc~=200 then return end

          str = str .. answer
          dataUrl = findpattern(answer, 'data%-url="(.-)"',1,10,1)
          if dataUrl == nil then break end

       end

    end
    
    answer = str 
    answer = string.gsub(answer, '\n', '')
  
    for w in string.gmatch(answer,'data%-id(.-)</a>') do

    	name = findpattern(w, 'alt="(.-)"',1,5,1)
    	adr = findpattern(w, 'href="(.-)"',1,6,1)
 	if name==nil or adr==nil then break end

        name = unescape_html(name)
        --img = findpattern(w, 'data%-src="(.-)"',1,10,1) or ''
        desc = findpattern(w, '<div class="station%-item__subtitle">(.-)<',1,37,1) 
        or findpattern(w, '<div class="fm%-item__subtitle">(.-)<',1,31,1)
        if desc == nil then desc = '' end
        desc = trim(desc)
        desc = unescape_html(desc)

     --debug_in_file(name .. '  ' .. adr .. ' ' .. desc .. '  ' .. img .. '\n')

     if source == 1 then
        img = findpattern(w, 'data%-src="(.-)"',1,10,1) or ''
      elseif source == 2 then
          if weblink_view~='' then 
             name = name:gsub(' ', '%%20')
             name = name:gsub(',', '%%2C')
             name = name:gsub('&', '%%26')
             img = weblink_view .. '4KYo/55jc6Vrvn/RadioAddonLogo/MyRadio/' .. name .. '.png'
          end
      end

      m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'
    end

  return m3ustr  
end

 m_simpleTV.OSD.ShowMessage("MyRadio - начало обновления..." ,0xFF00,10)

 local url = 'https://www.obozrevatel.com/radio/'

 local rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
 --m_simpleTV.WinInet.Close(session)

 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("myradio Connection error " .. rc ,255,3)
	   return
 end

--debug_in_file(answer .. '\n\n')

answer = findpattern(answer, 'v2__padding%-wrapper">(.-)</section>',1,0,0)
if answer==nil then return end

 local t={}
 local name,adr,grp
 local img=''
 local desc=''
 local i=1

 for w in string.gmatch(answer,'<a(.-)</a>') do

    grp = findpattern(w, '<div>(.-)</div>',1,5,6)
    adr = findpattern(w, 'href="(.-)"',1,6,1)
    if grp==nil or adr==nil then break end
    
    grp = 'MyRadio ' .. unescape_html(grp)
    
    m3ustr = getChannels(adr,grp)

i=i+1
end

grp = 'MyRadio FM'
adr = 'https://www.obozrevatel.com/radio/fm/'

m3ustr = m3ustr .. getChannels(adr,grp)
--[[
grp = 'MyRadio PlayLists'
adr = 'https://www.obozrevatel.com/music/playlist/'

m3ustr = m3ustr .. getChannels(adr,grp)
]]
--debug_in_file(m3ustr .. '\n')
--do return end

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
p.ProgressWindowHeader = 'MyRadio playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,m_simpleTV.User.Radio.TypeMedia,true,false)

if err==true then
     local mess = "MyRadio - радиостанции обновлены (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage(mess,0xFF00,5)
	 
end