-- видеоскрипт для сайта http://www.kinopoisk.ru (11/11/19)
-- необходимы скрипты:
-- yandex, kodik, filmix, videoframe, seasonvar, zonamobi, iviru, itv 2.0kp, videocdn, hdvb, collaps
-- открывает подобные ссылки:
-- https://www.kinopoisk.ru/film/336434
-- https://www.kinopoisk.ru/level/1/film/46225/sr/1/
-- https://www.kinopoisk.ru/level/1/film/942397/sr/1/
-- https://www.kinopoisk.ru/film/5928
-- https://www.kinopoisk.ru/film/4-mushketera-sharlo-1973-60498/sr/1/
-- https://www.kinopoisk.ru/images/film_big/946897.jpg
-- https://www.kinopoisk.ru/film/535341/watch/?from_block=Фильмы%20из%20Топ-250&
-- https://hd.kinopoisk.ru/film/456c0edc4049d31da56036a9ae1484f4
-- адрес сайта filmix ---------------------------------------------------------------------
local filmixsite = 'https://filmix.co'
-- 'https://filmix.today' (пример)
-- прокси для Seasonvar -------------------------------------------------------------------
local prxsvar = ''
-- '' - нет
-- 'http://proxy-nossl.antizapret.prostovpn.org:29976' (пример)
-- источники ------------------------------------------------------------------------------
local tname = {
-- сортировать: поменять порядок строк
-- отключить: поставить в начале строки --
	'КиноПоиск онлайн',
	'ITV 2.0',
	'ivi',
	'Videocdn',
	'Kodik',
	'Videoframe',
	'Filmix',
	'Collaps',
	'Hdvb',
	'Seasonvar',
	'ZonaMobi',
	}
