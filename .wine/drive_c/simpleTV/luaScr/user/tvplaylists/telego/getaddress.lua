--getaddress telego.club (12/11/2019)

 if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
 
 local inAdr =  m_simpleTV.Control.CurrentAdress
 
 if inAdr==nil then return end
 
 if not string.match( inAdr, '^$tgosvr') then return end
 
 m_simpleTV.Control.ChangeAdress='Yes'
 m_simpleTV.Control.CurrentAdress = 'error'
----------------------------------------

 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)

---------------------------------------------------------------------------
local function trim(str)
str = string.match(str,'^%s*(.-)%s*$')
  return str
end
---------------------------------------------------------------------------

if m_simpleTV.User.Telego01.Svr==nil then 
--[[
--    local rc,answer = m_simpleTV.WinInet.Request(session,{url='https://vk.com/territorytv'})
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
  m_simpleTV.User.Telego01.Svr = svr 

end

inAdr = string.gsub(inAdr, '$tgosvr' ,  m_simpleTV.User.Telego01.Svr)

    local rc,answer = m_simpleTV.WinInet.Request(session,{url=inAdr})
    --m_simpleTV.WinInet.Close(session)
   
    if rc~=200 then
   	   m_simpleTV.WinInet.Close(session)
   	   m_simpleTV.OSD.ShowMessage("Telego Connection error 2 " .. rc ,255,3)
   	   return
    end

--debug_in_file(answer .. '\n\n')

local url = string.match(answer, '<iframe.-src="(.-)"')
if url == nil then m_simpleTV.OSD.ShowMessage("Telego - can't find stream address" ,255,3) return end 


 local t={}
 t.url = url
 t.method = 'get' 
 t.headers = 'Referer: ' .. inAdr .. '\nX-Requested-With: XMLHttpRequest'

 rc,answer = m_simpleTV.WinInet.Request(session,t)
 m_simpleTV.WinInet.Close(session)

 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Telego Connection error 3 " .. rc ,255,3)
	   return
 end

 --debug_in_file(answer .. '\n\n')

 answer = string.gsub(answer, '"', "'")

 local retAdr = string.match(answer, "videoLink = '(.-)'") or string.match(answer, "file:.-'(.-)'")
 if retAdr==nil then return end
--debug_in_file(retAdr .. '\n\n')

m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246'


--debug_in_file('#EXTINF:-1,' .. m_simpleTV.Control.CurrentTitle .. '\n' .. retAdr .. '\n')
