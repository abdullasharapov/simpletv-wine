local luaEventHelper='\
 var gl_luaEventListenerArray = [];\
  function findInEventHelper(id,type,delete_only = false){\
   for(i=0,max=gl_luaEventListenerArray.length;i<max;i++){\
	 element = gl_luaEventListenerArray[i]\
     if( type==element.eventType && (element.elementId=="*" || element.elementId==id))\
	    {\
		 if(delete_only)\
		   {\
		    gl_luaEventListenerArray.splice(i,1)\
			break;\
		   }\
		 return element;\
		}\
	}\
   return null;\
  }\
  function luaEventHelperClick(e)\
  {\
   if (!e.target) return;\
   var i = findInEventHelper(e.target.id,"click");\
   if (i==null)\
    {\
	 for(n = 0,max = e.path.length;i<max;n++)\
	 {\
	  element = e.path[n];\
	  if(element.id == "") continue;\
	  i = findInEventHelper(element.id,"click");\
	  if(i!=null) break;\
	 }\
	}\
   if (i==null) return;\
   window.CHtmlDialog.callLua1(i.luaFun,e.target.id);\
  }\
  function luaEventHelperOnKeyUp(e)\
  {\
   if (!e.target) return;\
   var i = findInEventHelper(e.target.id,"keyup");\
   if (i==null) return;\
   window.CHtmlDialog.callLua2(i.luaFun,e.keyCode,e.target.id);\
  }\
  function luaEventHelperOnKeyDown(e)\
  {\
   if (!e.target) return;\
   var i = findInEventHelper(e.target.id,"keydown");\
   if (i==null) return;\
   window.CHtmlDialog.callLua2(i.luaFun,e.keyCode,e.target.id);\
  }\
  function luaAddEventListener(id,type,luaFun)\
  {\
   findInEventHelper(id,type,true)\
   gl_luaEventListenerArray.push({elementId:id,eventType:type,luaFun:luaFun});\
  }\
  document.addEventListener("click", luaEventHelperClick);\
  document.addEventListener("keyup", luaEventHelperOnKeyUp);\
  document.addEventListener("keydown", luaEventHelperOnKeyDown);\
'
-------------------------------------------------------------
local function LuaEventToJSEvent(Object,eventId,luaFun,elementId)
 local eventJS = nil
 if eventId == 'OnClick' then
	 eventJS = 'click'
 elseif eventId == 'OnClose' then
      m_simpleTV.Dialog.SetOnCloseEvent(Object,luaFun or '')
	  return nil  
 elseif eventId == 'OnKeyUp' then
	  eventJS = 'keyup'
 elseif eventId == 'OnKeyDown' then
	  eventJS = 'keydown'
 else
  error("Unsupported event (" .. eventId ..")" )
 end 
return eventJS
end  
-------------------------------------------------------------
function escapeJSString(str)
 if str == nil then return nil end
 str = string.gsub(str,'\\','\\\\')
 str = string.gsub(str,'"','\\"')
 str = string.gsub(str,'\n','\\n')
 str = string.gsub(str,'\r','\\r')
 return str
end
-------------------------------------------------------------
-------------------------------------------------------------
m_simpleTV.Dialog.Show = function(Name,UrlHtml,UrlLua,cx,cy,Flags,ParentObject)
local t={}
t.name = m_simpleTV.Common.string_toUTF8(Name)
t.urlHtml  = m_simpleTV.Common.string_toUTF8(UrlHtml)
t.urlLua  = m_simpleTV.Common.string_toUTF8(UrlLua)
t.flags = Flags
t.cx = cx
t.cy = cy
t.parent = ParentObject
return m_simpleTV.Dialog.ShowT(t)
end
-------------------------------------------------------------
-------------------------------------------------------------
m_simpleTV.Dialog.SetElementValueString = function(Object,Id,Value)
 m_simpleTV.Dialog.SetElementValueString_UTF8(Object,Id,m_simpleTV.Common.string_toUTF8(Value))
end
m_simpleTV.Dialog.SetElementValueString_UTF8 = function(Object,Id,Value)
 local scr = 'document.getElementById("' .. Id .. '").value = "' .. escapeJSString(Value) .. '";'
 m_simpleTV.Dialog.ExecScript(Object,scr)
end
-------------------------------------------------------------
m_simpleTV.Dialog.GetElementValueString = function(Object,Id)
 local ret = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,Id)
 if ret == nil then return nil end
 return m_simpleTV.Common.string_fromUTF8(ret)
end
-------------------------------------------------------------
m_simpleTV.Dialog.GetElementValueString_UTF8 = function(Object,Id)
 local scr = 'document.getElementById("' .. Id .. '").value'
 return m_simpleTV.Dialog.ExecScriptParam(Object,scr)
end
-------------------------------------------------------------
m_simpleTV.Dialog.AddComboValue = function(Object,Id,String,Index,Value)
 m_simpleTV.Dialog.AddComboValue_UTF8(Object,Id,m_simpleTV.Common.string_toUTF8(String),Index,Value~=nil and m_simpleTV.Common.string_toUTF8(Value) or nil)
