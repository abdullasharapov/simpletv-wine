
--This example shows how to search in range  from 'rtp://@233.33.220.0:5050' to 'rtp://@233.33.220.10:5050'
--!!!!all strings in UTF8!!!!-----
---------------------------------------------------------
-- start new ( Scan_GetVersion() >=1 )
---------------------------------------------------------
function Scan_GetVersion()  --this function should return version number
 return 1 -- 1 -  script must have Scan_Init()
end
---------------------------------------------------------
--Init the script
--start = false  - user does choice in the script's combo window
--start = true   - user press on Start button
---------------------------------------------------------
function Scan_Init(start)  
 t ={}
 
 --all values are optional 
 
 t.HaveOnFound  = true      --script have OnFound
 t.HaveOnConfig = true      --script have OnConfig and config button
 t.HaveOnInfo   = true      --script have OnInfo and Info button
 t.HaveParseAddress  = true   --script have ParseAddress
 t.HaveParseName   = true   --script have ParseName
 
 --Reorder main values 
 t.ThreadsCount  = 10     --value >1..100 
 t.Timeout  = 10   	 --value >0 in sec
 t.TryName  =  -1         --value >=0   
 --Update 24.10.2016
 t.TryDrm   =  -1         --value >=0   
 
 return t 
end
---------------------------------------------------------
function Scan_OnConfig() --Press on Config button
  m_simpleTV.Interface.MessageBox( m_simpleTV.Common.string_toUTF8('Example of Config'),'Config',0) --MB_OK 
end
---------------------------------------------------------
function Scan_OnInfo()  --Press on Info button
 m_simpleTV.Interface.MessageBox( m_simpleTV.Common.string_toUTF8('Example of Info'),'Info',0) --MB_OK 
end
---------------------------------------------------------
--!!!is calling from worker thread, all gui calls must be disabled!!!
--addressToFindInDB - formated  for search in DB - 'like "%address%"'
--addressToSaveInDB - pure address
---------------------------------------------------------
function Scan_ParseAddress(addressToFindInDB,addressToSaveInDB,Index )
  return addressToFindInDB,addressToSaveInDB 
end
---------------------------------------------------------
--!!!is calling from worker thread, all gui calls must be disabled!!!
--Type - see retT.Type in Scan_OnFound()
---------------------------------------------------------
function Scan_ParseName (NameToShow,NameToSave,Index,Type,Drm)
  return NameToShow,NameToSave 
end
---------------------------------------------------------
--this function must handle the end of scanning the address
--if present Scan_OnFound then Scan_ParseAddress(),Scan_ParseName() not call, not search in DB, the return values append directly to the scan tree.
--!!!is calling from worker thread, all gui calls must be disabled!!!
---------------------------------------------------------
function Scan_OnFound(foundT)  
 --in values
 --foundT.Index     -  Index 
 --foundT.Address   -  Address
 --foundT.ExtStr    -  Ext string (vsize, etc)
 --foundT.Name      -  Name from meta (may be empty)  
 --foundT.Publisher -  Publisher from meta (may be empty)  
 --foundT.Work      -  true if address replied
 --foundT.Drm       -  true if drm - valide if CheckDrm is on (Update 24.10.2016)
	
 debug_in_file 	('foundT.Index = ' .. foundT.Index .. '\nfoundT.Address = ' .. foundT.Address .. '\nfoundT.ExtStr = ' .. foundT.ExtStr .. '\nfoundT.Name = ' .. foundT.Name .. '\nfoundT.Publisher = ' .. foundT.Publisher .. '\nfoundT.Work = ' .. tostring(foundT.Work) .. '\n\n\n\n') 
	
 --return values	
 local retT={}
 if not foundT.Work then return end
 
 retT.Type = 0  --  -1 - not append,all other fields not required
			    --   0 - New channel
				--   1 - Channel in DB (ChannelID are valid)
				--   2 - PiP Channel (ChannelID are valid)
				--   3 - Not work (ChannelID are valid)				
				--   4 - Drm (ChannelID are valid)				
 retT.ChannelID = -1
 retT.Address = foundT.Address
 retT.NameToShow = 'name to show'
 retT.NameToSave = 'name to save'
 --retT.Drm = foundT.Drm  -- optional (Update 24.10.2016)
 
 return retT
end
---------------------------------------------------------
-- end new
---------------------------------------------------------
--this function should return the number of addresses
function Scan_GetCount(AllThreadsNumber)  
 --debug_in_file 	('Scan_GetCount(' .. AllThreadsNumber .. ')\n')
 return 255
end
---------------------------------------------------------
--this function should return the address by Index
--Index - current index
--ThreadNumber - current thread number
---------------------------------------------------------
function Scan_GetAddress(Index,ThreadNumber) 
 
 --debug_in_file 	('Scan_GetAddress(' ..  Index .. ',' .. ThreadNumber .. ')\n')
 return 'rtp://@233.33.220.' .. Index ..':5050'
 
end
---------------------------------------------------------