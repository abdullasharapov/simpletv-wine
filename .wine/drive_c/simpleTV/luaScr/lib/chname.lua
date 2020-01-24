pcall (dofile,m_simpleTV.MainScriptDir .. "lib/channel_filter.lua")
pcall (dofile,m_simpleTV.MainScriptDir .. "lib/epg_filter.lua")

------------------------------------------------------------------
--local
------------------------------------------------------------------
local function GetAllEpgForChannel(Name,BaseTable)
  
  local t={}
  local w=1
  for i=1,#BaseTable do
   if Name == BaseTable[i][1] then
      t[w]=BaseTable[i]
      w=w+1  	  
  end 
 end
  return t
end
------------------------------------------------------------------
--local
------------------------------------------------------------------
local function GetEpgShiftByChannelNameFirst(OldName)
  if epgFilterTableFirst~=nil then 
   local t = GetAllEpgForChannel(OldName,epgFilterTableFirst)
    for i=1,#t do
     local q = m_simpleTV.Database.GetTable('SELECT Id FROM ChannelsEpg WHERE (ChannelsEpg.ChName="' ..  m_simpleTV.Common.string_toUTF8(t[i][2],1251) .. '");',true)     
	 if q~=nil and q[1]~=nil and q[1].Id~=nil then
			return t[i][2],-t[i][3]*2
     end			
    end 
   if #t>=1 then return t[1][2],-t[1][3]*2 end
 end
 return OldName,-1000
end
------------------------------------------------------------------
--local
------------------------------------------------------------------
local function GetEpgShiftByChannelNameSecond(OldName)
 
 --debug_in_file(OldName .. ' first:' .. tostring(first) .. '\n')
 if epgFilterTable~=nil then 
   local t = GetAllEpgForChannel(OldName,epgFilterTable)
    for i=1,#t do
     local s = 'SELECT Id FROM ChannelsEpg WHERE (ChannelsEpg.ChName="' ..  m_simpleTV.Common.string_toUTF8(t[i][2],1251) .. '");'
	 --debug_in_file(s .. '\n')
	 local q = m_simpleTV.Database.GetTable(s,true)
     
	 if q~=nil and q[1]~=nil and q[1].Id~=nil then
			return t[i][2],-t[i][3]*2
     end			
    end 
   if #t>=1 then return t[1][2],-t[1][3]*2 end
 end
  --debug_in_file('dfdf' .. '\n')
 local shift = string.match(string.gsub(OldName,' ',''),'%([+-]?%d+%)')
 if shift == nil then 
   OldName = string.gsub(OldName,'%(.-%)','')
   --debug_in_file(OldName .. '\n')
   return OldName,-1000
 end
 
 --debug_in_file('shift:' .. shift .. '\n')
 OldName  = string.gsub(OldName,'%(%s*[+-]?%d+%s*%)','')
 --debug_in_file('new name:' .. OldName .. '\n')
 shift = string.gsub(shift,'[%(%)%+]','')
 shift = -tonumber(shift)
 if shift<-24 or shift>24 then shift=-500 end
 return OldName,shift*2
end
------------------------------------------------------------------
--called from core
------------------------------------------------------------------
function GetEpgShiftByChannelName(OldName,first)
  if first then 
      return GetEpgShiftByChannelNameFirst(OldName)
   end
  return   GetEpgShiftByChannelNameSecond(OldName)
end
------------------------------------------------------------------
--called from core
------------------------------------------------------------------
function TestEpgAfter(NameChannel,NamePr)
  if string.match(NamePr,'%(%s*[+-]?%d+%s*%)') and not string.match(NameChannel,'%(%s*[+-]?%d+%s*%)') then
    return true
  end
 return false 
end
------------------------------------------------------------------
--called from core
------------------------------------------------------------------
function ClearChannelNameForLogo(OldName)
 OldName  = string.gsub(OldName,'%([+-]?%d+%)','')
 OldName = m_simpleTV.Common.replaceUTF8(OldName,m_simpleTV.Common.string_toUTF8('(дубль)',1251),'')
 return OldName
end
------------------------------------------------------------------ 
--called from core
------------------------------------------------------------------ 
function ChangeChannelName(OldName,MassNames)

 if MassNames==nil then 
  if DefaultMassNames==nil then return OldName end
  MassNames=DefaultMassNames 
 end

 for i=1,#MassNames do  
   if OldName==MassNames[i][1] then return MassNames[i][2] end
 end

 return OldName
end
------------------------------------------------------------------
