-- скрапер TVS для загрузки плейлиста "PeersTV+" http://peers.tv (22/7/19)
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
	}
------------------------------------------------------------------------------------------
	module('peersTV_plus_pls', package.seeall)
	local my_src_name = 'PeersTV+'
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
	function GetVersion() return 2, 'UTF-8' end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local outm3u, err = tvs_func.get_m3u(decode64('aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3LzhCekVuSk5Q'))
		if err ~= '' then tvs_core.tvs_ShowError(err) m_simpleTV.Common.Sleep(1000) end
			if not outm3u or outm3u == '' then return '' end
		local t_pls = tvs_core.GetPlsAsTable(outm3u)
		t_pls = ProcessFilterTableLocal(t_pls)
		m_simpleTV.OSD.ShowMessage_UTF8(Source.name .. ' -> ' .. #t_pls, 0xffaf00, 5)
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return nil end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t .. '\n')