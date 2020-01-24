-- видеоскрипт для сайта https://filmix.co (2/11/19)
-- логин, пароль установить в 'Password Manager', для id - filmix
-- необходим AceStream
-- открывает подобные ссылки:
-- https://filmix.co/semejnyj/103212-odin-doma-2-zateryannyy-v-nyu-yorke-1992.html
-- https://filmix.co/play/112056
-- https://filmix.co/fantastika/113095-puteshestvenniki-2016.html
-- https://filmix.co/download-file/55308
-- https://filmix.co/download/5409
-- https://filmix.co/download/35895
-- зеркало -------------------------------------------------------------------------------
local zer = ''
-- '' - нет
-- 'https://filmix.today' - (пример)
------------------------------------------------------------------------------------------
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://filmix%.') and not inAdr:match('^%$filmixnet') then return end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 5, id = 'channelName'})
	if inAdr:match('^%$filmixnet') or not inAdr:match('&kinopoisk') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	if zer ~= '' then
		inAdr = inAdr:gsub('https?://filmix%..-/', zer .. '/')
	end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
		if inAdr:match('/download%-file/') then
			local retAdr = 'torrent://' .. inAdr:gsub('https://', 'http://')
			m_simpleTV.Control.CurrentAdress = retAdr
		 return
		end
	local host = inAdr:match('https?://.-/')
		if inAdr:match('/download/') then
			local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3809.87 Safari/537.36')
				if not session then return end
			m_simpleTV.Http.SetTimeout(session, 12000)
			local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
			m_simpleTV.Http.Close(session)
				if rc ~= 200 then return end
			local t, i = {}, 1
			for Adr in answer:gmatch('/(download%-file/%d+)') do
				t[i] = {}
				t[i].Id = i
				t[i].Name = i
				t[i].Adress = host .. Adr
				i = i + 1
			end
				if i == 1 then return end
			if i > 2 then
				local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберете торрент', 0, t, 5000, 1)
				if not id then id = 1 end
				inAdr = t[id].Adress
			else
				inAdr = t[1].Adress
			end
			inAdr = 'torrent://' .. inAdr:gsub('https://', 'http://')
			m_simpleTV.Control.CurrentAdress = inAdr
		 return
		end
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Filmix then
		m_simpleTV.User.Filmix = {}
	end
	if not m_simpleTV.User.Filmix.qlty then
		m_simpleTV.User.Filmix.qlty = tonumber(m_simpleTV.Config.GetValue('Filmix_qlty') or '720')
	end
	local title
	if m_simpleTV.User.Filmix.Tabletitle then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then
			title = m_simpleTV.User.Filmix.title .. ' - ' .. m_simpleTV.User.Filmix.Tabletitle[index + 1].Name
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
	local function DeCipher(url)
		url = url:gsub('&filmixnet', '')
		url = url:gsub('^%#%d', '')
		url = url:gsub('\\/', '/')
		local sep
		for i = 1, 5 do
			sep = url:match('[^a-zA-Z0-9%+]+')
				if not sep or url:match(sep .. '$') then
				 return decode64(url)
				end
				while true do
					local m = url:match(sep .. string.rep('%w', 24))
						if not m then break end
					url = url:gsub(m, '')
				end
		end
			if url:match(sep) and not url:match(sep .. '$') then return end
	 return decode64(url)
	end
	local function GetMaxResolutionIndex(t)
		local index
		for u = 1, #t do
				if t[u].qlty and m_simpleTV.User.Filmix.qlty < t[u].qlty then break end
			index = u
		end
	 return index or 1
	end
	local function GetQualityFromAddress(Adr)
		local t, i = {}, 1
		for qlty, adr in Adr:gmatch('%[(%d+).-%](.-mp4)') do
			t[i] = {}
			t[i].qlty = qlty:gsub('^2$', '1440'):gsub('^4$', '2160')
			t[i].Adress = adr .. '$OPT:NO-STIMESHIFT'
			i = i + 1
		end
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
			if i == 1 then return end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
		for i = 1, #t do
			t[i].Id = i
		end
		m_simpleTV.User.Filmix.Table = t
		local index = GetMaxResolutionIndex(t)
		m_simpleTV.User.Filmix.Index = index
	 return t[index].Adress
	end
	local function SaveFilmixPlaylist()
		if m_simpleTV.User.Filmix.Tabletitle then
			local t = m_simpleTV.User.Filmix.Tabletitle
			if #t > 250 then
				m_simpleTV.OSD.ShowMessageT({text = 'Сохранение плейлиста ...', color = ARGB(255, 155, 255, 255), showTime = 1000 * 30, id = 'channelName'})
			end
			local header = m_simpleTV.User.Filmix.title
			local adr, name
			local m3ustr = '#EXTM3U $ExtFilter="Filmix" $BorpasFileFormat="1"\n'
				for i = 1, #t do
					name = t[i].Name
					adr = t[i].Adress:gsub('^%$filmixnet', '')
					adr = GetQualityFromAddress(adr)
					m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. header .. '", ' .. name .. '\n' .. adr:gsub('%$OPT:.+', '') .. '\n'
				end
			header = m_simpleTV.Common.UTF8ToMultiByte(header)
			header = header:gsub('%c', ''):gsub('[\\/"%*:<>%|%?]+', ' '):gsub('%s+', ' '):gsub('^%s*', ''):gsub('%s*$', '')
			local fileEnd = ' (Filmix ' .. os.date('%d.%m.%y') ..').m3u'
			local folder = m_simpleTV.Common.GetMainPath(2) .. m_simpleTV.Common.UTF8ToMultiByte('сохраненые плейлисты/')
			lfs.mkdir(folder)
			local folderAk = folder .. 'Filmix/'
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
	local function play(Adr, title)
		if session then
			m_simpleTV.Http.Close(session)
		end
		local retAdr = GetQualityFromAddress(Adr:gsub('^%$filmixnet', ''))
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
	function Quality_filmix()
		local t = m_simpleTV.User.Filmix.Table
			if not t then return end
		local index = m_simpleTV.User.Filmix.Index
		if not m_simpleTV.User.Filmix.isVideo then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '💾', ButtonScript = 'SaveFilmixPlaylist()'}
		end
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		if #t > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙  Качество', index - 1, t, 5000, 1 + 4 + 2)
			if ret == 1 then
				m_simpleTV.User.Filmix.Index = id
				m_simpleTV.Control.SetNewAddress(t[id].Adress, m_simpleTV.Control.GetPosition())
				m_simpleTV.Config.SetValue('Filmix_qlty', t[id].qlty)
				m_simpleTV.User.Filmix.qlty = t[id].qlty
			end
			if ret == 2 then
				SaveFilmixPlaylist()
			end
		end
	end
	m_simpleTV.User.Filmix.isVideo = false
		if inAdr:match('^%$filmixnet') then
			play(inAdr, title)
		 return
		end
	inAdr = inAdr:gsub('&kinopoisk', '')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3809.87 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	m_simpleTV.User.Filmix.Tabletitle = nil
	local id = inAdr:match('/(%d+)')
		if not id then
			m_simpleTV.Http.Close(session)
		return
		end
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
			m_simpleTV.OSD.ShowMessageT({text = 'filmix ошибка[1]-' .. rc, color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
		 return
		end
	if answer:match('var dle_user_id=0') then
		local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('filmix') end, err)
		if login == '' or password == '' or not login or not password then
			login = 'mevalil'
			password = 'm123456'
		end
		if login and password then
			local rc, answer = m_simpleTV.Http.Request(session, {body = 'login_name=' .. url_encode(login) .. '&login_password=' .. url_encode(password) .. '&login=submit', url = host .. 'engine/ajax/user_auth.php', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})
			if rc == 200 and not answer:match('AUTHORIZED') then
				m_simpleTV.OSD.ShowMessageT({text = 'Неправильный логин или пароль\nfilmix ошибка[2]', color = ARGB(255, 255, 0, 0), showTime = 1000 * 10, id = 'channelName'})
			end
		end
	end
	title = answer:match('<title>(.-)</title>') or 'filmix'
	title = m_simpleTV.Common.multiByteToUTF8(title)
	title = title:gsub('[%s]?/.+', ''):gsub('[%s]?%(.+', ''):gsub('смотреть онлай.+', ''):gsub('[%s]$', '')
	m_simpleTV.User.Filmix.title = title
	m_simpleTV.Control.SetTitle(title)
	rc, answer = m_simpleTV.Http.Request(session, {url = host .. 'api/movies/player_data', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. inAdr, body = 'post_id=' .. id .. '&showfull=true' })
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
			m_simpleTV.OSD.ShowMessageT({text = 'filmix ошибка[3]-' .. rc, color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
		 return
		end
	local tr = answer:match('"video"(.-)}')
		if not tr then
			m_simpleTV.Http.Close(session)
			m_simpleTV.OSD.ShowMessageT({text = 'filmix ошибка[4]', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
		 return
		end
	local t, i = {}, 1
	local name, Adr
		for name, Adr in tr:gmatch('"(.-)":"(.-)"') do
			t[i] = {}
			t[i].Id = i
			name = unescape3(name)
			t[i].Name = name:gsub('\\/', '/')
			t[i].Adress = Adr
			i = i + 1
		end
		if i == 1 then return end
	if i > 2 then
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберете перевод - ' .. title, 0, t, 5000, 1)
		if not id then
			id = 1
		end
		inAdr = t[id].Adress
	else
		inAdr = t[1].Adress
	end
	if answer:match('"pl":"yes"') then
		local season_title = ''
		local Adr = DeCipher(inAdr)
			if not Adr then return end
		local rc, answer = m_simpleTV.Http.Request(session, {url = Adr})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessageT({text = 'filmix ошибка[5]-' .. rc, color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
			 return
			end
		answer = DeCipher(answer)
			if not answer then return end
		require 'json'
		local tab = json.decode(answer:gsub('(%[%])', '"nil"'))
			if not tab then return end
		local t, i = {}, 1
		if tab[1].folder then
			local s, j, sesnom = {}, 1
				while true do
						if not tab[j] then break end
					s[j] = {}
					s[j].Id = j
					s[j].Name = tab[j].title
					s[j].Adress = j
					j = j + 1
				end
				if j == 1 then return end
			if j > 2 then
				local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, s, 5000, 1)
				if not id then
					id = 1
				end
				sesnom = s[id].Adress
				season_title = ' (' .. s[id].Name .. ')'
			else
				sesnom = s[1].Adress
				local ses = s[1].Name:match('%d+') or '0'
				if tonumber(ses) > 1 then
					season_title = ' (' .. s[1].Name .. ')'
				end
			end
			season_title = season_title:gsub('%(%s+', '(')
				while true do
						if not tab[sesnom].folder[i] then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = tab[sesnom].folder[i].title:gsub('%(Сезон.-%)', '')
					t[i].Adress = '$filmixnet' .. tab[sesnom].folder[i].file
					i = i + 1
				end
				if i == 1 then return end
		else
				while true do
						if not tab[i] then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = tab[i].title:gsub('%(Сезон.-%)', '')
					t[i].Adress = '$filmixnet' .. tab[i].file
					i = i + 1
				end
				if i == 1 then return end
		end
		m_simpleTV.User.Filmix.Tabletitle = t
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Quality_filmix()'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		local pl = 0
		if i == 2 then
			pl = 32
			m_simpleTV.User.Filmix.isVideo = true
		end
		title = title .. season_title
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 5000, pl)
		if not id then
			id = 1
		end
		m_simpleTV.User.Filmix.title = title
		inAdr = t[id].Adress
		title = title .. ' - ' .. m_simpleTV.User.Filmix.Tabletitle[1].Name
	else
		inAdr = DeCipher(inAdr)
			if not inAdr then return end
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = title
		t1[1].Adress = inAdr
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Quality_filmix()'}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		m_simpleTV.OSD.ShowSelect_UTF8('Filmix', 0, t1, 5000, 64 + 32 + 128)
		m_simpleTV.User.Filmix.isVideo = true
	end
	play(inAdr, title)