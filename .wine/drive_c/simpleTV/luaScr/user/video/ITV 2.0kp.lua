-- видеоскрипт для источника "ITV 2.0" (kinopoisk) https://itv.rt.ru (3/11/19)
-- открывает подобные ссылки:
-- http://vod-ott.svc.iptv.rt.ru/hls/sd_2017_Istorii_prizrakov__q0w2_film/variant.m3u8
-- https://zabava-htvod.cdn.ngenix.net/hls/hd_1997_Zvezdnyy_desant__q0w0_ar6e6_film/variant.m3u8
-- юзер агент ---------------------------------------------------------------------------------------
local ua = 'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 4 Build/LMY48T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.89 Mobile Safari/537.36'
-- пртокол -----------------------------------------------------------------------------------------
local http = 0
-- 0 - httpS
-- 1 - http
-- прокси -------------------------------------------------------------------------------------------
local prx = ''
-- '' - нет
-- например 'http://217.150.200.152:8081'
-----------------------------------------------------------------------------------------------------
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://vod%-ott%.svc%.iptv%.rt%.ru/hls/')
			and not inAdr:match('^https?://zabava%-htvod%.cdn%.ngenix%.net/hls/')
			and not inAdr:match('^$ITV2kp')
		 then
		return
		end
	if not inAdr:match('&kinopoisk') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	inAdr = inAdr:gsub('&kinopoisk', '')
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.ITV2kp then
		m_simpleTV.User.ITV2kp = {}
	end
	if not m_simpleTV.User.ITV2kp.MaxResolution then
		m_simpleTV.User.ITV2kp.MaxResolution = tonumber(m_simpleTV.Config.GetValue('ITV2kp_qlty') or '100000000')
	end
	if http == 0 then
		inAdr = inAdr:gsub('http://', 'https://')
	else
		inAdr = inAdr:gsub('https://', 'http://')
	end
	local extopt = '$OPT:http-user-agent=' .. ua
	if prx ~= '' then
		extopt = extopt .. '$OPT:http-proxy=' .. prx
	end
	if m_simpleTV.Common.GetVlcVersion() > 3000 and http == 0 then
		extopt = extopt .. '$OPT:no-gnutls-system-trust'
	end
	local function GetMaxResolutionIndex(t)
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if (tvs_core) and (TVSources_var.IsTVS == true) then
			index = nil
		end
		if not index and not m_simpleTV.User.ITV2kp.MaxResolution then
			m_simpleTV.User.ITV2kp.MaxResolution = t[#t].res
		elseif index then
			if #t < index then
				index = #t - 1
			end
			if t[index+1] and t[index+1].res then
				m_simpleTV.User.ITV2kp.MaxResolution = t[index+1].res
			end
		end
		if m_simpleTV.User.ITV2kp.MaxResolution > 0 then
			index = 1
			for u = 1, #t do
					if t[u].res and m_simpleTV.User.ITV2kp.MaxResolution < t[u].res then break end
				index = u
			end
		end
	 return index
	end
		if inAdr:match('^$ITV2kp') then
			if m_simpleTV.User.ITV2kp.ResolutionTable then
				local index = GetMaxResolutionIndex(m_simpleTV.User.ITV2kp.ResolutionTable)
				local retAdr
				if not index then
					retAdr = inAdr
				else
					retAdr = m_simpleTV.User.ITV2kp.ResolutionTable[index].Adress
					m_simpleTV.Config.SetValue('ITV2kp_qlty', tostring(m_simpleTV.User.ITV2kp.MaxResolution))
				end
				retAdr = retAdr:gsub('$ITV2kp', '') .. extopt
				m_simpleTV.Control.CurrentAdress = retAdr
			end
		 return
		end
	local session = m_simpleTV.Http.New(ua, prx, true)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local retAdr = inAdr:gsub('%$OPT:.+', ''):gsub('bw%d+/', '')
	rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	local t, i = {}, 1
	local name, adr
		for w in answer:gmatch('EXT%-X%-STREAM%-INF(.-\n.-)\n') do
			adr = w:match('\n(.+)')
				if not adr then break end
			t[i] = {}
			name = w:match('BANDWIDTH=(%d+)') or '10'
			name = tonumber(name)
			t[i].Name = name / 1000 .. ' кбит/с'
			t[i].res = name
			t[i].Adress = '$ITV2kp' .. adr .. extopt
			i = i + 1
		end
	if i > 2 then
		t[i] = {Id = i, Name = 'адаптивное', res = 100000000, Adress = '$ITV2kp' .. retAdr .. extopt}
		table.sort(t, function(a, b) return a.res < b.res end)
		for i = 1, #t do
			t[i].Id = i
		end
		m_simpleTV.User.ITV2kp.ResolutionTable = t
		local index = GetMaxResolutionIndex(t)
		if not index then
			index = #t
		end
		retAdr = t[index].Adress:gsub('$ITV2kp', '')
		m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 32 + 64 + 128)
	else
		retAdr = retAdr .. extopt
	end
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')