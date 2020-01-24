if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.ZonaIPTV01==nil then m_simpleTV.User.ZonaIPTV01={} end

AddFileToExecute('events',m_simpleTV.MainScriptDir .. "user/tvplaylists/zona/events.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/zona/getaddress.lua")

