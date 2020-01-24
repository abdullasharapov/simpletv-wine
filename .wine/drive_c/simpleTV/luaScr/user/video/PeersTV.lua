-- видеоскрипт для плейлиста "PeersTV" http://peers.tv (12/9/19)
-- открывает подобные ссылки:
-- http://hls.peers.tv/streaming/set/16/tvrecw/playlist.m3u8
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://%w+%.peers%.tv/streaming/')
			and not inAdr:match('https?://%w+%.peers%.tv/experimental/')
			and not inAdr:match('https?://peers%.tv/data/')
		then
		 return
		end
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.PeersTV then
		m_simpleTV.User.PeersTV = {}
	end
	if not m_simpleTV.User.TVTimeShift then
		m_simpleTV.User.TVTimeShift = {}
	end
	inAdr = inAdr:gsub('//h1s%.', '//hls.')
	inAdr = inAdr:gsub('/experimental/', '/streaming/')
	local ua = decode64('RHVuZUhELzEuMC4xIHBlZXJzdHY')
	local extopt = '$OPT:http-user-agent=' .. ua
	if m_simpleTV.Common.GetVlcVersion() > 3000 then
		extopt = extopt .. '$OPT:no-ts-cc-check'
	end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = 'error'
	local session = m_simpleTV.Http.New(ua)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	m_simpleTV.User.TVTimeShift.PeersTVTimeshiftAdress = nil
	local function gettoken()
		local rc, answer = m_simpleTV.Http.Request(session, {body = decode64('Z3JhbnRfdHlwZT1pbmV0cmElM0Fhbm9ueW1vdXMmY2xpZW50X2lkPTI5NzgzMDUxJmNsaWVudF9zZWNyZXQ9YjRkNGViNDM4ZDc2MGRhOTVmMGFjYjViYzZiNWM3NjA='), url = decode64('aHR0cDovL2FwaS5wZWVycy50di9hdXRoLzIvdG9rZW4='), method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded'})
			if rc ~= 200 then return '' end
	 return	answer:match('"access_token":"(.-)"') or ''
	end
	if not m_simpleTV.User.PeersTV.token then
		m_simpleTV.User.PeersTV.token = gettoken()
	end
	local token = m_simpleTV.User.PeersTV.token
	local retAdr = inAdr:gsub('%$(.+)', '')
	local channelId = inAdr:match('%$id=(.-)%$')
	local isTimeshift = inAdr:match('%$tshift=(.-)%$')
	local isAccess = inAdr:match('%$access=(.+)')
	if isAccess == 'true' then
		retAdr = retAdr .. '?token=' .. token
	end
	retAdr = retAdr .. extopt
	m_simpleTV.Control.CurrentAdress = retAdr
	if isTimeshift then
		local rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cHM6Ly9hcGkucGVlcnMudHYvbWVkaWFsb2NhdG9yLzEvdGltZXNoaWZ0Lmpzb24/c3RyZWFtX2lkPQ==') .. channelId .. '&offset=3600', headers = decode64('QXV0aG9yaXphdGlvbjogQmVhcmVyIA==') .. token})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
			 return
			end
		local tadr = answer:match('"uri":"(.-)"') or ''
		tadr = tadr:gsub('\\', ''):gsub('?(.+)', '')
		m_simpleTV.User.TVTimeShift.PeersTVTimeshiftAdress = tadr
		-- debug_in_file(tadr .. '\n')
	end
	m_simpleTV.Http.Close(session)
-- debug_in_file(retAdr .. '\n')