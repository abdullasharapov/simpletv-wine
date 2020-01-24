-- script run from selectsource.lua
function OnOk(Object) -- must have
   TVSources_var.isMenuShowSelect = false

	if m_simpleTV.Control.CurrentTitle_UTF8 then
		m_simpleTV.Control.SetTitle(m_simpleTV.Control.CurrentTitle_UTF8:gsub("%b[]%s+",""))    
	end
	
	m_simpleTV.Control.EventPlayingInterval = 0
	m_simpleTV.Control.EventTimeOutInterval = 0 
end

function OnCancel(Object) -- must have
   TVSources_var.isMenuShowSelect = false
end