end
-------------------------------------------------------------
m_simpleTV.Dialog.AddComboValue_UTF8 = function(Object,Id,String,Index,Value)
 Index = Index or -1
 local scr = 'var select=document.getElementById("' .. Id .. '");\
 var opt = new Option("' .. escapeJSString(String) .. '","' .. (escapeJSString(Value) or '') .. '");\
 select.options[' .. (Index>=0 and Index or 'select.options.length') .. '] = opt;'
 m_simpleTV.Dialog.ExecScript(Object,scr)
end
-------------------------------------------------------------
m_simpleTV.Dialog.GetComboValue = function(Object,Id,NeedValue)
 local ret = m_simpleTV.Dialog.GetComboValue_UTF8(Object,Id,NeedValue)
 if ret == nil then return ret end
 return m_simpleTV.Common.string_fromUTF8(ret)
end
-------------------------------------------------------------
m_simpleTV.Dialog.GetComboValue_UTF8 = function(Object,Id,NeedValue)
 if NeedValue then
   return m_simpleTV.Dialog.GetElementValueString_UTF8(Object,Id)
 else
  local scr = '(function (){var sel = document.getElementById("' .. Id .. '");\
if (sel == null || sel.selectedIndex<0) return "";\
return sel.options[sel.selectedIndex].text;})();'
return m_simpleTV.Dialog.ExecScriptParam(Object,scr)
 end 
end
-------------------------------------------------------------
m_simpleTV.Dialog.SelectComboIndex = function(Object,Id,Value)
 local scr = 'document.getElementById("' .. Id .. '").selectedIndex = ' .. tostring(Value) .. ';'
 m_simpleTV.Dialog.ExecScript(Object,scr)
end
-------------------------------------------------------------
m_simpleTV.Dialog.GetCheckBoxValue = function(Object,Id)
 local scr = 'document.getElementById("' .. Id .. '").checked;'
 return m_simpleTV.Dialog.ExecScriptParam(Object,scr) and 1 or 0
end
-------------------------------------------------------------
m_simpleTV.Dialog.SetCheckBoxValue = function(Object,Id,Value)
 local scr = 'document.getElementById("' .. Id .. '").checked = ' .. tostring(Value) .. ';'
 m_simpleTV.Dialog.ExecScript(Object,scr)
end
-------------------------------------------------------------
-------------------------------------------------------------
m_simpleTV.Dialog.RemoveEventHandler = function(Object,eventId,elementId)
 local eventJS = LuaEventToJSEvent(Object,eventId,elementId)
 if eventJS == nil then return end 
 if  m_simpleTV.Dialog.ExecScriptParam(Object,'(function(){return typeof(gl_luaEventListenerArray) == "undefined";})()') == true then
    return
 end
 local scr =  "findInEventHelper('" .. elementId .. "','" .. eventJS .. "',true);"
 m_simpleTV.Dialog.ExecScript(Object,scr)
end
-------------------------------------------------------------
m_simpleTV.Dialog.AddEventHandler = function(Object,eventId,elementId,luaFun)
 local eventJS = LuaEventToJSEvent(Object,eventId,luaFun,elementId)
 if eventJS == nil then return end
 
 if  m_simpleTV.Dialog.ExecScriptParam(Object,'(function(){return typeof(gl_luaEventListenerArray) == "undefined";})()') == true then
	m_simpleTV.Dialog.ExecScript(Object,luaEventHelper)
 end
 
 local scr = "luaAddEventListener('" .. elementId .. "','" .. eventJS .. "','" .. luaFun .."');"
 m_simpleTV.Dialog.ExecScript(Object,scr)
end
-------------------------------------------------------------
m_simpleTV.Dialog.SetElementText = m_simpleTV.Dialog.SetElementValueString
m_simpleTV.Dialog.SetElementText_UTF8 = m_simpleTV.Dialog.SetElementValueString_UTF8
-------------------------------------------------------------
m_simpleTV.Dialog.SetElementHtml = function(Object,Id,Html)
 m_simpleTV.Dialog.SetElementHtml_UTF8(Object,Id,m_simpleTV.Common.string_toUTF8(Html))
end
-------------------------------------------------------------
m_simpleTV.Dialog.SetElementHtml_UTF8 = function(Object,Id,Html)
 local scr = 'document.getElementById("' .. Id .. '").innerHTML = "' .. escapeJSString(Html) .. '";'
 --debug_in_file(scr .. '\n\n\n\n')
 m_simpleTV.Dialog.ExecScript(Object,scr)
end
-------------------------------------------------------------
m_simpleTV.Dialog.GetElementHtml = function(Object,Id)
 local ret = m_simpleTV.Dialog.GetElementHtml_UTF8(Object,Id)
 if ret==nil then return nil end
 return m_simpleTV.Common.string_fromUTF8(ret)
end
-------------------------------------------------------------
m_simpleTV.Dialog.GetElementHtml_UTF8 = function(Object,Id)
 local scr = 'document.getElementById("' .. Id .. '").innerHTML'
 return m_simpleTV.Dialog.ExecScriptParam(Object,scr)
end
-------------------------------------------------------------

