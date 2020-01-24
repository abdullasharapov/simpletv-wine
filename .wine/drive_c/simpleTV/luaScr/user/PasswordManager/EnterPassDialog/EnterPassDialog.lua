require("pm")

----------------------------------------------------------------------
local function escapeJSString(str)
 if str == nil then return nil end
 str = string.gsub(str,'\\','\\\\')
 str = string.gsub(str,'"','\\"')
 str = string.gsub(str,'\n','\\n')
 str = string.gsub(str,'\r','\\r')
 return str
end
----------------------------------------------------------------------
local function setLogin(Object) 
 local scr = 'setInitialVal("' .. escapeJSString(m_simpleTV.User.PasswordManager.ShowPassDialogParam.id) .. '","'
						  	   .. escapeJSString(m_simpleTV.User.PasswordManager.ShowPassDialogParam.name) .. '",'
							   .. tostring(pm.getConfigVal('showPassword') or false) .. ');'
 m_simpleTV.Dialog.ExecScript(Object,scr)								
end
----------------------------------------------------------------------
local function reset()
 if    m_simpleTV.User==nil 
	or m_simpleTV.User.PasswordManager==nil 
	or m_simpleTV.User.PasswordManager.ShowPassDialogParam==nil 
   then
  return
 end
 m_simpleTV.User.PasswordManager.ShowPassDialogParam.submit   = nil
end 
----------------------------------------------------------------------
local function translteHtml(Object)

local function getJsTr(str)
  return 'm_globalTranslateMap.set("' .. escapeJSString(str) .. '","' .. escapeJSString(pm.tr(str)) .. '");'
end

  local scr ='m_globalTranslateMap.set("MainHeader","' .. escapeJSString(m_simpleTV.User.PasswordManager.ShowPassDialogParam.header) .. '");'
			 ..	getJsTr('Id')
             .. getJsTr('Name')
			 .. getJsTr('Login')
			 .. getJsTr('Password')
			 .. getJsTr('Ok')
  
  m_simpleTV.Dialog.ExecScript(Object,scr)
  m_simpleTV.Dialog.ExecScript(Object,'doTranslate();')
end
----------------------------------------------------------------------
function OnNavigateComplete(Object)
 
 if    m_simpleTV.User==nil 
	or m_simpleTV.User.PasswordManager==nil 
	or m_simpleTV.User.PasswordManager.ShowPassDialogParam==nil 
	or m_simpleTV.User.PasswordManager.ShowPassDialogParam.id==nil
	or m_simpleTV.User.PasswordManager.ShowPassDialogParam.id==''
	then
   
   m_simpleTV.Dialog.Close(Object)
   return
 end	   
  
  translteHtml(Object)
  setLogin(Object) 
  reset()
end
----------------------------------------------------------------------
function OnOk(Object)  
end
----------------------------------------------------------------------
function requestCancel(Object)
 reset()
 m_simpleTV.Dialog.Close(Object)
end
----------------------------------------------------------------------
function formSubmit(Object,id,login,password)
 if    m_simpleTV.User==nil 
	or m_simpleTV.User.PasswordManager==nil 
	or m_simpleTV.User.PasswordManager.ShowPassDialogParam==nil 
	or m_simpleTV.User.PasswordManager.ShowPassDialogParam.id==nil
	or m_simpleTV.User.PasswordManager.ShowPassDialogParam.id~=id
  then
  reset()
  m_simpleTV.Dialog.Close(Object) 
  return  
 end
 
 pm.update(id,nil,login,password)
 m_simpleTV.User.PasswordManager.ShowPassDialogParam.submit   = true
 m_simpleTV.Dialog.Close(Object) 
end
----------------------------------------------------------------------




