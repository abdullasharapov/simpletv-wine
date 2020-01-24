if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.SPBTV01==nil then m_simpleTV.User.SPBTV01={} end

--AddFileToExecute('events',m_simpleTV.MainScriptDir .. "user/tvplaylists/spbtv/events.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/spbtv/getaddress.lua")
