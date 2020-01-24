
local function getConfigVal(key)
 return m_simpleTV.Config.GetValue(key,"radioConf.ini")
end

local function setConfigVal(key,val)
  m_simpleTV.Config.SetValue(key,val,"radioConf.ini")
end

function OnNavigateComplete(Object)

  local value  
  value = getConfigVal("TypeMedia") or 0
  m_simpleTV.Dialog.SelectComboIndex(Object,'TypeMedia',value) 

  value = getConfigVal("RadioLogo") or 1
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioLogo',value)

  value = getConfigVal("RadioOSDTitle") or 1
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioOSDTitle',value)

  value = getConfigVal("RadioAddTuneIn") or 1
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioAddTuneIn',value)

  value = getConfigVal("RadioTuneInGrpName") or 'TuneIn added' 
  m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTuneInGrpName',value)

  if m_simpleTV.User.IsAudioTitle then
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'IsAT',1)
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'IsAT2',1)
     m_simpleTV.Dialog.SetElementText_UTF8(Object,'isAtmess','Audio Title is found. Show radio logotypes and Always show OSD title in main window options disabled.\nUse the Audio Title settings.')
    else
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'IsAT',0)
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'IsAT2',0)
  end
  
  value = getConfigVal("RadioBgPic") or 'user/Radio/pic/bg.jpg'
  m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBgPic',value) 

  value = getConfigVal("RadioCoverPic") or 'user/Radio/pic/1music.jpg' 
  m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioCoverPic',value) 

  m_simpleTV.Dialog.AddComboValue_UTF8(Object,'radioMusicLayout','No layout',-1,0)
  m_simpleTV.Dialog.AddComboValue_UTF8(Object,'radioMusicLayout','Layout 1',-1,1)
  m_simpleTV.Dialog.AddComboValue_UTF8(Object,'radioMusicLayout','Layout 2',-1,2)
  m_simpleTV.Dialog.AddComboValue_UTF8(Object,'radioMusicLayout','Layout 3',-1,3)
  m_simpleTV.Dialog.AddComboValue_UTF8(Object,'radioMusicLayout','Layout 4',-1,4)
  m_simpleTV.Dialog.AddComboValue_UTF8(Object,'radioMusicLayout','Layout 5',-1,5)
  m_simpleTV.Dialog.AddComboValue_UTF8(Object,'radioMusicLayout','Layout 6',-1,6)

  value = getConfigVal("radioMusicLayout") or 0
  m_simpleTV.Dialog.SelectComboIndex(Object,'radioMusicLayout',value)
  local layout=tonumber(value)
     
  if layout==0 or layout==1 then
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg','none')
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',0)     
  end    
  
  if layout==2 then
  
      value = getConfigVal("RadioTrackFontLayout2") or 'constantia,40,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout2 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout2 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout2 = t[7]
     end
     
      value = getConfigVal("RadioStationFontLayout2") or 'constantia,30,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout2 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout2 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout2 = t[7]
     end     

     value = getConfigVal("RadioTrackNumBreakLayout2") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout2") or 'ffff8c1a'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)

     value = getConfigVal("RadioBorderColorLayout2") or 'ffff8c1a'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout2") or 2
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)

     value = getConfigVal("RadioScrollTextLayout2") or 0
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)
     
  end 
     
  if layout==3 then
  
      value = getConfigVal("RadioTrackFontLayout3") or 'arial black,40,-1,5,0,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout3 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout3 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout3 = t[7]
     end
     
      value = getConfigVal("RadioStationFontLayout3") or 'arial black,30,-1,5,0,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout3 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout3 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout3 = t[7]
     end 

     value = getConfigVal("RadioTrackNumBreakLayout3") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout3") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)
     value = getConfigVal("RadioBorderColorLayout3") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout3") or 2
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)
     value = getConfigVal("RadioScrollTextLayout3") or 1
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)
  end
  
  if layout==4 then
  
      value = getConfigVal("RadioTrackFontLayout4") or 'constantia,40,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout4 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout4 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout4 = t[7]         
     end
     
      value = getConfigVal("RadioStationFontLayout4") or 'constantia,30,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout4 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout4 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout4 = t[7]         
     end 

     value = getConfigVal("RadioTrackNumBreakLayout4") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout4") or 'ffff8c1a'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)
     value = getConfigVal("RadioBorderColorLayout4") or 'ffff8c1a'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout4") or 0
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)
     value = getConfigVal("RadioScrollTextLayout4") or 0
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)
  end      

  if layout==5 then
  
      value = getConfigVal("RadioTrackFontLayout5") or 'arial black,40,-1,5,0,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout5 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout5 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout5 = t[7]                  
     end
     
      value = getConfigVal("RadioStationFontLayout5") or 'arial black,30,-1,5,0,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout5 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout5 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout5 = t[7]                  
     end 

     value = getConfigVal("RadioTrackNumBreakLayout5") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout5") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)
     value = getConfigVal("RadioBorderColorLayout5") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout5") or 0
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)
     value = getConfigVal("RadioScrollTextLayout5") or 1
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)
  end  
  
  if layout==6 then
  
      value = getConfigVal("RadioTrackFontLayout6") or 'constantia,40,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout6 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout6 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout6 = t[7]           
     end
     
      value = getConfigVal("RadioStationFontLayout6") or 'constantia,30,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout6 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout6 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout6 = t[7]            
     end 
       
     value = getConfigVal("RadioTrackNumBreakLayout6") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout6") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)
     value = getConfigVal("RadioBorderColorLayout6") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout6") or 10
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)
     value = getConfigVal("RadioScrollTextLayout6") or 0
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)
     
  end   


