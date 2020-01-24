local base = _G
module("recordPattern")

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
local m_currentRecordFileFormat = ''
local m_currentSnapshotFileFormat = ''
local m_currentTimeFormat = '%d.%m.%y %H-%M-%S' 
local m_epgTimeFormat = '%H-%M'
local m_Enabled = 1
---------------------------------------------------------------------------------  
---------------------------------------------------------------------------------
function getVersion()
 return '0.2'
end
---------------------------------------------------------------------------------
function tr(str)
  return base.m_simpleTV.Interface.Translate(str,'simpleTV::recordPattern')
end
------------------------------------------------------------------------------
local function getExtFilterName(id)
 local extFilterName='' 
 if id>=0 then 
   local t = base.m_simpleTV.Database.GetTable(
   'SELECT ExtFilter.Name FROM Channels INNER JOIN ExtFilter ON Channels.ExtFilter = ExtFilter.Id WHERE (Channels.Id=' 
   .. id ..');')
   if t~=nil and t[1]~=nil and t[1].Name~=nil then
      extFilterName =  t[1].Name;
   end
 end
 return  extFilterName
end
---------------------------------------------------------------------------------
local function getGroupName(id)
 local grName='' 
 if id>=0 then 
   local t = base.m_simpleTV.Database.GetTable(
   'SELECT Channels.[Group] FROM Channels WHERE (Channels.Id='.. id ..');')
   if t~=nil and t[1]~=nil and t[1].Group~=nil and base.type(t[1].Group)=='number' and t[1].Group>0 then
      t = base.m_simpleTV.Database.GetTable(
	  'SELECT Channels.Name FROM Channels WHERE (Channels.Id='.. t[1].Group ..');')	  
      if t~=nil and t[1]~=nil and t[1].Name~=nil then
	     grName =  t[1].Name;
	  end 
   end
 end   
 return  grName
end
---------------------------------------------------------------------------------
local function getEpgInfo(id)
 local epgInfo = nil 
 if id and id>0 then 
   local t = base.m_simpleTV.Database.GetTable(
             'SELECT * FROM ChProg WHERE (ChProg.Id=' .. id .. ');')
   if t~=nil and t[1]~=nil then
	    epgInfo =  t[1]    
   end
 end   
 return  epgInfo
end
---------------------------------------------------------------------------------
local function truncateUtf8(str,n)

  if base.m_simpleTV.Common.midUTF8~=nil then
    return base.m_simpleTV.Common.midUTF8(str,0,n)
  end 
 --str = base.m_simpleTV.Common.UTF8ToMultiByte(str)
 str:sub(1,n*2)
 --str = base.m_simpleTV.Common.multiByteToUTF8(str) 
 return str
end
---------------------------------------------------------------------------------
local function replaceOrRemove(str,varName,value) 
 value = value or '' 
 str = str:gsub('(%b"")',function(x) 
				    if x:match(varName) then 
					  if value=='' then return '' end
					  x = x:gsub('"','')
					  return x:gsub(varName,value)
					else
                     return x
				    end					 
				 end) 
 str = str:gsub(varName,value)                   
 return str 
end
---------------------------------------------------------------------------------
local function finalClean(str)   
  str = str:gsub('(%b"")',function(x) x=x:gsub('^"','«');return x:gsub('"$','»') end)
  str = str:gsub(':','᎓')
  --TODO ...
  str = str:gsub('[\\/"%*<>%|%?]+', '_')  
  
  str = truncateUtf8(str,240)
 
 return str
end
---------------------------------------------------------------------------------
------------------------------------------------------------------------------
local function getConfigFile()
 return "recordPattern.ini"
end
------------------------------------------------------------------------------
local function getConfigVal(key)
 return base.m_simpleTV.Config.GetValue(key,getConfigFile())
end
------------------------------------------------------------------------------
local function setConfigVal(key,val)
  base.m_simpleTV.Config.SetValue(key,val,getConfigFile())
end
------------------------------------------------------------------------------
--Interface
------------------------------------------------------------------------------
function timeFormatToStr(timePattern,t)
 
 timePattern = timePattern or ''
 timePattern = timePattern:gsub('%%[^aAbBcdHIMmpSwxXYy%%]','')
 
 if t==nil then t = base.os.time() end 
  
 return  base.m_simpleTV.Common.multiByteToUTF8(base.os.date(timePattern,t)) 

