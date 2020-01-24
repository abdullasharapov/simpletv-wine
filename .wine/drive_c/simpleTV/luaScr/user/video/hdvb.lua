-- видеоскрипт для видеобазы "Hdvb" https://hdvb.tv (12/11/19)
-- открывает подобные ссылки:
-- https://vid1571635931.tehranvd.biz/movie/8ac41b6af2ddc76c2bb2d3a202087a52/iframe
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://vid%d+.-/%a+/%x+/iframe')
			and not inAdr:match('^%$hdvb')
			and not inAdr:match('^https?://farsihd%.%a+/.+')
		then
		 return
		end
		if inAdr:match('%.m3u8') then return end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	if inAdr:match('^%$hdvb') or not inAdr:match('&kinopoisk') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3809.87 Safari/537.36', nil, true)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.hdvb then
		m_simpleTV.User.hdvb = {}
	end
	if not m_simpleTV.User.hdvb.qlty then
		m_simpleTV.User.hdvb.qlty = tonumber(m_simpleTV.Config.GetValue('hdvb_qlty') or '10000')
	end
	local refer = 'http://filmhd1080.pro/'
	local title
	if m_simpleTV.User.hdvb.Tabletitle then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then
			title = m_simpleTV.User.hdvb.title .. ' - ' .. m_simpleTV.User.hdvb.Tabletitle[index + 1].Name
		end
	end
	local function trim(s)
	 return s:gsub('^%s*(.-)%s*$', '%1')
	end
	local function GetAddress(Adr)
		local rc, answer = m_simpleTV.Http.Request(session, {url = Adr, headers = 'Referer: ' .. refer})
			if rc ~= 200 then return end
		answer = answer:match('data%-config=\'(.-)\'')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
			if not tab then return end
		local retAdr = tab.hls
			if not retAdr then return end
	 return retAdr
	end
	local function GetMaxResolutionIndex(t)
		local index
		for u = 1, #t do
				if t[u].qlty and m_simpleTV.User.hdvb.qlty < t[u].qlty then break end
			index = u
		end
	 return index or 1
	end
	local function GetQualityFromAddress(url)
		url = url:gsub('^//', 'https://')
		m_simpleTV.Http.SetRedirectAllow(session, false)
		local rc = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: ' .. refer})
		local raw = m_simpleTV.Http.GetRawHeader(session)
			if not raw then return end
		url = raw:match('Location: (.-)\n')
			if not url then return end
		m_simpleTV.Http.SetRedirectAllow(session, true)
		local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: ' .. refer})
			if rc ~= 200 then return end
		local base = url:match('.+/')
		local t, i = {}, 1
		local qlty, adr
			for w in answer:gmatch('#EXT%-X%-STREAM%-INF:(.-\n.-)\n') do
				qlty = w:match('RESOLUTION=%d+x(%d+)')
				adr = w:match('\n(.+)')
					if not qlty or not adr then break end
				t[i] = {}
				t[i].Adress = base .. adr:gsub('^%./', '') .. '$OPT:http-referrer=' .. refer
				t[i].qlty = qlty
				i = i + 1
			end
			if i == 1 then return end
			for _, v in pairs(t) do
				v.qlty = tonumber(v.qlty)
				if v.qlty > 0 and v.qlty <= 180 then
					v.qlty = 144
				elseif v.qlty > 180 and v.qlty <= 300 then
					v.qlty = 240
				elseif v.qlty > 300 and v.qlty <= 400 then
					v.qlty = 360
				elseif v.qlty > 400 and v.qlty <= 500 then
					v.qlty = 480
				elseif v.qlty > 500 and v.qlty <= 780 then
					v.qlty = 720
				elseif v.qlty > 780 and v.qlty <= 1200 then
					v.qlty = 1080
				elseif v.qlty > 1200 and v.qlty <= 1500 then
					v.qlty = 1444
				elseif v.qlty > 1500 and v.qlty <= 2800 then
					v.qlty = 2160
				elseif v.qlty > 2800 and v.qlty <= 4500 then
					v.qlty = 4320
				end
				v.Name = v.qlty .. 'p'
			end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
		for i = 1, #t do
			t[i].Id = i
		end
		m_simpleTV.User.hdvb.Table = t
		local index = GetMaxResolutionIndex(t)
		m_simpleTV.User.hdvb.Index = index
	 return t[index].Adress
	end
	local function play(Adr, title)
		local retAdr = GetAddress(Adr:gsub('^%$hdvb', ''))
			if not retAdr then
				m_simpleTV.Http.Close(session)
			 return
			end
		retAdr = GetQualityFromAddress(retAdr)
		m_simpleTV.Http.Close(session)
			if not retAdr then
				m_simpleTV.Control.CurrentAdress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
			 return
			end
		if m_simpleTV.Control.CurrentTitle_UTF8 then
			m_simpleTV.Control.CurrentTitle_UTF8 = title
		end
		m_simpleTV.OSD.ShowMessageT({text = title, color = ARGB(255, 155, 155, 255), showTime = 1000 * 5, id = 'channelName'})
		m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')
	end
	function Qlty_hdvb()
		local t = m_simpleTV.User.hdvb.Table
			if not t then return end
		local index = m_simpleTV.User.hdvb.Index
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		if #t > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 1 + 4)
			if ret == 1 then
				m_simpleTV.User.hdvb.Index = id
				m_simpleTV.Control.SetNewAddress(t[id].Adress, m_simpleTV.Control.GetPosition())
				m_simpleTV.Config.SetValue('hdvb_qlty', t[id].qlty)
				m_simpleTV.User.hdvb.qlty = t[id].qlty
			end
		end
	end
		if inAdr:match('^%$hdvb') then
			play(inAdr, title)
		 return
		end
	m_simpleTV.User.hdvb.Tabletitle = nil
	if not inAdr:match('&kinopoisk') then
		inAdr = inAdr:gsub('://vid%d+', '://vid' .. os.time())
		inAdr = inAdr:gsub('%.farsihd.%a+/', '.vb17100astridcoleman.pw/')
		inAdr = inAdr:gsub('://farsihd%.info/', '://vid' .. os.time() .. '.vb17100astridcoleman.pw/')
		inAdr = inAdr:gsub('http://', 'https://')
	else
		inAdr = inAdr:gsub('&kinopoisk', '')
	end
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: ' .. refer})
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
			m_simpleTV.OSD.ShowMessageT({text = 'hdvb ошибка[1]-' .. rc, color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
		 return
		end
	local title = m_simpleTV.Control.CurrentTitle_UTF8 or 'hdvb'
	m_simpleTV.Control.SetTitle(title)
	local transl = ''
	local tr = answer:match('name="translation">.-</div>')
	if tr then
		local t, i = {}, 1
			for Adr, name in tr:gmatch('<option.-value="(.-)".->(.-)</option>') do
				t[i] = {}
				t[i].Id = i
				t[i].Name = trim(name)
				t[i].Adress = trim(Adr)
				i = i + 1
			end
			if i == 1 then return end
		if i > 2 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберете перевод - ' .. title, 0, t, 5000, 1)
			if not id then
				id = 1
			end
			transl = t[id].Adress
			rc, answer = m_simpleTV.Http.Request(session, {url = inAdr .. '?t=' .. transl, headers = 'Referer: ' .. refer})
				if rc ~= 200 then return end
		else
			transl = t[1].Adress
		end
		transl = '&t=' .. transl
	end
	local season = ''
	local season_title = ''
	local seasons = answer:match('name="seasons">.-<select')
	if seasons then
		local t, i = {}, 1
			for Adr, name in seasons:gmatch('<option.-value="(.-)".->(.-)</option>') do
				t[i] = {}
				t[i].Id = i
				t[i].Name = trim(name)
				t[i].Adress = trim(Adr)
				i = i + 1
			end
			if i == 1 then return end
		if i > 2 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберете сезон - ' .. title, 0, t, 5000, 1)
			if not id then
				id = 1
			end
			season = t[id].Adress
			season_title = ' (' .. t[id].Name .. ')'
			rc, answer = m_simpleTV.Http.Request(session, {url = inAdr .. '?s=' .. season .. transl, headers = 'Referer: ' .. refer})
				if rc ~= 200 then return end
		else
			season = t[1].Adress
			local ses = t[1].Name:match('%d+') or '0'
			if tonumber(ses) > 1 then
				season_title = ' (' .. t[1].Name .. ')'
			end
		end
		season = '&s=' .. season
	end
	local episodes = answer:match('name="episodes">.-<select')
	if episodes then
		local t, i = {}, 1
			for Adr, name in episodes:gmatch('<option.-value="(.-)".->(.-)</option>') do
				t[i] = {}
				t[i].Id = i
				t[i].Name = trim(name)
				t[i].Adress = '$hdvb' .. inAdr .. '?e=' .. trim(Adr) .. season .. transl
				i = i + 1
			end
			if i == 1 then return end
		m_simpleTV.User.hdvb.Tabletitle = t
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_hdvb()'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		local p = 0
		if i == 2 then
			p = 32 + 128
		end
		t.ExtParams = {FilterType = 2}
		title = title .. season_title
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 5000, p)
		if not id then
			id = 1
		end
		inAdr = t[id].Adress
		m_simpleTV.User.hdvb.title = title
		title = title .. ' - ' .. m_simpleTV.User.hdvb.Tabletitle[1].Name
	else
		inAdr = inAdr .. transl
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = title
		t1[1].Adress = inAdr
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_hdvb()'}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		m_simpleTV.OSD.ShowSelect_UTF8('Hdvb', 0, t1, 5000, 64+32+128)
	end
	play(inAdr, title)