end
------------------------------------------------------------------

function OnOk(Object) 

 --save settings
--TypeMedia
 local value
 value = m_simpleTV.Dialog.GetComboValue_UTF8(Object,'TypeMedia')
 if value~=nil then
    if value == 'Channels' then
       setConfigVal("TypeMedia",0)
       m_simpleTV.User.Radio.TypeMedia = 0
     elseif value == 'Files' then
       setConfigVal("TypeMedia",1)
       m_simpleTV.User.Radio.TypeMedia = 1
     elseif value == 'Video' then
       setConfigVal("TypeMedia",3)
       m_simpleTV.User.Radio.TypeMedia = 3
    end
 end 

--radio logo
 value = m_simpleTV.Dialog.GetCheckBoxValue(Object,'RadioLogo')
 if value~=nil then
    setConfigVal("RadioLogo",value)
    if tonumber(value) == 1 then     
         m_simpleTV.User.Radio.RadioLogo = true
      else
         m_simpleTV.User.Radio.RadioLogo = false
   end
 end

--OSD title
 value = m_simpleTV.Dialog.GetCheckBoxValue(Object,'RadioOSDTitle')
 if value~=nil then
    setConfigVal("RadioOSDTitle",value)
    if tonumber(value) == 1 then 
         m_simpleTV.User.Radio.RadioOSDTitle = true
      else
         m_simpleTV.User.Radio.RadioOSDTitle = false
   end
 end

--TuneIn add channel
 value = m_simpleTV.Dialog.GetCheckBoxValue(Object,'RadioAddTuneIn')
 if value~=nil then
    setConfigVal("RadioAddTuneIn",value)
    if tonumber(value) == 1 then 
         m_simpleTV.User.Radio.RadioAddTuneIn = true
      else
         m_simpleTV.User.Radio.RadioAddTuneIn = false
   end
 end

--TuneIn group name
  value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTuneInGrpName')
  if value~=nil then
     setConfigVal("RadioTuneInGrpName",value)
     m_simpleTV.User.Radio.RadioTuneInGrpName = value
  end

