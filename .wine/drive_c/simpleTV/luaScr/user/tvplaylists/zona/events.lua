
if m_simpleTV.Control.CurrentAddress and not string.match( m_simpleTV.Control.CurrentAddress, '^$zonaiptvstream=' ) and not string.match( m_simpleTV.Control.RealAddress, '%?ZonaIPTV' ) then return end

if m_simpleTV.Control.Reason=='Timeout' then
   m_simpleTV.OSD.ShowMessage("Server is not responding",255,5)
   m_simpleTV.Control.Action = 'stop'
   m_simpleTV.Control.EventTimeOutInterval=0  
end

if m_simpleTV.Control.Reason=='Error' then

   local adr = m_simpleTV.Control.RealAddress
   local srv_up=0

   if string.match(adr, '%?ZonaIPTV' ) then
      local adr = '$zonaiptvstream=' .. string.gsub(adr , '%?ZonaIPTV' , '')
      m_simpleTV.Control.SetNewAddress(adr) 
      return
   end

   adr = string.gsub(adr, '(.-//.-/).+', '%1') 
    
   local url = adr .. 'status'   
   --debug_in_file(url .. '\n')
    
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
    
  local rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)  
  if rc==200 and string.match(answer, 'udpxy') then
     srv_up=1
    else
    m_simpleTV.OSD.ShowMessage("Server is not responding",255,5)
    m_simpleTV.Http.Close(session)
    m_simpleTV.Control.ExecuteAction(11)
  end      

  if m_simpleTV.User.ZonaIPTV01.RetryCount==nil then
     m_simpleTV.User.ZonaIPTV01.RetryCount=1
  end
  if m_simpleTV.User.ZonaIPTV01.RetryCount >= 100 then
     m_simpleTV.Control.ExecuteAction(11)
     m_simpleTV.OSD.ShowMessage("Can't run this channel. Connection limit is reached",255,5)
  end

  if srv_up==1 then
  
    if m_simpleTV.User.ZonaIPTV01.RetryCount < 100 then
    
       if m_simpleTV.User.ZonaIPTV01.RetryCount~=0 and m_simpleTV.User.ZonaIPTV01.RetryCount % 25 == 0 then
    
          m_simpleTV.OSD.ShowMessage("Trying restart proxy",255,5) 
    
             url = adr .. 'restart'
             rc,answer = m_simpleTV.Http.Request(session,{url = url})
             m_simpleTV.Http.Close(session)
    
       else 
          m_simpleTV.OSD.ShowMessage("Retry count " .. m_simpleTV.User.ZonaIPTV01.RetryCount,255,5)
       end
    
        m_simpleTV.Control.Action = 'repeat'
        m_simpleTV.User.ZonaIPTV01.RetryCount = m_simpleTV.User.ZonaIPTV01.RetryCount+1
    
      end
  
  end

end

if m_simpleTV.Control.Reason=='Playing' then
    if m_simpleTV.User.ZonaIPTV01.PlaylistsName~=nil then 
       m_simpleTV.Control.SetTitle(m_simpleTV.User.ZonaIPTV01.PlaylistsName)
    end
end

if m_simpleTV.Control.Reason=='Stopped' then
   m_simpleTV.User.ZonaIPTV01.PlaylistsName=nil 
   m_simpleTV.User.ZonaIPTV01.RetryCount=nil
end



