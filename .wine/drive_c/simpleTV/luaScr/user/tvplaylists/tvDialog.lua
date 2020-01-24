
local function getConfigVal(key)
 return m_simpleTV.Config.GetValue(key,"tvplaylistsConf.ini")
end

local function setConfigVal(key,val)
  m_simpleTV.Config.SetValue(key,val,"tvplaylistsConf.ini")
end

function OnNavigateComplete(Object)
  local value  
  value= getConfigVal("AutoupdatTTVChk") or 0
  m_simpleTV.Dialog.SetCheckBoxValue(Object,'AutoupdatTTVChk',value) 
end

function OnOk(Object)

local value

  value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'AutoupdatTTVChk') 
  if value~=nil then 	
      setConfigVal("AutoupdatTTVChk",value)
      if tonumber(value)==1 then
         m_simpleTV.User.TTV01.isAutoupdate=1
      else
         m_simpleTV.User.TTV01.isAutoupdate=0
      end
  end
end
