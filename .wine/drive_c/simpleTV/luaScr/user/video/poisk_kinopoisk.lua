-- видеоскрипт для поиска видео по видеобазе "Kodik", "Hdvb", "Videocdn" (31/10/19)
-- необходимы скрипты: kinopoisk
-- искать через команду меню "Открыть URL (Ctrl+N)"
-- поиск по целому слову или словосочетанию
-- использовать префикс "*" для названия, "**" id кинопоиска
-- открывает подобные запросы:
-- * адский
--  *судЬя   ДреДд
-- *13-й район
-- **840294
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^%s*%*') then return end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
		if inAdr:match('^%s*%*%*') then
			local retAdr = inAdr:match('%d+')
				if not retAdr then return end
			m_simpleTV.Control.PlayAddress('https://www.kinopoisk.ru/film/' .. retAdr)
		 return
		end
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = 'https://lh3.googleusercontent.com/OIwpSMus0b6KSGPTjYGnyw7XlHw1Xj0_4gL48j3OufbAbdv2M7Abo3KhJAVadErdVZkyND8FPQ=w640-h400-e365', TypeBackColor = 0, UseLogo = 3, Once = 1})
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3809.87 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local function xren(s)
		s = s:lower()
		s = s:gsub('*', '')
		s = s:gsub('%s+', ' ')
		s = s:gsub('^%s*(.-)%s*$', '%1')
		local a = {
				{'А', 'а'}, {'Б', 'б'}, {'В', 'в'}, {'Г', 'г'}, {'Д', 'д'}, {'Е', 'е'}, {'Ж', 'ж'}, {'З', 'з'},
				{'И', 'и'},	{'Й', 'й'}, {'К', 'к'}, {'Л', 'л'}, {'М', 'м'}, {'Н', 'н'}, {'О', 'о'}, {'П', 'п'},
				{'Р', 'р'}, {'С', 'с'},	{'Т', 'т'}, {'Ч', 'ч'}, {'Ш', 'ш'}, {'Щ', 'щ'}, {'Х', 'х'}, {'Э', 'э'},
				{'Ю', 'ю'}, {'Я', 'я'}, {'Ь', 'ь'},	{'Ъ', 'ъ'}, {'Ё', 'е'},	{'ё', 'е'},
				}
			for _, v in pairs(a) do
				s = s:gsub(v[1], v[2])
			end
	 return s
	end
	local retAdr = m_simpleTV.Common.multiByteToUTF8(inAdr)
	retAdr = xren(retAdr)
	require 'json'
	local t, i = {}, 1
-- Kodik
	local rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cHM6Ly9rb2Rpa2FwaS5jb20vc2VhcmNoP3Rva2VuPWI3Y2M0MjkzZWQ0NzVjNGFkMWZkNTk5ZDExNGY0NDM1JndpdGhfbWF0ZXJpYWxfZGF0YT10cnVlJnRpdGxlPQ') .. m_simpleTV.Common.toPersentEncoding(retAdr)})
	if rc == 200 then
		answer = answer:gsub('(%[%])', '"nil"'):gsub(string.char(239, 187, 191), '')
		local tab = json.decode(answer)
			if tab then
				local j = 1
				local t1, k
				local name, desc, pTitle, genres, year, kp, im, title, countries, poster
					while true do
							if not tab.results[j] then break end
						title = tab.results[j].title or tab.results[j].ru_title or tab.results[j].title_orig or tab.results[j].other_title
						if tab.results[j].kinopoisk_id and xren(title):match(retAdr) then
							t[i] = {}
							year = tab.results[j].year
							t[i].year = tonumber(year or '0')
							if year and year ~= '' then
								name = title .. ' (' .. year .. ')'
								year = ' | ' .. year
							else
								name = title
								year = ''
							end
							t[i].Name = name
							t[i].Adress = tab.results[j].kinopoisk_id
							if tab.results[j].material_data then
								t1, k = {}, 1
								while true do
										if not tab.results[j].material_data.countries or not tab.results[j].material_data.countries[k] or k == 3 then break end
									t1[k] = {}
									t1[k] = tab.results[j].material_data.countries[k]
									k = k + 1
								end
								countries = table.concat(t1, ' ')
								if countries and countries ~= '' then
									countries = ' | ' .. countries
								else
									countries = ''
								end
								t2, k2 = {}, 1
								while true do
										if not tab.results[j].material_data.genres or not tab.results[j].material_data.genres[k2] or k2 == 4 then break end
									t2[k2] = {}
									t2[k2] = tab.results[j].material_data.genres[k2]
									k2 = k2 + 1
								end
								genres = table.concat(t2, ' ')
								if genres and genres ~= '' then
									genres = ' | ' .. genres
								else
									genres = ''
								end
								poster = tab.results[j].material_data.poster_url
								if poster and poster ~= '' then
									t[i].InfoPanelLogo = poster
								else
									t[i].InfoPanelLogo = 'https://st.kp.yandex.net/images/movies/poster_none.png'
								end
								desc = tab.results[j].material_data.description
								if desc and desc ~= '' then
									t[i].InfoPanelDesc = desc:gsub('\\n', '\r'):gsub('%s+', ' ')
								end
								pTitle = title
								kp = tab.results[j].material_data.kinopoisk_rating
								if kp and kp ~= '' and kp ~= 0 then
									kp = ' | KP: ' .. tonumber(string.format('%.' .. (1 or 0) .. 'f', kp))
								else
									kp = ''
								end
								im = tab.results[j].material_data.imdb_rating
								if im and im ~= '' and im ~= 0 then
									im = ' | IDMb: ' .. tonumber(string.format('%.' .. (1 or 0) .. 'f', im))
								else
									im = ''
								end
								t[i].InfoPanelName = 'Kodik'
								t[i].InfoPanelShowTime = 30000
								t[i].InfoPanelTitle = pTitle .. year .. countries .. genres .. kp .. im
							end
							i = i + 1
						end
						j = j + 1
					end
			end
	end
