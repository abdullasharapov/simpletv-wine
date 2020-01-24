--script for telego.club (12/11/2019)

   local UpdateID = 'Telego_TV01'

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

    m_simpleTV.OSD.ShowMessage("Telego: start updating" ,0xFF00,10)
--[[
    --local rc,answer = m_simpleTV.WinInet.Request(session,{url='https://vk.com/territorytv'})
    local rc,answer = m_simpleTV.WinInet.Request(session,{url='https://ok.ru/group/53247573754008'})
    --m_simpleTV.WinInet.Close(session)
   
    if rc~=200 then
   	   m_simpleTV.WinInet.Close(session)
   	   m_simpleTV.OSD.ShowMessage("Telego Connection error 1 " .. rc ,255,3)
   	   return
    end

--debug_in_file(answer .. '\n\n')

 local svr = findpattern(answer, 'http%%3A%%2F%%2F(.-)&',1,0,1)
 if svr == nil then m_simpleTV.OSD.ShowMessage("Telego - can't find the site url " ,255,3) return end
 svr=url_decode(svr)
--debug_in_file(svr .. '\n\n')

 ]]

   local svr='http://telego475.com'
  
   if m_simpleTV.User.Telego01.Svr==nil then m_simpleTV.User.Telego01.Svr = svr end
  
    local rc,answer = m_simpleTV.WinInet.Request(session,{url=svr})
    m_simpleTV.WinInet.Close(session)
   
    if rc~=200 then
   	   m_simpleTV.WinInet.Close(session)
   	   m_simpleTV.OSD.ShowMessage("Telego Connection error 2 " .. rc ,255,3)
   	   return
    end

--debug_in_file(answer .. '\n\n')

 local m3ustr = '#EXTM3U\n'
 local name,adr,img
 local grp='Telego'
 local i=1

 for w in string.gmatch(answer,'<div class="button">(.-)/div></a>') do

        adr = findpattern( w,'href="(.-)"',1,6,1)
	name = findpattern( w,'center;">(.-)<',1,9,1)
	img = findpattern( w,'src="(.-)"',1,5,1)

	if adr == nil or name == nil or img  == nil then break end
          
         adr = '$tgosvr' .. adr 
         img = svr .. img


             m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'

        i=i+1

 end


--debug_in_file(m3ustr)
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
p.ExtFilter = 'Telego'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\telego.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'Telego playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList_UTF8 (tmpName,p,0,true,false)
os.remove(tmpName)

if err==true then
     local mess = "Telego - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end
