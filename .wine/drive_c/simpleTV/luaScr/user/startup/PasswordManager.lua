if not string.match(package.path, "user/PasswordManager/Core", 0) then
  package.path = package.path .. ";" .. m_simpleTV.MainScriptDir .. "user/PasswordManager/Core/?.lua"
end

if m_simpleTV.Interface.AddTranslator~=nil then
  m_simpleTV.Interface.AddTranslator(   m_simpleTV.MainScriptDir_UTF8 
								     .. "user/PasswordManager/translations/lang_" 
								     .. m_simpleTV.Interface.GetLanguage())
end 								   

require("pm")
AddFileToExecute("onconfig", m_simpleTV.MainScriptDir .. "user/PasswordManager/initconfig.lua")
