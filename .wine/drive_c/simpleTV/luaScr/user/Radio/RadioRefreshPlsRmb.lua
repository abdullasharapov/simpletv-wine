 require 'json' 

--local testString = [[ { "one":1 , "two":2, "primes":[2,3,5,7] } ]]
--local test_tab = json.decode(testString) 
--local json = require ('dkjson')

------------------------------------------
local function best(t)
    local current=0
	local i=0
	for k,v in pairs(t) do
	    i = tonumber(k)
        if i == nil or i == 0 then 
		    i = 64
		    if     k == 'low'   then  i= 32 
			elseif k == 'hight' then  i= 320 
			end
		end
		t[i] = v	
		current = math.max(current,i)		
	end
	local kbps = current
	if current == 32 then kbps='low'
	elseif current == 320 then kbps='hight'
	end
	return kbps, t[current]
end
--------------------------------------------

--local logfile = m_simpleTV.MainScriptDir .. 'user\\Radio\\DebugRmb.log'
--debug_in_file('DEBUG:\n\n',logfile,'new')

local ExtFilter = 'Radio'
local UpdateID  = 'RABMLER01'
 
local url =  'http://audio.rambler.ru/interface/radio/list/'  -- 


 local session=m_simpleTV.WinInet.New("Opera/12.54 (Windows NT 6.1; RU; ru) Presto/2.9.168 Version/11.52")
 if session == nil then return end
 --INTERNET_OPTION_CONNECT_TIMEOUT
 m_simpleTV.WinInet.SetOptionInt(session,2,3000,0)
 --INTERNET_OPTION_RECEIVE_TIMEOUT
 m_simpleTV.WinInet.SetOptionInt(session,6,6000,0)
 local rc, data =  m_simpleTV.WinInet.Get(session,url) 
 m_simpleTV.WinInet.Close(session) 

if rc~=200 then
	m_simpleTV.OSD.ShowMessage(' Net error:'.. rc, 0x00ffff,5) 
	return 
end	
if not data then 
  	 m_simpleTV.OSD.ShowMessage('Error data.',0xFF00,5)
	return 
end


--local out_m3u  = '#EXTM3U $ExtFilter="'..ExtFilter..'" $BorpasFileFormat="1"\n'
local out_m3u  = '#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\Rambler\\"\n'

data = data:gsub ('null,','"",')

data = data:gsub('%[%],','[""],')
data = m_simpleTV.Common.string_fromUTF8(data)

local  tab = json.decode(data) 

str=''
for k, v in pairs(tab) do
   if v.name then
    if not v.region then v.region='Россия' end
	local bitrate, stream = best(v.streams)
	v.name   = v.name:gsub ('[%.%,]',' ')
	--v.region = v.region:gsub ('[%.%,]',' ')
	--out_m3u = out_m3u ..'#EXTINF:-1  skipepg="1" group-title="Rambler '.. v.region..'" tvg-logo="'..v.logo.page.. '"'	
	--out_m3u = out_m3u ..' update-code="' .. UpdateID .. v.name .. '",' .. v.name..'\n'..stream ..'\n'
	out_m3u = out_m3u ..'#EXTINF:-1  skipepg="1" group-title="Rambler Radio"'	
	out_m3u = out_m3u ..' update-code="' .. UpdateID .. v.name .. '",' .. v.name..'\n'..stream ..'\n'
   end
end

----------------------------
--local _file = m_simpleTV.MainScriptDir .. 'user\\Radio\\RamblerRadio.m3u'
--debug_in_file(out_m3u, _file, true)
--os.remove(rambler_m3u_file)
--if true then return end	
-------------------------

 local tmpName = m_simpleTV.Common.GetTmpName()
  if tmpName==nil then 
  	 m_simpleTV.OSD.ShowMessage('Error get tmp filename.',0xFF00,5)
     return 
 end 
 local tfile = io.open(tmpName,'w+')
 if tfile==nil then 
	os.remove(tmpName)
	 m_simpleTV.OSD.ShowMessage('Error open tmp file : '..tmpName,0xFF00,5)
	return
 end
  
 tfile:write(out_m3u)
 tfile:close() 


local p={}
p.TypeSourse = 1
p.DeleteBeforeLoad = 0
p.TypeSkip   = 1
p.TypeFind =   0
p.AutoSearch = 1
p.NumberM3U =  0
p.Find_Group = 1
p.TypeCoding = 0  --  -1-auto  0 - plane text  1- UTF8  2- unicode
p.BorpasFileFormat=1
p.ExtFilter = ExtFilter
p.AutoNumber = 0
p.UpdateID = UpdateID 
p.NotDeleteWhenRefresh = 0
p.ExtFilterLogo =  '..\\Channel\\logo\\icons\\radio.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'Rambler playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList (tmpName,p,m_simpleTV.User.Radio.TypeMedia,true,false)
os.remove(tmpName)

if err==true then
     local mess = "Rambler - радиостанции обновлены (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage(mess,0xFF00,5)
	 
end
