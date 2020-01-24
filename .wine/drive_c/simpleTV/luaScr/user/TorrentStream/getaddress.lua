
if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
local inAdr =  m_simpleTV.Control.CurrentAddress_UTF8
if inAdr==nil then return end

if  string.match( inAdr, '^torrent://' ) then return end

if  string.match( inAdr, '^acestream://' ) then 
   inAdr = 	string.gsub( inAdr, '^acestream://','')
   m_simpleTV.Control.ChangeAddress='Yes'
   m_simpleTV.Control.ChangeAddress_UTF8='Yes'
   m_simpleTV.Control.CurrentAddress_UTF8 = 'torrent://PID=' .. inAdr	
   return 
end

if  string.match( inAdr, '%.acestream$' ) then 
   m_simpleTV.Control.ChangeAddress='Yes'
   m_simpleTV.Control.ChangeAddress_UTF8='Yes'
   m_simpleTV.Control.CurrentAddress_UTF8 = 'torrent://' .. inAdr	
   return 
end

if  string.len(inAdr)==40 and findpattern( inAdr, '(%x+)',1,0,0 )==inAdr then
        m_simpleTV.Control.ChangeAddress='Yes'
		m_simpleTV.Control.ChangeAddress_UTF8='Yes'
		m_simpleTV.Control.CurrentAddress_UTF8 = 'torrent://PID=' .. inAdr
		return
 end  

if not string.match( inAdr, '^http' ) then
local t = findpattern( inAdr, '(%x+)%$',1,0,1)
if t~=nil and string.len(t)==40 and findpattern( t, '(%x+)',1,0,0 )==t then
        m_simpleTV.Control.ChangeAddress='Yes'
		m_simpleTV.Control.ChangeAddress_UTF8='Yes'
		m_simpleTV.Control.CurrentAddress_UTF8 = 'torrent://PID=' .. inAdr
		return
 end  
end 
 
if  string.match( inAdr, '%.torrent$' ) or string.match( inAdr, '%.torrent%$' )  then    
   m_simpleTV.Control.ChangeAddress='Yes'
   m_simpleTV.Control.ChangeAddress_UTF8='Yes'
   m_simpleTV.Control.CurrentAddress_UTF8 = 'torrent://' .. inAdr
   return 
end

if  string.match( inAdr, '%.acelive$' ) or string.match( inAdr, '%.acelive%$' )  then 
   m_simpleTV.Control.ChangeAddress='Yes'
   m_simpleTV.Control.ChangeAddress_UTF8='Yes'
   m_simpleTV.Control.CurrentAddress_UTF8 = 'torrent://' .. inAdr
   return 
end

if  string.match( inAdr, '^magnet:' ) then 
   local infohash =  string.match( inAdr, 'btih:(%x+)')
   if infohash~=nil then
	m_simpleTV.Control.ChangeAddress='Yes'
	m_simpleTV.Control.ChangeAddress_UTF8='Yes'
	m_simpleTV.Control.CurrentAddress_UTF8 = 'torrent://INFOHASH=' .. infohash
    end
end



