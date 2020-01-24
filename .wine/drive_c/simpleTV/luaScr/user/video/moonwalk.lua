-- видеоскрипт для видеобазы "Moonwalk" (17/5/19)
-- открывает подобные ссылки:
-- http://moonwalk.cc/serial/9258550a799e3ea8a07a3da405df58e0/iframe
------------------------------------------------------------------------------------------
local noad = 0 -- пропускать рекламу в начале, сек.
------------------------------------------------------------------------------------------
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('^https?://.-/video/%w+/iframe')
			and not inAdr:match('^https?://.-/serial/%w+/iframe')
			and not inAdr:match('^%$moon')
		then
		 return
		end
		if inAdr:match('https?://videoframe%.') then return end
	if not inAdr:match('%$kinopoisk') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 5, id = 'channelName'})
	require 'json'
	require 'jsdecode'
	require 'lfs'
	inAdr = inAdr:gsub('^https?://moonwalk%.cc/', 'http://streamguard.cc/')
	inAdr = inAdr:gsub('%?block.+', '')
	inAdr = inAdr:gsub('amp;', '')
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local ua = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3359.170 Safari/537.36 OPR/53.0.2907.99'
	local session = m_simpleTV.Http.New(ua, '', true)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	m_simpleTV.Http.SetRedirectAllow(session, false)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Moonwalk then
		m_simpleTV.User.Moonwalk = {}
	end
	if not m_simpleTV.User.Moonwalk.RES then
		m_simpleTV.User.Moonwalk.RES = tonumber(m_simpleTV.Config.GetValue('MoonwalkRES') or '10000')
	end
	local title
	if m_simpleTV.User.Moonwalk.Tabletitle then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then
			title = m_simpleTV.User.Moonwalk.title .. ' - ' .. m_simpleTV.User.Moonwalk.Tabletitle[index+1].Name
		end
	end
	local kp, subt = false, ''
	if inAdr:match('%$kinopoisk') then
		kp = true
		inAdr = inAdr:gsub('$kinopoisk', '')
	end
	local nameepi = ''
	local nachadr = inAdr:match('.-/serial/') or inAdr:match('.-/video/')
	local function ShowInfo(s)
		local addElement = m_simpleTV.OSD.AddElement
		local removeElement = m_simpleTV.OSD.RemoveElement
		local q = {}
		q.once = 1
		q.zorder = 0
		q.cx = 0
		q.cy = 0
		q.id = 'MW_TEXT_INFO'
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
		addElement(q)
		q = {}
		q.id = 'MW_DIV_CR'
		q.cx = 200
		q.cy = 200
		q.class = 'DIV'
		q.minresx = 800
		q.minresy = 600
		q.align = 0x0403
		q.left = 0
		q.once = 1
		q.zorder = 1
		q.background = -1
		addElement(q)
		q = {}
		q.id = 'MW_DIV_CR_TEXT'
		q.cx = 0
		q.cy = 0
		q.class = 'TEXT'
		q.minresx = 0
		q.minresy = 0
		q.align = 0x0403
		q.text = 'Moonwalk by nexterr '
		q.color = ARGB(0x40, 211, 211, 211)
		q.font_height = -15
		q.font_weight = 700
		q.font_underline = 0
		q.font_italic = 0
		q.font_name = 'Arial'
		q.textparam = 0
		q.left = 5
		q.top = 5
		q.glow = 1
		q.glowcolor = ARGB(0x90, 0x00, 0x00, 0x00)
		addElement(q,'MW_DIV_CR')
			if m_simpleTV.Common.WaitUserInput(5000) == 1 then
				removeElement('MW_TEXT_INFO')
				removeElement('MW_DIV_CR')
			 return
			end
			if m_simpleTV.Common.WaitUserInput(5000) == 1 then
				removeElement('MW_TEXT_INFO')
				removeElement('MW_DIV_CR')
			 return
			end
			if m_simpleTV.Common.WaitUserInput(5000) == 1 then
				removeElement('MW_TEXT_INFO')
				removeElement('MW_DIV_CR')
			 return
			end
		removeElement('MW_TEXT_INFO')
		removeElement('MW_DIV_CR')
	end
	local function UnBlock(inAdr)
		if inAdr:match('season=') or inAdr:match('episode=') then
			inAdr = inAdr:gsub('%?ref=.-%?', '?'):gsub('[&%?]+ref=.-&', '&')
		else
			inAdr = inAdr:gsub('%?ref=.+', '')
		end
		local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: https://rezka.ag'})
		if rc == 302 then
			local raw = m_simpleTV.Http.GetRawHeader(session)
				if not raw then return end
			inAdr = raw:match('Location: (.-)\n') or ''
			rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: https://rezka.ag'})
		end
	 return rc, answer
	end
	local function GetMaxResolutionIndex(t)
		local index
		for u = 1, #t do
				if t[u].res and (m_simpleTV.User.Moonwalk.RES) < t[u].res then break end
			index = u
		end
	 return index or 1
	end
	local function GetMoonwalkAddress(answer)
		local tab = json.decode(answer:gsub('\u0026', '&'))
			if not tab or not tab.m3u8 then
				m_simpleTV.OSD.ShowMessage_UTF8('moonwalk ошибка[6]', 255, 5)
			 return
			end
		local retAdr = tab.mp4 or tab.m3u8
		rc, answer = m_simpleTV.Http.Request(session, {url = retAdr, headers = 'Referer:' .. retAdr})
			if rc ~= 200 then
				m_simpleTV.OSD.ShowMessage_UTF8('moonwalk ошибка[7]-' .. rc, 255, 5)
			 return
			end
		local tt, i = {}, 1
		local name, adr
		if tab.mp4 then
			for ee in string.gmatch(answer, '(".-":.-".-")') do
				tt[i] = {}
				tt[i].Id = i
				tt[i].Name = ee:match('"(.-)":')
				adr = ee:match(':.-"(.-)"')
				adr = adr .. '$OPT:NO-STIMESHIFT'
				if subt ~= '' then
					if m_simpleTV.Common.GetVlcVersion() < 3000 then
						subt = subt:gsub('://', '/subtitle://')
					end
					adr = adr .. '$OPT:input-slave=' .. subt:gsub('^%[.-%]', '') .. '$OPT:sub-track=0'
				end
				tt[i].Adress = adr
				tt[i].res = tonumber(tt[i].Name:match('%d+') or '10')
				i = i + 1
			end
		else
			for w in string.gmatch(answer, '#EXT%-X%-STREAM%-INF:(.-)m3u8') do
				name = w:match('RESOLUTION=(.-),')
				if not name then name = findpattern(w, '^(.-),', 1, 0, 1) end
				adr = findpattern(w, 'http(.+)', 1, 0, 0) .. 'm3u8'
					if not name or not adr then break end
				tt[i] = {}
				tt[i].Id = i
				tt[i].Name = name:match('x(%d+)') or '10'
				tt[i].Adress = adr
				tt[i].res = tonumber(tt[i].Name)
				i = i + 1
			end
		end
			if i == 1 then return retAdr end
		table.sort(tt, function(a, b) return a.res < b.res end)
		for i = 1, #tt do tt[i].Id = i end
		m_simpleTV.User.Moonwalk.Table = tt
		local index = GetMaxResolutionIndex(tt)
		m_simpleTV.User.Moonwalk.Index = index
		retAdr = tt[index].Adress
	 return retAdr
	end
	local function Crypto(partner_id, domain_id, video_token, ihash, e)
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js', headers = 'Referer:' .. inAdr})
			if rc ~= 200 then return end
		local scr = answer .. 'var str=\'{"a":' .. partner_id ..',"b":' .. domain_id .. ',"c":false,"e":"' .. video_token .. '","f":"' .. ua .. '"}\';var key=CryptoJS.enc.Hex.parse("' .. e .. '");var iv=CryptoJS.enc.Hex.parse("' .. ihash .. '");var encryptedStr=CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(str),key,{iv: iv,}).toString();//console.log(encryptedStr);'
	 return jsdecode.DoDecode('encryptedStr', false, scr, 0)
	end
	local function GetAddress(answer)
