if not string.match(package.path, "user/recordPattern/Core", 0) then
  package.path = package.path .. ";" .. m_simpleTV.MainScriptDir .. "user/recordPattern/Core/?.lua"
end

m_simpleTV.Interface.AddTranslator(   m_simpleTV.MainScriptDir_UTF8 
								     .. "user/recordPattern/translations/lang_" 
								     .. m_simpleTV.Interface.GetLanguage())

require("recordPattern")
AddFileToExecute("onconfig", m_simpleTV.MainScriptDir .. "user/recordPattern/initconfig.lua")
