-- скрипт дополнения "Архивы (timeshift)" (9/11/19)
-- запись ITV 2.0 ---------------------------------------------------------
local loadITV2 = 0 -- 0 - скачать; 1 - записать
local qlty = 0 -- качество: 0 - максимальное; 1 - не менять
--------------------------------------------------------------------------
-- Init
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.ip4 then
		m_simpleTV.User.ip4 = {}
	end
	if not m_simpleTV.User.TVTimeShift then
		m_simpleTV.User.TVTimeShift = {}
	end
	local ip4_table = m_simpleTV.User.ip4
	ip4_table.DefaultLen = 259200000 -- 3 дня
	local function GetAdrToSet(Adr, offset)
-- ITV 2.0
		if Adr:match('rt%.ru/hls/CH_')
			or Adr:match('ngenix%.net/hls/CH_')
		then
			if offset then
				m_simpleTV.User.TVTimeShift.isITV2_Offset = true
				m_simpleTV.User.TVTimeShift.ITV2_Offset = offset
			end
			local param = Adr:match('utcstart=(%d+)')
			if offset and param then
				Adr = ip4_TimeshiftGetNakedAdr(Adr) .. '?offset=' .. offset .. '&utcstart=' .. param
			elseif offset and not param then
				Adr = ip4_TimeshiftGetNakedAdr(Adr) .. '?offset=' .. offset .. "&utcstart=" .. os.time() .. '.00'
			else
				Adr = ip4_TimeshiftGetNakedAdr(Adr)
			end
-- zala
		elseif Adr:match('ott%.zala%.by')
			or Adr:match('178%.124%.183%.')
			or Adr:match('93%.85%.93%.')
		then
			if offset then
				m_simpleTV.User.TVTimeShift.isZala_Offset = true
				m_simpleTV.User.TVTimeShift.Zala_Offset = offset
				Adr = ip4_TimeshiftGetNakedAdr(Adr) .. '?offset=' .. offset
			end
-- yandextv
		elseif Adr:match('strm%.yandex%.ru/ka') then
			if offset then
				m_simpleTV.User.TVTimeShift.istYndx_Offset = true
				m_simpleTV.User.TVTimeShift.tYndx_Offset = offset
				local endY = os.time() - 120
				local startY = os.time() + offset
				if (endY - startY) > (6 * 3600) then
					endY = startY + (6 * 3600)
				end
				Adr = ip4_TimeshiftGetNakedAdr(Adr)
				Adr = Adr:gsub('&.-$', '') .. '?start=' .. startY .. '&end=' .. endY
			end
-- peerstv
		elseif Adr:match('hls%.peers%.tv')
			and m_simpleTV.User.TVTimeShift.PeersTVTimeshiftAdress
		then
			local param = Adr:match('token=([%w%-_]+)') or ''
			if offset then
				Adr = m_simpleTV.User.TVTimeShift.PeersTVTimeshiftAdress .. '?offset=' .. -offset .. '&token=' .. param
				if m_simpleTV.Common.GetVlcVersion() > 3000 then
					Adr = Adr .. '$OPT:no-ts-cc-check'
				end
			end
-- impulstv
		elseif (Adr:match('%.micro%.im') or Adr:match('213%.95%.%d+.%d+:8080'))
			and m_simpleTV.User.TVTimeShift.impulstvTimeshiftAdress
		then
			if offset then
				Adr = m_simpleTV.User.TVTimeShift.impulstvTimeshiftAdress .. '&timestamp=' .. os.time() + offset
			end
-- bluepoint
		elseif Adr:match('98%.158%.107%.17:%d+')
			and m_simpleTV.User.TVTimeShift.bluepointTimeshiftAdress
		then
			if offset then
				Adr = m_simpleTV.User.TVTimeShift.bluepointTimeshiftAdress .. '&timestamp=' .. os.time() + offset
			end
