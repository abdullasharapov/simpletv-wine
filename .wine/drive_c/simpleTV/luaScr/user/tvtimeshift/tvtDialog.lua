--скрипт дополнения Архивы (timeshift) (3/10/19)
  local function is_leap_year(year)
    return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
  end
  function get_days_in_month(month, year)
    return month == 2 and is_leap_year(year) and 29
           or ("\31\28\31\30\31\30\31\31\30\31\30\31"):byte(month)
  end
local function GetAdrToSet(Adr, offset)
-- ITV 2.0
 if string.match(Adr, 'rt%.ru/hls/CH_') or string.match(Adr, 'ngenix%.net/hls/CH_') then
			if offset then
				m_simpleTV.User.TVTimeShift.isITV2_Offset = true
				m_simpleTV.User.TVTimeShift.ITV2_Offset = offset
			end
	   local param = findpattern(Adr,'utcstart=[0-9]+',1,9,0)
       if offset and param then
          Adr = string.gsub(Adr,'?(.+)','') .. '?offset=' .. offset .. '&utcstart=' .. param
        elseif offset and not param then
          Adr = string.gsub(Adr,'?(.+)','') .. '?offset=' .. offset
         else
          Adr = string.gsub(Adr,'?(.+)','')
       end
--yandex
    elseif string.match(Adr, 'strm%.yandex%.ru/ka') then
       Adr = Adr:gsub('&start=.+' , ''):gsub('%?start=.+' , '')
       if offset then
				m_simpleTV.User.TVTimeShift.istYndx_Offset = true
				m_simpleTV.User.TVTimeShift.tYndx_Offset = offset
				local endY = os.time() - 120
				local startY = os.time() + offset
				if (endY - startY) > (6 * 3600) then
					endY = startY + (6 * 3600)
				end
				Adr = Adr:gsub('%?.+', ''):gsub('&.+', '') .. '?start=' .. startY .. '&end=' .. endY
       end
--zala
    elseif Adr:match('ott%.zala%.by') or Adr:match('178%.124%.183%.') or Adr:match('93%.85%.93%.') then
       if offset then
				m_simpleTV.User.TVTimeShift.isZala_Offset = true
				m_simpleTV.User.TVTimeShift.Zala_Offset = offset
				Adr = string.gsub(Adr,'?(.+)','') .. '?offset=' .. offset
		end
--peerstv
    elseif string.match(Adr, 'hls%.peers%.tv') then
       local param = findpattern(Adr,'token=(.+)',1,6,0) or ''
       if offset then
          Adr = m_simpleTV.User.TVTimeShift.PeersTVTimeshiftAdress .. '?offset=' .. -offset .. '&token=' .. param
       end
		if m_simpleTV.Common.GetVlcVersion() > 3000 then
			Adr = Adr .. '$OPT:no-ts-cc-check'
    	end
 end
   return Adr
end
function OnNavigateComplete(Object)
  local inAdr = m_simpleTV.Control.RealAdress
  if inAdr==nil then return end
  if m_simpleTV.User.TVTimeShift.Title == nil then
     m_simpleTV.User.TVTimeShift.Title = ''
 end
  if not string.match(m_simpleTV.Control.CurrentTitle_UTF8, 'https?://') then
     m_simpleTV.User.TVTimeShift.Title = m_simpleTV.Control.CurrentTitle_UTF8
    else
     m_simpleTV.User.TVTimeShift.Title = ''
  end
--debug_in_file(m_simpleTV.User.TVTimeShift.Title .. '\n')
  local interval = 7
  if inAdr:match('rt%.ru/hls/CH_')
     or inAdr:match('ngenix%.net/hls/CH_')
     or inAdr:match('strm%.yandex%.ru/ka')
     or inAdr:match('hls%.peers%.tv.-tshift=true')
     or inAdr:match('hls%.peers%.tv.-offset=') then
		interval = 3
	elseif inAdr:match('ott%.zala%.by') or inAdr:match('178%.124%.183%.') or inAdr:match('93%.85%.93%.') then
		interval = 2
  end
  m_simpleTV.Dialog.AddEventHandler(Object,'OnClose','*','OnClose')
  local currentDate = os.date('%m/%d/%Y %X')
  if currentDate == nil then return end
  --debug_in_file(currentDate..'\n')
  local pattern = '(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)'
  local month,day,year,hour,min,sec = string.match(currentDate, pattern)
  if day == nil or month == nil or hour == nil or min == nil or sec == nil then return end
  m_simpleTV.User.TVTimeShift.Month = month
  m_simpleTV.User.TVTimeShift.Year = year
  m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'Days',day)
  m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'Hours',hour)
  m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'Minutes',min)
  m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'Interval',interval)
  m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PlayBtn','OnClickPlayBtn')
  local timestamp = os.time() - interval*24*3600
  local endpoint = os.date("%d %b %H:%M", timestamp)
  m_simpleTV.Dialog.SetElementHtml_UTF8(Object,'Mess2','начинаются с<br>' .. endpoint )
