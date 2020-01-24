local base = _G
module("pm")

function GetVersion()
  return "0.20"
end

------------------------------------------------------------------------------
--LOCALS
------------------------------------------------------------------------------
m_PassDialogShowed = false
local m_loginTable = {}
local m_hash1 = {"b", "U", "N", "I", "Z", "o", "H", "V", "T", "w", "W", "D", "a", "f", "t", "Q", "9", "v", "g", "8", "x", "0", "1", "4", "c", "="}
local m_hash2 = {"p", "z", "m", "X", "R", "J", "2", "Y", "d", "n", "B", "G", "u", "y", "L", "s", "l", "M", "i", "e", "6", "k", "7", "3", "5", "F"}
------------------------------------------------------------------------------
local function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end
------------------------------------------------------------------------------
local function mixStr(str)
  local i=1
 while true do
  local re1 = m_hash1[i]
  if re1 == nil then break end
  local re2 = m_hash2[i]
  str = str:gsub(re1, '___')
  str = str:gsub(re2, re1)
  str = str:gsub('___', re2)
  i = i+1
 end 
 return str
end
------------------------------------------------------------------------------
local function encrypt(str)
 return mixStr( base.encode64(str) )
end
------------------------------------------------------------------------------
local function decrypt(str)
 return base.decode64( mixStr(str) ) 
end
------------------------------------------------------------------------------
local function findById(id)
 if m_loginTable==nil or id==nil or id=='' then return nil end
 
 id = base.string.lower(id) 
 for i=1,#m_loginTable do 
   if m_loginTable[i].id == id then return m_loginTable[i] end
 end  
 
 return nil
end
------------------------------------------------------------------------------
local function addId(id,name)
 if id==nil or id=='' then return end
  
 if name==nil or name=='' then name = id end

 local row = findById(id)
 if row==nil then
     local i = #m_loginTable+1
	 m_loginTable[i] = {}
	 m_loginTable[i].id = base.string.lower(id) 
	 m_loginTable[i].name = name
	 m_loginTable[i].login = ''
	 m_loginTable[i].password = ''
 end
 
 save(m_loginTable)
 reload()
end
------------------------------------------------------------------------------
local function showOsdMessage(str,reason)
 if not str then return end
 reason = reason or ''
 local t = {text='Password Manager: ' .. str,id='passwordManager',append = true}
			
 if reason == 'error' then
    t.showTime = 10*1000
    t.color 	   = base.ARGB(255,255,0,0)
 elseif reason == 'warning' then
	t.showTime = 10*1000
    t.color      = base.ARGB(255,255,255,0)
 end
 base.m_simpleTV.OSD.ShowMessageT(t) 
end
------------------------------------------------------------------------------
--Interface
------------------------------------------------------------------------------
function getLoginTable(id)
 return m_loginTable
end
------------------------------------------------------------------------------
function tr(str)
 if base.m_simpleTV.Interface.Translate~=nil then 
   return base.m_simpleTV.Interface.Translate(str,'simpleTV::PasswordManager')
 end
 return str 
end
------------------------------------------------------------------------------
function setAllowShowEnterPasswordDialog(val)
 if base.type(val) == 'boolean' then 
   setConfigVal('allowShowEnterPasswordDialog',val) 
 end 
end
------------------------------------------------------------------------------
function isAllowShowEnterPasswordDialog()
 local v = getConfigVal('allowShowEnterPasswordDialog')
 if v == nil then v = true end
 return v == 'true' or v==true
end
------------------------------------------------------------------------------
function showEnterPasswordDialog(id)
 if m_PassDialogShowed or isAllowShowEnterPasswordDialog()~=true then return false end
 
 local row = findById(id) 
 if row == nil 	then return false end 
 if row.login~='' and row.password~='' then return true,row.login,row.password end 
 
 m_PassDialogShowed = true	
 
 if base.m_simpleTV.User==nil then base.m_simpleTV.User={} end
 if base.m_simpleTV.User.PasswordManager==nil then base.m_simpleTV.User.PasswordManager={} end
 
 base.m_simpleTV.User.PasswordManager.ShowPassDialogParam = {}
 base.m_simpleTV.User.PasswordManager.ShowPassDialogParam.id = row.id
 base.m_simpleTV.User.PasswordManager.ShowPassDialogParam.name = row.name
 base.m_simpleTV.User.PasswordManager.ShowPassDialogParam.header = tr('Enter login/password for ') .. row.name
 
 local t={} 
 t.name = 'Password Manager v' .. GetVersion() 
 t.urlHtml  =  base.m_simpleTV.MainScriptDir_UTF8 .. 'user/PasswordManager/EnterPassDialog/EnterPassDialog.html'
 t.urlLua   =  'user/PasswordManager/EnterPassDialog/EnterPassDialog.lua'
 t.flags = 1+4  --HAVE_SIZE + ALLOW_RESIZE 
 t.cx = 450
 t.cy = 320
 base.m_simpleTV.Dialog.ShowT(t)
 m_PassDialogShowed = false
 
 if base.m_simpleTV.User.PasswordManager.ShowPassDialogParam.submit ~=true then
    return false
 end
 
 row = findById(id) 
 if row == nil 	then return false end 
 
 return true,row.login,row.password 
