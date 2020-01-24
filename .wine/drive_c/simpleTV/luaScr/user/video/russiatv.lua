-- видеоскрипт для плейлиста "Россия ТВ" https://vgtrk.com (28/8/19)
-- открывает подобные ссылки:
-- https://live.russia.tv/channel/1
-- https://player.vgtrk.com/iframe/live/id/21/start_zoom/true/showZoomBtn/false/isPlay/false/
-- https://player.vgtrk.com/iframe/datalive/id/19201/sid/kultura
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://live%.russia%.tv/channel/%d')
			and not inAdr:match('^https?://player%.vgtrk%.com/iframe/live/id/%d')
			and not inAdr:match('^https?://player%.vgtrk%.com/iframe/datalive/id/%d')
		then
		 return
		end
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = 'error'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/76.0.3809.87 Safari/537.36', nil, true)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local function GetAdr(url)
		m_simpleTV.Http.SetRedirectAllow(session, false)
		local rc = m_simpleTV.Http.Request(session, {url = url})
		local raw = m_simpleTV.Http.GetRawHeader(session)
			if not raw then return end
	 return raw:match('Location: (.-)\n')
	end
	local id = inAdr:match('/channel/(%d+)')
	if id then
		inAdr = 'https://live.russia.tv/api/now/channel/' .. id
	end
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
		 return
		end
	local sid = answer:match('&sid=(%w+)') or answer:match('\\?/sid\\?/(%w+)')
	local live_id = answer:match('"live_id":(%d+)') or answer:match('datavideo/id/(%d+)')
		if not sid or not live_id then return end
	rc, answer = m_simpleTV.Http.Request(session, {url = 'https://player.vgtrk.com/iframe/datalive/id/'.. live_id .. '/sid/' .. sid})
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
		 return
		end
	retAdr = answer:match('"auto":"(.-)"')
		if not retAdr then return end
	local Adr = GetAdr(retAdr)
		if Adr then
			local host = 'https://livehlsvgtrk2.cdnvideo.ru'
			retAdr = host .. Adr
		end
	rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	local base = retAdr:match('.+/')
	local i, t = 1, {}
	local adr, btr
		for w in answer:gmatch('EXT%-X%-STREAM%-INF(.-%.m3u8.-)\n') do
			btr = w:match('BANDWIDTH=(%d+)')
			if btr then
				adr = w:match('\n(.+)')
					if not adr then break end
				if not adr:match('^http') then
					adr = base .. adr:gsub('%.%./', ''):gsub('^/', '')
				end
				t[i] = {}
				t[i].Adress = adr
				t[i].res = tonumber(w:match('BANDWIDTH=(%d+)'))
				i = i + 1
			end
		end
	if i > 2 then
		table.sort(t, function(a, b) return a.res < b.res end)
		retAdr = t[#t].Adress
	end
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')