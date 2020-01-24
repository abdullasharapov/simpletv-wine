if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.YaTV==nil then m_simpleTV.User.YaTV={} end

--AddFileToExecute('events',m_simpleTV.MainScriptDir .. "user/tvplaylists/yatv/events.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/yatv/getaddress.lua")
