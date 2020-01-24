--script for peers.tv (22/08/2018)
------------------------------------------------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

 if not string.match( inAdr, '^$peerstv=') then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
------------------------------------------------------------------------------
 if m_simpleTV.User==nil then m_simpleTV.User={} end
 if m_simpleTV.User.PeersTV01==nil then m_simpleTV.User.PeersTV01={} end

 if m_simpleTV.User.TVTimeShift==nil then m_simpleTV.User.TVTimeShift={} end
 
 local userAgent = decode64('RHVuZUhELzEuMC4z')
 local extopt = '$OPT:http-user-agent=' .. userAgent
 m_simpleTV.User.PeersTV01.ExtOpt = extopt
------------------------------------------------------------------------------
 local session = m_simpleTV.Http.New(userAgent)
 if session == nil then return end
---------------------------------------------------------------------------
m_simpleTV.User.TVTimeShift.PeersTVTimeshiftAdress = nil

    local tt={}
    tt.url = decode64('aHR0cDovL2FwaS5wZWVycy50di9hdXRoLzIvdG9rZW4=')
    tt.body = decode64('Z3JhbnRfdHlwZT1pbmV0cmElM0Fhbm9ueW1vdXMmY2xpZW50X2lkPTI5NzgzMDUxJmNsaWVudF9zZWNyZXQ9YjRkNGViNDM4ZDc2MGRhOTVmMGFjYjViYzZiNWM3NjA=')
    tt.method = 'post'
    tt.headers = 'Content-Type: application/x-www-form-urlencoded'
    
    local rc,answer = m_simpleTV.Http.Request(session, tt)
    --m_simpleTV.Http.Close(session)
   
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("peers.tv getaddress error 1 " .. rc ,255,3)
   	   return
    end

--debug_in_file(answer .. '\n\n')

  local token = findpattern(answer, ':%b""',1,2,1)
  if token ==nil then 
     m_simpleTV.OSD.ShowMessage("peers.tv access token not found - abort " ,255,3)
     return 
  end
 
  inAdr = string.gsub(inAdr,'$peerstv=','') 
  inAdr = decode64(inAdr)
  --debug_in_file(inAdr .. '\n\n')

  local retAdr = string.gsub(inAdr,'%$(.+)','')

  local channelId = findpattern(inAdr, '%$id=(.-)%$',1,4,1)
  --debug_in_file(channelId .. '\n\n')


  local isTimeshift = findpattern(inAdr, '%$tshift=(.-)%$',1,8,1)
  if isTimeshift == 'true' then
     m_simpleTV.User.TVTimeShift.isPeersTVTimeshift = true
   else
     m_simpleTV.User.TVTimeShift.isPeersTVTimeshift = false
   end

  local isAccess = findpattern(inAdr, '%$access=(.+)',1,8,0)
  if isAccess == 'true' then
     retAdr = retAdr .. '?token=' .. token 
  end

m_simpleTV.Control.CurrentAdress = retAdr .. extopt
--debug_in_file(m_simpleTV.Control.CurrentAdress)

local str = '#EXTINF:-1,' .. m_simpleTV.Control.CurrentTitle_UTF8 .. '\n' .. m_simpleTV.Control.CurrentAdress .. '\n'
--debug_in_file(str)

if m_simpleTV.User.TVTimeShift.isPeersTVTimeshift then
   url = decode64('aHR0cHM6Ly9hcGkucGVlcnMudHYvbWVkaWFsb2NhdG9yLzEvdGltZXNoaWZ0Lmpzb24/c3RyZWFtX2lkPQ==') .. channelId .. '&offset=3600 '
    rc,answer = m_simpleTV.Http.Request(session,{url = url, headers = decode64('QXV0aG9yaXphdGlvbjogQmVhcmVyIA==') .. token})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("peers.tv getaddress error 2 " .. rc ,255,3)
   	   return
    end
  
  --debug_in_file(answer .. '\n')

  local tadr = findpattern(answer, ':%b""',1,2,1) or ''
  tadr = string.gsub(tadr, '\\', '')
  tadr = string.gsub(tadr, '?(.+)', '')
  --debug_in_file('PeersTVTimeshiftAdress = ' .. tadr .. '\n')

  m_simpleTV.User.TVTimeShift.PeersTVTimeshiftAdress = tadr

end


