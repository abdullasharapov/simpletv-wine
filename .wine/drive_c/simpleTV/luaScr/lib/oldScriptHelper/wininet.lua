
m_simpleTV.WinInet = {}
m_simpleTV.WinInet.Close = m_simpleTV.Http.Close
m_simpleTV.WinInet.GetCookies = m_simpleTV.Http.GetCookies
m_simpleTV.WinInet.SetCookies = m_simpleTV.Http.SetCookies
m_simpleTV.WinInet.GetRawHeader = m_simpleTV.Http.GetRawHeader
m_simpleTV.WinInet.GetLastError = m_simpleTV.Http.GetLastError
m_simpleTV.WinInet.RequestA = m_simpleTV.Http.RequestA
m_simpleTV.WinInet.Request =  m_simpleTV.Http.Request
m_simpleTV.WinInet.RequestCancel = m_simpleTV.Http.RequestCancel
--m_simpleTV.WinInet.SetGlobalAccessType
-------------------------------------------------------------------------------------
m_simpleTV.WinInet.New = function(userAgent,deprecate0,deprecate1,proxy)
  local needRawHeaders = true
  return m_simpleTV.Http.New(userAgent,proxy,needRawHeaders)
end
-------------------------------------------------------------------------------------
m_simpleTV.WinInet.SetOptionInt = function(session,id,val) 
 if id == 2 then
	m_simpleTV.Http.SetTimeout(session,val)
 elseif id==6 then 
   --ignore 
 else 
   error("m_simpleTV.Http not support this option")
 end
end
-------------------------------------------------------------------------------------
m_simpleTV.WinInet.SetOpenRequestFlags = function(session,val) 
 if val == 0x00200000 then 
 --INTERNET_FLAG_NO_AUTO_REDIRECT 0x00200000
	m_simpleTV.Http.SetRedirectAllow(session,false)
 end
 
end
-------------------------------------------------------------------------------------
m_simpleTV.WinInet.Get = function (session,urlP,deprecated0,deprecated1,headerP) 
return m_simpleTV.Http.Request(session,{url=urlP,header=headerP})
end
m_simpleTV.WinInet.Post = function (session,urlP,deprecated0,headerP,bodyP,fileName)
local t={url=urlP,method="post",headers=headerP,body=bodyP}
if fileName~=nil then t.writeinfile=true t.filename=fileName end
return m_simpleTV.Http.Request(session,t)
end
m_simpleTV.WinInet.GetFile = function (session,urlP,deprecated0,filenameP)
return m_simpleTV.Http.Request(session,{url=urlP,writeinfile=true,filename=filenameP})
end