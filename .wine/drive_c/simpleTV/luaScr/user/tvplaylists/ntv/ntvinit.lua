if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.NTVPlus==nil then m_simpleTV.User.NTVPlus={} end

AddFileToExecute('events',m_simpleTV.MainScriptDir .. "user/tvplaylists/ntv/events.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/ntv/getaddress.lua")