--layouts
  value=m_simpleTV.Dialog.GetComboValue_UTF8(Object,'radioMusicLayout')
  if value~=nil then
  
         if value=='No layout' then setConfigVal("radioMusicLayout",0)
            m_simpleTV.User.Radio.Layout=0
            m_simpleTV.User.Radio.Background = nil
            
     elseif value=='Layout 1' then setConfigVal("radioMusicLayout",1)
            m_simpleTV.User.Radio.Layout=1
            m_simpleTV.User.Radio.Background = nil
            
     elseif value=='Layout 2' then 
            setConfigVal("radioMusicLayout",2)

            local str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.TrackFontItalicLayout2 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.TrackFontUnderlineLayout2 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioTrackFontLayout2",str)
            m_simpleTV.User.Radio.RadioTrackFontLayout2 = str
            
            str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.StationFontItalicLayout2 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.StationFontUnderlineLayout2 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioStationFontLayout2",str) 
            m_simpleTV.User.Radio.RadioStationFontLayout2 = str           

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackNumBreak')
            setConfigVal("RadioTrackNumBreakLayout2",value)
            m_simpleTV.User.Radio.RadioTrackNumBreakLayout2=value

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTextColor')
            setConfigVal("RadioTextColorLayout2",value)
            m_simpleTV.User.Radio.RadioTextColorLayout2=value    
        
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBorderColor')
            setConfigVal("RadioBorderColorLayout2",value)
            m_simpleTV.User.Radio.RadioBorderColorLayout2=value   
          
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBlurBg')
            setConfigVal("RadioBlurBgLayout2",value)
            m_simpleTV.User.Radio.RadioBlurBgLayout2=value

            value = m_simpleTV.Dialog.GetCheckBoxValue(Object,'RadioScrollText') 
            setConfigVal("RadioScrollTextLayout2",value)
            m_simpleTV.User.Radio.RadioScrollTextLayout2=value 
         
            m_simpleTV.User.Radio.Layout=2
            m_simpleTV.User.Radio.Background = nil
            
     elseif value=='Layout 3' then 
            setConfigVal("radioMusicLayout",3)

            local str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.TrackFontItalicLayout3 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.TrackFontUnderlineLayout3 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioTrackFontLayout3",str)
            m_simpleTV.User.Radio.RadioTrackFontLayout3 = str
            
            str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.StationFontItalicLayout3 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.StationFontUnderlineLayout3 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioStationFontLayout3",str)
            m_simpleTV.User.Radio.RadioStationFontLayout3 = str            

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackNumBreak')
            setConfigVal("RadioTrackNumBreakLayout3",value)
            m_simpleTV.User.Radio.RadioTrackNumBreakLayout3=value

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTextColor')
            setConfigVal("RadioTextColorLayout3",value)
            m_simpleTV.User.Radio.RadioTextColorLayout3=value  
          
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBorderColor')
            setConfigVal("RadioBorderColorLayout3",value)
            m_simpleTV.User.Radio.RadioBorderColorLayout3=value
             
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBlurBg')
            setConfigVal("RadioBlurBgLayout3",value)
            m_simpleTV.User.Radio.RadioBlurBgLayout3=value

            value = m_simpleTV.Dialog.GetCheckBoxValue(Object,'RadioScrollText') 
            setConfigVal("RadioScrollTextLayout3",value)
            m_simpleTV.User.Radio.RadioScrollTextLayout3=value  
                    
            m_simpleTV.User.Radio.Layout=3
            m_simpleTV.User.Radio.Background = nil
            
     elseif value=='Layout 4' then 
            setConfigVal("radioMusicLayout",4)

            local str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.TrackFontItalicLayout4 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.TrackFontUnderlineLayout4 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioTrackFontLayout4",str)
            m_simpleTV.User.Radio.RadioTrackFontLayout4 = str
            
            str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.StationFontItalicLayout4 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.StationFontUnderlineLayout4 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioStationFontLayout4",str) 
            m_simpleTV.User.Radio.RadioStationFontLayout4 = str           

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackNumBreak')
            setConfigVal("RadioTrackNumBreakLayout4",value)
            m_simpleTV.User.Radio.RadioTrackNumBreakLayout4=value

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTextColor')
            setConfigVal("RadioTextColorLayout4",value)
            m_simpleTV.User.Radio.RadioTextColorLayout4=value  
          
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBorderColor')
            setConfigVal("RadioBorderColorLayout4",value)
            m_simpleTV.User.Radio.RadioBorderColorLayout4=value  
           
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBlurBg')
            setConfigVal("RadioBlurBgLayout4",value)
            m_simpleTV.User.Radio.RadioBlurBgLayout4=value

            value = m_simpleTV.Dialog.GetCheckBoxValue(Object,'RadioScrollText') 
            setConfigVal("RadioScrollTextLayout4",value)
            m_simpleTV.User.Radio.RadioScrollTextLayout4=value  
                    
            m_simpleTV.User.Radio.Layout=4
            m_simpleTV.User.Radio.Background = nil
            
     elseif value=='Layout 5' then 
            setConfigVal("radioMusicLayout",5)

            local str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.TrackFontItalicLayout5 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.TrackFontUnderlineLayout5 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioTrackFontLayout5",str)
            m_simpleTV.User.Radio.RadioTrackFontLayout5 = str
            
            str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.StationFontItalicLayout5 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.StationFontUnderlineLayout5 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioStationFontLayout5",str) 
            m_simpleTV.User.Radio.RadioStationFontLayout5 = str            

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackNumBreak')
            setConfigVal("RadioTrackNumBreakLayout5",value)
            m_simpleTV.User.Radio.RadioTrackNumBreakLayout5=value

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTextColor')
            setConfigVal("RadioTextColorLayout5",value)
            m_simpleTV.User.Radio.RadioTextColorLayout5=value  
          
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBorderColor')
            setConfigVal("RadioBorderColorLayout5",value)
            m_simpleTV.User.Radio.RadioBorderColorLayout5=value   
          
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBlurBg')
            setConfigVal("RadioBlurBgLayout5",value)
            m_simpleTV.User.Radio.RadioBlurBgLayout5=value

            value = m_simpleTV.Dialog.GetCheckBoxValue(Object,'RadioScrollText') 
            setConfigVal("RadioScrollTextLayout5",value)
            m_simpleTV.User.Radio.RadioScrollTextLayout5=value   

            m_simpleTV.User.Radio.Layout=5
            m_simpleTV.User.Radio.Background = nil
            
     elseif value=='Layout 6' then 
            setConfigVal("radioMusicLayout",6)
            
            local str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.TrackFontItalicLayout6 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.TrackFontUnderlineLayout6 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioTrackFontLayout6",str)
            m_simpleTV.User.Radio.RadioTrackFontLayout6 = str
            
            str=''
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontLayout')
            str = str .. value .. ','

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontHeight')
            str = str .. value .. ',-1,5,'

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioStationFontWeight')
            str = str .. value .. ','            

            value = m_simpleTV.User.Radio.StationFontItalicLayout6 or 0
            str = str .. value .. ','  
            
            value = m_simpleTV.User.Radio.StationFontUnderlineLayout6 or 0
            str = str .. value .. ',0,0,0,'              
            setConfigVal("RadioStationFontLayout6",str)
            m_simpleTV.User.Radio.RadioStationFontLayout6 = str            
                      
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTrackNumBreak')
            setConfigVal("RadioTrackNumBreakLayout6",value)
            m_simpleTV.User.Radio.RadioTrackNumBreakLayout6=value

            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioTextColor')
            setConfigVal("RadioTextColorLayout6",value)
            m_simpleTV.User.Radio.RadioTextColorLayout6=value 
           
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBorderColor')
            setConfigVal("RadioBorderColorLayout6",value)
            m_simpleTV.User.Radio.RadioBorderColorLayout6=value 
            
            value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBlurBg')
            setConfigVal("RadioBlurBgLayout6",value)
            m_simpleTV.User.Radio.RadioBlurBgLayout6=value

            value = m_simpleTV.Dialog.GetCheckBoxValue(Object,'RadioScrollText') 
            setConfigVal("RadioScrollTextLayout6",value)
            m_simpleTV.User.Radio.RadioScrollTextLayout6=value 
                     
            m_simpleTV.User.Radio.Layout=6
            m_simpleTV.User.Radio.Background = nil        

         end
  end
 
 --backround picture
  value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioBgPic')
  if value~=nil then
     value=value:gsub('\\','/')
     setConfigVal("RadioBgPic",value)
     m_simpleTV.User.Radio.RadioBgPic = value
  end
  
 --cover picture
  value = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'RadioCoverPic')
  if value~=nil then
     value=value:gsub('\\','/')
     setConfigVal("RadioCoverPic",value)
     m_simpleTV.User.Radio.RadioCoverPic = value
  end 
  

