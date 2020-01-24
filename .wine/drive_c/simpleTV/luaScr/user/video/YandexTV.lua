-- видеоскрипт для плейлиста "YandexTV" https://yandex.ru (5/8/19)
-- открывает подобные ссылки:
-- https://strm.yandex.ru/ka1/bigasia/bigasia0.m3u8
-- https://strm.yandex.ru/kal/ohotnik/ohotnik0_169_480p.json/index-v1-a1.m3u8
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://strm%.yandex%.ru/ka') and not inAdr:match('^%$tYndx') then return end
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	if inAdr:match('start=') and not inAdr:match('%$tYndx') then
		inAdr = '$tYndx' .. inAdr
	end
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.tYndx then
		m_simpleTV.User.tYndx = {}
	end
	local extopt = ''
	if m_simpleTV.Common.GetVlcVersion() > 3000 then
		extopt = extopt .. '$OPT:no-gnutls-system-trust'
	end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = 'error'
	if not inAdr:match('%$tYndx')
		and m_simpleTV.Control.GetMultiAddressIndex()
		and m_simpleTV.Control.GetMultiAddressIndex() >= 0
		and not ((tvs_core) and (TVSources_var.IsTVS == true))
		or inAdr:match('start=')
	then
		m_simpleTV.Control.CurrentAdress = inAdr:gsub('%?.+', ''):gsub('&.+', ''):gsub('%$tYndx', '') .. extopt
	 return
	end
	if not m_simpleTV.User.TVTimeShift then
		m_simpleTV.User.TVTimeShift = {}
	end
	if not m_simpleTV.User.tYndx.RES then
		m_simpleTV.User.tYndx.RES = tonumber(m_simpleTV.Config.GetValue('tYndxRES') or '10000')
	end
	local function GetRESIndex(t)
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if ((tvs_core) and (TVSources_var.IsTVS == true)) then
			index = nil
		end
		if not index and not m_simpleTV.User.tYndx.RES then
			m_simpleTV.User.tYndx.RES = t[#t].res
		elseif index then
			if #t < index then
				index = #t - 1
			end
			if t[index+1] and t[index+1].res then
				m_simpleTV.User.tYndx.RES = t[index+1].res
			end
		end
		if m_simpleTV.User.tYndx.RES > 0 then
			index = 1
			for u = 1, #t do
					if t[u].res and m_simpleTV.User.tYndx.RES < t[u].res then break end
				index = u
			end
		end
	 return index or 1
	end
	if inAdr:match('^$tYndx') then
		if m_simpleTV.User.tYndx.ResolutionTable then
			local index = GetRESIndex(m_simpleTV.User.tYndx.ResolutionTable)
			local retAdr = m_simpleTV.User.tYndx.ResolutionTable[index].Adress:gsub('$tYndx', '')
			if m_simpleTV.User.TVTimeShift.istYndx_Offset == true then
					local offset = m_simpleTV.User.TVTimeShift.tYndx_Offset
					local endY = os.time() - 120
					local startY = os.time() + offset
					if (endY - startY) > (6 * 3600) then
						endY = startY + (6 * 3600)
					end
					retAdr = retAdr .. '?start=' .. startY .. '&end=' .. endY
			end
			m_simpleTV.Config.SetValue('tYndxRES', tostring(m_simpleTV.User.tYndx.RES))
			m_simpleTV.Control.CurrentAdress = retAdr .. extopt
		end
	 return
	end
	m_simpleTV.User.TVTimeShift.istYndx_Offset = false
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local retAdr = inAdr:gsub('_%d+_%d+p%.json.+', '.m3u8'):gsub('/ka1/', '/kal/') .. '?vsid=21'
	rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	local base = retAdr:match('.+/')
	if answer:match('%.json') then
		base = retAdr:match('https?://.-/')
	end
	local i, t, name, adr = 1, {}
		for w in answer:gmatch('EXT%-X%-STREAM%-INF(.-%.m3u8.-)\n') do
			adr = w:match('\n(.+)')
				if not adr then break end
			if not adr:match('redundant') then
				name = w:match('RESOLUTION=(%d+x%d+)') or 'неизвестно'
				t[i] = {}
				t[i].Id = i
				t[i].Name = name
				t[i].Adress = '$tYndx' .. base .. adr:gsub('^/', ''):gsub('%?.+', ''):gsub('&.+', '')
				t[i].res = tonumber(name:match('x(%d+)') or '10')
				i = i + 1
			end
		end
	if i > 2 then
		t[i] = {Id = i, Name = 'адаптивное', res = 10000, Adress = '$tYndx' .. retAdr}
		table.sort(t, function(a, b) return a.res < b.res end)
		for i = 1, #t do t[i].Id = i end
		m_simpleTV.User.tYndx.ResolutionTable = t
		local index = GetRESIndex(t)
		retAdr = t[index].Adress:gsub('%$tYndx', '')
		m_simpleTV.OSD.ShowSelect_UTF8('⚙  Качество', index-1, t, 5000, 32+64+128)
	end
	m_simpleTV.Control.CurrentAdress = retAdr .. extopt
-- debug_in_file(retAdr .. '\n')