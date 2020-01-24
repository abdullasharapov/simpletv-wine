--script getaddress ntvplus (09/08/2017) 
------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

if not string.match( inAdr, '^ntvplusx=') then return end

--dofile(m_simpleTV.MainScriptDir .. "user/tvplaylists/ntvx/streams.lua") 

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
-------------------------------------------------------------------
 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)
 --INTERNET_FLAG_NO_AUTO_REDIRECT 0x00200000
 --m_simpleTV.WinInet.SetOpenRequestFlags(session,0x00200000)
---------------------------------------------------------------------------
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
---------------------------------------------------------------------------
local function get_value(val)
      for k, v in pairs(ntvstreams) do
         if tonumber(val)==k then return v end
      end
   return nil
end
---------------------------------------------------------------------------

  inAdr=string.gsub(inAdr,'ntvplusx=','')
 -- local val = get_value(inAdr)
 -- if val==nil then m_simpleTV.OSD.ShowMessage("ntvplusx values missing " ,255,3) return end

  local val = inAdr
  local streamId , qlty = string.match(val, '^(.-)%-(.+)$')
  --debug_in_file(streamId .. '  ' .. qlty .. '\n\n')
  if streamId == nil or qlty == nil then return end
  
 --do return end

if m_simpleTV.User.NTVPlusX.Param == nil then

    local url = 'https://ntvplus.tv/channel/embed?uid=&id=336&hash=3ebdd2affcc8903cfd127d1700993b1c'    
       local rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
       --m_simpleTV.WinInet.Close(session)

        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("ntvplusx Connection error 1 " .. rc ,255,3)
       	   return
        end

    --debug_in_file(answer.. '\n\n')


--https://player.ntvplus.tv/player/smil?timeShift=0&userId=2857116&sign=1dccd20cd4523f380f3bbd0ae47ecae3&platform=portal&contentId=5006df67d122fa3f0d000000&ts=1502360718460&contentType=channel&sessionId=2857116&includeHighlights=1&quality=HD

local userId = findpattern(answer, 'userId: "(.-)"',1,9,1)
local sign = findpattern(answer, 'sign: "(.-)"',1,7,1)
local ts = findpattern(answer, 'ts: "(.-)"',1,5,1)
if ts==nil or userId==nil or sign==nil then return end

 url = 'https://player.ntvplus.tv/player/smil?timeShift=0&userId=' .. userId .. '&sign=' .. sign .. '&platform=portal&contentId=5006df67d122fa3f0d000000&ts=' .. ts .. '&contentType=channel&sessionId=' .. userId .. '&includeHighlights=1&quality=HD'


       rc,answer = m_simpleTV.WinInet.Request(session,{url=url , headers='Accept:' .. 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\n' .. 
'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3\n' ..
'Referer: https://player.ntvplus.tv/swf/common/latest.swf'})
       --m_simpleTV.WinInet.Close(session)

        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("ntvplusx Connection error 2 " .. rc ,255,3)
       	   return
        end

   -- debug_in_file(answer.. '\n\n')

--http://transit.ntvplus.tv/to/LIVE/1024/HDS/HQ/CcZ9eHcyt_BeyoAfrnrnAw/1502297386/S-2685923/playlist.f4m

  local videoUrl = findpattern(answer, '"videoUrl":"(.-)"',1,11,1)
  if videoUrl == nil then return end
  
  local param = string.match(videoUrl, '/HDS/.-/(.-)/playlist')
  if param==nil then return end
  
  --debug_in_file(param.. '\n\n')
  
  m_simpleTV.User.NTVPlusX.Param = param 

end

local url = 'http://transit.ntvplus.tv/to/LIVE/' .. streamId .. '/HDS/HQ/' .. m_simpleTV.User.NTVPlusX.Param  .. '/playlist.f4m'

       local rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
       --m_simpleTV.WinInet.Close(session)

        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("ntvplusx Connection error 3 " .. rc ,255,3)
       	   return
        end

    --debug_in_file(answer.. '\n\n')

  url = string.match(answer, '<to>(.-)</to>')
  if url==nil then return end

        rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
       --m_simpleTV.WinInet.Close(session)

        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("ntvplusx Connection error 4 " .. rc ,255,3)
       	   return
        end

    --debug_in_file(answer.. '\n\n')

  local adr = string.match(answer, '<baseURL>(.-)</baseURL>')
  if adr==nil then return end

  adr = trim(adr)
  --debug_in_file(adr.. '\n\n')

 local retAdr = adr .. val .. '.f4m'
-- debug_in_file(retAdr.. '\n\n')

 m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246'

