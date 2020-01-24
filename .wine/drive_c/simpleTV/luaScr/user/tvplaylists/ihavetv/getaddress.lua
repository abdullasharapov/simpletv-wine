--open http://ihavesport.com/channel/11133/

if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
local inAdr =  m_simpleTV.Control.CurrentAddress

if not string.match( inAdr, '^%$ihavetv=' )  then return end

m_simpleTV.Control.ChangeAddress = 'Yes'
m_simpleTV.Control.CurrentAddress = 'error'

local userAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:56.0) Gecko/20100101 Firefox/56.0"

local session = m_simpleTV.Http.New(userAgent, nil, true)
if session==nil then return end

inAdr=string.gsub(inAdr,'%$ihavetv=','')
inAdr=decode64(inAdr)

local rc, answer = m_simpleTV.Http.Request(session,{url=inAdr, headers='Referer: ' .. inAdr})
if rc~=200 then m_simpleTV.Http.Close(session) return end 

--debug_in_file(answer ..'\n')

local retAdr = string.match(answer, 'videoPlayerHTML.-(http.-m3u8)')
if retAdr == nil then m_simpleTV.OSD.ShowMessage("Stream not found " ,255,3) return end
--debug_in_file(retAdr ..'\n')

local cc = m_simpleTV.Http.GetCookies(session, inAdr, 'PHPSESSID')
--debug_in_file(cc ..'\n')

local url = 'http://ihavesport.com/js/global.js'
rc, answer = m_simpleTV.Http.Request(session,{url=url, headers='Referer: ' .. inAdr})
m_simpleTV.Http.Close(session)
if rc~=200 then m_simpleTV.Http.Close(session) return end 


m_simpleTV.Control.CurrentAddress = retAdr .. '$OPT:http-user-agent=' .. userAgent .. '$OPT:http-ext-header=Cookie: PHPSESSID=' .. cc  .. ';' .. '$OPT:http-referrer=' .. inAdr