end
----------------------------------------------------------------------------------
function changeLayout(Object,id)

 local s = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,id,value)
       
 if s~=nil then

  local layout=tonumber(s)

  if layout==0 or layout==1 then
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout','none')    
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor','none')
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg','none')
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',0)     
  end    
  
  if layout==2 then
  
      value = getConfigVal("RadioTrackFontLayout2") or 'constantia,40,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout2 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout2 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout2 = t[7]
     end
     
      value = getConfigVal("RadioStationFontLayout2") or 'constantia,30,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout2 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout2 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout2 = t[7]
     end     

     value = getConfigVal("RadioTrackNumBreakLayout2") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout2") or 'ffff8c1a'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)

     value = getConfigVal("RadioBorderColorLayout2") or 'ffff8c1a'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout2") or 2
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)

     value = getConfigVal("RadioScrollTextLayout2") or 0
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)
     
  end 
     
  if layout==3 then
  
      value = getConfigVal("RadioTrackFontLayout3") or 'arial black,40,-1,5,0,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout3 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout3 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout3 = t[7]
     end
     
      value = getConfigVal("RadioStationFontLayout3") or 'arial black,30,-1,5,0,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout3 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout3 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout3 = t[7]
     end 

     value = getConfigVal("RadioTrackNumBreakLayout3") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout3") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)
     value = getConfigVal("RadioBorderColorLayout3") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout3") or 2
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)
     value = getConfigVal("RadioScrollTextLayout3") or 1
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)
  end
  
  if layout==4 then
  
      value = getConfigVal("RadioTrackFontLayout4") or 'constantia,40,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout4 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout4 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout4 = t[7]         
     end
     
      value = getConfigVal("RadioStationFontLayout4") or 'constantia,30,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout4 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout4 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout4 = t[7]         
     end 

     value = getConfigVal("RadioTrackNumBreakLayout4") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout4") or 'ffff8c1a'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)
     value = getConfigVal("RadioBorderColorLayout4") or 'ffff8c1a'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout4") or 0
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)
     value = getConfigVal("RadioScrollTextLayout4") or 0
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)
  end      

  if layout==5 then
  
      value = getConfigVal("RadioTrackFontLayout5") or 'arial black,40,-1,5,0,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout5 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout5 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout5 = t[7]                  
     end
     
      value = getConfigVal("RadioStationFontLayout5") or 'arial black,30,-1,5,0,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout5 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout5 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout5 = t[7]                  
     end 

     value = getConfigVal("RadioTrackNumBreakLayout5") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout5") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)
     value = getConfigVal("RadioBorderColorLayout5") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout5") or 0
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)
     value = getConfigVal("RadioScrollTextLayout5") or 1
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)
  end  
  
  if layout==6 then
  
      value = getConfigVal("RadioTrackFontLayout6") or 'constantia,40,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioTrackFontLayout6 = value
      
      local t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])
         m_simpleTV.User.Radio.TrackFontItalicLayout6 = t[6]
         m_simpleTV.User.Radio.TrackFontUnderlineLayout6 = t[7]           
     end
     
      value = getConfigVal("RadioStationFontLayout6") or 'constantia,30,-1,5,70,0,0,0,0,0'
      m_simpleTV.User.Radio.RadioStationFontLayout6 = value
      
      t={}
      if value ~= nil  then
         for w in string.gmatch(value, '[^,]+') do 
             t[#t+1]=w
         end
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontLayout',t[1])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
         m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])
         m_simpleTV.User.Radio.StationFontItalicLayout6 = t[6]
         m_simpleTV.User.Radio.StationFontUnderlineLayout6 = t[7]            
     end 
       
     value = getConfigVal("RadioTrackNumBreakLayout6") or 50
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackNumBreak',value)

     value = getConfigVal("RadioTextColorLayout6") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTextColor',value)
     value = getConfigVal("RadioBorderColorLayout6") or 'ffe8e8e8'
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBorderColor',value)

     value = getConfigVal("RadioBlurBgLayout6") or 10
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioBlurBg',value)
     value = getConfigVal("RadioScrollTextLayout6") or 0
     m_simpleTV.Dialog.SetCheckBoxValue(Object,'RadioScrollText',value)    
  end   

 end