end
------------------------------------------------------------------------------
function getFileName(outStr,t)
   
 if outStr==nil or  outStr=='' then return end
 
 local currentTimeStr = timeFormatToStr(t.timeFormat or m_currentTimeFormat)
 
 t.CHANNEL_GROUP = t.CHANNEL_GROUP or ''
 t.CHANNEL_GROUP = truncateUtf8(t.CHANNEL_GROUP,25)
 
 t.CHANNEL_EXTFILTER = t.CHANNEL_EXTFILTER or ''
 t.CHANNEL_EXTFILTER = truncateUtf8(t.CHANNEL_EXTFILTER,25)
 
 t.TIMESHIFT_OFFSET = t.TIMESHIFT_OFFSET or ''
  
 t.CHANNEL_NAME = t.CHANNEL_NAME or ''
 t.CHANNEL_NAME = truncateUtf8(t.CHANNEL_NAME,30)
 
 t.EPG_TITLE = t.EPG_TITLE or ''
 t.EPG_TITLE = truncateUtf8(t.EPG_TITLE,160)
 t.EPG_START = t.EPG_START or ''
 t.EPG_END   = t.EPG_END   or '' 
 t.EPG_CAT   = t.EPG_CAT    or '' 
 t.EPG_CAT   = truncateUtf8(t.EPG_CAT,25)
		
 outStr = replaceOrRemove(outStr,'CHANNEL_NAME',t.CHANNEL_NAME)
 outStr = replaceOrRemove(outStr,'CHANNEL_GROUP',t.CHANNEL_GROUP)
 outStr = replaceOrRemove(outStr,'CHANNEL_EXTFILTER',t.CHANNEL_EXTFILTER)
 
 outStr = replaceOrRemove(outStr,'EPG_TITLE',t.EPG_TITLE) 
 outStr = replaceOrRemove(outStr,'EPG_START',t.EPG_START)
 outStr = replaceOrRemove(outStr,'EPG_END',t.EPG_END)
 outStr = replaceOrRemove(outStr,'EPG_CAT',t.EPG_CAT)
 
 outStr = replaceOrRemove(outStr,'CURRENT_TIME',currentTimeStr)
 outStr = replaceOrRemove(outStr,'TIMESHIFT_OFFSET',t.TIMESHIFT_OFFSET)
  
 outStr = finalClean(outStr)

  --debug_in_file(outStr .. '\n' ) 
  return outStr
end
------------------------------------------------------------------------------
function getFileNameById(recordType,channelId,channelName,epgTitle,epgId,timeshiftOffset)

 if m_Enabled~=1 or channelId <0 then return end
  
 local outStr 
 if recordType==0 or recordType==2 then
    outStr = m_currentRecordFileFormat
  elseif recordType==-1 then
    outStr = m_currentSnapshotFileFormat
  else
     return 
 end	  
 
 local t={} 
 t.CHANNEL_NAME    = channelName
 t.CHANNEL_GROUP   = getGroupName(channelId)
 t.CHANNEL_EXTFILTER = getExtFilterName(channelId) 
 if timeshiftOffset and timeshiftOffset>0 then  
   t.TIMESHIFT_OFFSET = '' .. base.math.floor(timeshiftOffset/1000)
 end   
 
 t.EPG_TITLE       = epgTitle
 if epgId and epgId>0 then
	local epgT = getEpgInfo(epgId)
	if epgT~=nil then 
 
       local function stringToTimestamp(str) 
			local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
			local runyear, runmonth, runday, runhour, runminute, runseconds = str:match(pattern)
			local convertedTimestamp = base.os.time({year = runyear, month = runmonth, day = runday
													, hour = runhour, min = runminute
													, sec = runseconds})
			return convertedTimestamp
	   end
	t.EPG_START  = timeFormatToStr(m_epgTimeFormat,stringToTimestamp(epgT.StartPr))
	t.EPG_END    = timeFormatToStr(m_epgTimeFormat,stringToTimestamp(epgT.EndPr))
	t.EPG_CAT    = epgT.Category
 	end
 end
 
 return getFileName(outStr,t)
end 
------------------------------------------------------------------------------
function getEpgTimeFormat()
 return m_epgTimeFormat
end
------------------------------------------------------------------------------
function getVals()
 return  m_currentRecordFileFormat 
		,m_currentSnapshotFileFormat
		,m_currentTimeFormat
		,m_Enabled
end
------------------------------------------------------------------------------
function reload() 
 m_currentRecordFileFormat = getConfigVal('recordFormat') 
 if m_currentRecordFileFormat==nil or m_currentRecordFileFormat=='' then
   m_currentRecordFileFormat = '[CURRENT_TIME" - timeshift TIMESHIFT_OFFSET s"]" EPG_TITLE "[CHANNEL_NAME]'
 end   
 
 m_currentSnapshotFileFormat = getConfigVal('snapshotFormat') 
 if m_currentSnapshotFileFormat==nil or  m_currentSnapshotFileFormat=='' then
  m_currentSnapshotFileFormat = '[CURRENT_TIME" - timeshift TIMESHIFT_OFFSET s"]" EPG_TITLE "[CHANNEL_NAME]'
 end
 
 m_currentTimeFormat = getConfigVal('timeFormat') 
 if m_currentTimeFormat==nil or m_currentTimeFormat=='' then
   m_currentTimeFormat = '%d.%m.%y %H-%M-%S'  
 end   
 
 m_Enabled = getConfigVal('enabled') or 1
 
end
------------------------------------------------------------------------------
function save(recordFormat,snapshotFormat,timeFormat,enabled)
 
 if recordFormat~=nil then 
   setConfigVal('recordFormat',recordFormat)
 end 
 if snapshotFormat~=nil then 
   setConfigVal('snapshotFormat',snapshotFormat)
 end
 if timeFormat~=nil then 
	setConfigVal('timeFormat',timeFormat)
 end	
 
 if enabled~=nil then
    setConfigVal('enabled',enabled)
 end
end
------------------------------------------------------------------------------
--Startup init
------------------------------------------------------------------------------
reload()
 