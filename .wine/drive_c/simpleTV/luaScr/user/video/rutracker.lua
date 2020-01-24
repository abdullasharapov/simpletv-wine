-- видеоскрипт для сайта http://rutracker.org (1/07/19)
-- необходим Acestream
-- логин, пароль установить в 'Password Manager', для ID - rutracker
-- открывает подобные ссылки:
-- https://rutracker.org/forum/viewtopic.php?t=5419035
-- http://rutracker.cr/forum/dl.php?t=5340308
------------------------------------------------------------------------------------------
local prx = '' -- прокси: '' - нет; например 'http://proxy-nossl.antizapret.prostovpn.org:29976'
------------------------------------------------------------------------------------------
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://rutracker%..-/forum/') then return end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 1, id = 'channelName'})
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('rutracker') end, err)
		if login == '' or password == '' or not login or not password then
			m_simpleTV.OSD.ShowMessageT({text = 'Для rutracker нужен логин и пароль\nrutracker ошибка[1]', color = ARGB(255, 255, 0, 0)})
		 return
		end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/68.0.2785.143 Safari/537.36', prx, false)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local rc, answer = m_simpleTV.Http.Request(session, {method = 'post', url = inAdr:match('https?://.-/') .. 'forum/login.php', headers = '\nReferer: ' .. inAdr .. '\nContent-Type: application/x-www-form-urlencoded', body = 'login_username=' .. url_encode(login) .. '&login_password=' .. url_encode(password) .. '&login=%C2%F5%EE%E4'})
		if rc ~= 200 or (rc == 200 and answer:match('/captcha/')) then
			m_simpleTV.Http.Close(session)
			m_simpleTV.OSD.ShowMessageT({text = 'Ошибка авторизации\nперелогинтесь в браузере\n\nrutracker ошибка[1]', color = ARGB(255, 255, 0, 0)})
		 return
		end
	rc, answer = m_simpleTV.Http.Request(session, {method = 'post', url = inAdr:gsub('viewtopic', 'dl'), writeinfile = true})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	if m_simpleTV.Control.CurrentTitle_UTF8 then
		m_simpleTV.Control.CurrentTitle_UTF8 = 'rutracker'
	end
	m_simpleTV.Control.CurrentAdress = 'torrent://' .. answer
-- debug_in_file(inAdr .. '\n')