-- Hdvb
	local hdvbTitle
	local hdvbRetAdr = ' ' .. retAdr .. ' '
	hdvbRetAdr = hdvbRetAdr:gsub('%s+', ' '):gsub('%p', ' ')
	rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cHM6Ly9kYi50ZWhyYW52ZC5iaXovYXBpL3ZpZGVvcy5qc29uP3Rva2VuPWM5OTY2Yjk0N2RhMmYzYzI5YjMwYzBlMGRjY2E2Y2Y0JnRpdGxlPQ') .. m_simpleTV.Common.toPersentEncoding(retAdr)})
	if rc == 200 then
		answer = answer:gsub('(%[%])', '"nil"')
		answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/')
		local tab = json.decode(answer)
		if tab then
			local j = 1
			local name, year, title
				while true do
						if not tab[j] then break end
					name = tab[j].title_ru
					name = unescape3(name)
					hdvbTitle = xren(name)
					hdvbTitle = ' ' .. hdvbTitle .. ' '
					hdvbTitle = hdvbTitle:gsub('%s+', ' '):gsub('%p', ' ')
					if tab[j].kinopoisk_id and hdvbTitle:match(hdvbRetAdr) then
						t[i] = {}
						year = tab[j].year
						t[i].year = tonumber(year or '0')
						if year and year ~= '' then
							t[i].Name = name .. ' (' .. year .. ')'
							year = ' | ' .. year
						else
							t[i].Name = name
							year = ''
						end
						t[i].Adress = tab[j].kinopoisk_id
						t[i].InfoPanelLogo = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. tab[j].kinopoisk_id .. '.jpg'
						t[i].InfoPanelName = 'Hdvb'
						t[i].InfoPanelShowTime = 30000
						t[i].InfoPanelTitle = name .. year
						i = i + 1
					end
					j = j + 1
				end
		end
	end
	local videocdn = false
	local videocdnTitle
	local videocdnRetAdr = ' ' .. retAdr .. ' '
	videocdnRetAdr = videocdnRetAdr:gsub('%s+', ' '):gsub('%p', ' ')
-- Videocdn
	rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvbW92aWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZmaWVsZD10aXRsZSZsaW1pdD0yMCZxdWVyeT0') .. m_simpleTV.Common.toPersentEncoding(retAdr)})
	if rc == 200 then
		videocdn = true
		answer = answer:gsub('(%[%])', '"nil"'):gsub(string.char(239, 187, 191), '')
		local tab = json.decode(answer)
			if tab then
				local j = 1
				local name, year
					while true do
							if not tab.data[j] then break end
						name = tab.data[j].ru_title or tab.data[j].title_orig
						videocdnTitle = xren(name)
						videocdnTitle = ' ' .. videocdnTitle .. ' '
						videocdnTitle = videocdnTitle:gsub('%s+', ' '):gsub('%p', ' ')
						if tab.data[j].kinopoisk_id and videocdnTitle:match(videocdnRetAdr) then
							t[i] = {}
							year = tab.data[j].released
							if year and year ~= '' then
								year = year:match('%d+')
								t[i].year = tonumber(year or '0')
								t[i].Name = name .. ' (' .. year .. ')'
								year = ' | ' .. year
							else
								t[i].Name = name
								t[i].year = 0
								year = ''
							end
							t[i].Adress = tab.data[j].kinopoisk_id
							t[i].InfoPanelLogo = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. tab.data[j].kinopoisk_id .. '.jpg'
							t[i].InfoPanelName = 'Videocdn'
							t[i].InfoPanelShowTime = 30000
							t[i].InfoPanelTitle = name .. year
							i = i + 1
						end
						j = j + 1
					end
			end
	end
