require("pm")
local titleStr = "Password Manager"
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
local function fillTable(Object)
 
 m_simpleTV.Dialog.ExecScript(Object,'clearLogins()')   
 local t = pm.getLoginTable()  
 for i=1,#t do
  local scr = 'addEntry('
                         .. '"' .. escapeJSString(t[i].id) .. '"'
                        .. ',"' .. escapeJSString(t[i].name) .. '"' 
						.. ',"' .. escapeJSString(t[i].login) .. '"' 
						.. ',"' .. escapeJSString(t[i].password) .. '"' 
						.. ')'
  m_simpleTV.Dialog.ExecScript(Object,scr)  
 end
end 
----------------------------------------------------------------------
local function translteHtml(Object)

local function getJsTr(str)
  return 'm_globalTranslateMap.set("' .. escapeJSString(str) .. '","' .. escapeJSString(pm.tr(str)) .. '");'
end

  local scr ='m_globalTranslateMap.set("Password Manager","' .. escapeJSString( 'Password Manager v' .. pm.GetVersion() ) .. '");'
			 ..	getJsTr('Id')
             .. getJsTr('Name')
			 .. getJsTr('Login')
			 .. getJsTr('Password')
			 .. getJsTr('Actions')
			 .. getJsTr('New')
			 .. getJsTr('edit')
			 .. getJsTr('delete')
			 .. getJsTr('show password')
			 .. getJsTr('Editor')
			 .. getJsTr('Save')
			 .. getJsTr('Preference')		
		     .. getJsTr('Show passwords')
			 .. getJsTr('Show dialog of enter password')
			 .. getJsTr('Import')
			 .. getJsTr('Export')
  
  m_simpleTV.Dialog.ExecScript(Object,scr)
  m_simpleTV.Dialog.ExecScript(Object,'doTranslate();')
end
----------------------------------------------------------------------
function baseInit(Object)
 local scr = 'm_showPassword=' .. tostring(pm.getConfigVal('showPassword') or false) .. ';'
 m_simpleTV.Dialog.ExecScript(Object,scr)   
 m_simpleTV.Dialog.ExecScript(Object,'updateEditorShowPasswordButton();')  
 
 scr = 'm_showDialogPassword=' .. tostring(pm.isAllowShowEnterPasswordDialog()) .. ';'    
 m_simpleTV.Dialog.ExecScript(Object,scr)  
 fillTable(Object) 
end
----------------------------------------------------------------------
function OnNavigateComplete(Object)
  translteHtml(Object)
  baseInit(Object)
