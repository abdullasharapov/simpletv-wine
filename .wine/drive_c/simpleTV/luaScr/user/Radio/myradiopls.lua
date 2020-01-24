-- script for MyRadio playlists - radio.obozrevatel.com (1/12/2016)

 local UpdateID='MYRADIO02'

 local session = m_simpleTV.WinInet.New("Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.9.168 Version/11.52")
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

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
--------------------------------------------------------------------------------------- 

 m_simpleTV.OSD.ShowMessage("MyRadio Playlists - начало обновления.." ,0xFF00,10)

 local m3ustr='#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\MyRadio\\"\n'

 local t={}
 t.url = 'http://radio.obozrevatel.com/newplayer/58' --'http://vobhod.com/browse.php?u=http%3A%2F%2Fradio.obozrevatel.com%2Fnewplayer%2F58&b=0&f=norefer'
 t.method = 'get' 

 rc,answer = m_simpleTV.WinInet.Request(session,t)
 m_simpleTV.WinInet.Close(session)

 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("myradio Connection error " .. rc ,255,3)
	   return
 end

--debug_in_file(answer .. '\n\n')

 answer = string.gsub(answer,'\n','')
 answer = string.gsub(answer,'\r','')
 answer = string.gsub(answer,',','')
 answer = unescape_html(answer)
 answer = findpattern(answer,'<ul>(.-)</ul>',1,0,0)
 if answer == nil then return end
 --answer = unescape(answer)


 local i=1
 local name,adr,img,desc
 local grp='MyRadio Playlist'

 for w in string.gmatch(answer,'<li>(.-)</li>') do

	
	adr = findpattern (w,'href="(.-)"',1,6,1)
	name = string.match (w,'>(.-)<')
	if adr == nil or name == nil then break end
        
        adr = 'http://radio.obozrevatel.com' .. adr
        name = trim(name)

      m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" update-code="' .. UpdateID .. grp .. name ..  '",MyRadio Playlist:' .. name .. '\n' .. adr ..'\n' 

 end

--debug_in_file(m3ustr .. '\n\n')
--do return end

--m3ustr=m_simpleTV.Common.string_fromUTF8(m3ustr,1251)

local  tmpName = m_simpleTV.Common.GetTmpName()
 if tmpName==nil then 
		return 
 end 
 local tfile = io.open(tmpName,'w+')
 if tfile==nil then 
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
p.ExtFilter = 'Radio'
p.AutoNumber = 0
p.UpdateID=UpdateID
p.ExtFilterLogo =  '..\\Channel\\logo\\icons\\radio.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'MyRadio Playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList_UTF8 (tmpName,p,m_simpleTV.User.Radio.TypeMedia,true,false)
os.remove(tmpName)

   if err==true then
        local mess = "MyRadio плейлисты обновлены (" .. add .. ")"
   	 if add > 0 and add < 25 then 
   	    names = string.gsub(names,'%$end','\n')
   		mess = mess .. '\n' .. names
   	 end
   	 
   	 m_simpleTV.OSD.ShowMessage_UTF8(m_simpleTV.Common.multiByteToUTF8(mess),0xFF00,5)
   	 
   end