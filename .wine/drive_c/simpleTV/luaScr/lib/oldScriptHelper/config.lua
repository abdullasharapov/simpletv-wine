
m_simpleTV.Config.GetConfigInt = function(id) 
 local ret = m_simpleTV.Config.GetValue(id)
 if ret == nil then 
   if type(id)=="number" and id < 4100 then return 0 end
   return nil 
 end
 return tonumber(ret)
end
m_simpleTV.Config.SetConfigInt = function(id,val) m_simpleTV.Config.SetValue(id,val) end

m_simpleTV.Config.GetConfigString = function(id) 
 local ret = m_simpleTV.Config.GetConfigString_UTF8(id)
 if ret == nil then 
   if type(id)=="number" and id < 4100 then return '' end
   return nil 
 end
 return m_simpleTV.Common.string_fromUTF8(ret)
end
m_simpleTV.Config.GetConfigString_UTF8 = function(id) return m_simpleTV.Config.GetValue(id) end
									
m_simpleTV.Config.SetConfigString = function(id,val) 
 m_simpleTV.Config.SetConfigString_UTF8(id,m_simpleTV.Common.string_toUTF8(val))
end
m_simpleTV.Config.SetConfigString_UTF8 = function(id,val) m_simpleTV.Config.SetValue(id,val) end

m_simpleTV.Config.AddExtDialog = function (Name,HtmlUri,LuaUri)
local t ={}
t.name = m_simpleTV.Common.string_toUTF8(Name)
t.htmlUri = m_simpleTV.Common.string_toUTF8(HtmlUri)
t.luaUri  = m_simpleTV.Common.string_toUTF8(LuaUri)
m_simpleTV.Config.AddExtDialogT(t)
end


m_simpleTV.Config.SetElementValueString = m_simpleTV.Dialog.SetElementValueString
m_simpleTV.Config.SetElementValueString_UTF8 = m_simpleTV.Dialog.SetElementValueString_UTF8
m_simpleTV.Config.GetElementValueString = m_simpleTV.Dialog.GetElementValueString
m_simpleTV.Config.GetElementValueString_UTF8 = m_simpleTV.Dialog.GetElementValueString_UTF8
m_simpleTV.Config.AddComboValue = m_simpleTV.Dialog.AddComboValue
m_simpleTV.Config.AddComboValue_UTF8 = m_simpleTV.Dialog.AddComboValue_UTF8
m_simpleTV.Config.GetComboValue = m_simpleTV.Dialog.GetComboValue
m_simpleTV.Config.GetComboValue_UTF8 = m_simpleTV.Dialog.GetComboValue_UTF8
m_simpleTV.Config.SelectComboIndex = m_simpleTV.Dialog.SelectComboIndex
m_simpleTV.Config.GetCheckBoxValue = m_simpleTV.Dialog.GetCheckBoxValue
m_simpleTV.Config.SetCheckBoxValue = m_simpleTV.Dialog.SetCheckBoxValue
m_simpleTV.Config.AddEventHandler = m_simpleTV.Dialog.AddEventHandler
m_simpleTV.Config.SetElementText = m_simpleTV.Dialog.SetElementText
m_simpleTV.Config.SetElementText_UTF8 = m_simpleTV.Dialog.SetElementText_UTF8
m_simpleTV.Config.SetElementHtml = m_simpleTV.Dialog.SetElementHtml
m_simpleTV.Config.SetElementHtml_UTF8 = m_simpleTV.Dialog.SetElementHtml_UTF8
m_simpleTV.Config.GetElementHtml = m_simpleTV.Dialog.GetElementHtml
m_simpleTV.Config.GetElementHtml_UTF8 = m_simpleTV.Dialog.GetElementHtml_UTF8
m_simpleTV.Config.ExecScript = m_simpleTV.Dialog.ExecScript
m_simpleTV.Config.Close = m_simpleTV.Dialog.Close
