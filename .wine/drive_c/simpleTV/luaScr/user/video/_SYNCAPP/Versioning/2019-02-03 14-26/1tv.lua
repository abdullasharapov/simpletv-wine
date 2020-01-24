-- видеоскрипт для сайта https://media.1tv.ru (23/8/18)
-- открывает:
-- https://www.5-tv.ru/live
-- https://ren.tv/live
-- https://ctc.ru/online
-- https://ctclove.ru/online
-- https://chetv.ru/online
-- https://www.domashniy.ru/online
-- https://www.1tv.ru/live
-- https://www.1tv.ru/embedlive
-- https://stream.1tv.ru/embed
-- https://media.1tv.ru/embed/nmg/nmg-ren.html
-- https://media.1tv.ru/embed/nmg/nmg-5tv.html
-- https://media.1tv.ru/embed/nmg/nmg-iz.htm
-- https://media.1tv.ru/embed/ctcmedia/ctc-che.html
-- https://media.1tv.ru/embed/ctcmedia/ctc-love.html
-- https://media.1tv.ru/embed/ctcmedia/ctc-ctc.html
-- https://media.1tv.ru/embed/ctcmedia/ctc-dom.html
------------------------------------------------------------------------------------------
local bdw = 0 -- качество в кбит/с: 0 - максимальное; ограничить например до 1000
------------------------------------------------------------------------------------------
local cach = 0 -- размер кэша: 0 - не менять, 100-5000
------------------------------------------------------------------------------------------
require 'json'
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://www%.5%-tv%.ru/live') and not inAdr:match('https?://www%.domashniy%.ru/online') and not inAdr:match('https?://chetv%.ru/online') and not inAdr:match('https?://ctclove%.ru/online') and not inAdr:match('https?://ren%.tv/live') and not inAdr:match('https?://ctc%.ru/online') and not inAdr:match('https?://www%.1tv%.ru/live') and not inAdr:match('https?://www%.1tv%.ru/embedlive') and not inAdr:match('https?://stream.1tv%.ru/embed') and not inAdr:match('https?://media%.1tv%.ru/embed/nmg/') and not inAdr:match('https?://media%.1tv%.ru/embed/ctcmedia/') and not inAdr:match('^$tv1onln') then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = 'error'
	if not m_simpleTV.User then m_simpleTV.User = {} end
	if not m_simpleTV.User.tv1onln then m_simpleTV.User.tv1onln = {} end
	if not m_simpleTV.User.TVTimeShift then m_simpleTV.User.TVTimeShift = {} end
	if bdw > 0 and not m_simpleTV.User.tv1onln.MaxResolution then m_simpleTV.User.tv1onln.MaxResolution = bdw * 1000 end
	if bdw == 0 and not m_simpleTV.User.tv1onln.MaxResolution then m_simpleTV.User.tv1onln.MaxResolution = 100000000 end
	local function GetMaxResolutionIndex(t)
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if (tvs_core) and (TVSources_var.IsTVS == true) then index = nil end
		if not index and not m_simpleTV.User.tv1onln.MaxResolution then
			m_simpleTV.User.tv1onln.MaxResolution = t[#t].res
		elseif index then
			m_simpleTV.User.tv1onln.MaxResolution = t[index+1].res
		end
		if m_simpleTV.User.tv1onln.MaxResolution > 0 then
			index = 1
			for u = 1, #t do
					if t[u].res and m_simpleTV.User.tv1onln.MaxResolution < t[u].res then break end
				index = u
			end
		end
	 return index
	end
	if inAdr:match('^$tv1onln') then
		if m_simpleTV.User.tv1onln.ResolutionTable then
			local index = GetMaxResolutionIndex(m_simpleTV.User.tv1onln.ResolutionTable) or 1
			local retAdr = m_simpleTV.User.tv1onln.ResolutionTable[index].Adress:gsub('$tv1onln', '')
			m_simpleTV.Control.CurrentAdress = retAdr .. m_simpleTV.User.tv1onln.ExtOpt
		end
	 return
	end
	local api = 'https://media.1tv.ru/api/v1/'
	local api2 = 'https://stream.1tv.ru/api/'
	local array
	if inAdr:match('nmg%-iz') then array = 'nmg/playlist/iz' end
	if inAdr:match('ctc%-dom') or inAdr:match('domashniy%.ru/online') then array = 'ctc/playlist/ctc-dom' end
	if inAdr:match('nmg%-ren') or inAdr:match('ren%.tv/live') then array = 'nmg/playlist/ren-tv' end
	if inAdr:match('ctc%-ctc') or inAdr:match('ctc%.ru/online') then array = 'ctc/playlist/ctc' end
	if inAdr:match('ctc%-che') or inAdr:match('chetv%.ru/online') then array = 'ctc/playlist/ctc-che' end
	if inAdr:match('nmg%-5tv') or inAdr:match('5%-tv%.ru/live') then array = 'nmg/playlist/tv-5' end
	if inAdr:match('ctc%-love') or inAdr:match('ctclove%.ru/online') then array = 'ctc/playlist/ctc-love' end
	if inAdr:match('1tv%.ru/embedlive') or inAdr:match('www%.1tv%.ru/live') or inAdr:match('stream%.1tv%.ru/embed') then array = 'playlist/1tvch' api = api2 end
		if not array then return end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://stream.1tv.ru/get_hls_session'})
		if rc ~= 200 then m_simpleTV.Http.Close(session) return end
	local tab0 = json.decode(answer:gsub('(%[%])', '"nil"'))
		if not tab0 or not tab0.s then m_simpleTV.Http.Close(session) return end
	rc, answer = m_simpleTV.Http.Request(session, {url = api .. array .. '_as_array.json'})
		if rc ~= 200 then m_simpleTV.Http.Close(session) return end
	local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
		if not tab or not tab.hls or not tab.hls[1] then m_simpleTV.Http.Close(session) return end
	local retAdr = tab.hls[1] .. '&s=' .. tab0.s
	rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	local extopt = ''
	if cach >= 100 and cach <= 5000 then extopt = extopt .. '$OPT:network-caching=' .. cach end
	m_simpleTV.User.tv1onln.ExtOpt = extopt
	local i, t = 1, {}
	local name, adr
	for w in answer:gmatch('EXT%-X%-STREAM%-INF.-\n.-\n') do
		adr = w:match('\n(.-)\n')
			if not adr or adr == '' then break end
		name = w:match('BANDWIDTH=(%d+)') or '0'
		name = tonumber(name) / 1000
		name = math.floor(name)
		t[i] = {}
		t[i].Id = i
		t[i].Name = name .. ' кбит/с'
		t[i].Adress = '$tv1onln' .. adr
		t[i].res = name
		i = i + 1
	end
	table.sort(t, function(a, b) return a.res < b.res end)
	for i = 1, #t do t[i].Id = i end
	m_simpleTV.User.tv1onln.ResolutionTable = t
	local index
	if i > 1 then
		index = GetMaxResolutionIndex(t) or 1
		retAdr = t[index].Adress:gsub('$tv1onln', '')
	end
	if i > 2 then
		m_simpleTV.OSD.ShowSelect_UTF8('Качество', index-1, t, 5000, 32+64+128)
	end
	m_simpleTV.Control.CurrentAdress = retAdr .. m_simpleTV.User.tv1onln.ExtOpt
-- debug_in_file(retAdr .. '\n')