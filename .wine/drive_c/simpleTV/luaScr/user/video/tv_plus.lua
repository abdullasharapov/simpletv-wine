-- видеоскрипт для плейлиста "TV+"  (11/12/18) 
-- нужен  скрарер от 11 дек 2018
-- открывает подобные ссылки:
-- www.tvplusonline.ru/getsignedurlcdn.php?channel=ntv&quality=1
local inAdr = m_simpleTV.Control.CurrentAddress
if not inAdr  or m_simpleTV.Control.ChangeAddress ~= 'No' then return end
--[[
local d1,d2,d3 = inAdr:match('^https?://(%d+)%.(%d+)%.(%d+)')
d1, d2, d3 = tonumber(d1), tonumber(d2), tonumber(d3)
if  not ( (d1== 193 and d2==124 and  d3>=176 and  d3<=183)   or  (d1== 194 and d2==67 and  d3==207  ) )    then   return end
]]
if not inAdr:find('tvplusonline%.ru/') then return end

if not tvs_func then
     m_simpleTV.OSD.ShowMessage_UTF8("Необходимо дополнение TVSources." ,255, 5)
     return
end
m_simpleTV.Control.ChangeAddress = 'Yes'
m_simpleTV.Control.CurrentAddress = 'error'
    
local session = m_simpleTV.WinInet.New("Dalvik/2.1.0 (Linux; Android 7.1.2;)") 
if session == nil then return inAdr end 
        
local str = [[cwXVy2fSihnLC3nPB24GpsbTx3nPBxbSzvrwlLDPBKLUzxqUtMv3kcjeywX2AwSVmI4XlJaGkeXPBNv4oYbbBMrYB2LKidCUms4YoYKIksakcwLMihnLC3nPB24Gpt0GBMLSihrOzw4GCMv0DxjUigfKCIbLBMqGcGLSB2nHBcbYyYWGyw5ZD2vYid0GBv9ZAw1WBgvuvI5xAw5jBMv0lLjLCxvLC3qOC2vZC2LVBIWGEYb1CMWGpsaIAhr0Chm6lY93D3CUDhzWBhvZB25SAw5LlNj1l2DLDhnPz25LzhvYBc5WAha/DxjSpsiGFsaPiaOjBv9ZAw1WBgvuvI5xAw5jBMv0lKnSB3nLkhnLC3nPB24PiaOjCMv0DxjUicHYyZ09mJaWigfUzcbHBNn3zxiGB3iGyxv0AcKk]]
 local res, f = pcall (  tvs_func.b, str )
 if res then
	local auth =  loadstring(f)()	   
	if not inAdr:find('$OPT') then 
		local rc, answer = m_simpleTV.WinInet.Request(session, { url = inAdr .. '&quality=1' .. auth:gsub('^%?','&') } ) 
		m_simpleTV.WinInet.Close(session) 
		local retAdr =  (rc==200 and answer:gsub('%c','') or inAdr)
	    retAdr = retAdr .. decode64("JE9QVDpodHRwLXVzZXItYWdlbnQ9b2todHRwLzMuOS4w")
	    m_simpleTV.Control.CurrentAddress =  retAdr
	 end
end
