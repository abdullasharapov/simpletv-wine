--script shaluntv (31/08/2019)

------------------------------------------------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr = m_simpleTV.Control.CurrentAdress
if inAdr==nil then return end

if not string.match(inAdr, '^http://oxax%.tv' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
------------------------------------------------------------------------------
local function trim(str)
str = string.match(str,'^%s*(.-)%s*$')
  return str
end
------------------------------------------------------------------------------
    local url = inAdr

    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    --m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ShalunTV Connection error 1 - " .. rc ,255,5)
   	   return
    end
    --debug_in_file(answer .. '\n')

   local tmp = findpattern(answer, "kes:'(.-)'",1,5,1)
   if tmp == nil then return end

   url = 'http://oxax.tv/pley?kes=' .. tmp
   --if url == nil then return end

    rc,answer = m_simpleTV.Http.Request(session,{url = url, headers = 'Referer: ' .. inAdr})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ShalunTV Connection error 2 - " .. rc ,255,5)
   	   return
    end
    --debug_in_file(answer .. '\n')

   local retAdr = findpattern(answer, 'file:"(.-)"',1,6,1)
   if retAdr == nil then return end

 m_simpleTV.Control.CurrentAdress = retAdr 

