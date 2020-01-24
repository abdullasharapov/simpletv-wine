-- видеоскрипт для плейлиста "ITV 2.0" https://itv.rt.ru (30/10/19)
-- открывает подобные ссылки:
-- https://zabava-htlive.cdn.ngenix.net/hls/CH_MATCHTVHD/variant.m3u8
-- http://hlsstr03.svc.iptv.rt.ru/hls/CH_TNTHD/variant.m3u8
-- http://rt-vlg-samara-htlive-lb.cdn.ngenix.net/hls/CH_R03_OTT_VLG_SAMARA_M1/variant.m3u8
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
		if not inAdr:match('rt%.ru/hls/')
			and not inAdr:match('ngenix%.net[:%d]*/hls/CH_')
			and not inAdr:match('^%$ITV2') then
		 return
		end
		if inAdr:match('vod%-ott') or inAdr:match('^%$ITV2kp') or inAdr:match('&recITV2') then return end
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
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
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = 'error'
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.ITV2 then
		m_simpleTV.User.ITV2 = {}
	end
	if not m_simpleTV.User.TVTimeShift then
		m_simpleTV.User.TVTimeShift = {}
	end
	if not m_simpleTV.User.ITV2.RES then
		m_simpleTV.User.ITV2.RES = tonumber(m_simpleTV.Config.GetValue('ITV2RES') or '100000000')
	end
	local function GetRESIndex(t)
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if (tvs_core) and (TVSources_var.IsTVS == true) then
			index = nil
		end
		if not index and not m_simpleTV.User.ITV2.RES then
			m_simpleTV.User.ITV2.RES = t[#t].res
		elseif index then
			if #t < index then
				index = #t - 1
			end
			if t[index+1] and t[index+1].res then
				m_simpleTV.User.ITV2.RES = t[index+1].res
			end
		end
		if m_simpleTV.User.ITV2.RES > 0 then
			for u = 1, #t do
					if t[u].res and m_simpleTV.User.ITV2.RES < t[u].res then break end
				index = u
			end
		end
	 return index
	end
		if inAdr:match('^$ITV2') then
			if m_simpleTV.User.ITV2.ResolutionTable then
				local index = GetRESIndex(m_simpleTV.User.ITV2.ResolutionTable)
				local retAdr
				if not index then
					retAdr = inAdr
				else
					retAdr = m_simpleTV.User.ITV2.ResolutionTable[index].Adress
					m_simpleTV.Config.SetValue('ITV2RES', tostring(m_simpleTV.User.ITV2.RES))
				end
				if m_simpleTV.User.TVTimeShift.isITV2_Offset == true then
					retAdr = retAdr:gsub('$OPT:.+', '')
					retAdr = retAdr .. '&offset=' .. m_simpleTV.User.TVTimeShift.ITV2_Offset
				end
				retAdr = retAdr:gsub('%$ITV2', '') .. extopt
				m_simpleTV.Control.CurrentAdress = retAdr
			end
		 return
		end
		if inAdr:match('offset=') then
			m_simpleTV.Control.CurrentAdress = inAdr .. extopt
		 return
		end
	m_simpleTV.User.TVTimeShift.isITV2_Offset = false
	local session = m_simpleTV.Http.New(ua, prx, true)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local retAdr = inAdr:gsub('%$OPT:.+', ''):gsub('bw%d+/', '')
	local host = inAdr:match('https?://.-/')
	rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			retAdr = retAdr:gsub('%$ITV2', '') .. extopt
			m_simpleTV.Control.CurrentAdress = retAdr
		 return
		end
	local t, i = {}, 1
	local name, adr
		for w in answer:gmatch('EXT%-X%-STREAM%-INF(.-\n.-)\n') do
			adr = w:match('\n(.+)')
				if not adr then break end
			t[i] = {}
			t[i].Id = i
			name = w:match('BANDWIDTH=(%d+)') or '10'
			name = tonumber(name)
			t[i].Name = name / 1000 .. ' кбит/с'
			t[i].res = name
			t[i].Adress = '$ITV2' .. adr:gsub('/playlist%.', '/variant.'):gsub('https?://.-/', host) .. extopt
			i = i + 1
		end
	if i > 2 then
		t[i] = {Id = i, Name = 'адаптивное', res = 100000000, Adress = '$ITV2' .. retAdr .. extopt}
		table.sort(t, function(a, b) return a.res < b.res end)
		for i = 1, #t do
			t[i].Id = i
		end
		m_simpleTV.User.ITV2.ResolutionTable = t
		local index = GetRESIndex(t)
		if not index then
			index = #t
		end
		retAdr = t[index].Adress:gsub('%$ITV2', '')
		m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 32 + 64 + 128)
	else
		retAdr = retAdr .. extopt
	end
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')