-- megogo
		elseif Adr:match('vcdn%.biz') then
			if offset then
				m_simpleTV.User.TVTimeShift.ismegogo_Offset = true
				m_simpleTV.User.TVTimeShift.megogo_Offset = offset
				Adr = Adr:gsub('/ts/%d+/type%.live', '/type%.live')
				Adr = Adr:gsub('/type%.live', '/ts/' .. -offset .. '/type.live')
			end
-- LimeHD
		elseif (Adr:match('limehd%.') and m_simpleTV.User.TVTimeShift.limehdTimeshiftAdress) then
			if offset then
				Adr = m_simpleTV.User.TVTimeShift.limehdTimeshiftAdress .. 'timeshift_rel-' .. -offset .. '.m3u8'
			end
-- glanz, itv.live
		elseif Adr:match('ruip%.tv')
			or Adr:match('ottg%.tv')
			or Adr:match('%.itv%.zone')
			or Adr:match('%.itv%.live')
		then
			if offset then
				Adr = Adr:gsub('/index%.', '/video.')
				Adr = Adr:gsub('/mono%.', '/video.')
				Adr = Adr:gsub('/video%.', '/timeshift_rel-' .. -offset .. '.')
				Adr = Adr:gsub('/mpegts', '/timeshift_rel/' .. -offset)
				Adr = Adr:gsub('/timeshift_rel/%d+', '/timeshift_rel/' .. -offset)
				Adr = Adr:gsub('/timeshift_rel%-%d+', '/timeshift_rel-' .. -offset)
			end
-- glanz, itv.live, sharavoz
		elseif Adr:match('ruip%.tv')
			or Adr:match('ottg%.tv')
			or Adr:match('%.itv%.zone')
			or Adr:match('%.itv%.live')
			or Adr:match('%.spr24%.net')
		then
			if offset then
				Adr = Adr:gsub('/index%.', '/video.')
				Adr = Adr:gsub('/mono%.', '/video.')
				Adr = Adr:gsub('/video%.', '/timeshift_rel-' .. -offset .. '.')
				Adr = Adr:gsub('/mpegts', '/timeshift_rel/' .. -offset)
				Adr = Adr:gsub('/timeshift_rel/%d+', '/timeshift_rel/' .. -offset)
				Adr = Adr:gsub('/timeshift_rel%-%d+', '/timeshift_rel-' .. -offset)
			end
-- edem, ottclub
		elseif Adr:match('https?://%w+%.%w+%.%w+/iptv/%w+/%d+/index%.m3u8')
			or Adr:match('ott%.watch')
			or Adr:match('spacetv%.in')
			or Adr:match('myott%.tv')
		then
			Adr = ip4_TimeshiftGetNakedAdr(Adr) .. '?utc=' .. os.time() + offset .. '&lutc=' .. os.time()
-- shuratv
		elseif Adr:match('tvshka%.net') then
			Adr = ip4_TimeshiftGetNakedAdr(Adr) .. '?archive=' .. (os.time() + offset)
-- smotreshka
		elseif Adr:match('smotreshka%.tv')
			or Adr:match('lfstrm%.tv')
			or Adr:match('tightvideo%.com')
		then
			Adr = Adr:gsub('&shift=.-$' , '') .. '&shift=' .. -offset
-- ipnet
		elseif Adr:match('ipnet%.ua') then
			Adr = ip4_TimeshiftGetNakedAdr(Adr) .. '?timeshift=' .. os.time() + offset
-- spb
		elseif Adr:match('spbtv%.com') then
			if offset then
				m_simpleTV.User.TVTimeShift.isspb_Offset = true
				m_simpleTV.User.TVTimeShift.spb_Offset = offset
				Adr = ip4_TimeshiftGetNakedAdr(Adr) .. '?stream_start_offset=' .. - offset .. '000000'
			end
-- voka
		elseif Adr:match('voka%.tv') then
			if offset then
				m_simpleTV.User.TVTimeShift.isvoka_Offset = true
				m_simpleTV.User.TVTimeShift.voka_Offset = offset
				Adr = ip4_TimeshiftGetNakedAdr(Adr) .. '?stream_start_offset=' .. - offset .. '000000'
			end
		end
