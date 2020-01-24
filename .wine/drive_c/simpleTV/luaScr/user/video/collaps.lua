-- видеоскрипт для видеобазы "Collaps" https://collaps.org (11/11/19)
-- открывает подобные ссылки:
-- https://api1571722975.delivembed.cc/embed/movie/10517
-- https://delivembed.cc/embed/video/66176
-- https://api1572271040.iframecdn.club/embed/movie/10698
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://[%w%.]*delivembed%.cc')
			and not inAdr:match('^https?://[%w%.]*framecdn%.club')
			and not inAdr:match('^https?://[%w%.]*buildplayer.com')
			and not inAdr:match('^%$collaps')
		then
		 return
		end
		if m_simpleTV.Common.GetVlcVersion() < 3000 then return end
	require 'json'
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	if inAdr:match('^%$collaps') or not inAdr:match('&kinopoisk') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3809.87 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.collaps then
		m_simpleTV.User.collaps = {}
	end
	if not m_simpleTV.User.collaps.qlty then
		m_simpleTV.User.collaps.qlty = tonumber(m_simpleTV.Config.GetValue('collaps_qlty') or '480')
	end
	m_simpleTV.User.collaps.audios = false
	local title
	local refer = 'https://zombie-film.com/'
	local host = inAdr:match('https?://.-/')
	if m_simpleTV.User.collaps.Tabletitle then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then
			title = m_simpleTV.User.collaps.title .. ' - ' .. m_simpleTV.User.collaps.Tabletitle[index + 1].Name
		end
	end
	local function GetMaxResolutionIndex(t)
		local index
		for u = 1, #t do
				if t[u].qlty and m_simpleTV.User.collaps.qlty < t[u].qlty then break end
			index = u
		end
	 return index or 1
	end
	local function GetcollapsAdr(url)
		url = url:match('"%d+":"(.-)"')
			if not url then return end
		url = url:gsub('^//', 'https://')
		local Adr = url:gsub('/tracks/.-/', '/')
		local rc, answer = m_simpleTV.Http.Request(session, {url = Adr, headers = 'Referer: ' .. refer})
			if rc ~= 200 then
			 m_simpleTV.User.collaps.Table = nil
			 return url .. '$OPT:http-referrer=' .. refer
			end
		local t, i = {}, 1
		local qlty, adr
			for w in answer:gmatch('%#EXT%-X%-STREAM%-INF:(.-\n.-)\n') do
				qlty = w:match('RESOLUTION=%d+x(%d+)')
				adr = w:match('index%-v(%d+)')
					if not qlty or not adr then break end
				t[i] = {}
				t[i].Adress = url:gsub('/tracks/v%d+', '/tracks/v' .. adr) .. '$OPT:http-referrer=' .. refer
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
		m_simpleTV.User.collaps.Table = t
		local a = 0
			for audio in answer:gmatch('%#EXT%-X%-MEDIA:TYPE=AUDIO') do
				a = a + 1
			end
		if a > 1 then
			m_simpleTV.User.collaps.audios = true
		end
		local index = GetMaxResolutionIndex(t)
		m_simpleTV.User.collaps.Index = index
	 return t[index].Adress
	end
	function Qlty_collaps()
		local t = m_simpleTV.User.collaps.Table
			if not t or #t == 0 then return end
		local index = m_simpleTV.User.collaps.Index
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		t.ExtButton0 = {ButtonEnable = m_simpleTV.User.collaps.audios, ButtonName = '🔈'}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index-1, t, 5000, 1 + 4)
		if ret == 1 then
			m_simpleTV.User.collaps.Index = id
			m_simpleTV.User.collaps.qlty = t[id].qlty
			m_simpleTV.Control.SetNewAddress(t[id].Adress, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('collaps_qlty', t[id].qlty)
		end
		if ret == 2 then
			m_simpleTV.Control.ExecuteAction(88)
		end
	end
	local function play(Adr, title)
		local retAdr = GetcollapsAdr(Adr)
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
		if inAdr:match('^%$collaps') then
			play(inAdr, title)
		 return
		end
	if not inAdr:match('&kinopoisk') then
		inAdr = inAdr:gsub('^https?://.-/', 'https://api' .. os.time() .. '.buildplayer.com/')
	else
		inAdr = inAdr:gsub('&kinopoisk', '')
	end
	m_simpleTV.User.collaps.Tabletitle = nil
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: ' .. refer})
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
			m_simpleTV.OSD.ShowMessageT({text = 'collaps ошибка[1]-' .. rc, color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
		 return
		end
	local season_title = ''
	local seson = ''
	title = m_simpleTV.Control.CurrentTitle_UTF8 or 'Collaps'
	m_simpleTV.Control.SetTitle(title)
	local seasons = answer:match('franchise:%s*(%d+)')
	if seasons then
		inAdr = host .. 'contents/season/by-franchise/?id=' .. seasons
		local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: ' .. refer})
			if rc ~= 200 then return end
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
			if not tab then return end
		local t, i = {}, 1
			while true do
					if not tab[i] then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = tab[i].season .. ' сезон'
				t[i].forSort = tab[i].season
				t[i].Adress = tab[i].id
				i = i + 1
			end
			if i == 1 then return end
		if i > 2 then
			table.sort(t, function(a, b) return a.forSort < b.forSort end)
			for i = 1, #t do
				t[i].Id = i
			end
			t.ExtParams = {FilterType = 2}
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберете сезон - ' .. title, 0, t, 5000, 1)
			if not id then
				id = 1
			end
		 	seson = t[id].Adress
			season_title = ' (' .. t[id].Name .. ')'
		else
			seson = t[1].Adress
			local ses = t[1].Name:match('%d+') or '0'
			if tonumber(ses) > 1 then
				season_title = ' (' .. t[1].Name .. ')'
			end
		end
	end
	local episodes = answer:match('seasonId:%s*(%d+)')
	if episodes then
		inAdr = host .. 'contents/video/by-season/?id=' .. seson
		local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: ' .. refer})
			if rc ~= 200 then return end
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
			if not tab then return end
		local t, i = {}, 1
		local Adr, name, poster
			for w in answer:gmatch('"id":.-"blocked"') do
				Adr = w:match('"urlQuality":{(.-)}')
				name = w:match('"episode":"(%d+)')
					if not Adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name .. ' серия'
				t[i].Adress = '$collaps' .. Adr
				poster = w:match('"small":"(.-)"')
				if poster and poster:match('%.jpg') then
					t[i].InfoPanelName = title
					t[i].InfoPanelTitle = w:match('"name":"(.-)",') or t[i].Name
					t[i].InfoPanelShowTime = 5000
					t[i].InfoPanelLogo = poster
				end
				i = i + 1
			end
			if i == 1 then return end
		m_simpleTV.User.collaps.Tabletitle = t
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_collaps()'}
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
		m_simpleTV.User.collaps.title = title
		title = title .. ' - ' .. m_simpleTV.User.collaps.Tabletitle[1].Name
	else
		inAdr = answer:match('hlsList:%s*{(.-)}')
			if not inAdr then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessageT({text = 'collaps ошибка[3]', color = ARGB(255, 155, 255, 155), showTime = 1000 * 5, id = 'channelName'})
			 return
			end
		title = answer:match('title:%s*"(.-)",') or 'Collaps'
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = title
		t1[1].Adress = inAdr
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_collaps()'}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		m_simpleTV.OSD.ShowSelect_UTF8('Collaps', 0, t1, 5000, 64+32+128)
	end
	play(inAdr, title)