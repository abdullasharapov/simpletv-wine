-- скрапер TVS для загрузки плейлиста "TV+" с сайта http://www.tvplusonline.ru (24/7/19)
-- переименовать каналы ------------------------------------------------------------------
local filter = {
	{'Russia Today', 'Russia Today HD'},
	{'bash24', 'Башкортостан 24'},
	{'boxtv', 'Бокс ТВ'},
	{'classickino', 'Классика кино'},
	{'ctc', 'СТС'},
	{'ctcp2', 'СТС (+2)'},
	{'ctcp4', 'СТС (+4)'},
	{'ctcp6', 'СТС (+6)'},
	{'dom', 'Домашний'},
	{'europaplustv', 'Europa Plus TV'},
	{'friday', 'Пятница!'},
	{'fridayp2', 'Пятница! (+2)'},
	{'fridayp4', 'Пятница! (+4)'},
	{'fridayp6', 'Пятница! (+6)'},
	{'hdmedia', 'HD Media'},
	{'joycook', 'Joy Cook'},
	{'k5', 'Пятый канал'},
	{'kanal5', 'Пятый канал'},
	{'karusel', 'Карусель'},
	{'karuselp2', 'Карусель (+2)'},
	{'karuselp4', 'Карусель (+4)'},
	{'karuselp6', 'Карусель (+6)'},
	{'kinofamily', 'Киносемья'},
	{'kinohit', 'Кинохит'},
	{'kinolove', 'Киносвидание'},
	{'kinoman', 'Мужское кино'},
	{'kinomenu', 'КиноМеню HD'},
	{'kinopremier', 'Кинопремьера HD'},
	{'kultura', 'Россия К'},
	{'m1global', 'M-1 Global'},
	{'m24', 'Москва 24'},
	{'matcharena', 'Матч! Арена'},
	{'matcharenahd', 'Матч! Арена HD'},
	{'matchfighter', 'Матч! Боец'},
	{'matchfootball1', 'Матч! Футбол 1'},
	{'matchfootball1hd', 'Матч! Футбол 1 HD'},
	{'matchfootball2', 'Матч! Футбол 2'},
	{'matchfootball2hd', 'Матч! Футбол 2 HD'},
	{'matchfootball3', 'Матч! Футбол 3'},
	{'matchfootball3hd', 'Матч! Футбол 3 HD'},
	{'matchgame', 'Матч! Игра'},
	{'matchgamehd', 'Матч! Игра HD'},
	{'matchoursport', 'Матч! Наш спорт'},
	{'matchpremier', 'Матч! Премьер'},
	{'matchpremierhd', 'Матч! Премьер HD'},
	{'matchtv', 'Матч!'},
	{'matchtvhd', 'Матч! HD'},
	{'mir', 'Мир'},
	{'moscow24', 'Москва 24'},
	{'musicbox', 'Music Box'},
	{'muztv', 'Муз ТВ'},
	{'ntv', 'НТВ'},
	{'ntvp2', 'НТВ (+2)'},
	{'ntvp4', 'НТВ (+4)'},
	{'ntvp6', 'НТВ (+6)'},
	{'otr', 'ОТР'},
	{'perviy', 'Первый'},
	{'perviyhd', 'Первый HD'},
	{'perviyp2', 'Первый (+2)'},
	{'perviyp4', 'Первый (+4)'},
	{'perviyp6', 'Первый (+6)'},
	{'probusiness', 'Про Бизнес'},
	{'r1', 'Россия 1'},
	{'r1hd', 'Россия 1 HD'},
	{'r1p2', 'Россия 1 (+2)'},
	{'r1p4', 'Россия 1 (+4)'},
	{'r1p6', 'Россия 1 (+6)'},
	{'r2', 'Матч! ТВ'},
	{'r24', 'Россия 24'},
	{'radost', 'Радость моя'},
	{'ren', 'РЕН ТВ'},
	{'renp2', 'РЕН ТВ (+2)'},
	{'renp4', 'РЕН ТВ (+4)'},
	{'renp6', 'РЕН ТВ (+6)'},
	{'rtdocru', 'RTД HD'},
	{'rusmult', 'Советские мультфильмы'},
	{'russia', 'Россия 1'},
	{'russia24', 'Россия 24'},
	{'russiahd', 'Россия 1 HD'},
	{'russianmb', 'Music Box RU'},
	{'russianmbhd', 'Music Box RU HD'},
	{'russiap2', 'Россия 1 (+2)'},
	{'russiap4', 'Россия 1 (+4)'},
	{'russiap6', 'Россия 1 (+6)'},
	{'skazki', 'Сказки зайки'},
	{'sovmov', 'Советское кино'},
	{'spas', 'Спас'},
	{'sts', 'СТС'},
	{'stsp2', 'СТС (+2)'},
	{'stsp4', 'СТС (+4)'},
	{'stsp6', 'СТС (+6)'},
	{'super', 'Супер'},
	{'t2x2', '2x2'},
	{'terra', 'Terra Incognita'},
	{'tnt', 'ТНТ'},
	{'tnt4', 'ТНТ4'},
	{'tnthd', 'ТНТ HD'},
	{'tntmusic', 'ТНТ MUSIC'},
	{'tntp2', 'ТНТ (+2)'},
	{'tntp4', 'ТНТ (+4)'},
	{'tntp6', 'ТНТ (+6)'},
	{'tochkatv', 'Точка ТВ'},
	{'tv3', 'ТВ-3'},
	{'tv3p2', 'ТВ 3 (+2)'},
	{'tv3p4', 'ТВ 3 (+4)'},
	{'tv3p6', 'ТВ 3 (+6)'},
	{'tvc', 'ТВ Центр'},
	{'umorbox', 'Юмор ТВ'},
	{'umortv', 'Юмор ТВ'},
	{'unknownplanet', 'Неизвестная планета'},
	{'zvezda', 'Звезда'},
	}
