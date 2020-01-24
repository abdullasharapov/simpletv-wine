--script tvtap (06/09/2019)

------------------------------------------------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr = m_simpleTV.Control.CurrentAdress
if inAdr==nil then return end

if not string.match(inAdr, '^$tvtap=' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
------------------------------------------------------------------------------
  local userAgent = "USER-AGENT-tvtap-APP-V2"
  local session = m_simpleTV.Http.New(userAgent)
  if session == nil then return end
------------------------------------------------------------------------------
  require('json')
  require('jsdecode')

   local id = string.gsub(inAdr, '$tvtap=', '' )

   local url = 'http://tvtap.net/tvtap1/index_tvtappro.php?case=get_channel_link_with_token_tvtap_updated'
   local body = 'channel_id=' .. tonumber(id) .. '&username=603803577'
 
   local t={}  
   t.url = url
   t.method = 'post' 
   t.headers = 'User-Agent: ' .. userAgent .. '\napp-token: 9120163167c05aed85f30bf88495bd89'
   t.body = body
    
   local rc,answer = m_simpleTV.Http.Request(session,t)
   if rc~=200 then m_simpleTV.Http.Close(session) return end
  -- debug_in_file(answer .. '\n\n')

   local tab = json.decode(answer)
   if tab == nil then return end

   local str = tab.msg.channel[1].http_stream
   if str == nil then return end

  url = 'https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/crypto-js.min.js'

  rc,answer = m_simpleTV.Http.Request(session,{url = url})
  m_simpleTV.Http.Close(session)
  if rc~=200 then m_simpleTV.Http.Close(session) return end

  local scr =  answer .. '\n' ..
  [[ function decryptByDES(ciphertext, key) {
    var keyHex = CryptoJS.enc.Utf8.parse(key);
    // direct decrypt ciphertext
    var decrypted = CryptoJS.DES.decrypt({
        ciphertext: CryptoJS.enc.Base64.parse(ciphertext)
    }, keyHex, {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    });
    return decrypted.toString(CryptoJS.enc.Utf8);
}
var key = "98221122";]] .. 'var ciphertext = "' .. str .. 
'";var plaintext = decryptByDES(ciphertext, key);'

   --debug_in_file(scr .. '\n')

  local retAdr = jsdecode.DoDecode('plaintext', false, scr, 0)
  if retAdr==nil then return end

  m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-user-agent=' .. userAgent