-- debug_in_file('answer= ' .. answer .. '\n')
		subt = answer:match('"master_vtt":"(http.-)"') or ''
		local domain_id = answer:match("domain_id: (%d+)") or ''
		local partner_id = answer:match('partner_id: (%d+)') or ''
		local video_token = answer:match("video_token.-'(.-)'") or ''
		local hostvideo = answer:match('host: \'(.-)\'') or answer:match('assets_host: \'https?://(.-)\'') or ''
		local proto = answer:match('proto: \'(.-)\'') or 'http://'
		local ref = answer:match('ref: \'(.-)\'') or ''
		local url = proto .. hostvideo .. '/vs'
		local headers = 'X-Requested-With: XMLHttpRequest'
		rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1dlbmR5SC9QSFAtU2NyaXB0cy9tYXN0ZXIvbW9vbjRjcmFjay5pbmk=')})
			if rc == 200 then
				ihash = answer:match('iv  = "(.-)"') or ''
				e = answer:match('key = "(.-)"') or ''
				body = Crypto(partner_id, domain_id, video_token, ihash, e) or ''
				body = body:gsub('%+', '%%2B'):gsub('/', '%%2F')
				body = 'q=' .. body .. '&ref=' .. ref
				rc, answer = m_simpleTV.Http.Request(session, {body = body, url = url, method = 'post', headers = headers})
			end
			if rc ~= 200 then
				rc, answer = m_simpleTV.Http.Request(session, {url = 'http://dune-club.info/tts?pid=' .. partner_id.. '&did=' .. domain_id .. '&mee=' .. video_token})
				if rc == 200 then
					body = answer:gsub('%+', '%%2B'):gsub('/', '%%2F')
					body = 'q=' .. body .. '&ref=' .. ref
					rc, answer = m_simpleTV.Http.Request(session, {body = body, url = url, method = 'post', headers = headers})
				end
			end
			if rc ~= 200 then
				rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cDovL3dvbmt5Lmxvc3RjdXQubmV0L21vb253YWxrX2tleS5waHA=')})
				if rc == 200 then
					ihash = answer:match('"iv":"(.-)"') or ''
					e = answer:match('"key":"(.-)"') or ''
					body = Crypto(partner_id, domain_id, video_token, ihash, e) or ''
					body = body:gsub('%+', '%%2B'):gsub('/', '%%2F')
					body = 'q=' .. body .. '&ref=' .. ref
					rc, answer = m_simpleTV.Http.Request(session, {body = body, url = url, method = 'post', headers = headers})
				end
			end
			if rc ~= 200 then
				rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cDovL3d3dy51MmNzcDAxLm1sL2hkcmV6L2hkcl9rZXkucGhw')})
				if rc == 200 then
					ihash = answer:match('value2=(%w+)') or ''
					e = answer:match('value1=(%w+)') or ''
					body = Crypto(partner_id, domain_id, video_token, ihash, e) or ''
					body = body:gsub('%+', '%%2B'):gsub('/', '%%2F')
					body = 'q=' .. body .. '&ref=' .. ref
					rc, answer = m_simpleTV.Http.Request(session, {body = body, url = url, method = 'post', headers = headers})
				end
			end
			if rc ~= 200 then
				rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cDovL3d3dy51MmNzcDAxLnRrL2hkcmV6L2hkcl9rZXkucGhw')})
				if rc == 200 then
					ihash = answer:match('value2=(%w+)') or ''
					e = answer:match('value1=(%w+)') or ''
					body = Crypto(partner_id, domain_id, video_token, ihash, e) or ''
					body = body:gsub('%+', '%%2B'):gsub('/', '%%2F')
					body = 'q=' .. body .. '&ref=' .. ref
					rc, answer = m_simpleTV.Http.Request(session, {body = body, url = url, method = 'post', headers = headers})
				end
			end