------------------------------------------------------------------------------------------
	module('tvplus_pls', package.seeall)
	local my_src_name = 'TV+'
	local function ProcessFilterTableLocal(t)
		if not type(t) == 'table' then return end
		for i = 1, #t do
			t[i].name = tvs_core.tvs_clear_double_space(t[i].name)
			for _, ff in ipairs(filter) do
				if (type(ff) == 'table' and t[i].name == ff[1]) then
					t[i].name = ff[2]
				end
			end
		end
	 return t
	end
	function GetSettings()
		local scrap_settings = {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '..\\Channel\\logo\\Icons\\TVplus.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 1}, STV = {add = 0, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 1, AutoSearch = 1, AutoNumber = 1, NumberM3U = 0, GetSettings = 0, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0}}
	 return scrap_settings
	end
	function GetVersion() return 2, 'UTF-8' end
	function LoadFromSite()
		local ua = 'Dalvik/2.1.0 (Linux; Android 6.0.1;)'
		local session = m_simpleTV.Http.New(ua)
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cHM6Ly93d3cudHZwbHVzb25saW5lLnJ1L2dldGluZm92NC90dm1vYmlsZW1heC50eHQ=')})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 or (rc == 200 and answer == '') then return end
		answer = answer:gsub(string.char(239, 187, 191), '')
		local t, i = {}, 1
		local name, adr
			for name, _ in answer:gmatch('%c?(.-),(.-)%c') do
				t[i] = {}
				t[i].Id = i
				t[i].name = name
				t[i].address = 'TVplus' .. name
				i = i + 1
			end
				if i == 1 then return end
		local hash, res = {}, {}
			for _, v in ipairs(t) do
				if not hash[v.name] then
					res[#res + 1] = v
					hash[v.name] = true
				end
			end
	 return res
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' -> ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
			 return
			end
		t_pls = ProcessFilterTableLocal(t_pls)
		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' -> ' .. #t_pls, color = ARGB(255, 155, 255, 155), showTime = 1000 * 5, id = 'channelName'})
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return nil end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')