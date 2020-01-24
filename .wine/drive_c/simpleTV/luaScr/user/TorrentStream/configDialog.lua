
local adSkipExtOptions = "$OPT:vout=dummy$OPT:aout=dummy$OPT:rate=1$OPT:POSITIONTOCONTINUE=0.99"

local function getConfigVal(key)
 return m_simpleTV.Config.GetValue(key,"acestreamConf.ini")
end

local function setConfigVal(key,val)
  m_simpleTV.Config.SetValue(key,val,"acestreamConf.ini")
end

function OnNavigateComplete(Object)

  local value  
  value= getConfigVal("enginePath") or '%APPDATA%\\AceStream\\engine'
  m_simpleTV.Dialog.SetElementValueString(Object,'Path',value) 
  
  value= getConfigVal("engineParam") or ''
  m_simpleTV.Dialog.SetElementValueString(Object,'Params',value) 
  
  value=getConfigVal("address") or '127.0.0.1'
  m_simpleTV.Dialog.SetElementValueString(Object,'Address',value)
  
  value= getConfigVal("port") or -1 
  m_simpleTV.Dialog.SetElementValueString(Object,'Port','' .. value)
  
  value= getConfigVal("autoStart") or 1
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'AutoStart',value) 
  
  value= getConfigVal("closeOnExit") or 0
  m_simpleTV.Dialog.SelectComboIndex(Object,'AutoEnd',value) 
  
  value= getConfigVal("allowChangeName") or 0
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'AllowChangeName',value) 
  
  value= getConfigVal("allowShowName") or 1
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'AllowShowName',value) 
    
  value= getConfigVal("allowAD") or 1
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'CheckboxAD',value) 	
	
  value= getConfigVal("extParams") or 0
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'CheckboxAA1',value) 		
  
  value= getConfigVal("useAVCODECForMkvAvi") or 0
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'UseAVCODECForMkvAvi',value) 		
  
  value= getConfigVal("adSkipVlcParams") or adSkipExtOptions
  m_simpleTV.Dialog.SetElementValueString(Object,'ADTextOptions',value) 		
  
 m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','ButtonDef','OnClickButtonDef')
 m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','ButtonFolderPicker','OnFolderPicker')

end
------------------------------------------------------------------
function OnOk(Object)

local value

  value = m_simpleTV.Dialog.GetElementValueString(Object,'Path') 
  if value~=nil then 
		setConfigVal("enginePath",value)
  end		
  
  value = m_simpleTV.Dialog.GetElementValueString(Object,'Params') 
  if value~=nil then 
		setConfigVal("engineParam",value)
  end		
  
  value=m_simpleTV.Dialog.GetElementValueString(Object,'Address')
  if value~=nil then 
     setConfigVal("address",value)
  end
  
  value=m_simpleTV.Dialog.GetElementValueString(Object,'Port')
  value=tonumber(value)
  if value~=nil then 
    setConfigVal("port",value)
  end
    
  value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'AutoStart') 
  if value~=nil then 	
      setConfigVal("autoStart",value)
  end
  
  value=m_simpleTV.Dialog.GetComboValue(Object,'AutoEnd',true) 
  if value~=nil then 	
      value = tonumber(value)
	  if value~=nil then 	
			setConfigVal("closeOnExit",value)
	  end
  end
    
  value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'AllowChangeName') 
  if value~=nil then  
	setConfigVal("allowChangeName",value)
  end  
  
  value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'AllowShowName') 
  if value~=nil then  
	setConfigVal("allowShowName",value)
  end  

  
  value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'CheckboxAD') 
  if value~=nil then  
	setConfigVal("allowAD",value)
  end  
  
  value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'CheckboxAA1') 
  if value~=nil then  
	setConfigVal("extParams",value)
  end  
  
  value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'UseAVCODECForMkvAvi') 
  if value~=nil then  
	setConfigVal("useAVCODECForMkvAvi",value)
  end  
    
  value=m_simpleTV.Dialog.GetElementValueString(Object,'ADTextOptions')
  if value~=nil then 
     setConfigVal("adSkipVlcParams",value)
  end
  
  
end
------------------------------------------------------------------
function OnClickButtonDef(Object)
  
  m_simpleTV.Dialog.SetElementText(Object,'Path','%APPDATA%\\AceStream\\engine') 
  m_simpleTV.Dialog.SetElementText(Object,'Params','') 
  m_simpleTV.Dialog.SetElementText(Object,'Address','127.0.0.1')
  m_simpleTV.Dialog.SetElementText(Object,'Port','-1')
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'AutoStart',1) 
  m_simpleTV.Dialog.SelectComboIndex(Object,'AutoEnd',0) 
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'AllowChangeName',0)
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'AllowShowName',0) 
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'CheckboxAD',1) 	  
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'CheckboxAA1',0) 
m_simpleTV.Dialog.SetElementValueString(Object,'ADTextOptions',adSkipExtOptions) 		  
   
end
------------------------------------------------------------------
function OnFolderPicker(Object)

 local folder =  m_simpleTV.Common.FolderPicker('Выберите папку')
 
 if folder~=nil then 
    m_simpleTV.Dialog.SetElementValueString(Object,'Path',folder) 
 end	
 
end