-- видеоскрипт для сайта http://seasonvar.ru (28/10/19)
-- необходимы скрипты: pladform, rutube, youtube, russiatv, ovvatv, megogo
-- открывает подобные ссылки:
-- http://seasonvar.ru/serial-18656-Lyudi-3-season.html
------------------------------------------------------------------------------------------
local noad = 0 -- пропускать рекламу в начале, сек.
------------------------------------------------------------------------------------------
local prx = '' -- прокси
-- '' - нет
-- например 'http://proxy-nossl.antizapret.prostovpn.org:29976'
------------------------------------------------------------------------------------------
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://seasonvar%.') and not inAdr:match('&seasonvar') then return end
	require 'json'
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	if inAdr:match('&seasonvar') or not inAdr:match('&kinopoisk') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	local kp = false
	local host = inAdr:match('(https?://.-.)/')
	if inAdr:match('&kinopoisk') then
		kp = true
		inAdr = inAdr:gsub('&kinopoisk', '')
	end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/78.0.2785.143 Safari/537.36', prx, false)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Seasonvar then
		m_simpleTV.User.Seasonvar = {}
	end
	local title
	if m_simpleTV.User.Seasonvar.Tabletitle then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then title = m_simpleTV.User.Seasonvar.title .. ' - ' .. m_simpleTV.User.Seasonvar.Tabletitle[index+1].Name end
	end
	local function unesca(s)
		s = string.gsub(s, "u04(%x%x)", function (h)
		local s = tonumber(h, 16)
			if s < 64 then
				return string.char(0xD0,s+0x80)
			else return string.char(0xD1,s+0x40)
			end
		end)
		s = s:match('(.-серия)') or s
		s = s:gsub('<br>.-', ''):gsub('[%s]?SD.-', ' '):gsub('Трейлеры', ' - трейлер'):gsub('&#039;', '\'')
	 return s
	end
	local function getanswer(inAdr)
		local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
	 return answer
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
	function SaveSeasonvarPlaylist()
		if m_simpleTV.User.Seasonvar.Tabletitle and m_simpleTV.User.Seasonvar.title then
			require 'lfs'
			local t = m_simpleTV.User.Seasonvar.Tabletitle
			local header = m_simpleTV.User.Seasonvar.title
			local adr, name
			local m3ustr = '#EXTM3U $ExtFilter="Seasonvar" $BorpasFileFormat="1"\n'
				for i = 1, #t do
					name = t[i].Name
					adr = t[i].Adress:gsub('%$OPT:.+', '')
					m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. header .. '",' .. name .. '\n' .. adr:gsub('&seasonvar', '') .. '\n'
				end
			header = m_simpleTV.Common.UTF8ToMultiByte(header)
			header = header:gsub('%c', ''):gsub('[\\/"%*:<>%|%?]+', ' '):gsub('%s+', ' '):gsub('^%s*', ''):gsub('%s*$', '')
			local fileEnd = ' (Seasonvar ' .. os.date('%d.%m.%y') ..').m3u8'
			local folder = m_simpleTV.Common.GetMainPath(2) .. m_simpleTV.Common.UTF8ToMultiByte('сохраненые плейлисты/')
			lfs.mkdir(folder)
			local folderAk = folder .. 'Seasonvar/'
			lfs.mkdir(folderAk)
			local filePath = folderAk .. header .. fileEnd
			local fhandle = io.open(filePath, 'w+')
			if fhandle then
				fhandle:write(m3ustr)
				fhandle:close()
				ShowInfo('плейлист сохранен в файл\n' .. m_simpleTV.Common.multiByteToUTF8(header) .. fileEnd .. '\nв папку\n' .. m_simpleTV.Common.multiByteToUTF8(folderAk))
			else
				ShowInfo('невозможно сохранить плейлист')
			end
		end
	end
	local function GetAddressFromPlaylist(data)
			if not data:match('^%[{') then return end
		local tab = json.decode(data)
			if not tab then return end
		local a, n, k, l, Adress = {}, 1
		local Adr = ''
		for i = 1, #tab, 1 do
			local t = tab
			local isfile
			if t[i].file then
				k = 1
				isfile = true
			else
				if not t[i].folder then
					if not t[i] then break end
					t = t[i]
				else
					t = t[i].folder
				end
				k = #t
				isfile = false
			end
			for j = 1, k, 1 do
				a[n] = {}
				a[n].Id = n
				if isfile == true then
					l = i
				elseif isfile == false then l = j end
					a[n].Name = unesca(t[l].title)
					Adress = t[l].file
					Adress = Adress:gsub('b2xvbG8=', ''):gsub('/', ''):gsub('\\', ''):gsub('%#%d+', '')
					Adress = decode64(Adress)
					Adress = Adress:match('or (http.-mp4)') or Adress:match('(http.-mp4) or ') or Adress:match('(http.-m3u8) or')  or Adress:match('http.-mp4$') or Adress
					a[n].Adress = Adress:gsub('%]','%%5D'):gsub('%[','%%5B') .. '&seasonvar'
					a[n].subt = t[l].subtitle
					if a[n].subt then
						if m_simpleTV.Common.GetVlcVersion() < 3000 then
							a[n].subt = a[n].subt:gsub('://', '/subtitle://')
						end
						a[n].Adress = a[n].Adress .. '$OPT:input-slave=' .. a[n].subt:gsub('%[.-%]http', 'http') .. '$OPT:sub-track=0'
					end
					a[n].Adress = a[n].Adress .. '$OPT:NO-STIMESHIFT'
				n = n + 1
			end
		end
			if n == 1 then return end
		m_simpleTV.User.Seasonvar.Tabletitle = a
		a.ExtButton0 = {ButtonEnable = true, ButtonName = '💾', ButtonScript = 'SaveSeasonvarPlaylist()'}
		a.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		if #a > 1 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.Seasonvar.title, 0, a, 5000)
			if not id then id = 1 end
			retAdr = a[id].Adress
			title = m_simpleTV.User.Seasonvar.title .. ' - ' .. m_simpleTV.User.Seasonvar.Tabletitle[1].Name
		else
			retAdr = a[1].Adress
		end
	 return retAdr
	end
	local retAdr = inAdr
	if not retAdr:match('&seasonvar') then
		m_simpleTV.User.Seasonvar.Tabletitle = nil
		m_simpleTV.User.Seasonvar.title = nil
		local answer = getanswer(inAdr)
			if not answer then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessage_UTF8('seasonvar ошибка[2]', 250500, 5)
			 return
			end
		title = answer:match('itemprop="name">(.-)<') or 'seasonvar'
		title = title:gsub('Сериал ', ''):gsub('онлайн.-', ''):gsub(' смотреть онлайн.+', ''):gsub('&#039;', '\''):gsub('%(%d%d%d%d%)', '')
		if kp == false then title = title:gsub('/.+', '') end
		m_simpleTV.User.Seasonvar.title = title
		local seaslist = answer:match('<div class="pgs%-seaslist">(.-)</div>')
			if seaslist and kp == false then
				local t, i, name, adrs = {}, 1
					for ww in seaslist:gmatch('<a(.-)/a>') do
						name = ww:match('>(.-)<')
						adrs = ww:match('href="(.-)"')
						name = name:gsub(' >>> ', ''):gsub('Сериал ', ''):gsub('&amp;', '&'):gsub('&#039;', "'"):gsub('%(%d%d%d%d%)', '')
						t[i] = {}
						t[i].Id = i
						t[i].Adress = host .. adrs
						t[i].Name = name
						i = i + 1
					end
				if i > 2 then
					local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 5000, 1)
					if not id then id = 1 end
					inAdr = t[id].Adress
					m_simpleTV.User.Seasonvar.title = t[id].Name:gsub('%s%s+', ' ')
				else
					inAdr = t[1].Adress
				end
				answer = getanswer(inAdr)
			end
		local legalplay = answer:match('src=".-(//legalplay.-)"')
			if legalplay then
				local answer = getanswer(legalplay:gsub('^//', 'http://'))
					if not answer then
						m_simpleTV.Http.Close(session)
						m_simpleTV.OSD.ShowMessage_UTF8('seasonvar ошибка[3]', 250500, 5)
					 return
					end
				local lic = answer:match('<ul class="svplaylist%-ul">(.-)</ul>')
					if not lic then
						m_simpleTV.Http.Close(session)
						m_simpleTV.OSD.ShowMessage_UTF8('seasonvar ошибка[4]', 255, 5)
					 return
					end
				local player = lic:match('onclick="(.-)%(')
				local playerurl = answer:match(player .. '.-src="(.-)\'')
				if playerurl:match('^//') then playerurl = 'http:'.. playerurl end
				local i, t = 1, {}
					for dataid, name in lic:gmatch('<li onclick="' .. player .. '%(\\\'(.-)\\.->(.-)</li>') do
						t[i] = {}
						t[i].Id = i
						t[i].Name = name
						t[i].Adress = playerurl .. dataid
						i = i + 1
					end
				if i > 2 then
 					local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 5000)
					if not id then id = 1 end
					retAdr = t[id].Adress
				else
					retAdr = t[1].Adress
				end
				m_simpleTV.Http.Close(session)
				m_simpleTV.Control.ChangeAdress = 'No'
				m_simpleTV.Control.CurrentAdress = retAdr
				dofile(m_simpleTV.MainScriptDir .. 'user\\video\\video.lua')
			 return
			end
		local pladform = answer:match('src=".-(//out.pladform.-)"')
			if pladform then
				if m_simpleTV.Control.CurrentTitle_UTF8 then
					m_simpleTV.Control.CurrentTitle_UTF8 = title
				end
				local retAdr = pladform
				m_simpleTV.Http.Close(session)
				m_simpleTV.Control.ChangeAdress = 'No'
				m_simpleTV.Control.CurrentAdress = retAdr:gsub('^//', 'http://')
				dofile(m_simpleTV.MainScriptDir .. 'user\\video\\video.lua')
			 return
			end
		local secure = answer:match("'secureMark': '(.-)'")
		if not secure then secure = '0' end
		local id = answer:match('data%-id%-season="(.-)"') or ''
		local serial = answer:match('data%-id%-serial="(.-)"') or ''
		local timez = answer:match("'time': (%d+)") or ''
		local body = 'id=' .. id .. '&serial=' .. serial .. '&type=html5&secure=' .. secure .. '&time=' .. timez
		local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. inAdr .. '\nCookie: uppodhtml5_volume=1; playerHtml=true'
		local rc, answer = m_simpleTV.Http.Request(session, {body = body, url = host .. '/player.php', method = 'post', headers = headers})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessage_UTF8('seasonvar ошибка[5]-' .. rc, 255, 5)
			 return
			end
		local url = answer:match('var pl =.-"(.-)"')
		local translate = answer:match('<script>var pl(.-)<li class="label"')
		if translate then
			local translate = translate:gsub('<li.-"0".-</li>', ''):gsub("{'0':", '<li translate="0">Стандартный<pl[0] =')
			local t1, i, name = {}, 1
				for ww in translate:gmatch('<li(.-);</script>') do
					name = ww:match('translate=.->(.-)<')
					t1[i] = {}
					t1[i].Id = i
					t1[i].Name = name:gsub('&amp;', '&') .. string.rep(' ', 20)
					t1[i].Adress = ww:match('pl.-"(.-)"')
					i = i + 1
				end
				if i == 1 then
					m_simpleTV.Http.Close(session)
					m_simpleTV.OSD.ShowMessage_UTF8('seasonvar ошибка[5.2]', 255, 8)
				 return
				end
			if i > 2 then
				local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Перевод - ' .. m_simpleTV.User.Seasonvar.title, 0, t1, 5000, 1)
				if not id then id = 1 end
				url = t1[id].Adress
			else
				url = t1[1].Adress
			end
		end
		rc, answer = m_simpleTV.Http.Request(session, {url = host .. url, headers = 'Referer: ' .. inAdr})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 or (rc == 200 and (answer == '' or answer:match('^%[%]') or not answer:match('^%[{'))) then
				m_simpleTV.OSD.ShowMessage_UTF8('Видео недоступно или заблокировано\nseasonvar ошибка[6]', 825155, 8)
			 return
			end
		retAdr = GetAddressFromPlaylist(answer)
	end
		if not retAdr then
			m_simpleTV.Control.CurrentAdress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
		 return
		end
	if m_simpleTV.Control.CurrentTitle_UTF8 then
		m_simpleTV.Control.CurrentTitle_UTF8 = title
	end
	m_simpleTV.OSD.ShowMessageT({text = title, color = ARGB(255, 155, 155, 255), showTime = 1000 * 5, id = 'channelName'})
	retAdr = retAdr .. '$OPT:start-time=' .. noad
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')