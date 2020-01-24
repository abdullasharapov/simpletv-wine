-- видеоскрипт для сайта http://megogo.net (17/2/19)
-- открывает подобные ссылки:
-- https://megogo.ru/ru/view/2874281-garazhi.html
-- https://megogo.net/ru/view/2290531-den-vyborov.html
-- https://megogo.ru/ru/view/148741-zhit-zdorovo.html
-- https://megogo.ru/s/video/embed/index.html?video_id=2614 -- нет меню выбора качества
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://megogo%.') and not inAdr:match('%$megogo') then return end
	require('jsdecode')
	require('json')
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 5, id = 'channelName'})
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/71.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local host = inAdr:match('(https:?//.-)/')
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Megogo then
		m_simpleTV.User.Megogo = {}
	end
	if not m_simpleTV.User.Megogo.RES then
		m_simpleTV.User.Megogo.RES = tonumber(m_simpleTV.Config.GetValue('MegogoRES') or '10000')
	end
	local function GetMaxResolutionIndex(t)
		local index
		for u = 1, #t do
				if t[u].res and (m_simpleTV.User.Megogo.RES) < t[u].res then break end
			index = u
		end
	 return index or 1
	end
	local function GetAddress(id)
		id = id:gsub('%$megogo', '')
		local str = 'video_id=' .. id .. '63ee38849d'
		local url = 'https://cdnjs.cloudflare.com/ajax/libs/blueimp-md5/2.10.0/js/md5.min.js'
		local rc, answer = m_simpleTV.WinInet.Request(session, {url = url})
			if rc ~= 200 then return end
		local hash = jsdecode.DoDecode('md5("' .. str .. '");', false, answer, 0)
		url = 'https://api.megogo.net/v1/stream?video_id=' .. id .. '&sign=' .. hash .. '_kodi_j1'
		rc, answer = m_simpleTV.Http.Request(session, {url = url})
			if rc ~= 200 then return end
		local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
			if not tab or not tab.data or not tab.data.src or tab.data.src == '' then return end
	 return tab.data.src
	end
	local function GetMegogoAddress(retAdr)
		local rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
			if rc ~= 200 then return end
		local tt, i = {}, 1
		local name, adr
			for w in answer:gmatch('#EXT%-X%-STREAM%-INF:(.-)m3u8') do
				name = w:match('NAME="(%d+)') or '10'
				adr = findpattern(w, 'http(.+)', 1, 0, 0) .. 'm3u8'
					if not name or not adr then break end
				tt[i] = {}
				tt[i].Id = i
				tt[i].Name = name
				tt[i].Adress = adr
				tt[i].res = tonumber(name)
				i = i + 1
			end
			if i == 1 then return retAdr end
		table.sort(tt, function(a, b) return a.res < b.res end)
		for i = 1, #tt do tt[i].Id = i end
		m_simpleTV.User.Megogo.Table = tt
		local index = GetMaxResolutionIndex(tt)
		m_simpleTV.User.Megogo.Index = index
		retAdr = tt[index].Adress
	 return retAdr
	end
	function Quality_Megogo()
		local t = m_simpleTV.User.Megogo.Table
			if not t then return end
		local index = m_simpleTV.User.Megogo.Index
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '❌', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		if #t > 1 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙  Качество', index-1, t, 5000, 1+4)
			if ret == 1 then
				m_simpleTV.User.Megogo.Index = id
				m_simpleTV.Control.SetNewAddress(t[id].Adress, m_simpleTV.Control.GetPosition())
				m_simpleTV.Config.SetValue('MegogoRES', t[id].res)
				m_simpleTV.User.Megogo.RES = t[id].res
			end
		end
	end
	local function unescape_html(str)
		str = str:gsub('%(.+%)', '')
		str = str:gsub('Фильм', '')
		str = str:gsub(' %- смотреть.+', '')
		str = str:gsub('Мультсериал ', '')
		str = str:gsub('Шоу ', '')
		str = str:gsub('Сериал.+&quot;', '')
		str = str:gsub('Сериал', '')
		str = str:gsub('season', 'сезон')
		str = str:gsub('Сезон С', 'С')
		str = str:gsub('&rsquo;', 'e')
		str = str:gsub('&eacute;', "'")
		str = str:gsub('&#039;', "'")
		str = str:gsub('&ndash;', "-")
		str = str:gsub('&#8217;', "'")
		str = str:gsub('&raquo;', '"')
		str = str:gsub('&laquo;', '"')
		str = str:gsub('&lt;', '<')
		str = str:gsub('&gt;', '>')
		str = str:gsub('&quot;', '"')
		str = str:gsub('&apos;', "'")
		str = str:gsub('&#(%d+);', function(n) return string.char(n) end)
		str = str:gsub('&#x(%d+);', function(n) return string.char(tonumber(n, 16)) end)
		str = str:gsub('&amp;', '&') -- Be sure to do this after all others
	 return str
	end
	local function FixSpaces(str)
		if not str then return '' end
		str = str:gsub('%s+', ' ')
		str = str:match('^%s*(.-)%s*$')
	 return str
	end
	local retAdr = inAdr
	if not inAdr:match('$megogo') then
		local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessage_UTF8('megogo ошибка[4]-' .. rc, 255, 5)
			 return
			end
		local title = answer:match('<h1.-"view__title">(.-)</h1>') or answer:match('<h1 class="video%-title".->(.-)</h1>') or 'megogo'
		title = FixSpaces(title)
		title = unescape_html(title)
		if m_simpleTV.Control.CurrentTitle_UTF8 then m_simpleTV.Control.CurrentTitle_UTF8 = title end
		local epi = answer:match('"episodes-count"') or answer:match('<li class="filter2i') or answer:match('<ul class="nav seasons%-list">')
		local nameepi
		if epi then
			local t, i = {}, 1
			for w in answer:gmatch('<li class="nav%-item(.-)</li>') do
				local Adr = w:match('href="(.-)"')
				local name = w:match('title="(.-)"')
					if not Adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = unescape_html(name)
				t[i].Adress = host .. Adr:gsub('%s', '')
				i = i + 1
			end
			if i > 2 then
				local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите сезон - ' .. title, 0, t, 5000, 1)
				if not id then id = 1 end
				retAdr = t[id].Adress
				nameepi = t[id].Name
			else
				retAdr = t[1].Adress
			end
			rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
				if rc ~= 200 then
					m_simpleTV.Http.Close(session)
					m_simpleTV.OSD.ShowMessage_UTF8('megogo ошибка[5]-' .. rc, 255, 5)
				 return
				end
		end
		local ser = answer:match('<div class="season')
		retAdr = inAdr:match('/(%d+)') or inAdr:match('video_id=(%d+)') or ''
		if ser then
			ser = answer:match('.+(<div class="season.-data%-episode=.+)')
			if not nameepi then
				nameepi = ''
			else
				nameepi = ' - ' .. nameepi .. ' '
			end
			local i, t = 1, {}
			for w in ser:gmatch('data%-episode=(.-)</div>') do
				local name = w:match('title="(.-)"')
				local Adr = w:match('href="(.-)"')
				local idd = w:match('data%-id="(.-)"')
					if not Adr or not name or not idd then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = unescape_html(name)
				t[i].Adress = idd .. '$megogo'
				i = i + 1
			end
			if i == 1 then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessage_UTF8('megogo ошибка[6]-' .. rc, 255, 5)
			 return
			end
			t.ExtButton1 = {ButtonEnable = true, ButtonName = '❌', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Quality_Megogo()'}
			if i > 2 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. nameepi, 0, t, 5000)
				if not id then id = 1 end
				retAdr = t[id].Adress
			end
			if i == 2 then
				m_simpleTV.OSD.ShowSelect_UTF8(title .. nameepi, 0, t, 5000, 32+128)
				retAdr = t[1].Adress
			end
		else
			local t1 = {}
			t1[1] = {}
			t1[1].Id = 1
			t1[1].Name = title
			t1[1].Adress = retAdr
			if not inAdr:match('video_id=') then
				t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Quality_Megogo()'}
				t1.ExtButton1 = {ButtonEnable = true, ButtonName = '❌', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
				m_simpleTV.OSD.ShowSelect_UTF8('Megogo', 0, t1, 5000, 64+32+128)
			end
		end
	end
	retAdr = GetAddress(retAdr)
		if not retAdr then
			m_simpleTV.Http.Close(session)
			m_simpleTV.OSD.ShowMessageT({text = 'видео доступно только в браузере\nmegogo ошибка[1]', color = ARGB(255, 155, 155, 255), showTime = 1000 * 5, id = 'channelName'})
		 return
		end
	retAdr = GetMegogoAddress(retAdr)
	m_simpleTV.Http.Close(session)
		if not retAdr then
			m_simpleTV.OSD.ShowMessageT({text = 'megogo ошибка[2]', color = ARGB(255, 155, 155, 255), showTime = 1000 * 5, id = 'channelName'})
		 return
		end
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')