-- debug_in_file('Adr=' .. Adr .. '\n')
	 return Adr
	end
	local function GetOffset(Adr)
		local offset
		if Adr:match('ngenix%.net/hls/CH_')
			or Adr:match('rt%.ru/hls/CH_')
		then
			offset = ip4_table.CurAdr:match('offset=(%-%d+)')
		elseif Adr:match('ott%.zala%.by')
			or Adr:match('178%.124%.183%.')
			or Adr:match('93%.85%.93%.')
		then
			offset = ip4_table.CurAdr:match('offset=(%-%d+)')
		elseif Adr:match('strm%.yandex%.ru/ka') then
			offset = ip4_table.CurAdr:match('start=(%d+)')
			if offset then
				offset = offset - os.time()
			end
		elseif Adr:match('98%.158%.107%.17:%d+') then -- bluepoint
			offset = ip4_table.CurAdr:match('timestamp=(%d+)')
			if offset then
				offset = offset - os.time()
			end
		elseif Adr:match('spbtv%.com') -- spb, voka
			or Adr:match('voka%.tv')
		then
			offset = ip4_table.CurAdr:match('stream_start_offset=(%d+)')
			if offset then
				offset = - (offset / 1000000)
			end
		elseif Adr:match('213%.95%.%d+.%d+:8080') then -- impulstv
			offset = ip4_table.CurAdr:match('timestamp=(%d+)')
			if offset then
				offset = offset - os.time()
			end
		elseif Adr:match('hls%.peers%.tv') then
			offset = ip4_table.CurAdr:match('offset=(%d+)')
			if offset then
				offset = - offset
			end
		elseif Adr:match('hlsarchive%.limehd%.tv') then
			offset = ip4_table.CurAdr:match('timeshift_rel%-(%d+)')
			if offset then
				offset = - offset
			end
		elseif Adr:match('%.itv%.zone') -- glanz, itv.live, sharavoz
			or Adr:match('%.itv%.live')
			or Adr:match('ottg%.tv')
			or Adr:match('ruip%.tv')
			or Adr:match('%.spr24%.net')
		then
			offset = ip4_table.CurAdr:match('timeshift_rel[%-/](%d+)')
			if offset then
				offset = - offset
			end
		elseif Adr:match('vcdn%.biz') then -- megogo
			offset = ip4_table.CurAdr:match('/ts/(%d+)')
			if offset then
				offset = - offset
			end
		elseif Adr:match('smotreshka%.tv')
			or Adr:match('tightvideo%.com')
			or Adr:match('lfstrm.%tv')
		then
			offset = ip4_table.CurAdr:match('&shift=(%d+)')
			if offset then
				offset = - offset
			end
		elseif Adr:match('https?://%w+%.%w+%.%w+/iptv/%w+/%d+/index%.m3u8')
			or Adr:match('ott%.watch')
			or Adr:match('spacetv%.in')
			or Adr:match('myott%.tv')
		then
			offset = ip4_table.CurAdr:match('utc=(%d+)')
			if offset then
				offset = offset - os.time()
			end
		elseif Adr:match('tvshka%.net') then
			offset = ip4_table.CurAdr:match('archive=(%d+)')
			if offset then
				offset = offset - os.time()
			end
		elseif Adr:match('ipnet%.ua') then
			offset = ip4_table.CurAdr:match('timeshift=(%d+)')
			if offset then
				offset = offset - os.time()
			end
		end
-- if offset then debug_in_file('offset=' .. offset .. '\n') end
	 return offset
	end
-- Timer handler
	function ip4_TimeshiftSetDelayed()
		ip4_TimeshiftStopTimer()
		local state = m_simpleTV.Control.GetState()
			if state < 1 or state > 5 then return end
		local offset = 0
		if ip4_table.TimeShiftPos ~= 1.0 then
			offset = math.floor(ip4_table.TimeShiftLen * (1 - ip4_table.TimeShiftPos ) / 1000 )
		end
		ip4_table.CurOffset = 0
		if ip4_table.TimeShiftPos == 1.0 then
			ip4_table.AdrToSet = GetAdrToSet(ip4_table.CurAdr, nil)
		else
			ip4_table.CurOffset = - offset
			ip4_table.AdrToSet = GetAdrToSet(ip4_table.CurAdr, - offset)
		end