end
------------------------------------------------------------------------------
function GetPassword(id)  
  if id == nil or id=='' then
    return nil, nil, nil, 1, tr("incorrect ID")
  end
    
  if base.type(m_loginTable) ~= "table" then
    return nil, nil, nil, 3, tr("error in the passwords database")
  end
  
  local row = findById(id)    
  if row == nil then
    return nil, nil, nil, 4, tr("ID is not found in the passwords database")
  end
  
  return row.login, row.password, ''
end
------------------------------------------------------------------------------
function GetTestPassword(id, name, notShowWarning)

  local login, pass, deprecate0, error_type, error_text = GetPassword(id)
  
  if error_type then
    if  error_type == 4 then
		addId(id, name)
		if notShowWarning ~= true then
		   
		   if isAllowShowEnterPasswordDialog() then
			 local ret,newLogin,newPass = showEnterPasswordDialog(id)
			 if ret==true then return true, newLogin, newPass, '' end			 
		   end 	  		     
	     showOsdMessage(tr('Enter login/password for ') .. name,'warning') 
		end
     else
	    showOsdMessage(error_text,'error') 
	end  	
   return false, error_type, error_text
  end
    
 return true, login, pass, ''
end
------------------------------------------------------------------------------
function getConfigFile()
 return "passwordmanager.ini"
end
------------------------------------------------------------------------------
function getConfigVal(key)
 return base.m_simpleTV.Config.GetValue(key,getConfigFile())
end
------------------------------------------------------------------------------
function setConfigVal(key,val)
  base.m_simpleTV.Config.SetValue(key,val,getConfigFile())
end
------------------------------------------------------------------------------
function update(id,name,login,password)
 
 if m_loginTable==nil or id==nil or id=='' then return end
 id = base.string.lower(id)   
 for i=1,#m_loginTable do 
   if m_loginTable[i].id == id then     
    
	if name~=nil then m_loginTable[i].name = name end
    if login~=nil then m_loginTable[i].login = login end
    if password~=nil then m_loginTable[i].password = password end   
	
	save(m_loginTable)
	reload()
    return
   end 
 end   
end
------------------------------------------------------------------------------
function reload()
 m_loginTable = {}
 local data = decrypt(getConfigVal('maindata') or '')
    
 for w in data:gmatch('(.-)|') do       
   
   local id       =  base.string.lower(trim(base.m_simpleTV.Common.fromPersentEncoding(w:match('id="(.-)"') or '')))
   local name     =  trim(base.m_simpleTV.Common.fromPersentEncoding(w:match('name="(.-)"') or ''))
   local login    =  trim(base.m_simpleTV.Common.fromPersentEncoding(w:match('login="(.-)"') or ''))
   local password =  trim(base.m_simpleTV.Common.fromPersentEncoding(w:match('password="(.-)"') or ''))

   --base.debug_in_file(id .. ' ' .. name .. ' ' .. login .. ' ' .. password)
   
   if id~='' then
	  local i = #m_loginTable+1
	  m_loginTable[i] = {}
	  m_loginTable[i].id = id
	  m_loginTable[i].name = name
	  m_loginTable[i].login = login
	  m_loginTable[i].password = password
   end	
 end   
end
------------------------------------------------------------------------------
function save(tLogins)
 if tLogins==nil or base.type(tLogins) ~= 'table' then return end
 
 base.table.sort(tLogins,function(a,b) return a.id < b.id end)
 
 local str = ''
 for i=1,#tLogins do    
   
   local id       = base.string.lower(trim(tLogins[i].id or ''))
   local name     = trim(tLogins[i].name or '')
   local login    = trim(tLogins[i].login or '')
   local password = trim(tLogins[i].password or '')
   		 
   if id~='' then
   str =   str  
		 .. 'id="'    .. base.m_simpleTV.Common.toPersentEncoding(id) .. '"'
		 .. 'name="'  .. base.m_simpleTV.Common.toPersentEncoding(name) .. '"'
		 .. 'login="' .. base.m_simpleTV.Common.toPersentEncoding(login) .. '"'
		 .. 'password="' .. base.m_simpleTV.Common.toPersentEncoding(password)  .. '"'  
		 .. '|'
    end		 
 end
 setConfigVal('maindata',encrypt(str)) 
end
------------------------------------------------------------------------------
--Startup init
------------------------------------------------------------------------------
reload()
