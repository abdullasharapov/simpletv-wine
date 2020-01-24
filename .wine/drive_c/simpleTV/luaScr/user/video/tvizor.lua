------------------------------------------------------------------------------------------------------
-- Open link http://tvizor.org/travel-channel.html or  http://onelike.tv/vh1.html or  http://telego8.net/match-tv-live.html  
-- or http://ok-tv.org/channels/223-sarafan-tv.html  or http://only-tv.org/okhotnik-i-rybolov.html
-- or  http://hdtv720.net/..
----------------------------------------------------------------------------------------------------- 
if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
local inAdr =  m_simpleTV.Control.CurrentAddress_UTF8
if inAdr==nil then return end
if  not inAdr:find('^https?://hdtv720%.net')
    and  not inAdr:find('^https?://onelike%.tv')  
    and  not inAdr:find('^https?://onelike%-tv%.net')  
    and  not inAdr:find('^https?://telego%d+%.net')   
    and  not inAdr:find('^https?://telego%d+%.com')   
    and  not inAdr:find('^https?://vkluchitv%d+%.net')   
    and  not inAdr:find('^https?://vkluchitv%d+%.com')   
    and  not inAdr:find('^https?://ok%-tv%.org')   
    and  not inAdr:find('^https?://ok%-tv%.net')   
    and  not inAdr:find('^https?://only%-tv%.org')   
    and  not inAdr:find('^https?://only%-tv%.net')   
    and  not inAdr:find('^https?://tvizor%.org')  
    then return 
end
    
 local extopt = inAdr:match('(%$OPT:.+)') or ''
inAdr = inAdr:gsub('(%$OPT:.+)','')
m_simpleTV.Control.ChangeAdress = 'Yes'
m_simpleTV.Control.ChangeAddress = 'Yes'
m_simpleTV.Control.CurrentAddress = 'error'
------------------------------------------------------------------------------------
	local rc, answer
	local ua = "Mozilla/5.0 (Windows NT 10.0; rv:58.0) Gecko/20100101 Firefox/58.0"
	local session = m_simpleTV.WinInet.New( ua)
	if session == nil then return end
	m_simpleTV.WinInet.SetOptionInt(session,2,6000,0)
	m_simpleTV.WinInet.SetOptionInt(session,6,6000,0)
	m_simpleTV.WinInet.SetOpenRequestFlags(session, 0x80000000 + 0x04000000)
	
   if inAdr:find('https?://hdtv720.net')   then 
				rc, answer = m_simpleTV.WinInet.Request(session,{url="http://hdtv720.net/"})
				if rc ~= 200 then
				        m_simpleTV.WinInet.Close(session)
				        m_simpleTV.OSD.ShowMessage_UTF8("Ошибка соединения 1 - " .. rc,255,10)
				      return
				end	
		       local host  = answer:match('<a target="_blank"%s+href=[\"\']https?://(.-)/')
		       inAdr = inAdr:gsub("hdtv720.net",host)
	end
	
	
	rc, answer = m_simpleTV.WinInet.Request(session,{url=inAdr})
	if rc ~= 200 then
	        m_simpleTV.WinInet.Close(session)
	        m_simpleTV.OSD.ShowMessage_UTF8("Ошибка соединения 1 - " .. rc,255,10)
	      return
	end	
	answer = answer:gsub("<%!%-%-(.-)%-%->","")
	local refAdr = answer:match ('<iframe.*src="(.-php)"')
	--debug_in_file(refAdr)
	-----------------------------------------------------------
	local headers = 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n' ..
	                       'Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3\r\n' ..
	                       'Referer: ' .. inAdr .. '\r\n' 
	rc, answer = m_simpleTV.WinInet.Request(session,{url=refAdr, headers = headers})
	if rc ~= 200 then
	        m_simpleTV.WinInet.Close(session)
	        m_simpleTV.OSD.ShowMessage_UTF8("Ошибка соединения 2 - " .. rc,255,10)
	      return
	end
	-------------------------------------------------------------
	--debug_in_file(answer)
	local retAdr =  answer:match("file%:%s?['\"](http.-)['\"]")  or answer:match("source.*src=['\"](http.-)['\"] ")  or answer:match("file=(.-)['\"]>") or answer:match("value=['\"]src=(http.-)&") 
	if retAdr == nil then
	    m_simpleTV.OSD.ShowMessage_UTF8("Поток не найден",255,10)
	   return
	end
---------------------------------------------------------------------
--extopt =  '$OPT:http-referrer=' .. inAdr .. '$OPT:http-user-agent='..ua
--debug_in_file('TVizor: ' ..retAdr .. extopt)
m_simpleTV.Control.CurrentAddress =  retAdr .. extopt
m_simpleTV.Control.CurrentAddress_UTF8 =  retAdr .. extopt
