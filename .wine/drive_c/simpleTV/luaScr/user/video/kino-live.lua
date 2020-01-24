-- видеоскрипт для сайта http://kino-live2.org (19/8/19)
-- открывает подобные ссылки:
-- http://kino-live2.org/715732764-kontakt.html
-- http://kino-live12.site/715732790-sobaki-mstiteli.html
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://kino%-live[%d+]*%.')
			and not inAdr:match('https?://kinolive%.')
			and not inAdr:match('&kinolive')
		then
		 return
		end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 5, id = 'channelName'})
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	local host = inAdr:match('(https?://.-)/')
	local retAdr = inAdr
	if not retAdr:match('&kinolive') then
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.CurrentAdress = ''
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
	local function nameclean(name)
		local name = name:gsub('%sHD', ''):gsub('1080p?', ''):gsub('720p?', ''):gsub('FullHD', ''):gsub('%(HD%)', ''):gsub('%(SATRip%)', ''):gsub('%(WEBRip%)', ''):gsub('%[%]', ''):gsub('%s%)', ')'):gsub('%(%)', ''):gsub('онлайн на.+', '')
	 return name
	end
	local function GetAddressFromPlaylist(answer)
		local tab = json.decode(answer)
			if not tab or not tab.playlist then
				m_simpleTV.OSD.ShowMessage_UTF8('kino-live ошибка[1]', 255, 5)
			 return
			end
		local a, n, k, l, sezon = {}, 1
		local Adr, sezon = '', ''
		for i = 1, #tab.playlist, 1 do
			local t = tab.playlist
			local isfile
			if t[i].file ~= nil then
				k = 1
				isfile = true
			else
				if t[i].playlist == nil then break end
				t = t[i].playlist
				k = #t
				isfile = false
			end
			if k > 1 then
				sezon = tab.playlist[i].comment
				sezon = ' (' .. sezon .. ')'
			end
			for j = 1, k, 1 do
				a[n] = {}
				a[n].Id = n
				if isfile == true then
					l = i
				elseif isfile == false then l = j end
					a[n].Name = nameclean(t[l].comment .. sezon)
					a[n].Adress = t[l].file .. '&kinolive'
					n = n + 1
			end
		end
		if #a > 1 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, a, 5000)
			if id == nil then id = 1 end
			retAdr = a[id].Adress
			title = title .. ' - ' .. a[id].Name
		else
			retAdr = a[1].Adress
		end
	 return retAdr
	end
		local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessage_UTF8('kino-live ошибка[2]-' .. rc, 255, 5)
			 return
			end
		local flashvars = answer:match('<iframe src=".-</iframe>')
			if not flashvars then
				m_simpleTV.OSD.ShowMessage_UTF8('kino-live ошибка[3]', 255, 5)
			 return
			end
		title = answer:match('<title>(.-)</title>') or 'kino-live'
		title = m_simpleTV.Common.multiByteToUTF8(title)
		title = nameclean(title)
		m_simpleTV.Control.CurrentTitle_UTF8 =
		m_simpleTV.OSD.ShowMessageT({text = title, showTime = 1000 * 5, id = 'channelName'})
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		local file = flashvars:match('file=(.-)"')
		local pl = file:match('/player/.+')
		if pl then
			local pl = host .. pl
			local rc, answer = m_simpleTV.Http.Request(session, {url = pl})
				if rc ~= 200 then
					m_simpleTV.Http.Close(session)
					m_simpleTV.OSD.ShowMessage_UTF8('kino-live ошибка[4]' .. rc, 255, 5)
				 return
				end
			answer = answer:match('{.+}')
				if not answer then m_simpleTV.Http.Close(session) return end
			answer = answer:gsub('(%[%])', '"nil"')
			retAdr = GetAddressFromPlaylist(answer, title)
			retAdr = retAdr:gsub('&kinolive', '')
			m_simpleTV.Control.CurrentAdress = retAdr
		 return
		end
		if file then
			retAdr = file
		end
			if not file and not pl then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessage_UTF8('kino-live ошибка[5]', 255, 5)
			 return
			end
		m_simpleTV.Http.Close(session)
	end
	retAdr = retAdr:gsub('&kinolive', '')
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')