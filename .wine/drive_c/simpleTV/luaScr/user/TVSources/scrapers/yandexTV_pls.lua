-- скрапер TVS для загрузки плейлиста "YandexTV" https://tv.yandex.ru (12/9/19)
-- необходим видоскрипт: yandexTV
-- переименовать каналы ------------------------------------------------------------------
local filter = {
	{'РАЗ', 'РазТВ'},
	{'Эфир', 'Эфир (Казань)'},
	{'Первый', 'Первый канал HD'},
	{'Известия', 'Известия HD'},
	{'RT Doc', 'RTД HD'},
	{'RT', 'Russia Today HD'},
	{'МАТЧ!', 'Матч ТВ HD'},
	{'Футбол', 'Футбол HD'},
	{'HITV', 'HITV HD'},
	{'О2ТВ', 'О2ТВ HD'},
	{'HardLife TV', 'HardLife TV HD'},
	{'Охотник и Рыболов', 'Охотник и рыболов HD'},
	{'Неизвестная планета', 'Неизвестная планета HD'},
	{'Классика кино', 'Классика кино HD'},
	{'Старт', 'Старт HD'},
	{'Большая Азия', 'Большая Азия HD'},
	{'Ратник', 'Ратник HD'},
	{'ТНТ', 'ТНТ HD'},
	{'World Fashion Channel', 'World Fashion Channel HD'},
	{'ТВ-3', 'ТВ 3 HD'},
	{'HD Медиа', 'HD Media'},
	{'Россия 24', 'Россия 24 HD'},
	{'Наша Сибирь', 'Наша Сибирь HD'},
	{'RUTV', 'RU TV HD'},
	{'Дождь', 'Дождь HD'},
	{'Пятый канал', 'Пятый канал HD'},
	{'Global Star TV', 'Global Star TV HD'},
	{'Univer TV', 'Univer TV HD'},
	{'26 регион', '26 Регион HD (Ставрополь)'},
	{'360°', '360 Подмосковье (Москва)'},
	{'Барс', 'Барс (Иваново)'},
	{'Архыз 24', 'Архыз 24 (Черкесск)'},
	{'Волга', 'Волга (Нижний Новгород)'},
	{'Екатеринбург-ТВ', 'Екатеринбург-ТВ (Екатеринбург)'},
	{'Кубань 24', 'Кубань 24 Орбита (Краснодар)'},
	{'Липецкое время', 'Липецкое время (Липецк)'},
	{'Осетия-Ирыстон', 'Осетия-Ирыстон (Владикавказ)'},
	{'ОТВ', 'ОТВ (Челябинск)'},
	{'ОТВ 24', 'ОТВ 24 (Екатеринбург)'},
	{'Первый тульский', 'Первый Тульский (Тула)'},
	{'РТС - Абакан', 'РТС - Абакан (Абакан)'},
	{'Сургут 24', 'Сургут 24 (Сургут)'},
	{'Татарстан - 24', 'Татарстан-24 (Казань)'},
	{'ТВ Центр Красноярск HD', 'Центр Красноярск (Красноярск)'},
	{'ТВ-21+', 'ТВ21+ (Мурманск)'},
	{'ШАДР-инфо', 'Шадр-Инфо (Шадринск)'},
	{'Волгоград 1', 'Волгоград 1 (Волгоград)'},
	{'Ветта', 'Ветта 24 (Пермь)'},
	{'Дагестан', 'Дагестан (Махачкала)'},
	{'Катунь 24', 'Катунь 24 (Барнаул)'},
	{'Русский Север', 'Русский Север (Вологда)'},
	{'СвоёТВ', 'СВОЁТВ (Ставрополь)'},
	{'Губерния', 'Губерния ТВ (Хабаровск)'},
	{'Вся Уфа', 'Вся Уфа (Уфа)'},
	{'Тверской проспект - Регион', 'Тверской Проспект (Тверь)'},
	{'Наш дом', '11 канал (Пенза)'},
	{'Рыбинск-40', 'Рыбинск-40 (Рыбинск)'},
	{'Евразия', 'Евразия (Орск)'},
	{'RTVI (Онлайн-вещание)', 'RTVi'},
	{'ЦТВ', 'Центральное телевидение'},
	{'1 HD Music Television', '1HD'},
	{'360° Новости', '360 Новости (Москва)'},
	{'8 канал - Красноярский край', '8 Канал (Красноярск)'},
	{'Югра', 'Югра (Тюмень)'},
	{'Юрган', 'Юрган (Сыктывкар)'},
	{'Удмуртия', 'Моя Удмуртия (Ижевск)'},
	{'Телеканал 86', '86 Канал (Сургут)'},
	{'Ростов-папа', 'Ростов-папа (Ростов)'},
	{'Мотоспорт ТВ', 'Моторспорт ТВ'},
	{'Афонтово', 'Афонтово (Красноярск)'},
	{'Самара 24', 'Самара 24 (Самара)'},
	{'ТВ БРИКС', 'TV BRICS'},
	{'ТиВиСи HD', 'ТиВиСи HD (Иркутск)'},
	{'ТК Центр Красноярск HD', 'Центр Красноярск (Красноярск)'},
	{'Якутия 24', 'Якутия 24 (Якутск)'},
	{'TV Губерния', 'TV Губерния (Воронеж)'},
	{'НВК Саха', 'Саха (Якутск)'},
	{'Рифей-ТВ', 'Рифей-ТВ (Пермь)'},
	{'Тагил-ТВ', 'Тагил-ТВ (Нижний Тагил)'},
	}
