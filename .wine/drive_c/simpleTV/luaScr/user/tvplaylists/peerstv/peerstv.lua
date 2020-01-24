--script for peers.tv (22/08/2018)

-----------------------------------------------

 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)
-------------------------------------------
function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
-------------------------------------------

    m_simpleTV.OSD.ShowMessage("PeersTV: start updating" ,0xFF00,10)

    local tt={}
    tt.url = decode64('aHR0cDovL2FwaS5wZWVycy50di9hdXRoLzIvdG9rZW4=')
    tt.body = decode64('Z3JhbnRfdHlwZT1pbmV0cmElM0Fhbm9ueW1vdXMmY2xpZW50X2lkPTI5NzgzMDUxJmNsaWVudF9zZWNyZXQ9YjRkNGViNDM4ZDc2MGRhOTVmMGFjYjViYzZiNWM3NjA=')
    tt.method = 'post'
    tt.headers = 'Content-Type: application/x-www-form-urlencoded'
    
    local rc,answer = m_simpleTV.WinInet.Request(session, tt)
    --m_simpleTV.WinInet.Close(session)
   
    if rc~=200 then
   	   m_simpleTV.WinInet.Close(session)
   	   m_simpleTV.OSD.ShowMessage("peers.tv Connection error 1 " .. rc ,255,3)
   	   return
    end

--debug_in_file(answer .. '\n\n')

  local token = findpattern(answer, ':%b""',1,2,1)
  if token ==nil then 
     m_simpleTV.OSD.ShowMessage("peers.tv access token not found - abort " ,255,3)
     return 
  end

 local UpdateID = 'PeersTV_TV01'
 local grp='PeersTV'
 local m3ustr = '#EXTM3U\n'
 local name,adr,id,tshift,access
 local i=1

    rc,answer = m_simpleTV.WinInet.Request(session,{url='http://api.peers.tv/iptv/2/playlist.m3u', headers = decode64('Q2xpZW50LUNhcGFiaWxpdGllczogcGFpZF9jb250ZW50LGFkdWx0X2NvbnRlbnRcblJlZmVyZXI6IGh0dHA6Ly9obHMucGVlcnMudHYvc3RyZWFtaW5nL2Rpc2NvdmVyeXdvcmxkLzE2L3R2cmVjdy9wbGF5bGlzdC5tM3U4XG5BdXRob3JpemF0aW9uOiBCZWFyZXIg') .. token})
    m_simpleTV.WinInet.Close(session)
   
    if rc~=200 then
   	   m_simpleTV.WinInet.Close(session)
   	   m_simpleTV.OSD.ShowMessage("peers.tv Connection error 2 " .. rc ,255,3)
   	   return
    end

--debug_in_file(answer .. '\n\n')
--local noTimeShift=''
 for w in string.gmatch(answer,'STREAM%-INF(.-)m3u8') do

    if w:match('timeshift=true') then
       tshift='$tshift=true'  else
      -- _, adr = string.match(w, ', (.-)\n(.+)')
      --local a,aa,aaa = string.match(adr, '://(.-/)(.-/)(.-/).+') or ''
       tshift='$tshift=false' 
    end 

    --noTimeShift = noTimeShift .. ",'" .. a..aa..aaa.. "'\n"

    if w:match('access=denied') then
       access='$access=false'  else
       access='$access=true' 
    end 

    id = findpattern(w, 'id=(%d+) ', 1,3,1) or ''
    id = '$id=' .. id

    grp = findpattern(w, 'group%-title="(.-)"', 1,13,1) or 'Other'
    grp = 'PeersTV - ' .. grp

    name, adr = string.match(w, ', (.-)\n(.+)')   
    if name==nil or adr == nil then break end 

    name = trim(name)
    adr = adr .. 'm3u8' .. id .. tshift .. access
    adr = '$peerstv=' .. encode64(adr)  

      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. adr .. '" group-title="' .. grp .. '",' .. name .. '\n' .. adr .. '\n'
  
      --m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. grp .. '",' .. name .. '\n' .. adr .. '\n'
 end

--debug_in_file(m3ustr .. '\n\n')
--debug_in_file(noTimeShift)
--do return end

  --îïöèè  äëÿ çàãğóçêè ïëåéëèñòà 
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
p.ExtFilter = 'PeersTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\peerstv.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'PeersTV playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList_UTF8 (tmpName,p,0,true,false)
--os.remove(tmpName)

if err==true then
     local mess = "PeersTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end