------------------------------------------------------------------------------------------
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://[%w%.]*kinopoisk%.ru/.+') then return end
	require 'json'
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 3, id = 'channelName'})
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	m_simpleTV.Control.ChangeAdress= 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
		if not inAdr:match('/film') then return end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3497.81 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if inAdr:match('hd%.kinopoisk%.ru') then
		local id = inAdr:match('hd%.kinopoisk%.ru/film/(%x+)')
			if not id then return end
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://api.ott.kinopoisk.ru/v7/hd/content/' .. id .. '/metadata'})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
			 return
			end
		id = answer:match('"kpId":(%d+)')
			if not id then return end
		inAdr = 'https://www.kinopoisk.ru/film/' .. id
	end
	inAdr = inAdr:gsub('/watch/.+', ''):gsub('/watch%?.+', ''):gsub('/sr/.+', '')
	local kpid = inAdr:match('.+%-(%d+)') or inAdr:match('/film//?(%d+)') or inAdr:match('(%d+)%.')
		if not kpid then return end
	local turl, svar, t, rett, Rt = {}, {}, {}, {}, {}
	local rc, answer, retAdr, title, orig_title, year, kp_r, imdb_r, zonaAbuse, zonaUrl, zonaSerial, zonaId, zonaDesc, logourl
	local usvar, i, u = 1, 1, 1
	local function unescape_html(str)
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
	local function answerZonaMovie()
		local rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cDovL3pzb2xyMy56b25hc2VhcmNoLmNvbS9zb2xyL21vdmllL3NlbGVjdC8/d3Q9anNvbiZmbD1uYW1lX29yaWdpbmFsLHllYXIsc2VyaWFsLHJhdGluZ19raW5vcG9pc2ssbmFtZV9ydXMscmF0aW5nX2ltZGIsbW9iaV91cmwsYWJ1c2UsbW9iaV9saW5rX2lkLGRlc2NyaXB0aW9uJnE9aWQ6') .. kpid})
			if rc ~= 200 then return end
			if not answer:match('"year"') or not answer:match('^{') then return end
	 return	answer
	end
	local function answerdget(url)
		if url:match('widget%.kinopoisk%.ru') then
			if not m_simpleTV.Common.GetVlcVersion or m_simpleTV.Common.GetVlcVersion() < 3000 then return end
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			local filmId = answer:match('"filmId":"(.-)"')
				if not filmId then return end
			rc, answer = m_simpleTV.Http.Request(session, {url = 'https://frontend.vh.yandex.ru/v23/player/' .. filmId .. '.json?locale=ru&from=streamhandler_tv&service=ya-main&disable_trackings=1'})
				if rc ~= 200 then return end
				if not answer:match('"stream_type":"HLS","url":"%a') then return end
			answer = url
		elseif url:match('videocdn%.tv') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			answer = answer:match('"iframe_src":"(.-)"')
				if not answer then return end
		elseif url:match('itv%.rt%.ru') then
				if not m_simpleTV.Common.GetVlcVersion or m_simpleTV.Common.GetVlcVersion() < 3000 then return end
				if zonaSerial then return end
			rc, answer = m_simpleTV.Http.Request(session, {url = url .. url_encode(title) .. '&per_page=15'})
				if rc ~= 200 or (rc == 200 and not answer:match('^{"content"')) then return end
			local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
				if not tab then return end
			local uRt, i = 1, 1
			local yearRt, nameRt, urlRt, typeRt
				while true do
						if not tab.content[i] then break end
					yearRt = tab.content[i].year
					nameRt = tab.content[i].name
					typeRt = tab.content[i].type
						if not nameRt or not yearRt or not typeRt then break end
					if tonumber(yearRt) == year and typeRt:match('Film') then
						Rt[uRt] = {}
						Rt[uRt].Id = uRt
						Rt[uRt].Name = nameRt
						Rt[uRt].Adress = tab.content[i].content_assets[1].asset_url
						uRt = uRt + 1
					end
					i = i + 1
				end
				if uRt == 1 then return end
		elseif url:match('ivi%.ru') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url .. url_encode(orig_title) ..'&from=0&to=5&app_version=870&paid_type=AVOD'})
				if rc ~= 200 or (rc == 200 and not answer:match('^{')) then return end
			local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
				if not tab or not tab.result then return end
			local i = 1
			local idivi, kpidivi, drmivi, Adrivi
				while true do
						if not tab.result[i] then break end
					kpidivi = tab.result[i].kp_id or 0
					drmivi = tab.result[i].drm_only or false
					idivi = tab.result[i].id
						if kpidivi == tonumber(kpid) and drmivi == false and idivi then Adrivi = 'https://www.ivi.ru/kinopoisk=' .. idivi break end
					i = i + 1
				end
				if not Adrivi then return end
			answer = Adrivi
		elseif url:match('kodikapi%.com') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			answer = answer:match('"link":"(.-)"')
				if not answer then return end
		elseif url:match('zonasearch%.com/solr/movie') then
				if not zonaUrl or zonaAbuse ~= '' or not zonaId then return end
			if zonaSerial then
				zonaUrl = zonaUrl:gsub('/movies/', '/tvseries/')
			end
			answer = zonaUrl
		elseif url:match(filmixsite) then
				if title == '' and orig_title == '' then return end
			local ratimdbot, ratkinot, ratimdbdo, ratkindo, yearot, yeardo, cat = '', '', '', '', '', '', ''
			if imdb_r > 0 then ratimdbot = imdb_r - 1 ratimdbdo = imdb_r + 1 end
			if kp_r > 0 then ratkinot = kp_r - 1 ratkindo = kp_r + 1 end
			if zonaSerial then
				cat = '&serials=on'
			end
			if year > 0 then yearot = year - 1 yeardo = year + 1 end
			local namei = orig_title:gsub('%?$', ''):gsub('.-`', ''):gsub('*', '')
			local filmixurl = filmixsite .. '/search'
			local rc, filmixansw = m_simpleTV.Http.Request(session, {url = filmixurl})
				if rc ~= 200 then return end
			local filmixCookie = m_simpleTV.Http.GetCookies(session, filmixurl, '') or ''
			local bodypar, bodypar1 = filmixansw:match('<div class="line%-block".-<input type="hidden" name="(.-)" value(=".-)".-<div')
				if not (bodypar1 or bodypar2) then return end
			bodypar = bodypar .. bodypar1:gsub('"', '')
			m_simpleTV.Http.SetCookies(session, url, '', filmixCookie)
			local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl
			local body = bodypar .. '&story=' .. url_encode(namei) .. '&search_start=0&do=search&subaction=search&years_ot=' .. yearot .. '&years_do=' .. yeardo .. '&kpi_ot=' .. ratkinot .. '&kpi_do=' .. ratkindo .. '&imdb_ot=' .. ratimdbot .. '&imdb_do=' .. ratimdbdo .. '&sort_name=asc&undefined=asc&sort_date=&sort_favorite=' .. cat
			rc, answer = m_simpleTV.Http.Request(session, {body = body, url = filmixsite .. '/engine/ajax/sphinx_search.php', method = 'post', headers = headers})
				if rc ~= 200 or (rc == 200 and (answer:match('^<h3>') or not answer:match('<div class="name%-block"'))) then return end
		elseif url:match('seasonvar%.ru') then
				if not zonaSerial then return end
			local svarnamei = orig_title:gsub('[!?]', ' '):gsub('ё', 'е')
			local sessionsvar
			if prxsvar ~= '' then
				sessionsvar = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/78.0.2785.143 Safari/537.36', prxsvar, false)
					if not sessionsvar then return end
			end
			rc, answer = m_simpleTV.Http.Request((sessionsvar or session), {url = url .. url_encode(svarnamei)})
				if rc ~= 200 or (rc == 200 and (answer:match('"query":""') or answer:match('"data":null'))) then
					if sessionsvar then
						m_simpleTV.Http.Close(sessionsvar)
					end
				 return
				end
				if answer:match('"data":%[""%]') or answer:match('"data":%["",""%]') then
					svarnamei = title:gsub('[!?]', ' '):gsub('ё', 'е')
					rc, answer = m_simpleTV.Http.Request((sessionsvar or session), {url = url .. url_encode(svarnamei)})
						if rc ~= 200 or (rc == 200 and (answer:match('"query":""') or answer:match('"data":%[""%]') or answer:match('"data":%["",""%]'))) then
							if sessionsvar then
								m_simpleTV.Http.Close(sessionsvar)
							end
						 return
						end
				end
			if sessionsvar then
				m_simpleTV.Http.Close(sessionsvar)
			end
				if not answer:match('^{') then return end
			local t = json.decode(answer:gsub('(%[%])', '"nil"'):gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'))
				if not t then return end
			local a, j = {}, 1
				while true do
						if not t.data[j] or not t.suggestions.valu[j] or t.data[j] == '' then break end
					a[j] = {}
					a[j].Id = j
					a[j].rkpsv = t.suggestions.kp[j]:match('>(.-)<') or 0
					a[j].Name = unescape3(t.suggestions.valu[j])
					a[j].Adress = 'http://seasonvar.ru/' .. t.data[j]
					j = j + 1
				end
				if j == 1 then return end
			local i, rkpsv, svarkptch = 1
				svarnamei = svarnamei:gsub('%%', string.char(37))
				for _, v in pairs(a) do
					rkpsv = tonumber(v.rkpsv)
					svarkptch = 0.1
					if kp_r > 0 then
						if svarname == 0 then
							if (rkpsv >= (kp_r - svarkptch) and rkpsv <= (kp_r + svarkptch)) and not a[i].Name:match('<span style') and (a[i].Name:match('/%s*' .. svarnamei .. '$') or a[i].Name:match('/%s*' .. svarnamei .. '%s')) then v.Id = usvar svar[usvar] = v usvar = usvar + 1 end
						else
							if (rkpsv >= (kp_r - svarkptch) and rkpsv <= (kp_r + svarkptch)) and not a[i].Name:match('<span style') and a[i].Name:match(svarnamei) then v.Id = usvar svar[usvar] = v usvar = usvar + 1 end
						end
					else
						if svarname == 0 then
							if not a[i].Name:match('<span style') and (a[i].Name:match('/%s*' .. svarnamei .. '$') or a[i].Name:match('/%s*' .. svarnamei .. '%s')) then v.Id = usvar svar[usvar] = v usvar = usvar + 1 end
						else
							if not a[i].Name:match('<span style') and a[i].Name:match(svarnamei) then v.Id = usvar svar[usvar] = v usvar = usvar + 1 end
						end
					end
				end
			if usvar == 1 then
				svar, i = {}, 1
				for _, v in pairs(a) do svar[i] = v i = i + 1 end
			end
		elseif url:match('iframe%.video') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			answer = answer:match('"path":"(.-)"')
				if not answer then return end
		elseif url:match('apicollaps%.cc') then
				if m_simpleTV.Common.GetVlcVersion() < 3000 then return end
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			answer = answer:match('"iframe_url":"(.-)"')
				if not answer then return end
		elseif url:match('tehranvd%.biz') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			answer = answer:match('"iframe_url":"(.-)"')
				if not answer then return end
		end
	 return answer
	end
	local function getAdr(answer, url)
		if url:match('iframe%.video') then
			retAdr = answer
		elseif url:match('ivi%.ru') then
			retAdr = answer
		elseif url:match('videocdn%.tv') then
			retAdr = answer
		elseif url:match('itv%.rt%.ru') then
			local hash, rtab = {}, {}
			local u
				for i = 1, #Rt do
					if not hash[Rt[i].Adress] then
						u = #rtab + 1
						rtab[u] = Rt[i]
						hash[Rt[i].Adress] = true
					end
				end
				for i = 1, #rtab do
					rtab[i].Id = i
				end
			rtab.ExtButton1 = {ButtonEnable = true, ButtonName = '🢀'}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено на портале ITV 2.0', 0, rtab, 10000, 1)
				if ret == 3 then return -1 end
			if not id then
				id = 1
			end
			retAdr = rtab[id].Adress
		elseif url:match('kodikapi%.com') then
			retAdr = answer
		elseif url:match('zonasearch%.com/solr/movie') then
			retAdr = answer
		elseif url:match('widget%.kinopoisk%.ru') then
			retAdr = answer
		elseif url:match(filmixsite) then
			local i, f = 1, {}
			for ww in answer:gmatch('<div class="name%-block">(.-)</div>') do
				f[i] = {}
				f[i].Id = i
				f[i].Name = ww:match('title="(.-)"')
				f[i].Adress = ww:match('href="(.-)"')
				i = i + 1
			end
			f.ExtButton1 = {ButtonEnable = true, ButtonName = '🢀'}
 			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено на Filmix', 0, f, 10000, 1)
				if ret == 3 then return -1 end
			if not id then
				id = 1
			end
			retAdr = f[id].Adress
		elseif url:match('seasonvar%.ru') then
			svar.ExtButton1 = {ButtonEnable = true, ButtonName = '🢀'}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено на Seasonvar', 0, svar, 10000, 1)
				if ret == 3 then return -1 end
			if not id then
				id = 1
			end
			retAdr = svar[id].Adress
		elseif url:match('apicollaps%.cc') then
			retAdr = answer
		elseif url:match('tehranvd%.biz') then
			retAdr = answer
		end
	 return retAdr
	end
	local function getlogo()
		local session2 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/78.0.2785.143 Safari/537.36')
			if not session2 then return end
		m_simpleTV.Http.SetTimeout(session2, 5000)
		m_simpleTV.Http.SetRedirectAllow(session2, false)
		local url = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. kpid .. '.jpg'
		local rc, answer = m_simpleTV.Http.Request(session2, {url = url})
		m_simpleTV.Http.Close(session2)
		if rc == 200 then
			logourl = url
			m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = logourl, TypeBackColor = 0, UseLogo = 3, Once = 1})
		else
			url = 'https://lh3.googleusercontent.com/OIwpSMus0b6KSGPTjYGnyw7XlHw1Xj0_4gL48j3OufbAbdv2M7Abo3KhJAVadErdVZkyND8FPQ=w640-h400-e365'
			m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = url, TypeBackColor = 0, UseLogo = 3, Once = 1})
		end
	end
	local function setMenu()
		local logo_k = logourl or 'https://upload.wikimedia.org/wikipedia/ru/thumb/9/96/Kinopoisk_logo_orange.png/143px-Kinopoisk_logo_orange.png'
		m_simpleTV.Control.ChangeChannelLogo(logo_k, m_simpleTV.Control.ChannelID)
		for i = 1, #tname do
			if tname[i] == 'Videoframe' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9pZnJhbWUudmlkZW8vYXBpL3YyL3NlYXJjaD9rcD0') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'Kodik' then
				turl[i] = {adr = decode64('aHR0cDovL2tvZGlrYXBpLmNvbS9nZXQtcGxheWVyP3Rva2VuPTQ0N2QxNzllODc1ZWZlNDQyMTdmMjBkMWVlMjE0NmJlJmtpbm9wb2lza0lEPQ') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'КиноПоиск онлайн' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9vdHQtd2lkZ2V0Lmtpbm9wb2lzay5ydS9raW5vcG9pc2suanNvbj9lcGlzb2RlPSZzZWFzb249JmZyb209a3AmaXNNb2JpbGU9MCZrcElkPQ==') .. kpid, tTitle = 'Фильмы и сериалы с Яндекс.Эфир', tLogo = 'https://www.torpedo.ru/upload/resize_cache/iblock/cad/325_325_1/caddb19b51cd12166d1261700046a8f7.png'}
			elseif tname[i] == 'ZonaMobi' then
				turl[i] = {adr = decode64('em9uYXNlYXJjaC5jb20vc29sci9tb3ZpZQ=='), tTitle = 'Фильмы и сериалы с Zona.mobi', tLogo = 'http://zona-sait.ru/wp-content/uploads/2017/11/logo.png'}
			elseif tname[i] == 'Filmix' then
				turl[i] = {adr = filmixsite .. decode64('L2VuZ2luZS9hamF4L3NwaGlueF9zZWFyY2gucGhw'), tTitle = 'Фильмы и сериалы с Filmix.me', tLogo = logo_k}
			elseif tname[i] == 'Seasonvar' then
				turl[i] = {adr = decode64('aHR0cDovL3NlYXNvbnZhci5ydS9hdXRvY29tcGxldGUucGhwP3F1ZXJ5PQ=='), tTitle = 'Сериалы с Seasonvar.ru', tLogo = 'http://hostingkartinok.com/uploads/images/2011/09/af3d6033d255a3e36a6094a5ba74ebb7.png'}
			elseif tname[i] == 'ivi' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9hcGkuaXZpLnJ1L21vYmlsZWFwaS9zZWFyY2gvdjUvP2ZpZWxkcz1rcF9pZCxpZCxkcm1fb25seSZmYWtlPTAmcXVlcnk9'), tTitle = 'Фильмы и сериалы с ivi.ru', tLogo = 'http://saledeal.ru/wp-content/uploads/2019/09/ivi.png'}
			elseif tname[i] == 'ITV 2.0' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9pdHYucnQucnUvYXBpL3YxL3NlYXJjaC9hdXRvc3VnZ2VzdD9xPQ=='), 		tTitle = 'Фильмы с портала Интерактивного ТВ 2.0', tLogo = 'https://frisbi24.ru/files/a29/256/rtlogo-rgb.png'}
			elseif tname[i] == 'Videocdn' then
				turl[i] = {adr = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPW9TN1d6dk5meGU0SzhPY3NQanBBSVU2WHUwMVNpMGZtJmtpbm9wb2lza19pZD0') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'Collaps' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9hcGljb2xsYXBzLmNjL2xpc3Q/dG9rZW49MjI2ZmQzMjRmYzUwZjlmNDQ3ZTlhNTExN2ViZDgwZDYma2lub3BvaXNrX2lkPQ') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'Hdvb' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9kYi50ZWhyYW52ZC5iaXovYXBpL3ZpZGVvcy5qc29uP3Rva2VuPWM5OTY2Yjk0N2RhMmYzYzI5YjMwYzBlMGRjY2E2Y2Y0JmlkX2twPQ') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			end
		end
	end
	local function getReting()
			local function round(num)
			 return tonumber(string.format('%.' .. (1 or 0) .. 'f', num))
			end
		local kp, im
		local star = ''
		local slsh = ''
		if kp_r > 0 then
			kp = 'KP: ' .. round(kp_r)
		end
		if imdb_r > 0 then
			im = 'IDMb: ' .. round(imdb_r)
		end
			if not kp and not im then
			 return ''
			end
		if kp and im then
			slsh = ' / '
		end
	 return ' ★ ' .. (kp or '') .. slsh .. (im or '')
	end
	local function getRkinopoisk()
		local answer = answerZonaMovie()
			if not answer then
				title = ''
				orig_title = ''
				year = 0
				kp_r = 0
				imdb_r = 0
			 return
			end
		local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
			if not tab or not tab.response then return end
		zonaUrl = tab.response.docs[1].mobi_url
		zonaId = tab.response.docs[1].mobi_link_id
		zonaSerial = tab.response.docs[1].serial
		zonaAbuse = tab.response.docs[1].abuse
		zonaDesc = tab.response.docs[1].description
		local name_rus = tab.response.docs[1].name_rus
		local name_original = tab.response.docs[1].name_original
		if name_original == '' then
			name_original = name_rus or ''
		end
		title = name_rus or name_original or ''
		m_simpleTV.Control.SetTitle(title)
		m_simpleTV.OSD.ShowMessageT({text = title, color = ARGB(255, 255, 170, 0), showTime = 1000 * 20, id = 'channelName'})
		orig_title = name_original or title or ''
		local zonaYear = tab.response.docs[1].year or ''
		zonaYear = tostring(zonaYear)
		year = tonumber(zonaYear:match('%d+') or '0')
		kp_r = tonumber(tab.response.docs[1].rating_kinopoisk or '0')
		imdb_r = tonumber(tab.response.docs[1].rating_imdb or '0')
	 return ''
	end
	local function menu()
		for i = 1, #tname do
			t[i] = {}
			t[i].Name = tname[i]
			t[i].answer = answerdget(turl[i].adr)
			t[i].Adress = turl[i].adr
			if zonaDesc and zonaDesc ~= '' and title ~= '' then
				t[i].InfoPanelTitle = zonaDesc
				t[i].InfoPanelName = title .. ' (' .. year .. ')'
				t[i].InfoPanelLogo = logourl or 'https://upload.wikimedia.org/wikipedia/ru/thumb/9/96/Kinopoisk_logo_orange.png/143px-Kinopoisk_logo_orange.png'
			else
				t[i].InfoPanelTitle = turl[i].tTitle
				t[i].InfoPanelLogo = turl[i].tLogo
			end
			t[i].InfoPanelShowTime = 30000
		end
		for _, v in pairs(t) do
			if v.answer then v.Id = u rett[u] = v u = u + 1 end
		end
	end
	local function selectmenu()
		rett.ExtParams = {FilterType = 2}
		rett.ExtButton1 = {ButtonEnable = true, ButtonName = '✕󠁙󠁙'}
		m_simpleTV.OSD.ShowMessageT({text = '', color = ARGB(0, 0, 0, 0), showTime = 1000 * 1, id = 'channelName'})
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🎞 ' .. title .. getReting(), 0, rett, 8000, 1 + 2)
		if ret == 3 then
			retAdr = 0
		 return
			end
		if not id then id = 1 end
		retAdr = getAdr(rett[id].answer, rett[id].Adress)
		if retAdr == -1 then selectmenu() end
	end
	getlogo()
	getRkinopoisk()
	setMenu()
	menu()
		if #rett == 0 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Http.Close(session)
			m_simpleTV.Control.ExecuteAction(11)
			m_simpleTV.OSD.ShowMessageT({text = 'Видео не найдено\nkinopoisk ошибка[2]', color = ARGB(255, 155, 255, 155), showTime = 1000 * 5, id = 'channelName'})
		 return
		end
	selectmenu()
		if not retAdr or retAdr == 0 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Http.Close(session)
			m_simpleTV.Control.ExecuteAction(11)
			if not retAdr then m_simpleTV.OSD.ShowMessageT({text = 'Видео не найдено\nkinopoisk ошибка[3]', color = ARGB(255, 155, 255, 155), showTime = 1000 * 5, id = 'channelName'}) end
		 return
		end
	if title == '' then
		title = 'Кинопоиск'
	end
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	m_simpleTV.Control.SetTitle(title)
	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.ChangeAdress = 'No'
	retAdr = retAdr:gsub('^//', 'http://'):gsub('\\/', '/') .. '&kinopoisk'
	m_simpleTV.Control.CurrentAdress = retAdr
	dofile(m_simpleTV.MainScriptDir .. 'user\\video\\video.lua')
-- debug_in_file(retAdr .. '\n')