-- скрапер TVS для загрузки плейлиста "PeersTV" http://peers.tv (29/9/19)
-- необходим видоскрипт: peersTV
-- переименование каналов ----------------------------------------------------------------
local filter = {
	{'Муз ТВ', 'МУЗ-ТВ'},
	{'Фест-ТВ', '1HD'},
	{'8 канал Красноярский край', '8 канал (Красноярск)'},
	{'Петербург-5 канал', 'Пятый канал'},
	{'Travel Adventure', 'Travel+ Adventure'},
	{'Тайны Галактики', 'Galaxy'},
	{'ТИВИКОМ', 'Тивиком (Улан-Удэ)'},
	{'ОРТРК-12 КАНАЛ', '12 канал (Омск)'},
	{'Барс плюс', 'Барс плюс (Иваново)'},
	{'360', '360 Подмосковье (Москва)'},
	{'ТВ Центр Красноярск', 'Центр Красноярск (Красноярск)'},
	{'ШАДР-инфо', 'Шадр-Инфо (Шадринск)'},
	{'2x2', '2x2 (+4)'},
	{'СТС', 'СТС Мир'},
	{'Кино 24', 'KINO 24'},
	{'Алмазный край', 'Алмазный край (Якутск)'},
	{'Катунь 24', 'Катунь 24 (Барнаул)'},
	{'FastNFunBOX', 'Fast&FunBox'},
	{'Erox (18+)', 'Erox HD'},
	{'Brazzers TV Europe (18+)', 'Brazzers TV Europe'},
	{'blue HUSTLER (18+)', 'Blue Hustler'},
	{'86', '86 Канал (Сургут)'},
	{'Вся Уфа', 'Вся Уфа (Уфа)'},
	{'Липецкое время', 'Липецкое время (Липецк)'},
	{'НАШ ДОМ', '11 канал (Пенза)'},
	{'Якутия 24', 'Якутия 24 (Якутск)'},
	{'ЮТВ', 'Ю'},
	{'Юрган', 'Юрган (Сыктывкар)'},
	{'ТиВиСи', 'ТиВиСи HD (Иркутск)'},
	{'ОТС [HD]', 'ОТС (Новосибирск)'},
	{'НТН24', 'НТН24 (Новосибирск)'},
	{'Альтес', 'Альтес (Чита)'},
	{'Арктика 24', 'Арктика 24 (Ноябрьск)'},
	{'НВК САХА', 'Саха (Якутск)'},
	{'НТВ-Право', 'НТВ Право'},
	{'НТВ-Сериал', 'НТВ Сериал'},
	{'НТВ-Стиль', 'НТВ Стиль'},
	{'НТВ-Хит', 'НТВ Хит'},
	}
------------------------------------------------------------------------------------------
	module('peersTV_pls', package.seeall)
	local my_src_name = 'PeersTV'
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
		local scrap_settings = {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '..\\Channel\\logo\\Icons\\Peers.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 1}, STV = {add = 0, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 1, AutoSearch = 1, AutoNumber = 1, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0}}
	 return scrap_settings
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function LoadFromSite()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.2785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local rc, answer = m_simpleTV.Http.Request(session, {body = decode64('Z3JhbnRfdHlwZT1pbmV0cmElM0Fhbm9ueW1vdXMmY2xpZW50X2lkPTI5NzgzMDUxJmNsaWVudF9zZWNyZXQ9YjRkNGViNDM4ZDc2MGRhOTVmMGFjYjViYzZiNWM3NjA='), url = decode64('aHR0cDovL2FwaS5wZWVycy50di9hdXRoLzIvdG9rZW4='), method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded'})
			if rc ~= 200 then
				answer = ''
			end
		local token = answer:match('"access_token":"(.-)"') or ''
		rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cDovL2FwaS5wZWVycy50di9pcHR2LzIvcGxheWxpc3QubTN1P2NiPQ=='), headers = decode64('Q2xpZW50LUNhcGFiaWxpdGllczogcGFpZF9jb250ZW50LGFkdWx0X2NvbnRlbnRcblJlZmVyZXI6IGh0dHA6Ly9obHMucGVlcnMudHYvc3RyZWFtaW5nL2Rpc2NvdmVyeXdvcmxkLzE2L3R2cmVjdy9wbGF5bGlzdC5tM3U4XG5BdXRob3JpemF0aW9uOiBCZWFyZXIg') .. token})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
		local t, i = {}, 1
		local name, adr, id, tshift, access
			for w in answer:gmatch('STREAM%-INF(.-)m3u8') do
				name, adr = w:match(', (.-)\n(.+)')
					if not adr or not name then break end
				if not adr:match('/data/tv/') then
					if w:match('timeshift=true') then
						tshift = '$tshift=true'
					else
						tshift = '$tshift=false'
						adr = adr:gsub('//hls%.', '//h1s.')
					end
					if w:match('access=denied') then
						access = '$access=false'
					else
						access = '$access=true'
					end
					id = w:match('id=(%d+)') or ''
					t[i] = {}
					t[i].name = name
					t[i].address = adr .. 'm3u8' .. '$id=' .. id .. tshift .. access
					i = i + 1
				end
			end
			if i == 1 then return end
	 return t
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
			 return
			end
		t_pls = ProcessFilterTableLocal(t_pls)
		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' (' .. #t_pls .. ')', color = ARGB(255, 155, 255, 155), showTime = 1000 * 10, id = 'channelName'})
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then
			 return nil
			end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')