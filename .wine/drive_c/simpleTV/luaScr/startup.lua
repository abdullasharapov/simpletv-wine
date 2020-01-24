--!not change global init section!---------
--require('LuaXml')
require ('ex')
dofile (m_simpleTV.MainScriptDir .. "lib/C++Defines.lua")
dofile (m_simpleTV.MainScriptDir .. "lib/common.lua")
dofile (m_simpleTV.MainScriptDir .. "lib/oldScriptHelper/oldScriptHelper.lua")

local pathname = m_simpleTV.MainScriptDir .. "user/startup"

for entry in os.dir(pathname) do
  if string.match(entry.name,'%.lua$') then
	 dofile (m_simpleTV.MainScriptDir .. "user/startup/" .. entry.name)
  end
end
