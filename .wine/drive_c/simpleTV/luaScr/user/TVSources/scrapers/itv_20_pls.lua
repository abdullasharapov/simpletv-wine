-- скрапер TVS для загрузки плейлиста "ITV 2.0" https://itv.rt.ru (12/11/19)
-- переименовать каналы -------------------------------------------------------
local filter = {
	{'REN-TV HD', 'РЕН ТВ HD'},
	{'Доверие', 'Москва. Доверие (Москва)'},
	{'Общественное телевидение России', 'ОТР'},
	{'360 Подмосковье HD', '360 Подмосковье HD (Москва)'},
	{'Русский экстрим', 'Russian Extreme'},
	{'BOLT', 'BOLT HD'},
	{'Star Cinema', 'Star Cinema (Россия)'},
	{'Star Cinema HD', 'Star Cinema HD (Россия)'},
	{'Star Family', 'Star Family (Россия)'},
	{'Star Family HD', 'Star Family HD (Россия)'},
	{'Деда Мороза', 'Телеканал Деда Мороза'},
	{'5 канал', 'Пятый канал'},
	{'Sony Entertainment Television HD', 'SET HD'},
	{'REN-TV', 'РЕН ТВ'},
	{'MTV', 'MTV Russia'},
	{'Телекомпания ПЯТНИЦА', 'Пятница'},
	{'О%2C кино!', 'О!КИНО'},
	{'КИНОУЖАС', 'Киноужас'},
	{'Время далекое и близкое', 'Время'},
	}
--------------------------------------------------------------------------------
	module('itv_20_pls', package.seeall)
	local my_src_name = 'ITV 2.0'
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
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '..\\Channel\\logo\\Icons\\ITV 2.0.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 1}, STV = {add = 0, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoNumber = 0, NumberM3U = 0, GetSettings = 0, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function Itv20GetTbl(p, p1)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Linux; Android 5.1.1; Nexus 4 Build/LMY48T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.89 Mobile Safari/537.36')
			if not session then return end
		require 'json'
		m_simpleTV.Http.SetTimeout(session, 8000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = decode64(p)})
		local t, i = {}, 1
		if rc == 200 then
			local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
			if tab and tab.channels_list then
				while true do
						if not tab.channels_list[i] then break end
					t[i] = {}
					t[i].name = tab.channels_list[i].bcname
					t[i].address = tab.channels_list[i].smlOttURL
					i = i + 1
				end
			end
		end
		rc, answer = m_simpleTV.Http.Request(session, {url = decode64(p1)})
		m_simpleTV.Http.Close(session)
		if rc == 200 then
			local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
			if tab and tab.channels_list then
				local j = 1
				while true do
						if not tab.channels_list[j] then break end
					t[i] = {}
					t[i].name = tab.channels_list[j].bcname
					t[i].address = tab.channels_list[j].smlOttURL
					j = j + 1
					i = i + 1
				end
			end
		end
			if i == 1 then return end
		local hash, t1 = {}, {}
			for i = 1, #t do
				if not hash[t[i].address] then
					t1[#t1 + 1] = t[i]
					hash[t[i].address] = true
				end
			end
		local t0, j = {}, 1
			for _, v in pairs(t1) do
				if v.address:match('^http')
					and v.address:match('/CH_')
					and not (
							v.address:match('TEST')
							or v.name:match('^Тест')
							or v.name:match('^Test')
							or v.name:match('Sberbank')
							)
				then
					v.name = v.name:gsub('^Телеканал', '')
					v.name = v.name:gsub(' SD', '')
					v.name = v.name:gsub('«', '')
					v.name = v.name:gsub('»', '')
					v.name = v.name:gsub('"', '')
					v.name = v.name:gsub(':%s', ' ')
					v.name = v.name:gsub('^Канал', '')
					v.name = v.name:gsub(',', '%%2C')
					v.name = v.name:gsub('%.%s*$', '')
					t0[j] = v
					j = j + 1
				end
			end
			if j == 1 then return end
	 return t0
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local w = 'aHR0cHM6Ly9mZS1tb3Muc3ZjLmlwdHYucnQucnUvQ2FjaGVDbGllbnRKc29uL2pzb24vQ2hhbm5lbFBhY2thZ2UvbGlzdF9jaGFubmVscz9jaGFubmVsUGFja2FnZUlkPTg0NDE1OTU3JmxvY2F0aW9uSWQ9NzAwMDAxJmZyb209MCZ0bz0yMTQ3NDgzNjQ3'
		local w1 = 'aHR0cHM6Ly9mZS1tb3Muc3ZjLmlwdHYucnQucnUvQ2FjaGVDbGllbnRKc29uL2pzb24vQ2hhbm5lbFBhY2thZ2UvbGlzdF9jaGFubmVscz9jaGFubmVsUGFja2FnZUlkPTE2NDc3MjQ0MiZsb2NhdGlvbklkPTcwMDAwMSZmcm9tPTAmdG89MjE0NzQ4MzY0Nw'
		local t_pls = Itv20GetTbl(w, w1)
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0)})
			 return
			end
		t_pls = ProcessFilterTableLocal(t_pls)
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