-- debug_in_file('ip4_table.AdrToSet=' .. ip4_table.AdrToSet .. '\n')
		m_simpleTV.Control.SetNewAddress(ip4_table.AdrToSet)
	end
-- Main handler
	function ip4_TimeshiftHandler(Type, Data, Data1, Data2)
-- Data - address
-- Data1 - offset
-- Data2 - epgId (maybe nil or -1)
-- debug_in_file ('Type: ' .. Type .. '\n')
-- if Data then debug_in_file('Data: ' .. Data .. '\n') end
-- if Data1 then debug_in_file('Data1: ' .. Data1 .. '\n') end
-- if Data2 then debug_in_file('Data2: ' .. Data2 .. '\n') end
-- debug_in_file ('\n')
		if Data then
			if string.find(Data, 'tvshka%.net') then
				ip4_table.DefaultLen = 21 * 86400000
			elseif string.find(Data, 'https?://%w+%.%w+%.%w+/iptv/%w+/%d+/index%.m3u8') then
				ip4_table.DefaultLen = 4 * 86400000
			elseif string.find(Data, 'TVSources') then
				ip4_table.DefaultLen = 21 * 86400000
			elseif string.find(Data, '%.itv%.zone') or string.find(Data, '%.itv%.live') then
				ip4_table.DefaultLen = tonumber(Data:match('period=(%d+)') or '7') * 86400000
			elseif string.find(Data, '%.spr24%.net') then
				ip4_table.DefaultLen = tonumber(Data:match('period=(%d+)') or '3') * 86400000
			elseif string.find(Data, 'ottg%.tv') then
				ip4_table.DefaultLen = tonumber(Data:match('period=(%d+)') or '7') * 86400000
			elseif string.find(Data, 'impulstv/.-tshift=true') then
				ip4_table.DefaultLen = tonumber(Data:match('period=(%d+)') or '3') * 86400000
			elseif ((string.find(Data, '%.micro%.im') or string.find(Data, '213%.95%.%d+.%d+:8080')) and m_simpleTV.User.TVTimeShift.impulstvTimeshiftPeriod) then
				ip4_table.DefaultLen = tonumber(m_simpleTV.User.TVTimeShift.impulstvTimeshiftPeriod) * 86400000
			elseif string.find(Data, 'TVmegogo') or string.find(Data, 'vcdn%.biz') then
				ip4_table.DefaultLen = 2 * 86400000
			elseif string.find(Data, 'yandex%.ru') then
				ip4_table.DefaultLen = 7 * 86400000
			elseif string.find(Data, 'spbtv%.com.-tshift=') then
				ip4_table.DefaultLen = tonumber(Data:match('period=(%d+)')) * 86400000
			elseif (string.find(Data, 'spbtv%.com') and m_simpleTV.User.TVTimeShift.spbTimeshiftPeriod) then
				ip4_table.DefaultLen = tonumber(m_simpleTV.User.TVTimeShift.spbTimeshiftPeriod) * 86400000
			elseif string.find(Data, 'voka%.tv.-tshift=') then
				ip4_table.DefaultLen = tonumber(Data:match('period=(%d+)')) * 86400000
			elseif (string.find(Data, 'voka%.tv') and m_simpleTV.User.TVTimeShift.vokaTimeshiftPeriod) then
				ip4_table.DefaultLen = tonumber(m_simpleTV.User.TVTimeShift.vokaTimeshiftPeriod) * 86400000
			elseif (string.find(Data, '%.limehd%.') and m_simpleTV.User.TVTimeShift.limehdTimeshiftAdress) or string.find(Data, 'infolink/%d.-tshift=') then
				ip4_table.DefaultLen = 5 * 86400000
			elseif string.find(Data, 'smotreshka%.tv') or string.find(Data, 'tightvideo%.com') then
				ip4_table.DefaultLen = 7 * 86400000
			elseif string.find(Data, 'peers%.tv') then
				ip4_table.DefaultLen = 1 * 86400000
			elseif string.find(Data, 'ott%.watch') or string.find(Data, 'spacetv%.in') or string.find(Data, 'myott%.tv') then
				ip4_table.DefaultLen = 7 * 86400000
			elseif string.find(Data, 'ipnet%.ua') then
				ip4_table.DefaultLen = 1 * 86400000
			elseif string.find(Data, '//bluepoint/.-tshift=true') or string.find(Data, '98%.158%.107%.17:8181') then
				ip4_table.DefaultLen = 10 * 86400000
			elseif string.find(Data, 'ott%.zala%.by') or string.find(Data, '178%.124%.183%.') or string.find(Data, '93%.85%.93%.') then
				ip4_table.DefaultLen = 2 * 86400000
			else
				ip4_table.DefaultLen = 259200000
			end
		end
		if Type == 'GetLengthByAddress' then
			if not ip4_TimeshiftTestAddress(Data) then
			 return 0
			end
		 return ip4_table.DefaultLen
		end
		if Type == 'TestAddress' then
			ip4_TimeshiftStopTimer()
			if ip4_table.AdrToSet then
				if not ip4_TimeshiftCompareAdr(Data, ip4_table.AdrToSet) then
					ip4_table.AdrToSet = nil
				end
			end
		 return ip4_TimeshiftTestAddress(Data)
		end
		if Type == 'Start' then
			ip4_TimeshiftStopTimer()
			ip4_table.TimeShiftPos = 1.0
			ip4_table.TimeShiftLen = ip4_table.DefaultLen
			ip4_table.CurAdr = Data
			ip4_table.pauseStart = nil
			ip4_table.CurOffset = 0