end
function OnClickPlayBtn(Object)
  m_simpleTV.Dialog.SetElementHtml_UTF8(Object,'Mess','')
  local timshift_interval = m_simpleTV.Dialog.GetElementValueString(Object,'Interval')
  local t_month = m_simpleTV.User.TVTimeShift.Month
  local t_year = m_simpleTV.User.TVTimeShift.Year
  local t_day = m_simpleTV.Dialog.GetElementValueString(Object,'Days')
  local t_hour = m_simpleTV.Dialog.GetElementValueString(Object,'Hours')
  local t_min = m_simpleTV.Dialog.GetElementValueString(Object,'Minutes')
   if timshift_interval == nil or timshift_interval == '' then
    return
  end
  if t_day == nil or t_day == '' then
     m_simpleTV.Dialog.SetElementHtml_UTF8(Object,'Mess','день не установлен')
    return
  end
  if t_hour == nil or t_hour == '' then t_hour=0 end
  if t_min == nil or t_min == '' then t_min=0 end
  local timestamp1 = os.time()
  --debug_in_file(timestamp1..'\n')
  local timestamp2 = os.time({day=t_day,month=t_month,year=t_year,hour=t_hour,min=t_min,sec=0})
  --debug_in_file(timestamp2..'\n')
  local currentDate = os.date('%m/%d/%Y %X')
  if currentDate == nil then return end
  --debug_in_file(currentDate..'\n')
  local pattern = '(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)'
  local month,day,year,hour,min,sec = string.match(currentDate, pattern)
  if day == nil or month == nil or hour == nil or min == nil or sec == nil then return end
  local shiftedDate = tonumber(day)-timshift_interval
  if shiftedDate < 0 then
       shiftedDate = get_days_in_month(month-1, year) + shiftedDate
       if (tonumber(t_day) > tonumber(day) and tonumber(t_day) < shiftedDate) or tonumber(t_day)==0 or tonumber(t_day) >= get_days_in_month(month-1, year)+1 or tonumber(t_hour) > 24 or tonumber(t_min) > 60 then
           m_simpleTV.Dialog.SetElementHtml_UTF8(Object,'Mess','Неправильная дата или время')
           return
       end
     else
      if tonumber(t_day) < shiftedDate or tonumber(t_day) > tonumber(day) or tonumber(t_day)==0 or tonumber(t_day) > get_days_in_month(month, year) or tonumber(t_hour) > 24 or tonumber(t_min) > 60 then
         m_simpleTV.Dialog.SetElementHtml_UTF8(Object,'Mess','Неправильная дата или время')
        return
      end
  end
  local inAdr = m_simpleTV.Control.RealAdress
  if inAdr==nil then return end
  --inAdr = findpattern(inAdr,'(.-)%.m3u8',1,0,0)
  --if inAdr==nil then return end
  local offset = timestamp2 - timestamp1 + 10
  --debug_in_file(offset .. '\n')
  if offset>0 then offset=0 end
  inAdr = GetAdrToSet(inAdr, offset)
  if inAdr==nil then return end
  --debug_in_file(inAdr ..'\n')
  local t = m_simpleTV.PlayList.GetCurrentChannelInfo()
  if t.RealAddress =='' then
     m_simpleTV.Control.PlayAddress(inAdr)
    else
    m_simpleTV.Control.SetNewAddress(inAdr)
  end
  m_simpleTV.Dialog.Close(Object)
end
function JSCallBack1(Object,param_utf8)
   if param_utf8 == nil or param_utf8 == '' then
    return
  end
 local timestamp = os.time() - param_utf8*24*3600
 local endpoint = os.date("%d %b %H:%M", timestamp)
 m_simpleTV.Dialog.SetElementHtml_UTF8(Object,'Mess2','начинаются с<br>' .. endpoint )
end
function JSCallBack0(Object)
  m_simpleTV.Dialog.Close(Object)
end
function OnOk(Object)
end
function OnCancel(Object)
end
function OnClose(Object)
end