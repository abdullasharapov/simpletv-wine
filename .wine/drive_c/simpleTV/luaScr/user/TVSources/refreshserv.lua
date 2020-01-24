-- если  стрим udpxy		
if  TVSources_var.tmp.MenuId  then 

-- Рестарт воспроизведения,  IP сервера сброшен, чтобы принудительно найти новый.
	if TVSources_var.tmp.CurrentId and TVSources_var.tmp.source and m_simpleTV.Control.MainMode <= 3 then
	
	    local tmp_src = TVSources_var.tmp.source[TVSources_var.tmp.CurrentId]
		m_simpleTV.OSD.ShowMessage_UTF8((tmp_src.name or '') .. ': поиск сервера' , 0xffffff, 5)
		TVSources_var.tmp.source = tvs_core.tvs_GetSourceParam()
		TVSources_var.tmp.source[TVSources_var.tmp.CurrentId].ip='manual'
	    tvs_core.tvs_SaveSources() 
		if m_simpleTV.Control.Restart then 
		   m_simpleTV.Control.Restart(false) 
		else
		   m_simpleTV.Control.ExecuteAction(11)
		   m_simpleTV.Control.ExecuteAction(63)
		end
	
	end

end

-- серии / качество  (в скриптах видео)
--m_simpleTV.Control.ChangeAdress = 'No'  	dofile (m_simpleTV.MainScriptDir .. 'user/video/video.lua') 	m_simpleTV.Control.ExecuteAction(108) 