-- debug_in_file('data:' .. Data .. '\ntoset:' .. (ip4_table.AdrToSet or '') .. '\n\n')
-- debug_in_file('ChannelID=' .. m_simpleTV.Control.ChannelID .. 'EpgId=' .. m_simpleTV.Timeshift.EpgId .. '\n')
			if Data1 == 0 and ip4_TimeshiftCompareAdr(ip4_table.CurAdr, ip4_table.AdrToSet) then
				ip4_table.CurAdr = ip4_table.AdrToSet
			end
			ip4_table.AdrToSet = nil
			ip4_table.PrevTitle = nil
			local offset
			local setadr = false
			if Data1 ~= 0 then
				offset = - math.floor(Data1 / 1000)
				setadr = true
			else
				offset = GetOffset(ip4_table.CurAdr)
			end
			if offset then
-- debug_in_file('offset = ' .. offset .. '\n')
				offset = tonumber(offset)
				if offset < 0 then
					ip4_table.TimeShiftPos = 1 - ((- offset * 1000) / ip4_table.TimeShiftLen)
					if ip4_table.TimeShiftPos < 0 or ip4_table.TimeShiftPos > 1 then
						ip4_table.TimeShiftPos = 1.0
					end
					if setadr then
						ip4_table.CurAdr = GetAdrToSet(ip4_table.CurAdr, offset)
					end
					ip4_table.CurOffset = offset
					local offsetc = math.floor(ip4_table.TimeShiftLen * (1 - ip4_table.TimeShiftPos) / 1000)
					local timeshift_date = os.date('%x %X', (os.time() - offsetc))
-- debug_in_file(timeshift_date .. '\n')
					local month, day, year, hour, min, sec = timeshift_date:match('(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)')
					if day and month and hour and min and sec then
						day = string.format('%d', day)
						month = month:gsub('01', 'января')
						month = month:gsub('02', 'февраля')
						month = month:gsub('03', 'марта')
						month = month:gsub('04', 'апреля')
						month = month:gsub('05', 'мая')
						month = month:gsub('06', 'июня')
						month = month:gsub('07', 'июля')
						month = month:gsub('08', 'августа')
						month = month:gsub('09', 'сентября')
						month = month:gsub('10', 'октября')
						month = month:gsub('11', 'ноября')
						month = month:gsub('12', 'декабря')
						local str = ' (Архив ' .. day .. ' ' .. month .. ' в ' .. hour .. ':' .. min .. ')'
						local title = m_simpleTV.Control.GetTitle()
						title = title .. str
						if not ip4_table.PrevTitle or ip4_table.PrevTitle ~= title then
							ip4_table.PrevTitle = title
							m_simpleTV.Control.SetTitle(title)
							m_simpleTV.OSD.ShowMessageT({text = title, color = ARGB(255, 155, 155, 255), showTime = 1000 * 5, id = 'channelName'})
						end
					end
				end
			end
