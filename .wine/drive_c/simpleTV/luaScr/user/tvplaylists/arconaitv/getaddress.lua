--script for https://www.arconaitv.us (08/09/2019)

------------------------------------------------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress
if inAdr==nil then return end

if not string.match(inAdr, 'arconaitv%.us' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
------------------------------------------------------------------------------
    require('jsdecode')

    local retAdr=''

    local rc,answer = m_simpleTV.Http.Request(session,{url = inAdr})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ArconaiTV Connection error 1 - " .. rc ,255,5)
   	   return
    end
  
  --debug_in_file(answer .. '\n')

    answer = findpattern(answer,'eval(.-)</script>',1,4,9)
    if answer==nil then return end

    local str = jsdecode.DoDecode(answer)
    if str==nil then return end
    --debug_in_file(str .. '\n')
 
    retAdr = findpattern(str,'src:(.-),',1,5,2)
    if retAdr==nil then return end

    m_simpleTV.Control.CurrentAdress = retAdr ..'$OPT:http-user-agent=Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127'