-- debug_in_file('proto= ' .. proto .. '\n' .. 'hostvideo= ' .. hostvideo .. '\n' .. 'partner_id= ' .. partner_id .. '\n' .. 'domain_id= ' .. domain_id .. '\n' .. 'video_token= ' .. video_token .. '\n' .. 'ihash= ' .. (ihash or '') .. '\n' .. 'e= ' .. (e or '') .. '\n' .. 'body= ' .. (body or '') .. '\n')
				if rc ~= 200 then return end
	 return answer
	end
	function SaveMoonwalkPlaylist()
		if m_simpleTV.User.Moonwalk.Tabletitle and m_simpleTV.User.Moonwalk.title then
			m_simpleTV.OSD.ShowMessageT({text = 'Сохранение плейлиста ...', color = ARGB(255, 155, 255, 255), showTime = 1000 * 60, id = 'channelName'})
			local t = m_simpleTV.User.Moonwalk.Tabletitle
			local header = m_simpleTV.User.Moonwalk.title
			local adr, name
			local m3ustr = '#EXTM3U $ExtFilter="Moonwalk" $BorpasFileFormat="1"\n'
				for i = 1, #t do
					name = t[i].Name
					adr = t[i].Adress:gsub('%$moon', '')
					local rc, answer = m_simpleTV.Http.Request(session, {url = adr, headers = 'Referer:' .. adr})
					if rc == 302 then
						local raw = m_simpleTV.Http.GetRawHeader(session)
							if not raw then break end
						local inAdr = raw:match('Location: (.-)\n') or ''
						rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: ' .. inAdr})
					end
					if answer:match('Blocked') or rc == 302 then
						rc, answer = UnBlock(adr:gsub('%$moon', ''))
					end
						if rc ~= 200 then break end
					answer = GetAddress(answer)
					adr = GetMoonwalkAddress(answer)
					m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. header .. '",' .. name .. '\n' .. adr:gsub('%$.+', '') .. '\n'
				end
			header = m_simpleTV.Common.UTF8ToMultiByte(header)
			header = header:gsub('%c', ''):gsub('[\\/"%*:<>%|%?]+', ' '):gsub('%s+', ' '):gsub('^%s*', ''):gsub('%s*$', '')
			local fileEnd = ' (Moonwalk ' .. os.date('%d.%m.%y') ..').m3u'
			local folder = m_simpleTV.Common.GetMainPath(2) .. m_simpleTV.Common.UTF8ToMultiByte('сохраненые плейлисты/')
			lfs.mkdir(folder)
			local folderAk = folder .. 'Moonwalk/'
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
	function Quality_Moonwalk()
		local t = m_simpleTV.User.Moonwalk.Table
			if not t then return end
		local index = m_simpleTV.User.Moonwalk.Index
		if not m_simpleTV.User.Moonwalk.isVideo then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '💾'}
		end
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
		t.ExtParams = {FilterType = 2}
		if #t > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙  Качество', index-1, t, 5000, 1+4+2)
			if ret == 1 then
				m_simpleTV.User.Moonwalk.Index = id
				m_simpleTV.Control.SetNewAddress(t[id].Adress, m_simpleTV.Control.GetPosition())
				m_simpleTV.Config.SetValue('MoonwalkRES', t[id].res)
				m_simpleTV.User.Moonwalk.RES = t[id].res
			end
			if ret == 2 then
				SaveMoonwalkPlaylist()
			end
		end
	end
	local function play(answer)
		local retAdr = GetAddress(answer)
			if not retAdr then
				m_simpleTV.Http.Close(session)
				m_simpleTV.Control.CurrentAdress = 'http://wonky.lostcut.net/vids/error_getlink.avi'
			 return
			end
		retAdr = GetMoonwalkAddress(retAdr)
			if not retAdr then
				m_simpleTV.Http.Close(session)
				m_simpleTV.Control.CurrentAdress = 'http://dune-club.info/plugins/update/1.mp4'
			 return
		end
		if m_simpleTV.Control.CurrentTitle_UTF8 then
			m_simpleTV.Control.CurrentTitle_UTF8 = title
		end
		m_simpleTV.OSD.ShowMessageT({text = title, color = ARGB(255, 155, 155, 255), showTime = 1000 * 5, id = 'channelName'})
		m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:start-time=' .. noad
