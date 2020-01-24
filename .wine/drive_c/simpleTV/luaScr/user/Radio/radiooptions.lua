
local function setConfigVal(key,val)
  m_simpleTV.Config.SetValue(key,val,"radioConf.ini")
end
  
 --VSG
 local t ={}
 t[1] = {}
 t[1].Id   =  1
 t[1].Name    =  "Show radio logotypes in main window"
 t[1].Checked =  m_simpleTV.User.Radio.RadioLogo
 
 t[2] = {}
 t[2].Id   =  2
 t[2].Name    =  "Always show OSD title in main window"
 t[2].Checked =  m_simpleTV.User.Radio.RadioOSDTitle
 
 t.ExtButton0 = {}
 t.ExtButton0.ButtonEnable = true
 t.ExtButton0.ButtonName = 'Playlists'

 local ret,id = m_simpleTV.OSD.ShowSelect('Radio options',-1,t,0,1+4+8)

 if ret==2 then
    dofile(m_simpleTV.MainScriptDir .. "user/Radio/RefreshPls.lua")
    return
 end

 if id==nil then 
   return 
 end

 if id==1 then 
 
    if m_simpleTV.User.Radio.RadioLogo then
       m_simpleTV.User.Radio.RadioLogo = false
       setConfigVal("RadioLogo",0)
         m_simpleTV.User.Radio.Background = nil
     elseif not m_simpleTV.User.Radio.RadioLogo then
       m_simpleTV.User.Radio.RadioLogo = true
       setConfigVal("RadioLogo",1)
         m_simpleTV.User.Radio.Background = nil
    end
 
    if m_simpleTV.User.Radio.RadioOSDTitle then
       setConfigVal("RadioOSDTitle",1)
     elseif not m_simpleTV.User.Radio.RadioOSDTitle then
       setConfigVal("RadioOSDTitle",0)
    end
 
 elseif id==2 then
 
    if m_simpleTV.User.Radio.RadioOSDTitle then
       m_simpleTV.User.Radio.RadioOSDTitle = false
       setConfigVal("RadioOSDTitle",0)
     elseif not m_simpleTV.User.Radio.RadioOSDTitle then
       m_simpleTV.User.Radio.RadioOSDTitle = true
       setConfigVal("RadioOSDTitle",1)
    end
 
    if m_simpleTV.User.Radio.RadioLogo then
       setConfigVal("RadioLogo",1)
     elseif not m_simpleTV.User.Radio.RadioLogo then
       setConfigVal("RadioLogo",0)
    end
 end 



