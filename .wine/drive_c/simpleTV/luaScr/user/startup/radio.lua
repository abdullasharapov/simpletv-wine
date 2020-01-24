
if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.Radio==nil then m_simpleTV.User.Radio={} end
if m_simpleTV.User.AudioTitle==nil then m_simpleTV.User.AudioTitle={} end

function radioOsdEvent()
 if not m_simpleTV.User.Radio.isActive or m_simpleTV.User.Radio.isActive==nil then 
    return
 end
 local t = m_simpleTV.Control.GetCurrentChannelInfo()
 if t~=nil and t.Address~=nil then
	m_simpleTV.Control.CurrentAdress = t.Address
	m_simpleTV.Control.Reason = 'Playing'
	
	if m_simpleTV.User.Radio~=nil and m_simpleTV.User.Radio.Background~=nil then
		m_simpleTV.User.Radio.Background = nil
	end
	dofile (m_simpleTV.MainScriptDir .. "user/Radio/events.lua")
 end	
end

AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/Radio/getaddress.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/Radio/tunein.lua")
AddFileToExecute('onconfig',m_simpleTV.MainScriptDir .. "user/Radio/initconfig.lua")
AddFileToExecute('events',m_simpleTV.MainScriptDir .. "user/Radio/events.lua")
m_simpleTV.OSD.AddEventListener({type=1,callback="radioOsdEvent"})


  local t={}
  t.utf8 = true
  t.name = 'OSD update playlists'
  t.luastring = 'user/Radio/RefreshPls.lua'
  t.submenu = 'Radio'
  t.key = string.byte('R')
  t.ctrlkey = 2
  t.location = 0
  m_simpleTV.Interface.AddExtMenuT(t)

  local t={}
  t.utf8 = true
  t.name = 'OSD options'
  t.luastring = 'user/Radio/radiooptions.lua'
  t.submenu = 'Radio'
  --t.key = string.byte('R')
  --t.ctrlkey = 2
  t.location = 0
  m_simpleTV.Interface.AddExtMenuT(t)

  local function getConfigVal(key)
   return m_simpleTV.Config.GetValue(key,"radioConf.ini")
  end

 local value
 value = getConfigVal("TypeMedia")
 if value~=nil then
    if tonumber(value) == 0 then
       m_simpleTV.User.Radio.TypeMedia = 0
     elseif tonumber(value) == 1 then
       m_simpleTV.User.Radio.TypeMedia = 1
     elseif tonumber(value) == 3 then
       m_simpleTV.User.Radio.TypeMedia = 3
    end
 end 
 
 if value==nil then
    m_simpleTV.User.Radio.TypeMedia = 0
 end

 value = getConfigVal("RadioLogo")
 if value~=nil then
    if tonumber(value) == 1 then  
         m_simpleTV.User.Radio.RadioLogo = true
      elseif tonumber(value) == 0 then
         m_simpleTV.User.Radio.RadioLogo = false
   end
 end

 if value==nil then
    m_simpleTV.User.Radio.RadioLogo = true
 end

 value = getConfigVal("RadioOSDTitle")
 if value~=nil then
    if tonumber(value) == 1 then 
         m_simpleTV.User.Radio.RadioOSDTitle = true
      elseif tonumber(value) == 0 then
         m_simpleTV.User.Radio.RadioOSDTitle = false
   end
 end

 if value==nil then
    m_simpleTV.User.Radio.RadioOSDTitle = true
 end

 value = getConfigVal("RadioAddTuneIn")
 if value~=nil then
    if tonumber(value) == 1 then 
         m_simpleTV.User.Radio.RadioAddTuneIn = true
      elseif tonumber(value) == 0 then
         m_simpleTV.User.Radio.RadioAddTuneIn = false
   end
 end

 if value==nil then
    m_simpleTV.User.Radio.RadioAddTuneIn = true
 end

 value = getConfigVal("RadioTuneInGrpName")
 if value~=nil then
    m_simpleTV.User.Radio.RadioTuneInGrpName = value
   else
     m_simpleTV.User.Radio.RadioTuneInGrpName = 'TuneIn added'
 end


 value=getConfigVal('radioMusicLayout') 
  if value~=nil then
     value=tonumber(value)
         if value==0 then
            m_simpleTV.User.Radio.Layout=0
     elseif value==1 then
            m_simpleTV.User.Radio.Layout=1
     elseif value==2 then
            m_simpleTV.User.Radio.Layout=2
     elseif value==3 then
            m_simpleTV.User.Radio.Layout=3
     elseif value==4 then
            m_simpleTV.User.Radio.Layout=4
     elseif value==5 then
            m_simpleTV.User.Radio.Layout=5
     elseif value==6 then
            m_simpleTV.User.Radio.Layout=6
         end         
  end

 if value==nil then m_simpleTV.User.Radio.Layout=0 end
 
 
 value = getConfigVal("RadioBgPic")
 if value~=nil then
    m_simpleTV.User.Radio.RadioBgPic = value
   else
     m_simpleTV.User.Radio.RadioBgPic = 'user/Radio/pic/bg.jpg'
 end
 
 value = getConfigVal("RadioCoverPic")
 if value~=nil then
    m_simpleTV.User.Radio.RadioCoverPic = value
   else
     m_simpleTV.User.Radio.RadioCoverPic = 'user/Radio/pic/1music.jpg' 
 end
 
 
 --default settings
 --layout 2
value = getConfigVal("RadioTrackFontLayout2") or 'constantia,40,-1,5,70,0,0,0,0,0'
m_simpleTV.User.Radio.RadioTrackFontLayout2=value