------------------------------------------------------------------------------------------
	module('yandexTV_pls', package.seeall)
	local my_src_name = 'YandexTV'
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
		local scrap_settings = {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '..\\Channel\\logo\\Icons\\Yandex.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 1}, STV = {add = 0, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 1, AutoSearch = 1, AutoNumber = 1, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0}}
	 return scrap_settings
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function LoadFromSite(url)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.2785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = decode64(url)})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
		require 'json'
		local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
			if not tab then return end
		local t, i = {}, 1
		local k2
			while true do
					if not tab.set[i] then break end
				t[i] = {}
				t[i].name = tab.set[i].title:gsub(',', '%%2C')
				t[i].address = tab.set[i].content_url
				t[i].special = tab.set[i].is_special_project
				t[i].channel_type = tab.set[i].channel_type
				t[i].ya_plus = tab.set[i].ya_plus
				t[i].hidden = tab.set[i].hidden
				k2 = 1
					while true do
							if not tab.set[i].status or not tab.set[i].status[k2] then break end
							if tab.set[i].status[k2] == 'hidden' then
								t[i].status = true
							 break
							end
						k2 = k2 + 1
					end
				if tab.set[i].channel_category
					and tab.set[i].channel_category[1] == 'yandex'
				then
					t[i].channel_category = true
				end
				i = i + 1
			end
			if i == 1 then return end
	 return t
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite('aHR0cHM6Ly95YW5kZXgucnUvcG9ydGFsL3R2c3RyZWFtX2pzb24vY2hhbm5lbHM/c3RyZWFtX29wdGlvbnM9aGlyZXMmbG9jYWxlPXJ1JmZyb209bW9yZGE')
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
			 return
			end
		t_pls = ProcessFilterTableLocal(t_pls)
			for _, v in pairs(t_pls) do
				if v.status == true
					or v.ya_plus
					or v.channel_category == true
					or v.special == true
					or v.hidden and v.hidden == '1'
					or (v.channel_type and (v.channel_type == 'yatv' or v.channel_type == 'yatv@yttv'))
					or v.address:match('/non__fake/')
					or v.address:match('/ya_chan_tv')
				then
					v.skip = true
				else
					v.address = v.address:gsub('%?.+', ''):gsub('/kal/', '/ka1/')
				end
			end
		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' (' .. #t_pls .. ')', color = ARGB(255, 155, 255, 155), showTime = 1000 * 5, id = 'channelName'})
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