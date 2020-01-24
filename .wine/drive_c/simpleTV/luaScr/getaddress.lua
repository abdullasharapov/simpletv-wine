if TVSources_var then dofile(TVSources_var.TVSdir ..'/getaddress.lua') end
---------------------------
dofile (m_simpleTV.MainScriptDir .. "user/video/video.lua")
ExecuteFilesByReason('getaddress')

---------------------------
if TVSources_var then dofile(TVSources_var.TVSdir ..'/getfinish.lua') end
