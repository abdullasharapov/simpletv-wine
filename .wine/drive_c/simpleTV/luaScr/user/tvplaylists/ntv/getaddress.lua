--script ntvplus (01/06/2018) 

------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

if not string.match( inAdr, '^$ntvplus=') then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
-------------------------------------------------------------------
 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Linux; Android 7.0; SM-G892A Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/60.0.3112.107 Mobile Safari/537.36")
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

local qlty='-576p'
inAdr=string.gsub(inAdr,'$ntvplus=','')

if m_simpleTV.User.NTVPlus.Table==nil then

local url = decode64('aHR0cDovL21hcGkubnR2cGx1cy50di92MS90di9jaGFubmVscz9hcHBUeXBlPWFuZHJvaWQ=')
   
 local rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
 --m_simpleTV.WinInet.Close(session)

 if rc~=200 then
    m_simpleTV.WinInet.Close(session)
    m_simpleTV.OSD.ShowMessage("ntvplus Connection error 1 " .. rc ,255,3)
    return
 end

 answer=string.gsub(answer,'%[%]','""')

 require('json')
 local tab=json.decode(answer)
 if tab==nil then return end

 local i=1
 local t={}

 while true do
       if tab[i] == nil or tab[i].name == nil or tab[i].streamServerId==nil or tab[i].videoUrl==nil then  break end   

          t[i]={}
          t[i].Id=i
          t[i].name=tab[i].name
          t[i].streamServerId=trim(tab[i].streamServerId)
          t[i].videoUrl=trim(tab[i].videoUrl)
  i=i+1
 end
 m_simpleTV.User.NTVPlus.Table = t

end

for i, v in ipairs(m_simpleTV.User.NTVPlus.Table) do 
   if tonumber(inAdr)==tonumber(v.streamServerId) then
      url=v.videoUrl
      if string.match(v.name,'%(HD%)') then 
         --debug_in_file(v.name .. '\n\n')
         qlty= '-720p'
     end

   end
end


       local rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
       --m_simpleTV.WinInet.Close(session)

        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("ntvplus Connection error 2 " .. rc ,255,3)
       	   return
        end

    --debug_in_file(answer.. '\n\n')

  url = string.match(answer, '<to>(.-)</to>')
  if url==nil then return end

        rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
        m_simpleTV.WinInet.Close(session)

        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("ntvplus Connection error 3 " .. rc ,255,3)
       	   return
        end

    --debug_in_file(answer.. '\n\n')

  local adr = string.match(answer, '<baseURL>(.-)</baseURL>')
  if adr==nil then return end

  adr = trim(adr)
  --debug_in_file(adr.. '\n\n')

 local retAdr = adr .. inAdr .. qlty .. '.f4m'
 --debug_in_file(retAdr.. '\n\n')

 m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-user-agent=Mozilla/5.0 (Linux; Android 7.0; SM-G892A Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/60.0.3112.107 Mobile Safari/537.36'

