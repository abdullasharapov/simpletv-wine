
---------------------------------------------------------------------------
m_simpleTV.Interface.AddExtMenu = function (name,luastr,letter,mod_keys,location,code_page,submenu,image) 
local t={} 
t.utf8 = false 
t.codepage = code_page 
t.name = name 
t.luastring = luastr 
t.key = letter 
t.ctrlkey = mod_keys 
t.location = location 
t.submenu = submenu 
t.image = image 
return m_simpleTV.Interface.AddExtMenuT(t) 
end 
---------------------------------------------------------------------------
m_simpleTV.Interface.AddExtMenu_UTF8 = function (name,luastr,letter,mod_keys,location,code_page,submenu,image) 
local t={} 
t.name = name 
t.luastring = luastr 
t.key = letter 
t.ctrlkey = mod_keys 
t.location = location 
t.submenu = submenu 
t.image = image 
return m_simpleTV.Interface.AddExtMenuT(t) 
end
---------------------------------------------------------------------------
m_simpleTV.Interface.PlaylistGetSelectedItems = m_simpleTV.PlayList.PlaylistGetSelectedItems
m_simpleTV.Interface.PlaylistIsVisible = m_simpleTV.PlayList.PlaylistIsVisible
m_simpleTV.Interface.PlaylistShow = m_simpleTV.PlayList.PlaylistShow

m_simpleTV.Interface.SetElementDebugMode = m_simpleTV.OSD.SetElementDebugMode
m_simpleTV.Interface.AddElementToMainFrame = m_simpleTV.OSD.AddElement
m_simpleTV.Interface.RemoveElementFromMainFrame = m_simpleTV.OSD.RemoveElement
m_simpleTV.Interface.ControlElement = m_simpleTV.OSD.ControlElement
