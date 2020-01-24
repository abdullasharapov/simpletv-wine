-- видеоскрипт для сайта https://vimeo.com (4/8/19)
-- открывает подобные ссылки:
-- https://vimeo.com/channels/staffpicks/190785902?autoplay=1
-- https://vimeo.com/156942975
-- https://player.vimeo.com/video/150619949?title=0&byline=0&portrait=0
-- https://player.vimeo.com/video/344303837?wmode=transparent&referer=https://www.clubbingtv.com/video/play/4194/live-dj-set-with-dan-lo/
-----------------------------------------------------------------------------------------
local qlty = 0 -- качество: 0 - максимальное, ограничить от 320
-----------------------------------------------------------------------------------------
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('vimeo%.com') and not inAdr:match('&vimeo') then return end
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	inAdr = inAdr:gsub('http://', 'https://')
	if not m_simpleTV.User.vimeo then
		m_simpleTV.User.vimeo = {}
	end
	if qlty > 0 and not m_simpleTV.User.vimeo.MaxResolution then
		m_simpleTV.User.vimeo.MaxResolution = qlty
	end
	if qlty == 0 and not m_simpleTV.User.vimeo.MaxResolution then
		m_simpleTV.User.vimeo.MaxResolution = 10000
	end
	local function GetMaxResolutionIndex(t)
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if (tvs_core) and (TVSources_var.IsTVS == true) then
			index = nil
		end
		if not index and not m_simpleTV.User.vimeo.MaxResolution then
			m_simpleTV.User.vimeo.MaxResolution = t[#t].qlty
		elseif index then
			if #t < index then
				index = #t - 1
			end
			if t[index+1] and t[index+1].qlty then
				m_simpleTV.User.vimeo.MaxResolution = t[index+1].qlty
			end
		end
		if m_simpleTV.User.vimeo.MaxResolution > 0 then
			for u = 1, #t do
					if t[u].qlty and m_simpleTV.User.vimeo.MaxResolution < t[u].qlty then break end
				index = u
			end
		end
	 return index or 1
	end
	if inAdr:match('&vimeo') then
		if m_simpleTV.User.vimeo.ResolutionTable then
			if m_simpleTV.Control.CurrentTitle_UTF8 then
				m_simpleTV.Control.CurrentTitle_UTF8 = m_simpleTV.User.vimeo.title
			end
			local index = GetMaxResolutionIndex(m_simpleTV.User.vimeo.ResolutionTable)
			local retAdr = m_simpleTV.User.vimeo.ResolutionTable[index].Adress:gsub('&vimeo', '')
			m_simpleTV.Control.CurrentAdress = retAdr
		end
	 return
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if not inAdr:match('player%.vimeo%.com') then
		rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
				m_simpleTV.OSD.ShowMessage_UTF8('vimeo ошибка[1]-' .. rc, 255, 5)
			 return
			end
		local id = answer:match('content="(.-)"') or ''
		local data = answer:match('data%-config%-url="([^"]+)"') or answer:match('%.open%("GET","(https?://player%.vimeo%.com/video/%d+/config[^"]+)"') or answer:find('"config_url":"https?:') and answer:match('"config_url":"(https?:[^"]+)"') or answer:match('https?://player%.vimeo%.com/video/' .. id .. '/config[^\'"%s]+') or 'http://player.vimeo.com/video/' .. id .. '/config'
			if not data then
				m_simpleTV.OSD.ShowMessage_UTF8('vimeo ошибка[2]', 255, 5)
			 return
			end
		data = data:gsub('&amp;', '&'):gsub('\\/', '/')
		rc, answer = m_simpleTV.Http.Request(session, {url = data})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
	else
		local headers = inAdr:match('&referer=(.-)$') or 'https://faaf.tv\nCookie: player=""'
		headers = 'Referer: ' .. headers
		inAdr = inAdr:gsub('[&?].-$', '')
		rc, answer = m_simpleTV.Http.Request(session, {url = inAdr, headers = headers})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
		answer = answer:match('var config = ({.-});')
			if not answer then return end
	end
	answer = answer:gsub('%[%]', '"nil"')
	require 'json'
	local tab = json.decode(answer)
		if not tab
			or not tab.request
			or not tab.request.files
			or not tab.request.files.progressive
		then
		 return
		end
	local t, i = {}, 1
		while true do
				if not tab.request.files.progressive[i] then break end
			t[i] = {}
			t[i].Id = i
			t[i].Name = tab.request.files.progressive[i].quality
			t[i].Adress = tab.request.files.progressive[i].url .. '&vimeo'
			t[i].qlty = tab.request.files.progressive[i].height
			i = i + 1
		end
		if i == 1 then return end
	table.sort(t, function(a, b) return a.qlty < b.qlty end)
	for i = 1, #t do t[i].Id = i end
	m_simpleTV.User.vimeo.ResolutionTable = t
	local index, retAdr
	if i > 1 then
		index = GetMaxResolutionIndex(t)
		retAdr = t[index].Adress:gsub('&vimeo', '')
	end
	if i > 2 then
		m_simpleTV.OSD.ShowSelect_UTF8('⚙  Качество', index - 1, t, 5000, 32 + 64 + 128)
	end
	if inAdr:match('^https?://vimeo.com') then
		local title = tab.video.title or 'Vimeo'
		m_simpleTV.Control.CurrentTitle_UTF8 = title
	end
	m_simpleTV.User.vimeo.title = m_simpleTV.Control.CurrentTitle_UTF8
	m_simpleTV.Control.CurrentAdress = retAdr
-- debug_in_file(retAdr .. '\n')