-- debug_in_file ('retAdr = ' .. ip4_table.CurAdr .. '\n')
		 return ip4_table.CurAdr
		end
		if Type == 'IsSeekable' then
		 return true
		end
		if Type == 'GetPosition' then
			if ip4_table.pauseStart and ip4_table.CurOffset then
				ip4_table.TimeShiftPos = 1 - (((-ip4_table.CurOffset + (os.time() - ip4_table.pauseStart)) * 1000) / ip4_table.TimeShiftLen)
				if ip4_table.TimeShiftPos < 0 then
					ip4_table.TimeShiftPos = 0
				end
			end
		 return ip4_table.TimeShiftPos
		end
		if Type == 'GetLength' then
		 return ip4_table.TimeShiftLen
		end
		if Type == 'SetPostion' then
			ip4_TimeshiftStopTimer()
				if not ip4_table.CurAdr then
				 return false
				end
			ip4_table.TimeShiftPos = Data
			ip4_table.TimerId = m_simpleTV.Timer.SetTimer(1500, 'ip4_TimeshiftSetDelayed()')
		 return true
		end
		if Type == 'OnStop' then
			ip4_TimeshiftStopTimer()
		 return
		end
		if Type == 'OnPaused' then
			ip4_table.pauseStart = os.time()
-- debug_in_file('OnPause time= ' .. ip4_table.pauseStart .. '\n')
		 return
		end
		if Type == 'OnPlaying' then
			if ip4_table.pauseStart then
-- debug_in_file('OnPlaying time=' .. ip4_table.pauseStart .. '\n')
				local len = os.time() - ip4_table.pauseStart
