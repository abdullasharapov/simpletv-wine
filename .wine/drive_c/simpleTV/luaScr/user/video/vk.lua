-- видеоскрипт для сайта http://vk.com (14/2/19)
-- необходимы скрипты: youtube ...
-- открывает подобные ссылки:
-- https://vk.com/video-33598391_456239036
-- https://vk.com/video2797862_166856999?list=e957bb0f2a63f9c911
-- http://vkontakte.ru/video-208344_73667683
-- https://vk.com/feed?z=video-101982925_456239539%2F1900258e458f45eccc%2Fpl_post_-101982925_3149238
-- https://vk.com/video.php?act=s&oid=-21693490&id=159155218
-- <iframe src="https://vk.com/video_ext.php?oid=-24136539&id=456239830&hash=34e326ffb9cbb93e" width="640" height="360" frameborder="0" allowfullscreen></iframe>
-- https://vk.com/videos-53997646?section=album_49667766&z=video-53997646_456239913%2Fclub53997646%2Fpl_-53997646_49667766
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://vk%.com') and not inAdr:match('https?://vkontakte%.ru') then return end
		if inAdr:match('/video_hls%.php') then return end
	require 'json'
	inAdr = inAdr:gsub('vkontakte%.ru', 'vk%.com')
	m_simpleTV.Control.ChangeAdress= 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local function GetParam(inAdr)
		local oid, vid
		if inAdr:match('vk%.com/video%-') then
			oid, vid = inAdr:match('video(.-)_(%d+)')
			if oid == nil or vid == nil then return nil end
		end
		if inAdr:match('vk%.com/video%.php') then
			oid, vid = inAdr:match('oid=(.-)&id=(%d+)')
			if oid == nil or vid == nil then return nil end
		end
		if inAdr:match('vk%.com/.-/video%-') then
			oid, vid = inAdr:match('video(.-)_(%d+)')
			if oid == nil or vid == nil then return nil end
		end
		if inAdr:match('vk%.com/.-=video%-') then
			oid, vid = inAdr:match('=video(.-)_(%d+)')
			if oid == nil or vid == nil then return nil end
		end
		if inAdr:match('vk%.com/video_ext') then
			oid, vid = inAdr:match('oid=(.-)&id=(.-)&')
			if oid == nil or vid == nil then return nil end
		end
		if inAdr:match('vk%.com/video%d') then
			oid, vid = inAdr:match('video(.-)_(%d+)%?')
			if oid == nil or vid == nil then
				oid, vid = inAdr:match('video(.-)_(%d+)$')
				if oid == nil or vid == nil then return nil end
			end
		end
	 return oid, vid
	end
	local oid, vid = GetParam(inAdr)
		if oid == nil or vid == nil then
			m_simpleTV.Http.Close(session)
			m_simpleTV.OSD.ShowMessage_UTF8('vkontakte ошибка[1]', 255, 5)
		 return
		end
	local url = decode64('aHR0cHM6Ly9hcGkudmsuY29tL21ldGhvZC92aWRlby5nZXQ/dmlkZW9zPQ==') .. oid .. '_' .. vid .. decode64('JmFjY2Vzc190b2tlbj02NjcxM2U0N2M4YjU4MDNiZDhlOWIyOGVjMzFiMDFkMDVmZjY1ZTFiZTFjMWYwYTI0Zjc3MjVlMzEwZTAxNzFlOTdjN2MyMjRlOTZlNjQ5MGE2MmJlJnY9NS43Mw==')
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then
			m_simpleTV.OSD.ShowMessage_UTF8('vkontakte ошибка[2]-' .. rc, 255, 5)
		 return
		end
	local t = json.decode(answer:gsub('(%[%])', '"nil"'))
		if t == nil then return end
		if t.response == nil or t.response.count == 0 then
			m_simpleTV.OSD.ShowMessage_UTF8('vkontakte ошибка[3]', 255, 5)
		 return
		end
	m_simpleTV.Control.CurrentTitle = m_simpleTV.Common.UTF8ToMultiByte(t.response.items[1].title)
	local tt = {}
	if t.response.items[1].files.mp4_1080 then tt[1] = t.response.items[1].files.mp4_1080 end
	if t.response.items[1].files.mp4_720 then tt[2] = t.response.items[1].files.mp4_720 end
	if t.response.items[1].files.mp4_480 then tt[3] = t.response.items[1].files.mp4_480 end
	if t.response.items[1].files.mp4_360 then tt[4] = t.response.items[1].files.mp4_360 end
	if t.response.items[1].files.mp4_240 then tt[5] = t.response.items[1].files.mp4_240 end
		if t.response.items[1].files.flv_320 then
			m_simpleTV.Control.CurrentAdress = t.response.items[1].files.flv_320
		 return
		end
		if t.response.items[1].files.hls then
			m_simpleTV.Control.CurrentAdress = t.response.items[1].files.hls .. '$OPT:no-ts-trust-pcr'
		 return
		end
		if t.response.items[1].files.external and not t.response.items[1].files.live then
			m_simpleTV.Control.ChangeAdress = 'No'
			m_simpleTV.Control.CurrentAdress = t.response.items[1].files.external
			dofile(m_simpleTV.MainScriptDir .. "user\\video\\video.lua")
		 return
		end
		if t.response.items[1].files.live then
			m_simpleTV.Control.CurrentAdress = t.response.items[1].files.live .. '$OPT:no-ts-trust-pcr'
		 return
		end
	local i, ttt = 1, {}
	local retAdr
		for k, v in pairs(tt) do
			if k == 1 then k = '1080' end
			if k == 2 then k = '720' end
			if k == 3 then k = '480' end
			if k == 4 then k = '360' end
			if k == 5 then k = '240' end
			ttt[i] = {}
			ttt[i].Id  = i
			ttt[i].Name = k
			ttt[i].Adress = v
			i = i + 1
		end
	if i > 2 then
		local _, id = m_simpleTV.OSD.ShowSelect_UTF8('Качество', 0, ttt, 5000, 64+32+128)
		if id == nil then id = 1 end
		retAdr = ttt[id].Adress
	else
		retAdr = ttt[1].Adress
	end
	m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:NO-STIMESHIFT'
-- debug_in_file(retAdr .. '\n')