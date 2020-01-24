function OnNavigateComplete(Object)

--m_simpleTV.jsUnpacker.EncodeText
local scr
if m_simpleTV.jsUnpacker.PreScr~=nil then
	scr = m_simpleTV.jsUnpacker.PreScr
	param = m_simpleTV.jsUnpacker.Param
    --debug_in_file(scr .. '\n\n\n') 
    m_simpleTV.Dialog.ExecScript(Object,scr,"javascript")
end	
 if param == nil or param == 1 then
 scr = "var idd = document.getElementById('dtext');if (idd != null) idd.innerHTML = " .. m_simpleTV.jsUnpacker.EncodeText
 m_simpleTV.Dialog.ExecScript(Object,scr,"javascript")
 
 m_simpleTV.jsUnpacker.DecodeText =  m_simpleTV.Dialog.GetElementHtml(Object,'dtext')
  --debug_in_file(m_simpleTV.jsUnpacker.DecodeText .. '\n') 
elseif param == 0 then
 scr = 'window.external.CallLua1(' .. m_simpleTV.jsUnpacker.EncodeText .. ');'
 m_simpleTV.Dialog.ExecScript(Object,scr,"javascript")
end
 
 if m_simpleTV.jsUnpacker.NotHide==true then return end
 
 m_simpleTV.Dialog.ExecScriptParam(Object,'(function(){return "";})();')  
 m_simpleTV.Dialog.Close(Object);
end

 if param == 0 then
  function JSCallBack1(Object,param_utf8)
    m_simpleTV.jsUnpacker.DecodeText =  param_utf8
  end
end