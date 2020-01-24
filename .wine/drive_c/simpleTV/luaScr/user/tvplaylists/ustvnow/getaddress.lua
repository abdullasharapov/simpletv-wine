--script 123tvnow(01/09/2019)

------------------------------------------------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr = m_simpleTV.Control.CurrentAdress
if inAdr==nil then return end

if not string.match(inAdr, 'http://123tvnow%.com/watch' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
------------------------------------------------------------------------------
  require('json')
  require('jsdecode')

    local retAdr=''

    local rc,answer = m_simpleTV.Http.Request(session,{url = inAdr , headers = 'Referer: http://123tvnow.com/category/united-states-usa/'})
    --m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("123tvnow Connection error 1 - " .. rc ,255,5)
   	   return
    end
  
  --debug_in_file(answer .. '\n')
  --do return end

 if string.match(answer, 'ok%.ru/videoembed/') then

   local url=findpattern(answer,'<iframe src="(.-)"',1,13,1)
   if url==nil then return end

    rc,answer = m_simpleTV.Http.Request(session,{url = 'https:'..url, headers = 'Referer: ' .. inAdr})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("123tvnow Connection error 2 - " .. rc ,255,5)
   	   return
    end

  --debug_in_file(answer .. '\n')

  local str=findpattern(answer,'hlsMasterPlaylistUrl(.-)?',1,20,1)
  if str==nil then return end

  retAdr=findpattern(str, 'https(.+)',1,0,0) or ''

 end

 if string.match(answer, 'var __=E%.d') then

  local str=findpattern(answer,'var __=E%.d(.-);',1,0,0)
  if str==nil then return end

  local url = 'https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/crypto-js.min.js'
  rc,answer = m_simpleTV.Http.Request(session,{url = url, headers = 'Referer: ' .. inAdr})
  if rc~=200 then m_simpleTV.Http.Close(session) return end

  local scr =  answer .. '\n' ..
  [[ var E = {
    m: 256,
    d: function(r, t) {
        var e = JSON.parse(CryptoJS.enc.Utf8.stringify(CryptoJS.enc.Base64.parse(r))),
            o = CryptoJS.enc.Hex.parse(e.salt),
            p = CryptoJS.enc.Hex.parse(e.iv),
            a = e.ciphertext,
            S = parseInt(e.iterations);
        S <= 0 && (S = 999);
        var i = this.m / 4,
            n = CryptoJS.PBKDF2(t, o, {
                hasher: CryptoJS.algo.SHA512,
                keySize: i / 8,
                iterations: S
            });
        return CryptoJS.AES.decrypt(a, n, {
            mode: CryptoJS.mode.CBC,
            iv: p
        }).toString(CryptoJS.enc.Utf8)
    }
};]] .. str 

   --debug_in_file(scr .. '\n')

  url = jsdecode.DoDecode('__', false, scr, 0)
  if url==nil then return end

  rc,answer = m_simpleTV.Http.Request(session,{url = url, headers = 'Referer: ' .. inAdr})
  m_simpleTV.Http.Close(session)
  if rc~=200 then return end

  --debug_in_file(answer .. '\n')
  retAdr = answer
 end

 if string.match(retAdr, 'espn%.tmedia%.me') then
    m_simpleTV.OSD.ShowMessage("Can't play this channel",255,5)
    m_simpleTV.Control.ExecuteAction(11)
  return
 end

--[[
  
  local str=findpattern(answer,'atob(.-);',1,6,3)
  if str==nil then return end
  
  local param = findpattern(answer,"+='%?(.-);",1,3,2) or ''
  
  local url=decode64(str)..param
  --debug_in_file(url .. '\n')


 if string.match(retAdr, 'tmedia%.me/') then
    rc,answer = m_simpleTV.Http.Request(session,{url = retAdr, headers = 'Referer: ' .. inAdr})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("123tvnow Connection error 2 - " .. rc ,255,5)
   	   return
    end

  debug_in_file(answer .. '\n')
  
   answer = string.gsub(answer, ':%[%]', ':""')
   answer = string.gsub(answer, '%[%]', ' ')
  
   local tab = json.decode(answer)
   if tab == nil or tab[1].file==nil then return end
  
   retAdr = tab[1].file
  else
   retAdr = decode64(str)
 end
]]

-- debug_in_file(retAdr .. '\n')
 m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-referrer=' .. inAdr 

