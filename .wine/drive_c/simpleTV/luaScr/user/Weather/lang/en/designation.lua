
local _lng = {
'temperature',
'humidity',
'pressure',
'mm Hg. Art.',
'wind',
'm/s',
'clouds',
'Weather',
'at',
'rain for 3h:',
'snow for 3h:',
}

local _wind = {
'northern',
'northeastern',
'eastern',
'southeastern',
'southern',
'southwestern',
'western',
'northwestern',
}

local _wind_s = {'N' ..string.char(0xE2,0x86,0x93),
				 'NE'..string.char(0xE2,0x86,0x99),
				 'E' ..string.char(0xE2,0x86,0x90),
				 'SE'..string.char(0xE2,0x86,0x96),
				 'S' ..string.char(0xE2,0x86,0x91),
				 'SW'..string.char(0xE2,0x86,0x97),
				 'W' ..string.char(0xE2,0x86,0x92),
				 'NW'..string.char(0xE2,0x86,0x98),
				 ''}

local _wind_s_xp = {'N','NE','E','SE','S','SW','W','NW',''}

local _time_of_day = { "morn", "day",    "even",   "night"    }	
			 
return _lng, _wind, _wind_s, _wind_s_xp   , _time_of_day          