if videocdn1 == true then
	rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHYtc2VyaWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZmaWVsZD10aXRsZSZsaW1pdD0yMCZxdWVyeT0') .. m_simpleTV.Common.toPersentEncoding(retAdr)})
	if rc == 200 then
		answer = answer:gsub('(%[%])', '"nil"'):gsub(string.char(239, 187, 191), '')
		local tab = json.decode(answer)
			if tab then
				local j = 1
				local name, year
					while true do
							if not tab.data[j] then break end
						name = tab.data[j].ru_title or tab.data[j].title_orig
						videocdnTitle = xren(name)
						videocdnTitle = ' ' .. videocdnTitle .. ' '
						videocdnTitle = videocdnTitle:gsub('%s+', ' '):gsub('%p', ' ')
						if tab.data[j].kinopoisk_id and videocdnTitle:match(videocdnRetAdr) then
							t[i] = {}
							year = tab.data[j].released
							if year and year ~= '' then
								year = year:match('%d+')
								t[i].year = tonumber(year or '0')
								t[i].Name = name .. ' (' .. year .. ')'
								year = ' | ' .. year
							else
								t[i].year = 0
								year = ''
								t[i].Name = name
							end
							t[i].Adress = tab.data[j].kinopoisk_id
							t[i].InfoPanelLogo = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. tab.data[j].kinopoisk_id .. '.jpg'
							t[i].InfoPanelName = 'Videocdn'
							t[i].InfoPanelShowTime = 30000
							t[i].InfoPanelTitle = name .. year
							i = i + 1
						end
						j = j + 1
					end
			end
	end
	rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZmaWVsZD10aXRsZSZsaW1pdD0yMCZxdWVyeT0') .. m_simpleTV.Common.toPersentEncoding(retAdr)})
	if rc == 200 then
		answer = answer:gsub('(%[%])', '"nil"'):gsub(string.char(239, 187, 191), '')
		local tab = json.decode(answer)
			if tab then
				local j = 1
				local name, year
					while true do
							if not tab.data[j] then break end
						name = tab.data[j].ru_title or tab.data[j].title_orig
						videocdnTitle = xren(name)
						videocdnTitle = ' ' .. videocdnTitle .. ' '
						videocdnTitle = videocdnTitle:gsub('%s+', ' '):gsub('%p', ' ')
						if tab.data[j].kinopoisk_id and videocdnTitle:match(videocdnRetAdr) then
							t[i] = {}
							year = tab.data[j].released
							if year and year ~= '' then
								year = year:match('%d+')
								t[i].year = tonumber(year or '0')
								t[i].Name = name .. ' (' .. year .. ')'
								year = ' | ' .. year
							else
								t[i].year = 0
								year = ''
								t[i].Name = name
							end
							t[i].Adress = tab.data[j].kinopoisk_id
							t[i].InfoPanelLogo = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. tab.data[j].kinopoisk_id .. '.jpg'
							t[i].InfoPanelName = 'Videocdn'
							t[i].InfoPanelShowTime = 30000
							t[i].InfoPanelTitle = name .. year
							i = i + 1
						end
						j = j + 1
					end
			end
	end
end
	m_simpleTV.Http.Close(session)
		if i == 1 then
			m_simpleTV.OSD.ShowMessageT({text = 'в видеобазе не найдено ', color = ARGB(255, 155, 255, 155), showTime = 1000 * 5, id = 'channelName'})
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
	local hash, res = {}, {}
		for i = 1, #t do
			t[i].Adress = tostring(t[i].Adress)
			if not hash[t[i].Adress] then
				u = #res + 1
				res[u] = t[i]
				hash[t[i].Adress] = true
			end
		end
	table.sort(res, function(a, b) return a.year < b.year end)
	for i = 1, #res do
		res[i].Id = i
	end
	local AutoNumberFormat
	if #res > 4 then
		AutoNumberFormat = '%1. %2'
	else
		AutoNumberFormat = ''
	end
	res.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	res.ExtParams = {FilterType = 2, AutoNumberFormat = AutoNumberFormat}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 поиск: ' .. retAdr, 0, res, 30000, 1 + 4 + 8)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
	if ret == 1 then
		retAdr = 'https://www.kinopoisk.ru/film/' .. res[id].Adress
	end
	m_simpleTV.Control.ChangeAdress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAdress = retAdr
	dofile(m_simpleTV.MainScriptDir .. 'user/video/video.lua')
-- debug_in_file(retAdr .. '\n')