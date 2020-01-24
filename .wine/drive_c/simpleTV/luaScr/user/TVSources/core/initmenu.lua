
----------- Прописываемся в горячих клавишах --------------
local function AddExtMenu(t)
	 	if m_simpleTV.Interface.AddExtMenuT then 	m_simpleTV.Interface.AddExtMenuT(t)
		else	 m_simpleTV.Interface.AddExtMenu_UTF8(t.name, t.luastring, t.key, t.ctrlkey)
		end	 
end

	local t ={}
    t.submenu =  "TVSources"
	t.image = TVSources_var.TVSdir .. '\\settings\\img\\TVSourcesButtonC.png'
    -------------    
	t.name = tvs_core.tvs_GetLangStr('menu_hotkey')
	t.luastring = 'user\\TVSources\\selectsource.lua'
	t.key = TVSources_var.HotKey[1]
	t.ctrlkey = TVSources_var.HotKey[2]
    AddExtMenu(t)
		
	t.name = tvs_core.tvs_GetLangStr('menu_upd_pls')
	t.luastring = 'user\\TVSources\\selectupdate.lua'
	t.key = TVSources_var.HotKeyUpd[1]
	t.ctrlkey = TVSources_var.HotKeyUpd[2]
	AddExtMenu(t)
	
	if TVSources_var.HotKeyServ[1]~=0 then
		t.name = tvs_core.tvs_GetLangStr('menu_server_start')
		if  m_simpleTV.Common.isX64()  then
			t.luastring = 'user\\TVSources\\core\\x64\\tvs_server.lua'
		else
			t.luastring = 'user\\TVSources\\core\\tvs_server.lua'
		end
		t.key = TVSources_var.HotKeyServ[1]
		t.ctrlkey = TVSources_var.HotKeyServ[2]
		AddExtMenu(t)
	end
	-------------------------------
if TVSources_var.DMode==1  then
	m_simpleTV.Interface.AddExtMenu_UTF8('TEST', 'user\\TVSources\\TEST.lua', string.byte('0'),1)  -- ctrl+0
end