-- debug_in_file(retAdr .. '\n')
	end
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr:gsub('$moon', ''), headers = 'Referer:' .. inAdr})
	if rc == 302 then
		local raw = m_simpleTV.Http.GetRawHeader(session)
			if not raw then return end
		local inAdr = raw:match('Location: (.-)\n') or ''
		rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: ' .. inAdr})
	end
	if answer:match('Blocked') or rc == 302 then
		rc, answer = UnBlock(inAdr:gsub('$moon', ''))
	end
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
			m_simpleTV.OSD.ShowMessage_UTF8('moonwalk ошибка[2]-' .. rc, 255, 5)
		 return
		end
		if inAdr:match('$moon') then
			play(answer)
		 return
		end
	m_simpleTV.User.Moonwalk.isVideo = true
	m_simpleTV.User.Moonwalk.Tabletitle = nil
	title = m_simpleTV.Control.CurrentTitle_UTF8 or 'Moonwalk'
	m_simpleTV.User.Moonwalk.title = title
	local transl = answer:match('translations: %[(.-%]%]),.-seasons')
	if transl and not transl:match('seasons') and kp == false then
		local t, i = {}, 1
			for Adr, name in transl:gmatch('%["(.-)","(.-)"%]') do
				t[i] = {}
				t[i].Id = i
				t[i].Name = name
				t[i].Adress = nachadr .. Adr .. '/iframe'
				i = i + 1
			end
		if i > 2 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберете перевод - ' .. title, 0, t, 5000, 1)
			if not id then id = 1 end
			 inAdr = t[id].Adress
		else
			inAdr = t[1].Adress
		end
		rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: ' .. inAdr})
		if answer:match('Blocked') or rc == 302 then
			rc, answer = UnBlock(inAdr:gsub('$moon', ''))
				if rc ~= 200 then
					m_simpleTV.Http.Close(session)
					m_simpleTV.OSD.ShowMessage_UTF8('moonwalk ошибка[3]-' .. rc, 255, 5)
				 return
				end
		end
	end
	local seasons = answer:match('seasons: %[(.-%d+.-)%]')
	if seasons then
		local t, i = {}, 1
			for seas in seasons:gmatch('%d+') do
				t[i] = {}
				t[i].Id = i
				t[i].Name = 'сезон ' .. seas
				t[i].Adress = inAdr:gsub('%?ref=.+', '') .. '?season=' .. seas
				i = i + 1
			end
		t.ExtParams = {FilterType = 2}
		if i > 2 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберете сезон: ' .. title, 0, t, 5000, 1 + 2)
			if not id then id = 1 end
			inAdr = t[id].Adress
			nameepi = t[id].Name
		else
			inAdr = t[1].Adress
		end
		rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: ' .. inAdr})
		if nameepi ~= '' then nameepi = ' (' .. nameepi .. ')' end
		if answer:match('Blocked') or rc == 302 then
			rc, answer = UnBlock(inAdr:gsub('$moon', ''))
				if rc ~= 200 then
					m_simpleTV.Http.Close(session)
					m_simpleTV.OSD.ShowMessage_UTF8('moonwalk ошибка[4]-' .. rc, 255, 5)
				 return
				end
		end
	end
	local episodes = answer:match('episodes: %[(.-%d+.-)%]')
	if episodes then
		local t, i = {}, 1
			for epis in episodes:gmatch('%d+') do
				t[i] = {}
				t[i].Id = i
				t[i].Name = 'серия ' .. epis
				t[i].Adress = '$moon' .. inAdr:gsub('%?ref=.-%?', '?'):gsub('[&%?]+ref=.-&', '&') .. '&episode=' .. epis
				i = i + 1
			end
		m_simpleTV.User.Moonwalk.isVideo = false
		m_simpleTV.User.Moonwalk.Tabletitle = t
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Quality_Moonwalk()'}
		t.ExtParams = {FilterType = 2}
		if i > 2 then
			local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. nameepi, 0, t, 5000)
			if not id then id = 1 end
			inAdr = t[id].Adress
			end
		if i == 2 then
			m_simpleTV.OSD.ShowSelect_UTF8(title .. nameepi, 0, t, 5000, 32+128)
			inAdr = t[1].Adress
		end
		rc, answer = m_simpleTV.Http.Request(session, {url = inAdr:gsub('$moon', ''), headers = 'Referer:' .. inAdr})
		if rc == 302 then
			local raw = m_simpleTV.Http.GetRawHeader(session)
				if not raw then return end
			local inAdr = raw:match('Location: (.-)\n') or ''
			rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = 'Referer: ' .. inAdr})
		end
		if answer:match('Blocked') or rc == 302 then
			rc, answer = UnBlock(inAdr:gsub('$moon', ''))
		end
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessage_UTF8('moonwalk ошибка[2.1]-' .. rc, 255, 5)
			 return
			end
		if nameepi ~= '' then
			title = title .. nameepi
			m_simpleTV.User.Moonwalk.title = title
		end
		title = title .. ' - ' .. m_simpleTV.User.Moonwalk.Tabletitle[1].Name
	else
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = m_simpleTV.User.Moonwalk.title
		t1[1].Adress = inAdr
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Quality_Moonwalk()'}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		m_simpleTV.OSD.ShowSelect_UTF8('Moonwalk', 0, t1, 5000, 64+32+128)
	end
	play(answer)