-- debug_in_file('len=' .. len .. '\n')
				ip4_table.pauseStart = nil
				ip4_table.CurOffset = ip4_table.CurOffset - len
				if len > 40 and ip4_table.CurAdr and ip4_table.CurOffset then
					ip4_TimeshiftStopTimer()
					ip4_table.CurOffset = ip4_table.CurOffset - 10
					local adr = ip4_TimeshiftHandler('Start', ip4_table.CurAdr, (-ip4_table.CurOffset) * 1000)
					m_simpleTV.Control.SetNewAddress(adr)
				end
			end
		 return
		end
		if Type == 'IsRecordAble' then
			if ip4_TimeshiftTestAddress(Data) and Data1 <= ip4_table.DefaultLen then
			 return true
			end
		 return false
		end
		if Type == 'GetRecordAddress' then
				if not ip4_TimeshiftTestAddress(Data) and Data1 > ip4_table.DefaultLen then return end
			local extopt = Data:match('%$OPT:(.+)') or ''
			Data = Data:gsub('%$OPT:(.+)', '')
			local adr
			if Data2 and Data2 > 0 then
					local function StrToTimestamp(str, shift)
						local ryear, rmonth, rday, rhour, rmin, rsec = str:match('(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)')
					 return os.time({year = ryear, month = rmonth, day = rday, hour = rhour, min = rmin, sec = rsec}) - (shift or 0)
					end
				local addToStart = tonumber(m_simpleTV.Config.GetValue('scheduler/archiveMargin', 'simpleTVConfig') or 0) or 0
				local addToEnd = tonumber(m_simpleTV.Config.GetValue('scheduler/timerMargin', 'simpleTVConfig') or 0) or 0
				local t = m_simpleTV.Database.GetTable('SELECT * FROM ChProg WHERE (ChProg.Id=' .. Data2 .. ');')
				local chShift
				if (Data:match('rt%.ru/hls/CH_') or Data:match('ngenix%.net/hls/CH_'))
					and t
					and t[1]
					and t[1].StartPr
					and t[1].EndPr
					and loadITV2 == 0
				then
					-- chShift = math.floor((StrToTimestamp(t[1].StartPr) - (os.time() - math.floor(Data1/1000)))/3600)*3600
					adr = ip4_TimeshiftGetNakedAdr(Data) .. '?utcstart='
							.. (StrToTimestamp(t[1].StartPr, chShift) - (addToStart * 60))
							.. '&utcend=' .. (StrToTimestamp(t[1].EndPr, chShift) + (addToEnd * 60))
				end
				if (Data:match('ruip%.tv') or Data:match('%.itv%.zone') or Data:match('%.itv%.live') or Data:match('ottg%.tv') or Data:match('%.spr24%.net'))
					and t
					and t[1]
					and t[1].StartPr
					and t[1].EndPr
				then
					-- chShift = math.floor((StrToTimestamp(t[1].StartPr) - (os.time() - math.floor(Data1/1000)))/3600)*3600
					local token = Data:match('%?.+') or ''
					Data = Data:gsub('/index.+', '')
					Data = Data:gsub('/mono.+', '')
					Data = Data:gsub('/video.+', '')
					Data = Data:gsub('/mpegt.+', '')
					Data = Data:gsub('/timeshift_re.+', '')
					adr = Data .. '/video-'
							.. (StrToTimestamp(t[1].StartPr, chShift) - (addToStart * 60)) .. '-'
							.. (StrToTimestamp(t[1].EndPr, chShift) - StrToTimestamp(t[1].StartPr, chShift) + (addToEnd * 60) + (addToStart * 60))
							.. '.m3u8'
					adr = adr .. token
				end
				if Data:match('strm%.yandex%.ru/ka')
					and t
					and t[1]
					and t[1].StartPr
					and t[1].EndPr
				then
					-- chShift = math.floor((StrToTimestamp(t[1].StartPr) - (os.time() - math.floor(Data1/1000)))/3600)*3600
					local endY = (StrToTimestamp(t[1].EndPr, chShift)) + (addToEnd * 60)
					if endY > (os.time() - 120) then
						endY = os.time() - 120
					end
					adr = ip4_TimeshiftGetNakedAdr(Data) .. '?start='
							.. (StrToTimestamp(t[1].StartPr, chShift) - (addToStart * 60))
							.. '&end=' .. endY
				end
			end
			if not adr then
				adr = GetAdrToSet(Data, math.floor(- Data1 / 1000))
			end
			if adr:match('rt%.ru/hls/CH_') or adr:match('ngenix%.net/hls/CH_') then
				adr = adr .. '&recITV2'
				if qlty == 0 then
					adr = adr:gsub('bw%d+/', '')
				end
			end
			if adr:match('strm%.yandex%.ru/ka') then
				adr = adr:gsub('/ka1/', '/kal/')
			end
			adr = adr .. extopt
-- debug_in_file ('adr rec: ' .. adr .. '\n')
		 return adr
		end
	end
-- Helpers
	function ip4_TimeshiftTestAddress(Adr)