end
------------------------------------------------------------------------------------
function colorPicker(Object, id)
  
 local s = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,id,value)
 local startColor = ARGB(255,0,0,0)
 if s~=nil then
    startColor = tonumber(s,16)
 end
 
 local newColor1 = m_simpleTV.Interface.ColorPicker(startColor,"Choose color")
 
 if newColor1 ~= nil  then
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,id,string.format('%x',newColor1))
 end

end
------------------------------------------------------------------------------------
function changeFont(Object, id)
  
 local s = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,id,value)
 if s~=nil then
 
   local startFont=s
   if id=='RadioTrackFontLayout' then  
   
      local value=m_simpleTV.Dialog.GetComboValue_UTF8(Object,'radioMusicLayout')
      if value~=nil then
               if value=='Layout 2' then 
                  startFont = m_simpleTV.User.Radio.RadioTrackFontLayout2
           elseif value=='Layout 3' then 
                  startFont = m_simpleTV.User.Radio.RadioTrackFontLayout3
           elseif value=='Layout 4' then 
                  startFont = m_simpleTV.User.Radio.RadioTrackFontLayout4
           elseif value=='Layout 5' then 
                  startFont = m_simpleTV.User.Radio.RadioTrackFontLayout5
           elseif value=='Layout 6' then 
                  startFont = m_simpleTV.User.Radio.RadioTrackFontLayout6
               end                   
      end
      
      local newFont =  m_simpleTV.Interface.FontPicker(startFont,"Choose font")

      local t={}
      if newFont ~= nil  then
         for w in string.gmatch(newFont, '[^,]+') do 
             t[#t+1]=w
         end
         --t[1] - font name
         --t[2] - font height
         --t[3] - -1
         --t[4] - 5
         --t[5] - font weight
         --t[6] - italic (0 or 1)
         --t[7] - underline (0 or 1)
         
        m_simpleTV.Dialog.SetElementValueString_UTF8(Object,id,newFont:gsub(',.+',''))
       
        value=m_simpleTV.Dialog.GetComboValue_UTF8(Object,'radioMusicLayout')    
        if value~=nil then

            m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontHeight',t[2])
            m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioTrackFontWeight',t[5])       

               if value=='Layout 2' then 
                  m_simpleTV.User.Radio.RadioTrackFontLayout2=newFont
                  m_simpleTV.User.Radio.TrackFontItalicLayout2 = t[6]
                  m_simpleTV.User.Radio.TrackFontUnderlineLayout2 = t[7]                                   
           elseif value=='Layout 3' then 
                  m_simpleTV.User.Radio.RadioTrackFontLayout3=newFont
                  m_simpleTV.User.Radio.TrackFontItalicLayout3 = t[6]
                  m_simpleTV.User.Radio.TrackFontUnderlineLayout3 = t[7]                    
           elseif value=='Layout 4' then 
                  m_simpleTV.User.Radio.RadioTrackFontLayout4=newFont  
                  m_simpleTV.User.Radio.TrackFontItalicLayout4 = t[6]
                  m_simpleTV.User.Radio.TrackFontUnderlineLayout4 = t[7]                  
           elseif value=='Layout 5' then 
                  m_simpleTV.User.Radio.RadioTrackFontLayout5=newFont
                  m_simpleTV.User.Radio.TrackFontItalicLayout5 = t[6]
                  m_simpleTV.User.Radio.TrackFontUnderlineLayout5 = t[7]                    
           elseif value=='Layout 6' then 
                  m_simpleTV.User.Radio.RadioTrackFontLayout6=newFont
                  m_simpleTV.User.Radio.TrackFontItalicLayout6 = t[6]
                  m_simpleTV.User.Radio.TrackFontUnderlineLayout6 = t[7]                                   
               end
        end
      end   
   end
   
   if id=='RadioStationFontLayout' then  
   
      local value=m_simpleTV.Dialog.GetComboValue_UTF8(Object,'radioMusicLayout')
      if value~=nil then
               if value=='Layout 2' then 
                  startFont = m_simpleTV.User.Radio.RadioStationFontLayout2
           elseif value=='Layout 3' then 
                  startFont = m_simpleTV.User.Radio.RadioStationFontLayout3
           elseif value=='Layout 4' then 
                  startFont = m_simpleTV.User.Radio.RadioStationFontLayout4
           elseif value=='Layout 5' then 
                  startFont = m_simpleTV.User.Radio.RadioStationFontLayout5
           elseif value=='Layout 6' then 
                  startFont = m_simpleTV.User.Radio.RadioStationFontLayout6
               end                   
      end
      
      local newFont =  m_simpleTV.Interface.FontPicker(startFont,"Choose font")

      local t={}
      if newFont ~= nil  then
         for w in string.gmatch(newFont, '[^,]+') do 
             t[#t+1]=w
         end
         --t[1] - font name
         --t[2] - font height
         --t[3] - -1
         --t[4] - 5
         --t[5] - font weight
         --t[6] - italic (0 or 1)
         --t[7] - underline (0 or 1)
         
        m_simpleTV.Dialog.SetElementValueString_UTF8(Object,id,newFont:gsub(',.+',''))
       
        value=m_simpleTV.Dialog.GetComboValue_UTF8(Object,'radioMusicLayout')    
        if value~=nil then

            m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontHeight',t[2])
            m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'RadioStationFontWeight',t[5])       

               if value=='Layout 2' then 
                  m_simpleTV.User.Radio.RadioStationFontLayout2=newFont  
                  m_simpleTV.User.Radio.StationFontItalicLayout2 = t[6]
                  m_simpleTV.User.Radio.StationFontUnderlineLayout2 = t[7]  
           elseif value=='Layout 3' then 
                  m_simpleTV.User.Radio.RadioStationFontLayout3=newFont
                  m_simpleTV.User.Radio.StationFontItalicLayout3 = t[6]
                  m_simpleTV.User.Radio.StationFontUnderlineLayout3 = t[7]                    
           elseif value=='Layout 4' then 
                  m_simpleTV.User.Radio.RadioStationFontLayout4=newFont
                  m_simpleTV.User.Radio.StationFontItalicLayout4 = t[6]
                  m_simpleTV.User.Radio.StationFontUnderlineLayout4 = t[7]                    
           elseif value=='Layout 5' then 
                  m_simpleTV.User.Radio.RadioStationFontLayout5=newFont
                  m_simpleTV.User.Radio.StationFontItalicLayout5 = t[6]
                  m_simpleTV.User.Radio.StationFontUnderlineLayout5 = t[7]                    
           elseif value=='Layout 6' then 
                  m_simpleTV.User.Radio.RadioStationFontLayout6=newFont
                  m_simpleTV.User.Radio.StationFontItalicLayout6 = t[6]
                  m_simpleTV.User.Radio.StationFontUnderlineLayout6 = t[7]
               end
        end
      end  
   end
 
 end
end
