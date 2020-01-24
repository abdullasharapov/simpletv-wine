-- видеоскрипт для сайта http://rutube.ru (31/8/19)
-- открывает подобные ссылки:
-- http://rutube.ru/play/embed/65096dd768a0ddf62cf578651f3ad431?autoStart=false
-- https://rutube.ru/video/9674ccc10aaf921bff941ecdfe05f9b5/?pl_id=1721&pl_type=source
-- http://rutube.ru/video/embed/d25d3888d24e1a4d37950cb540c0bbe3
-- https://rutube.ru/feeds/live/9f87a9a0cecbe773be6fddcbd93585ac/
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://rutube%.ru') and not inAdr:match('^%$rutube') then return end
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = 'error'
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.rutube then
		m_simpleTV.User.rutube = {}
	end
	if not m_simpleTV.User.rutube.qB then
		m_simpleTV.User.rutube.qB = tonumber(m_simpleTV.Config.GetValue('rutube_qlty_b') or '100000000')
	end
	if not m_simpleTV.User.rutube.qR then
		m_simpleTV.User.rutube.qR = tonumber(m_simpleTV.Config.GetValue('rutube_qlty_r') or '100000000')
	end
	if m_simpleTV.User.rutube.qlty_mode == true then
		m_simpleTV.User.rutube.qR = m_simpleTV.User.rutube.qlty or m_simpleTV.User.rutube.qR
	else
		m_simpleTV.User.rutube.qB = m_simpleTV.User.rutube.qlty or m_simpleTV.User.rutube.qB
	end
	local function GetRESIndex(t)
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if (tvs_core) and (TVSources_var.IsTVS == true) then
			index = nil
		end
		if not index and not m_simpleTV.User.rutube.qlty then
			m_simpleTV.User.rutube.qlty = t[#t].res
		elseif index then
			if #t < index then
				index = #t - 1
			end
			if t[index+1] and t[index+1].res then
				m_simpleTV.User.rutube.qlty = t[index+1].res
			end
		end
		if m_simpleTV.User.rutube.qlty > 0 then
			for u = 1, #t do
					if t[u].res and m_simpleTV.User.rutube.qlty < t[u].res then break end
				index = u
			end
		end
	 return index or 1
	end
	if inAdr:match('^$rutube') then
		if m_simpleTV.Control.CurrentTitle_UTF8 then
			m_simpleTV.Control.CurrentTitle_UTF8 = m_simpleTV.User.rutube.title
		end
		if m_simpleTV.User.rutube.ResolutionTable then
			local index = GetRESIndex(m_simpleTV.User.rutube.ResolutionTable)
			local retAdr
			if not index then
				retAdr = inAdr
			else
				retAdr = m_simpleTV.User.rutube.ResolutionTable[index].Address
				if m_simpleTV.User.rutube.qlty_mode == true then
					m_simpleTV.Config.SetValue('rutube_qlty_r', tostring(m_simpleTV.User.rutube.qlty))
				else
					m_simpleTV.Config.SetValue('rutube_qlty_b', tostring(m_simpleTV.User.rutube.qlty))
				end
			end
			retAdr = retAdr:gsub('%$rutube', '')
			m_simpleTV.Control.CurrentAdress = retAdr
		end
	 return
	end
	local retAdr = inAdr:gsub('embed/', ''):gsub('play/', 'video/'):gsub('tracks/', 'video/'):gsub('feeds/live/', 'video/')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local id = retAdr:match('video[/=](%w+)')
		if not id then return end
	local Ref = inAdr
	local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://rutube.ru/api/play/options/' .. id .. '/?format=json', headers = 'Referer: ' .. Ref})
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
		return
		end
	retAdr = answer:match('m3u8":%s*"(.-)"') or answer:match('"hls":.-"url":%s*"(.-)"')
		if not retAdr then return end
	local title = answer:match('"title":%s*"(.-)",') or 'rutube'
	title = unescape3(title)
	title = title:gsub('Прямой эфир канала ', '')
	title = title:gsub('Прямой эфир ', '')
	m_simpleTV.User.rutube.title = title
	if m_simpleTV.Control.CurrentTitle_UTF8 then
		m_simpleTV.Control.CurrentTitle_UTF8 = title
	end
	rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	local i, t, name, adr = 1, {}
	if answer:match('RESOLUTION=%d+x(%d+)')	 then
		for w in answer:gmatch('EXT%-X%-STREAM%-INF(.-%.m3u8)') do
			adr = w:match('http.-%.m3u8')
			name = w:match('RESOLUTION=%d+x(%d+)')
				if not adr or not name then break end
			if m_simpleTV.Common.GetVlcVersion() > 3000 then
				adr = adr .. '$OPT:adaptive-use-access$OPT:demux=adaptive,any'
			end
			name = tonumber(name)
			if name > 500 and name < 600 then
				name = 576
			end
			t[i] = {}
			t[i].Name = name .. 'p'
			t[i].Address = '$rutube' .. adr
			t[i].res = name
			i = i + 1
		end
		m_simpleTV.User.rutube.qlty_mode = true
	else
		for w in answer:gmatch('EXT%-X%-STREAM%-INF(.-%.m3u8)') do
			adr = w:match('http.-%.m3u8')
			name = w:match('BANDWIDTH=(%d+)')
				if not adr or not name then break end
			name = tonumber(string.format('%d', name / 1000))
			t[i] = {}
			t[i].res = name
			t[i].Name = name .. ' кбит/с'
			if m_simpleTV.Common.GetVlcVersion() > 3000 then
				adr = adr .. '$OPT:adaptive-use-access$OPT:demux=adaptive,any'
			end
			t[i].Address = '$rutube' .. adr
			i = i + 1
		end
		m_simpleTV.User.rutube.qlty_mode = false
	end
	if m_simpleTV.User.rutube.qlty_mode == true then
		m_simpleTV.User.rutube.qlty = m_simpleTV.User.rutube.qR
	else
		m_simpleTV.User.rutube.qlty = m_simpleTV.User.rutube.qB
	end
	if i > 2 then
		t[i] = {Id = i, Name = 'адаптивное', res = 100000000, Address = '$rutube' .. retAdr}
		local hash, t1 = {}, {}
		for _, v in ipairs(t) do
			if not hash[v.res] then
				t1[#t1 + 1] = v
				hash[v.res] = true
			end
		end
		table.sort(t1, function(a, b) return a.res < b.res end)
		for i = 1, #t1 do
			t1[i].Id = i
		end
		m_simpleTV.User.rutube.ResolutionTable = t1
		local index = GetRESIndex(t1)
		retAdr = t1[index].Address
		if not inAdr:match('/embed/') then
			m_simpleTV.OSD.ShowSelect_UTF8('⚙ качество', index - 1, t1, 5000, 32 + 64 + 128)
		end
	end
	retAdr = retAdr:gsub('%$rutube', '')
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')