--script for http://flacr.ru/ (16/01/2016)

   local UpdateID='FLAC_R01'

--------------------------------------------------------------------------
 local session = m_simpleTV.WinInet.New("Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.9.168 Version/11.52")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)
--INTERNET_FLAG_SECURE
--m_simpleTV.WinInet.SetOpenRequestFlags(session, 0x00800000 + 0x00002000 + 0x00001000)
-------------------------------------------

  m_simpleTV.OSD.ShowMessage("FLAC Radio: start updating" ,0xFF00,10)

 local url = 'http://flacr.ru/'
 local rc,answer=m_simpleTV.WinInet.Get(session,url)
 m_simpleTV.WinInet.Close(session)
 
  if rc~=200 then
 	   m_simpleTV.WinInet.Close(session)
 	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
 	   return
  end

 --debug_in_file(answer .. '\n')

 local tmp = findpattern(answer,'<TABLE border=1(.-)</TABLE>',1,0,0 )
  if tmp == nil then m_simpleTV.OSD.ShowMessage("FLAC Radio: updating error" ,255,10) end

 local adr,name
 local m3u = '#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\flacru\\"\n'
 local group = 'FLAC Radio'
 for w in string.gmatch(tmp,'<TR><TD>(.-)</a>') do
     name = findpattern(w,'(.-)<',1,0,1)
     adr = findpattern(w,'href=(.-)>',1,5,1)
     if name == nil or adr == nil then break end
  
   m3u = m3u .. '#EXTINF:-1 skipepg="1" update-code="' .. UpdateID .. group .. name .. '",' .. group .. ':' .. name .. '\n' .. adr .. '\n' 
 end

--debug_in_file(m3u)
--do return end
 
 local  tmpName = m_simpleTV.Common.GetTmpName()
 if tmpName == nil then return end 
 
  local tfile = io.open(tmpName,'w+')
  if tfile == nil then 
      os.remove(tmpName)
      return
  end
  
  tfile:write(m3u)
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
p.ProgressWindowHeader = 'FLAC Radio playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList (tmpName,p,m_simpleTV.User.Radio.TypeMedia,true,false)
os.remove(tmpName)

if err==true then
     local mess = "FLAC Radio: playlist updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage(mess,0xFF00,5)
	 
end
