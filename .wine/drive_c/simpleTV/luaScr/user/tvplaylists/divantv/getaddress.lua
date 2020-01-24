--script for divan.tv (15/04/2017)

require('json')

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress
if inAdr==nil then return end

if not string.match( inAdr, '^divantvid=' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = ''
----------------------------------------------------------------
local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246")
if session == nil then return end

 --INTERNET_OPTION_CONNECT_TIMEOUT
 m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
 --INTERNET_OPTION_RECEIVE_TIMEOUT
 m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)
---------------------------------------------------------------

local id = string.match(inAdr, '^divantvid=(%d+)')
if id == nil then return end
--debug_in_file(id .. '\n')

local url = 'http://n.divan.tv/index.php?action=play&ch_id=' .. id .. '&feature_id=channels'

 local t={}
 t.url = url
 t.method = 'post' 
 t.headers = 'Accept:application/json, text/javascript, */*; q=0.01\nAccept-Language:ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4\nReferer: http://n.divan.tv\n' .. 'X-Requested-With: XMLHttpRequest'
 t.body = ''

 local rc,answer = m_simpleTV.WinInet.Request(session,t)
 m_simpleTV.WinInet.Close(session)
       
 if rc~=200 then
      m_simpleTV.WinInet.Close(session)
      m_simpleTV.OSD.ShowMessage("Divantv Connection error 1 " .. rc ,255,3)
      return
 end

--debug_in_file(answer .. '\n')

local tab=json.decode(answer)
if tab==nil or tab.vars==nil or tab.vars.channel == nil or tab.vars.channel.stream == nil then return end

local retAdr = tab.vars.channel.stream
--debug_in_file(retAdr .. '\n')

m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246'

