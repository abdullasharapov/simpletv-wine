require("recordPattern")
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
local function translateHtml(Object)

local function getJsTr(str)
  return 'm_globalTranslateMap.set("' .. escapeJSString(str) .. '","' .. escapeJSString(recordPattern.tr(str)) .. '");'
end

  local scr ='m_globalTranslateMap.set("Record Pattern","' .. escapeJSString( 'Record Pattern v' .. recordPattern.getVersion() ) .. '");'
			 ..	getJsTr('Channel')
			 ..	getJsTr('Group')
			 ..	getJsTr('ExtFilter')
			 ..	getJsTr('EPG')
			 ..	getJsTr('Time')
			 ..	getJsTr('Timeshift')
			 ..	getJsTr('Reset')
			 ..	getJsTr('Format for record')
			 ..	getJsTr('Format for snapshot')
		     ..	getJsTr('Format for time')
			 ..	getJsTr('EPG category')
			 ..	getJsTr('EPG start')
			 ..	getJsTr('EPG end');
				 
  m_simpleTV.Dialog.ExecScript(Object,scr)
  m_simpleTV.Dialog.ExecScript(Object,'doTranslate();')

end
----------------------------------------------------------------------
function baseInit(Object)
 
 local recordFormat,snapshotFormat,timeFormat,setEnabled = recordPattern.getVals()
 
 local scr = 'setRecordPattern("' .. escapeJSString(recordFormat) .. '");'
 m_simpleTV.Dialog.ExecScript(Object,scr)   

 scr = 'setSnapshotPattern("' .. escapeJSString(snapshotFormat) .. '");'
 m_simpleTV.Dialog.ExecScript(Object,scr)   
 
 scr = 'setTimePattern("' .. escapeJSString(timeFormat) .. '");'
 m_simpleTV.Dialog.ExecScript(Object,scr)   
 
 scr = 'setEnabled(' .. setEnabled .. ');'
 m_simpleTV.Dialog.ExecScript(Object,scr)   
 
 updateRecordPreview(Object,recordFormat,timeFormat)
 updateSnapshotPreview(Object,snapshotFormat,timeFormat)
 updateTimePreview(Object,timeFormat)
  
 m_simpleTV.Dialog.ExecScript(Object,'startUp()')   
  
end
----------------------------------------------------------------------
function OnNavigateComplete(Object)
  translateHtml(Object)
  baseInit(Object)
end
----------------------------------------------------------------------
function OnOk(Object)
 local recordFormat = m_simpleTV.Dialog.ExecScriptParam(Object,'getRecordPattern();')  
 local snapshotFormat = m_simpleTV.Dialog.ExecScriptParam(Object,'getSnapshotPattern();')  
 local timeFormat = m_simpleTV.Dialog.ExecScriptParam(Object,'getTimePattern();')  
 local setEnabled = m_simpleTV.Dialog.ExecScriptParam(Object,'getEnabled();')  
 if setEnabled then setEnabled = 1 else setEnabled = 0 end   
 recordPattern.save(recordFormat,snapshotFormat,timeFormat,setEnabled)
 recordPattern.reload() 
end
----------------------------------------------------------------------
--From html
----------------------------------------------------------------------
local function patternToString(inPattern,timePattern)

 local t ={}
 t.CHANNEL_NAME    = recordPattern.tr('channel name')
 t.CHANNEL_GROUP   = recordPattern.tr('group name')
 t.CHANNEL_EXTFILTER = recordPattern.tr('ExtFilter')
 t.TIMESHIFT_OFFSET = '1001'
 t.timeFormat      = timePattern

 t.EPG_TITLE       = recordPattern.tr('EPG title')
 t.EPG_START  	   = recordPattern.timeFormatToStr(recordPattern.getEpgTimeFormat())
 t.EPG_END    	   = recordPattern.timeFormatToStr(recordPattern.getEpgTimeFormat())
 t.EPG_CAT         = recordPattern.tr('EPG category')
  
 return recordPattern.getFileName ( inPattern,t )
end								   
----------------------------------------------------------------------
function updateRecordPreview(Object,inPattern,timePattern) 
 local scr = 'setPreviewRec("' .. escapeJSString(patternToString(inPattern,timePattern) or '') .. '");'
 m_simpleTV.Dialog.ExecScript(Object,scr)   
end
----------------------------------------------------------------------
function updateSnapshotPreview(Object,inPattern,timePattern)
 local scr = 'setPreviewSnap("' .. escapeJSString(patternToString(inPattern,timePattern) or '') .. '");'
 m_simpleTV.Dialog.ExecScript(Object,scr)   
end
----------------------------------------------------------------------
function updateTimePreview(Object,timePattern)  
 local str = recordPattern.timeFormatToStr(timePattern)
 local scr = 'setPreviewTime("' .. escapeJSString(str) .. '");'
 m_simpleTV.Dialog.ExecScript(Object,scr)   
end
----------------------------------------------------------------------
function resetToDefaults(Object)  
 recordPattern.save('','','',1)
 recordPattern.reload() 
 baseInit(Object)
end