end
----------------------------------------------------------------------
function OnOk(Object)
 
 local showPass = m_simpleTV.Dialog.ExecScriptParam(Object,'(function(){return m_showPassword;})();')  
 if type(showPass) == 'boolean' then pm.setConfigVal('showPassword',showPass) end
 pm.setAllowShowEnterPasswordDialog(m_simpleTV.Dialog.ExecScriptParam(Object,'(function(){return m_showDialogPassword;})();'))
   
 local tFromJs = m_simpleTV.Dialog.ExecScriptParam(Object,'getLogins();')  
 local t = {}

 for k,v in pairs(tFromJs) do
	t[#t+1] = v 
 end   
 
  pm.save (t)
  pm.reload();
end
----------------------------------------------------------------------
--from v0.19
----------------------------------------------------------------------
local function oldPMDecodeStr(str, code)
  local s = string.gsub(str, "^" .. code, "")
  local n = tonumber(string.sub(s, 1, 1))
  s = string.sub(s, 2)
  local x = ""
  for i = 1, n do
    x = x .. "="
  end
  return x .. s
end
----------------------------------------------------------------------
local function importFromOld(line)
 if line==nil or not string.match(line, "^Rd%d") then
     m_simpleTV.Interface.MessageBox(pm.tr("Incorrect file"),titleStr,0x10)
	 return false
 end		
 line = oldPMDecodeStr(line,"Rd")
 line = decode64(string.reverse(line))
 --debug_in_file(line .. '\n')
 local logins = {}
 for w in line:gmatch('|(.-)|') do
   --debug_in_file(w .. '\n')   
   local t = split(w, '/')
   local id   =   t[1] or ''
   local name =   t[2] or ''
   local login  = t[3] or ''
   local pass =   t[4] or ''
   
   if id~='' and name~='' and login~='' and pass~='' then
     local i = #logins+1
	 logins[i]={}
	 logins[i].id       = id
	 logins[i].name     = name
	 logins[i].login    = login
	 logins[i].password = pass
	 
	 --debug_in_file('id:' .. logins[i].id .. '\nname:' .. logins[i].name 
		--			.. '\nloggin:' .. logins[i].login .. '\npassword:' .. logins[i].password .. '\n')
   end
 end  
 if #logins < 1 then return false end 
 pm.save(logins)
 return true
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function requestImport(Object)
 if m_simpleTV.Interface.FilePicker == nil then return end
 
 if #(pm.getLoginTable())>0 then 
  if 6 ~= m_simpleTV.Interface.MessageBox(pm.tr("All current logins/passwords will be removed.\nContinue ?")												
										 ,titleStr,0x24) then return end
 end 										 
 
 local t = {}
 --t.name = pm.tr('Choose file')
 --t.startFolder = ''
 t.filters  = 'Data (*.txt *.ini);All (*)'
 --t.options    =  QFileDialog::ReadOnly
 --t.fileMode   =  QFileDialog::ExistingFile
 --t.acceptMode =  QFileDialog::AcceptOpen
 local path = m_simpleTV.Interface.FilePicker(t)
 if path == nil then return end
 
 local fhandle = io.open(path, "r")
 if fhandle == nil then 
    m_simpleTV.Interface.MessageBox(pm.tr("Can't open file"),titleStr,0x10)
   return 
 end
 if fhandle:seek("end") > 1024*512 then
	 fhandle:close()
	 m_simpleTV.Interface.MessageBox(pm.tr("Incorrect file"),titleStr,0x10)
     return 
 end 	 
 
 fhandle:seek("set", 0) 
 if path:match('(.-)pm_keys%.txt$') then 
    --import from old
	local data = fhandle:read("*l")
	fhandle:close()
	if importFromOld(data) ~= true then return end 
 else 
  local data = fhandle:read("*a")
  fhandle:close()
  if not data:match('(.-)%[General%](.-)maindata') then 
	  m_simpleTV.Interface.MessageBox(pm.tr("Incorrect file"),titleStr,0x10)
     return 
  end 	 
  path = m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Common.GetMainPath(1)) 
		 .. '/LuaConfig/' .. pm.getConfigFile()
  m_simpleTV.Config.Sync(pm.getConfigFile())  
  
  local destFile = io.open(path, "w+")
  if destFile == nil then 
    m_simpleTV.Interface.MessageBox(pm.tr("Can't open destination file"),titleStr,0x10)
   return 
  end
  destFile:write (data)
  destFile:close()  
  m_simpleTV.Config.Sync(pm.getConfigFile())
 end
   
 pm.reload()
 baseInit(Object)
 m_simpleTV.Interface.MessageBox(pm.tr("Export has been successful"),titleStr,0x00)
end
----------------------------------------------------------------------
function requestExport(Object)
 
 if m_simpleTV.Interface.FilePicker == nil then return end
  
 if #(pm.getLoginTable())==0 then 
   m_simpleTV.Interface.MessageBox(pm.tr("No data for export"),titleStr,0x10)
   return 
 end   
 
 local t = {}
 --t.name = pm.tr('Choose file')
 --t.startFolder = ''
 t.selectFile = pm.getConfigFile()
 t.filters  = 'Data (*.ini);All (*)'
 t.options    =  0 --QFileDialog::NO
 t.fileMode   =  0 --QFileDialog::AnyFile
 t.acceptMode =  1 --QFileDialog::AcceptSave
 
 local destPath = m_simpleTV.Interface.FilePicker(t)
 if    destPath == nil then return end
 
 local sourcePath = m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Common.GetMainPath(1)) 
					.. '/LuaConfig/' .. pm.getConfigFile()
 
 m_simpleTV.Config.Sync(pm.getConfigFile())   
 local fhandle = io.open(sourcePath, "r")
 if fhandle == nil then 
    m_simpleTV.Interface.MessageBox(pm.tr("No data for export"),titleStr,0x10)
   return 
 end
 fhandle:seek("set", 0) 
 local data = fhandle:read("*a")
 fhandle:close()
  
 fhandle = io.open(destPath, "w+")
  if fhandle == nil then 
    m_simpleTV.Interface.MessageBox(pm.tr("Can't open destination file"),titleStr,0x10)
   return 
  end
 fhandle:write (data)
 fhandle:close()   
 
 m_simpleTV.Interface.MessageBox(pm.tr("File was saved in ") .. "'" .. destPath .. "'"  
								 ,titleStr,0x00)

end
----------------------------------------------------------------------

