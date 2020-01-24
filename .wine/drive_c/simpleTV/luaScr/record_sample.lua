--!!!!  RENAME TO THIS FILE TO record.lua for work
--!!!!  Переименовать этот файл в record.lua 


--!! All strings in UTF8 !!
--m_simpleTV.Control.RecordChannelName   current channel name
--m_simpleTV.Control.RecordEpgName       current epg name (may be empty)
--m_simpleTV.Control.RecordFileName      current file name
--m_simpleTV.Control.RecordChannelId     id of channel
--m_simpleTV.Control.RecordEpgId         id of EPG (may be empty -1(invalide))
--m_simpleTV.Control.RecordType          type   -1 - snapshot,0 - timer, 2 - quick record
--m_simpleTV.Control.RecordSnapshotFileName  current snapshot file name
--m_simpleTV.Control.RecordTimeshiftOffset  

--example show how format file name
--local timestr = m_simpleTV.Common.string_toUTF8(os.date("%d--%m--%Y %H--%M--%S"))
--if m_simpleTV.Control.RecordEpgName~="" then    
--   m_simpleTV.Control.RecordFileName = m_simpleTV.Control.RecordChannelName .. ' (' .. m_simpleTV.Control.RecordEpgName .. ') ' .. timestr   
-- else 
--  m_simpleTV.Control.RecordFileName = m_simpleTV.Control.RecordChannelName .. ' [' .. timestr  .. ']'
--end
--[[

if m_simpleTV.Control.RecordEpgId>0 then
  local t = m_simpleTV.Database.GetTable('SELECT ProgData.* FROM ProgData WHERE (ProgData.IdProg=' .. m_simpleTV.Control.RecordEpgId .. ');')
  if t==nil or t[1]==nil or t[1].Start==nil or t[1].End==nil then return end 
  debug_in_file(m_simpleTV.Control.RecordEpgName .. '\n')
  debug_in_file(os.date('start - %c\n', t[1].Start))
  debug_in_file(os.date('end - %c\n', t[1].End))
  local div = t[1].End - t[1].Start  
  debug_in_file('sub - ' .. math.floor(div/3600) .. 'h:' .. math.floor((div%3600)/60) .. 'm')
  debug_in_file('\n\n')

end]]
--[[
 if m_simpleTV.Control.RecordType==-1 then
  m_simpleTV.Control.RecordSnapshotFileName = m_simpleTV.Control.RecordChannelName .. ' - ' .. m_simpleTV.Control.RecordEpgName
 end]]  

 --!! All strings in UTF8 !!
--m_simpleTV.Control.RecordChannelName current channel name
--m_simpleTV.Control.RecordEpgName current epg name (may be empty)
--m_simpleTV.Control.RecordFileName current file name

--example show how format file name
--local timestr = m_simpleTV.Common.string_toUTF8(os.date("%d--%m--%Y %H--%M--%S"))
--if m_simpleTV.Control.RecordEpgName~="" then 
-- m_simpleTV.Control.RecordFileName = m_simpleTV.Control.RecordChannelName .. ' (' .. m_simpleTV.Control.RecordEpgName .. ') ' .. timestr 
-- else 
-- m_simpleTV.Control.RecordFileName = m_simpleTV.Control.RecordChannelName .. ' [' .. timestr .. ']'
--end

--[[
--example for ver 0.5 
local function stringToTimestamp(str) 
 local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
 local runyear, runmonth, runday, runhour, runminute, runseconds = str:match(pattern)
 local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
 return convertedTimestamp
end

debug_in_file("channel id:" .. m_simpleTV.Control.RecordChannelId .. '\n')
debug_in_file("channel name:" .. m_simpleTV.Control.RecordChannelName .. '\n')
debug_in_file("channel address:" .. m_simpleTV.Control.CurrentAddress .. '\n')
debug_in_file("epg name:" .. (m_simpleTV.Control.RecordEpgName or '')  .. '\n' )
debug_in_file("epg id:" .. (m_simpleTV.Control.RecordEpgId or '')  .. '\n' )
if m_simpleTV.Control.RecordEpgId and m_simpleTV.Control.RecordEpgId>0 then
 local t = m_simpleTV.Database.GetTable('SELECT * FROM ChProg WHERE (ChProg.Id=' .. m_simpleTV.Control.RecordEpgId .. ');')
  if t~=nil and t[1]~=nil and t[1].StartPr~=nil and t[1].EndPr~=nil then 
   debug_in_file('epg start:' .. t[1].StartPr .. '\n')
   debug_in_file('epg end:' .. t[1].EndPr .. '\n')
   local div = stringToTimestamp(t[1].EndPr) - stringToTimestamp(t[1].StartPr)
   debug_in_file('epg sub - ' .. math.floor(div/3600) .. 'h:' .. math.floor((div%3600)/60) .. 'm')
   debug_in_file('\n')
  end
end

debug_in_file("file name:" .. m_simpleTV.Control.RecordFileName  .. '\n' )
debug_in_file("snapshot file name:" .. m_simpleTV.Control.RecordSnapshotFileName  .. '\n' )
debug_in_file("record type:" .. m_simpleTV.Control.RecordType  .. '\n' )
]]
--[[
local ExtFilterName=''
if m_simpleTV.Control.RecordChannelId>=0 then 
   local t = m_simpleTV.Database.GetTable(
   'SELECT ExtFilter.Name FROM Channels INNER JOIN ExtFilter ON Channels.ExtFilter = ExtFilter.Id WHERE (Channels.Id=' 
   .. m_simpleTV.Control.RecordChannelId ..');')
     if t~=nil and t[1]~=nil and t[1].Name~=nil then
      ExtFilterName =  ' - ' ..  t[1].Name;
     end
end

local timestr = m_simpleTV.Common.multiByteToUTF8(os.date("%d.%m.%Y %H-%M-%S"))
if m_simpleTV.Control.RecordEpgName~="" then 
   m_simpleTV.Control.RecordFileName = m_simpleTV.Control.RecordEpgName .. ' (' .. m_simpleTV.Control.RecordChannelName .. ')' 
   .. '[' .. timestr .. ']' .. ExtFilterName
 else 
  m_simpleTV.Control.RecordFileName = m_simpleTV.Control.RecordChannelName .. ' [' .. timestr .. ']' .. ExtFilterName
end
]]




