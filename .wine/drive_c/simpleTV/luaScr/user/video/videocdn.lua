-- видеоскрипт для видеобазы "videocdn" https://videocdn.tv (12/11/19)
-- открывает подобные ссылки:
-- https://videocdn.so/fnXOUDB9nNSO?kp_id=5928
-- https://videocdn.so/fnXOUDB9nNSO/tv-series/92
-- https://videocdn.so/fnXOUDB9nNSO/tv-series/4592
-- https://32.tvmovies.in/fnXOUDB9nNSO/movie/22080
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://[%w%.]*videocdn%.')
			and not inAdr:match('^https?://%w+%.tvmovies%.in')
			and not inAdr:match('^%$videocdn')
		then
		 return
		end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 5, id = 'channelName'})
	if inAdr:match('^%$videocdn') or not inAdr:match('&kinopoisk') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3809.87 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Videocdn then
		m_simpleTV.User.Videocdn = {}
	end
	if not m_simpleTV.User.Videocdn.qlty then
		m_simpleTV.User.Videocdn.qlty = tonumber(m_simpleTV.Config.GetValue('Videocdn_qlty') or '10000')
	end
	local title
	if m_simpleTV.User.Videocdn.Tabletitle then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then
			title = m_simpleTV.User.Videocdn.title .. ' - ' .. m_simpleTV.User.Videocdn.Tabletitle[index+1].Name
		end
	end
	local function ShowInfo(s)
		local q = {}
			q.once = 1
			q.zorder = 0
			q.cx = 0
			q.cy = 0
			q.id = 'AK_INFO_TEXT'
			q.class = 'TEXT'
			q.align = 0x0202
			q.top = 0
			q.color = ARGB(0xFF, 0xFF, 0xFF, 0xF0)
			q.font_italic = 0
			q.font_addheight = 6
			q.padding = 20
			q.textparam = 1 + 4
			q.text = s
			q.background = 0
			q.backcolor0 = ARGB(0x90, 0, 0, 0)
		m_simpleTV.OSD.AddElement(q)
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
		end
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
		end
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
		end
		m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
	end
	local function GetMaxResolutionIndex(t)
		local index
		for u = 1, #t do
				if t[u].qlty and m_simpleTV.User.Videocdn.qlty < t[u].qlty then break end
			index = u
		end
	 return index or 1
	end
	local function GetQualityFromAddress(url)
		url = url:gsub('^%[', '')
		local t, i = {}, 1
			for qlty, adr in url:gmatch('%[(.-)%](.-mp4)') do
				t[i] = {}
				t[i].qlty = qlty:match('%d+') or 10
				t[i].Adress = adr:gsub('^//', 'https://') .. '$OPT:NO-STIMESHIFT'
				i = i + 1
			end
			if i == 1 then return end
			for _, v in pairs(t) do
				v.qlty = tonumber(v.qlty)
				if v.qlty > 0 and v.qlty <= 180 then
					v.qlty = 144
				elseif v.qlty > 180 and v.qlty <= 300 then
					v.qlty = 240
				elseif v.qlty > 300 and v.qlty <= 400 then
					v.qlty = 360
				elseif v.qlty > 400 and v.qlty <= 500 then
					v.qlty = 480
				elseif v.qlty > 500 and v.qlty <= 780 then
					v.qlty = 720
				elseif v.qlty > 780 and v.qlty <= 1200 then
					v.qlty = 1080
				elseif v.qlty > 1200 and v.qlty <= 1500 then
					v.qlty = 1444
				elseif v.qlty > 1500 and v.qlty <= 2800 then
					v.qlty = 2160
				elseif v.qlty > 2800 and v.qlty <= 4500 then
					v.qlty = 4320
				end
				v.Name = v.qlty .. 'p'
			end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
		for i = 1, #t do
			t[i].Id = i
		end
		m_simpleTV.User.Videocdn.Table = t
		local index = GetMaxResolutionIndex(t)
		m_simpleTV.User.Videocdn.Index = index
	 return t[index].Adress
	end
	local function SaveVideocdnPlaylist()
		if m_simpleTV.User.Videocdn.Tabletitle then
			local t = m_simpleTV.User.Videocdn.Tabletitle
			if #t > 250 then
				m_simpleTV.OSD.ShowMessageT({text = 'Сохранение плейлиста ...', color = ARGB(255, 155, 255, 255), showTime = 1000 * 30, id = 'channelName'})
			end
			local header = m_simpleTV.User.Videocdn.title
			local adr, name
			local m3ustr = '#EXTM3U $ExtFilter="Videocdn" $BorpasFileFormat="1"\n'
				for i = 1, #t do
					name = t[i].Name
					adr = t[i].Adress:gsub('^%$videocdn', '')
					adr = GetQualityFromAddress(adr)
					m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. header .. '",' .. name .. '\n' .. adr:gsub('%$OPT:.+', '') .. '\n'
				end
			header = m_simpleTV.Common.UTF8ToMultiByte(header)
			header = header:gsub('%c', ''):gsub('[\\/"%*:<>%|%?]+', ' '):gsub('%s+', ' '):gsub('^%s*', ''):gsub('%s*$', '')
			local fileEnd = ' (Videocdn ' .. os.date('%d.%m.%y') ..').m3u'
			local folder = m_simpleTV.Common.GetMainPath(2) .. m_simpleTV.Common.UTF8ToMultiByte('сохраненые плейлисты/')
			lfs.mkdir(folder)
			local folderAk = folder .. 'Videocdn/'
			lfs.mkdir(folderAk)
			local filePath = folderAk .. header .. fileEnd
			local fhandle = io.open(filePath, 'w+')
			m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 1, id = 'channelName'})
			if fhandle then
				fhandle:write(m3ustr)
				fhandle:close()
				ShowInfo('плейлист сохранен в файл\n' .. m_simpleTV.Common.multiByteToUTF8(header) .. '\nв папку\n' .. m_simpleTV.Common.multiByteToUTF8(folderAk))
			else
				ShowInfo('невозможно сохранить плейлист')
			end
		end
	end
	local function play(retAdr, title)
		retAdr = GetQualityFromAddress(retAdr:gsub('^%$videocdn', ''))
			if not retAdr then
				m_simpleTV.Control.CurrentAdress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
			 return
			end
		if m_simpleTV.Control.CurrentTitle_UTF8 then
			m_simpleTV.Control.CurrentTitle_UTF8 = title
		end
		m_simpleTV.OSD.ShowMessageT({text = title, color = ARGB(255, 155, 155, 255), showTime = 1000 * 5, id = 'channelName'})
		m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')
	end
	function Qlty_Videocdn()
		local t = m_simpleTV.User.Videocdn.Table
			if not t then return end
		local index = m_simpleTV.User.Videocdn.Index
		if not m_simpleTV.User.Videocdn.isVideo then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '💾', ButtonScript = 'SaveVideocdnPlaylist()'}
		end
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		if #t > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 1 + 4 + 2)
			if ret == 1 then
				m_simpleTV.User.Videocdn.Index = id
				m_simpleTV.Control.SetNewAddress(t[id].Adress, m_simpleTV.Control.GetPosition())
				m_simpleTV.Config.SetValue('Videocdn_qlty', t[id].qlty)
				m_simpleTV.User.Videocdn.qlty = t[id].qlty
			end
			if ret == 2 then
				SaveVideocdnPlaylist()
			end
		end
	end
	m_simpleTV.User.Videocdn.isVideo = false
		if inAdr:match('^%$videocdn') then
			play(inAdr, title)
		 return
		end
	inAdr = inAdr:gsub('&kinopoisk', ''):gsub('%?block=%w+', '')
	m_simpleTV.User.Videocdn.Tabletitle = nil
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessageT({text = 'videocdn ошибка[1]-' .. rc, color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
		 return
		end
	title = answer:match('<title>([^<]+)') or answer:match('id="title" value="([^"]+)')
	if not title or title == '' then
		title = m_simpleTV.Control.CurrentTitle_UTF8
	end
	m_simpleTV.Control.SetTitle(title)
	local tv_series
	if answer:match('value="tv_series"') then
		tv_series = true
	end
	local transl
	local tr = answer:match('<div class="translations".-</div>')
	if tr then
		local t, i = {}, 1
			for Adr, name in tr:gmatch('<option.-value="(.-)".->(.-)</option>') do
				t[i] = {}
				t[i].Id = i
				t[i].Name = name:gsub('.+template>', '')
				t[i].Adress = Adr
				i = i + 1
			end
			if i == 1 then return end
		if i > 2 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберете перевод - ' .. title, 0, t, 5000, 1)
			if not id then id = 1 end
			transl = t[id].Adress
		else
			transl = t[1].Adress
		end
	end
	transl = transl or '0'
	local answer = answer:match('id="files" value="(.-)"')
		if not answer then return end
	answer = answer:gsub('&quot;', '"')
	answer = answer:match('"' .. transl .. '":%[({.-}%]})%]')
			or answer:match('"' .. transl .. '":%[({.-}%]})')
			or answer:match('"' .. transl .. '":"(.-)"')
			or answer
	answer = '[' .. answer .. ']'
	answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/')
	if tv_series then
		require 'json'
		local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
			if not tab then return end
		local season_title = ''
		local t, i = {}, 1
		if tab[1].folder then
			local s, j, seson = {}, 1
				while true do
						if not tab[j] then break end
					s[j] = {}
					s[j].Id = j
					s[j].Name = unescape3(tab[j].comment)
					s[j].Adress = j
					j = j + 1
				end
				if j == 1 then return end
			if j > 2 then
				local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, s, 5000, 1)
				if not id then
					id = 1
				end
				seson = s[id].Adress
				season_title = ' (' .. s[id].Name .. ')'
			else
				seson = s[1].Adress
				local ses = s[1].Name:match('%d+') or '0'
				if tonumber(ses) > 1 then
					season_title = ' (' .. s[1].Name .. ')'
				end
			end
				while true do
						if not tab[seson].folder[i] then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = unescape3(tab[seson].folder[i].comment):gsub('&lt;.+', '')
					t[i].Adress = '$videocdn' .. tab[seson].folder[i].file
					i = i + 1
				end
				if i == 1 then return end
		else
				while true do
						if not tab[i] then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = unescape3(tab[i].comment):gsub('&lt;.+', '')
					t[i].Adress = '$videocdn' .. tab[i].file
					i = i + 1
				end
				if i == 1 then return end
		end
		m_simpleTV.User.Videocdn.Tabletitle = t
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_Videocdn()'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		t.ExtParams = {FilterType = 2}
		local p = 0
		if i == 2 then
			p = 32
			m_simpleTV.User.Videocdn.isVideo = true
		end
		title = title .. season_title
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 5000, p)
		if not id then
			id = 1
		end
		inAdr = t[id].Adress
		m_simpleTV.User.Videocdn.title = title
		title = title .. ' - ' .. m_simpleTV.User.Videocdn.Tabletitle[1].Name
	else
		inAdr = answer:gsub('\\/', '/')
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = title
		t1[1].Adress = inAdr
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_Videocdn()'}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		m_simpleTV.OSD.ShowSelect_UTF8('Videocdn', 0, t1, 5000, 64+32+128)
		m_simpleTV.User.Videocdn.isVideo = true
	end
	play(inAdr, title)