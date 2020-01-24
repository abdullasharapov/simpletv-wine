--This example shows how to search in range  from 'rtp://@233.33.220.0:5050' to 'rtp://@233.33.220.10:5050'

--this function should return the number of addresses
function Scan_GetCount(AllThreadsNumber)  
 --debug_in_file 	('Scan_GetCount(' .. AllThreadsNumber .. ')\n')
 return 10
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