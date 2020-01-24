--script for slotos.eu (09/04/2019)
--lno66850@molms.com
if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress
if inAdr==nil then return end

if not string.match( inAdr, '^%$slotostv=' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
----------------------------------------------------------------
   local userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246'
  
   local session = m_simpleTV.WinInet.New(userAgent)
   if session == nil then return end
---------------------------------------------------------------

   local t={} 
   t.url = 'http://tv.slotos.eu/user/login?=json'
   t.method = 'post' 
   t.headers = 'User-Agent: ' .. userAgent .. '\nAccept: */*\nAccept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7\nContent-Type: application/x-www-form-urlencoded\nReferer: http://tv.slotos.eu/'
   t.body = 'login=lno66850%40molms.com&pwd=lno66850%40molms.com'
    
   local rc,answer = m_simpleTV.WinInet.Request(session,t)
   if rc~=200 then m_simpleTV.WinInet.Close(session)  return end
   --debug_in_file(answer .. '\n\n')

   inAdr = string.gsub(inAdr,'$slotostv=','') 
   inAdr = decode64(inAdr)
   --debug_in_file(inAdr .. '\n\n')

   t.url = inAdr
   t.method = 'post' 
   t.headers = 'User-Agent: ' .. userAgent .. '\nAccept: */*\nAccept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7\nContent-Type: application/x-www-form-urlencoded\nReferer: http://tv.slotos.eu/'
   t.body = 'ajax-title=title'
    
   local rc,answer = m_simpleTV.WinInet.Request(session,t)
   if rc~=200 then m_simpleTV.WinInet.Close(session)  return end
   --debug_in_file(answer .. '\n\n')

   local code = string.match(answer, '<iframe.-class="(.-)"')
   if code==nil then return end
   --debug_in_file(code .. '\n\n')

   local url = 'http://tv.slotos.eu/channel/m3u8?=json'
   body = 'code=' .. code .. '&stream='
 
   t.url = url
   t.method = 'post' 
   t.headers = 'User-Agent: ' .. userAgent .. '\nAccept: */*\nAccept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7\nContent-Type: application/x-www-form-urlencoded\nReferer: ' .. inAdr
   t.body = body
    
   rc,answer = m_simpleTV.WinInet.Request(session,t)
   --m_simpleTV.WinInet.Close(session)
   if rc~=200 then m_simpleTV.WinInet.Close(session)  return end
   --debug_in_file(answer .. '\n\n')

   answer = string.gsub(answer, '\\', '')

   local retAdr = string.match(answer, ':"(.-)"')
   if retAdr==nil then m_simpleTV.OSD.ShowMessage("stream not found " ,255,3) return end

   rc,answer = m_simpleTV.WinInet.Request(session,{url=retAdr,headers = 'Referer: http://tv.slotos.eu/player'})
m_simpleTV.WinInet.Close(session)

  if string.match(answer, 'EXTM3U') then
     m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-referrer=http://tv.slotos.eu/player'
    else
     m_simpleTV.OSD.ShowMessage(answer ,255,3)
  end