value = getConfigVal("RadioStationFontLayout2") or 'constantia,30,-1,5,70,0,0,0,0,0'
m_simpleTV.User.Radio.RadioStationFontLayout2 = value

value = getConfigVal("RadioTrackNumBreakLayout2") or 50
m_simpleTV.User.Radio.RadioTrackNumBreakLayout2=value

value = getConfigVal("RadioTextColorLayout2") or 'ffff8c1a'
m_simpleTV.User.Radio.RadioTextColorLayout2=value
value = getConfigVal("RadioBorderColorLayout2") or 'ffff8c1a'
m_simpleTV.User.Radio.RadioBorderColorLayout2=value  

value = getConfigVal("RadioBlurBgLayout2") or 2
m_simpleTV.User.Radio.RadioBlurBgLayout2=value
value = getConfigVal("RadioScrollTextLayout2") or 0
m_simpleTV.User.Radio.RadioScrollTextLayout2=value

 --layout 3
value = getConfigVal("RadioTrackFontLayout3") or 'arial black,40,-1,5,0,0,0,0,0,0'
m_simpleTV.User.Radio.RadioTrackFontLayout3=value

value = getConfigVal("RadioStationFontLayout3") or 'arial black,30,-1,5,0,0,0,0,0,0'
m_simpleTV.User.Radio.RadioStationFontLayout3 = value

value = getConfigVal("RadioTrackNumBreakLayout3") or 50
m_simpleTV.User.Radio.RadioTrackNumBreakLayout3=value

value = getConfigVal("RadioTextColorLayout3") or 'ffe8e8e8'
m_simpleTV.User.Radio.RadioTextColorLayout3=value
value = getConfigVal("RadioBorderColorLayout3") or 'ffe8e8e8'
m_simpleTV.User.Radio.RadioBorderColorLayout3=value 
 
value = getConfigVal("RadioBlurBgLayout3") or 2
m_simpleTV.User.Radio.RadioBlurBgLayout3=value
value = getConfigVal("RadioScrollTextLayout3") or 1
m_simpleTV.User.Radio.RadioScrollTextLayout3=value
 
  --layout 4
value = getConfigVal("RadioTrackFontLayout4") or 'constantia,40,-1,5,70,0,0,0,0,0'
m_simpleTV.User.Radio.RadioTrackFontLayout4=value

value = getConfigVal("RadioStationFontLayout4") or 'constantia,30,-1,5,70,0,0,0,0,0'
m_simpleTV.User.Radio.RadioStationFontLayout4 = value

value = getConfigVal("RadioTrackNumBreakLayout4") or 50
m_simpleTV.User.Radio.RadioTrackNumBreakLayout4=value

value = getConfigVal("RadioTextColorLayout4") or 'ffff8c1a'
m_simpleTV.User.Radio.RadioTextColorLayout4=value
value = getConfigVal("RadioBorderColorLayout4") or 'ffff8c1a'
m_simpleTV.User.Radio.RadioBorderColorLayout4=value  

value = getConfigVal("RadioBlurBgLayout4") or 0
m_simpleTV.User.Radio.RadioBlurBgLayout4=value
value = getConfigVal("RadioScrollTextLayout4") or 0
m_simpleTV.User.Radio.RadioScrollTextLayout4=value
 
  --layout 5
value = getConfigVal("RadioTrackFontLayout5") or 'arial black,40,-1,5,0,0,0,0,0,0'
m_simpleTV.User.Radio.RadioTrackFontLayout5=value

value = getConfigVal("RadioStationFontLayout5") or 'arial black,30,-1,5,0,0,0,0,0,0'
m_simpleTV.User.Radio.RadioStationFontLayout5 = value

value = getConfigVal("RadioTrackNumBreakLayout5") or 50
m_simpleTV.User.Radio.RadioTrackNumBreakLayout5=value

value = getConfigVal("RadioTextColorLayout5") or 'ffe8e8e8'
m_simpleTV.User.Radio.RadioTextColorLayout5=value
value = getConfigVal("RadioBorderColorLayout5") or 'ffe8e8e8'
m_simpleTV.User.Radio.RadioBorderColorLayout5=value  

value = getConfigVal("RadioBlurBgLayout5") or 0
m_simpleTV.User.Radio.RadioBlurBgLayout5=value
value = getConfigVal("RadioScrollTextLayout5") or 1
m_simpleTV.User.Radio.RadioScrollTextLayout5=value
 
  --layout 6
value = getConfigVal("RadioTrackFontLayout6") or 'constantia,40,-1,5,70,0,0,0,0,0'
m_simpleTV.User.Radio.RadioTrackFontLayout6=value

value = getConfigVal("RadioStationFontLayout6") or 'constantia,30,-1,5,70,0,0,0,0,0'
m_simpleTV.User.Radio.RadioStationFontLayout6 = value

value = getConfigVal("RadioTrackNumBreakLayout6") or 50
m_simpleTV.User.Radio.RadioTrackNumBreakLayout6=value

value = getConfigVal("RadioTextColorLayout6") or 'ffe8e8e8'
m_simpleTV.User.Radio.RadioTextColorLayout6=value
value = getConfigVal("RadioBorderColorLayout6") or 'ffe8e8e8'
m_simpleTV.User.Radio.RadioBorderColorLayout6=value  

value = getConfigVal("RadioBlurBgLayout6") or 10
m_simpleTV.User.Radio.RadioBlurBgLayout6=value
value = getConfigVal("RadioScrollTextLayout6") or 0
m_simpleTV.User.Radio.RadioScrollTextLayout6=value
 
 
 
 
 
 
 
