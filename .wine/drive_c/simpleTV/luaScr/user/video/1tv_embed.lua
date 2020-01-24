-- видеоскрипт для сайта http://1tv.ru (8/8/18)
-- открывает подобные ссылки:
-- https://www.1tv.ru/embed/93684:12
-- http://www.1tv.ru/i_video/88056
-- <iframe width="560" height="315" src="//www.1tv.ru/embed/39598:12" frameborder="0" allow="encrypted-media" allowfullscreen></iframe>
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('www%.1tv%.ru/i_video/') and not inAdr:match('www%.1tv%.ru/embed/') then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local uid = inAdr:match('/(%d+)')
		if not uid then return end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if inAdr:match('/embed/') then url = 'https://www.1tv.ru/video_materials.json?single=true&video_id=' .. uid end
	if inAdr:match('/i_video/') then url = 'https://www.1tv.ru/video_materials.json?single=true&legacy_id=' .. uid end
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('1tv ошибка[1]-' .. rc, 255, 5)
		 return
		end
	local retAdr = answer:match('"hd","src":"(.-)"') or answer:match('"sd","src":"(.-)"') or answer:match('"ld","src":"(.-)"')
		if not retAdr then
			m_simpleTV.OSD.ShowMessage_UTF8('1tv ошибка[2]', 255, 5)
		 return
		end
	retAdr = retAdr:gsub('^//', 'http://'):gsub('%.mp4', ',.mp4.urlset/master.m3u8')
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')