if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.Filmon01==nil then m_simpleTV.User.Filmon01={} end

AddFileToExecute('events',m_simpleTV.MainScriptDir .. "user/tvplaylists/filmon/events.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/filmon/getaddress.lua")