-- debug_in_file('ip4_TimeshiftTestAddress = ' .. Adr .. '\n\n')
		if Adr:match('rt%.ru/hls/CH_')
			or Adr:match('ngenix%.net/hls/CH_')
			or Adr:match('strm%.yandex%.ru/ka') -- yandex
			or Adr:match('hls%.peers%.tv.-tshift=true') -- peers
			or Adr:match('hls%.peers%.tv.-offset=') -- peers
			or (Adr:match('hls%.peers%.tv') and m_simpleTV.User.TVTimeShift.PeersTVTimeshiftAdress) -- peers
			or Adr:match('TVSources')
			or Adr:match('infolink/%d.-tshift=true') -- limehd
			or (Adr:match('limehd%.') and m_simpleTV.User.TVTimeShift.limehdTimeshiftAdress) -- limehd
			or (Adr:match('ruip%.tv') and not Adr:match('ruip%.tv/%d+/video%-')) -- glanz
			or (Adr:match('ottg%.tv') and not Adr:match('ottg%.tv.-tshift=false')) -- glanz
			or Adr:match('https?://%w+%.%w+%.%w+/iptv/%w+/%d+/index%.m3u8') -- edem
			or Adr:match('ott%.watch')
			or Adr:match('tvshka%.net')
			or Adr:match('smotreshka%.tv') -- smotreshka
			or Adr:match('tightvideo%.com') -- smotreshka
			or Adr:match('lfstrm%.tv') -- smotreshka
			or Adr:match('spacetv%.in') -- ottclub.cc
			or Adr:match('myott%.tv') -- ottclub.cc
			or Adr:match('ipnet%.ua')
			or Adr:match('impulstv/.-tshift=true') -- impulstv
			or ((Adr:match('%.micro%.im') or Adr:match('213%.95%.%d+.%d+:8080')) and m_simpleTV.User.TVTimeShift.impulstvTimeshiftAdress) -- impulstv
			or Adr:match('//bluepoint/.-tshift=true') -- bluepoint
			or (Adr:match('98%.158%.107%.17:%d+') and m_simpleTV.User.TVTimeShift.bluepointTimeshiftAdress) -- bluepoint
			or (Adr:match('spbtv%.com') and m_simpleTV.User.TVTimeShift.spbTimeshiftAdress) -- spb
			or Adr:match('spbtv%.com.-tshift=true') -- spb
			or (Adr:match('voka%.tv') and m_simpleTV.User.TVTimeShift.vokaTimeshiftAdress) -- voka
			or Adr:match('voka%.tv.-tshift=true') -- voka
			or (Adr:match('%.itv%.zone') and not Adr:match('%.itv%.zone.-tshift=false')) -- itv.live
			or (Adr:match('%.itv%.live') and not Adr:match('%.itv%.live.-tshift=false')) -- itv.live
			or (Adr:match('%.spr24%.net') and not Adr:match('%.spr24%.net.-tshift=false')) -- sharavoz
			or Adr:match('vcdn%.biz.-/type%.live') and m_simpleTV.User.TVTimeShift.TVmegogoTimeshiftAdress -- megogo
			or Adr:match('TVmegogo/.-tshift=true')-- megogo
			or Adr:match('ott%.zala%.by') or Adr:match('178%.124%.183%.') or Adr:match('93%.85%.93%.')
		then
		 return true
		end
	 return false
	end
	function ip4_TimeshiftStopTimer()
		if ip4_table.TimerId then
			m_simpleTV.Timer.DeleteTimer(ip4_table.TimerId)
			ip4_table.TimerId = nil
		end
	end
	function ip4_TimeshiftGetNakedAdr(Adr)
		if not Adr then
		 return nil
		end
	 return Adr:gsub('%?.-$', '')
	end
	function ip4_TimeshiftCompareAdr(Adr1, Adr2)
		if not Adr1 or not Adr2 then
		 return false
		end
	 return (Adr1:gsub('%?.-$', '') == Adr2:gsub('%?.-$', ''))
	end
-- Post init
	m_simpleTV.Timeshift.AddHandler('ip4_TimeshiftHandler', 5000)
-- Add ext Menu
	local t = {}
	t.utf8 = true -- string coding
--t.codepage (0) - code page of non utf8 text
	t.name = 'Архивы' -- Name of item in the "Extra" menu if name=='-' then add separator
	t.luastring = 'user\\tvtimeshift\\tvtDialoginit.lua' -- lua file name or script
--t.lua_as_scr (false) - if true then t.luastring is script, overwise t.luastring is file name of lua script
--t.submenu ('') - string, name of submenu
	t.key = 0x01000002
	t.ctrlkey = 2 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
	t.location = 0 --(0) - 0 - in main menu, 1 - in playlist menu, -1 all
	t.image = m_simpleTV.Common.GetMainPath(2) .. '\\skin\\base\\img\\programme\\timer.png' -- string, image file name
	m_simpleTV.Interface.AddExtMenuT(t)