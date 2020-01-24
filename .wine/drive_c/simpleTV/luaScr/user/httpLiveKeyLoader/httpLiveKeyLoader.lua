function httpLiveKeyLoader_nop()
end

function httpLiveKeyLoader_Log(str,verbose)
 m_simpleTV.Logger.WriteToLog(str,(verbose or 3),'httpLiveKeyLoader')
end
 
function httpLiveKeyLoader_Close(id)
 httpLiveKeyLoader_Log('close id:' ..  id)
 SmartDRM.close(id)
end

function httpLiveKeyLoader_Get (id,url)

 if string.match(url,"https://vmxott%.svc%.iptv%.rt%.ru/CAB/keyfile") then
    
    httpLiveKeyLoader_Log('key request id:' ..  id .. ',url:' .. url)
	url = url .. '&'
	local r_param = string.match(url,'r=(.-)&')
	local p_param = string.match(url,'p=(.-)&')

	httpLiveKeyLoader_Log('r:' ..  r_param .. ',p:'  .. p_param)

	local key,err = SmartDRM.getkey(id,p_param,r_param)
	if key==nil then 
	    httpLiveKeyLoader_Log('Get key failed ('  .. (err or 'undefined')  .. ')' ,1)
	  return 2,''
	end
	httpLiveKeyLoader_Log('Got key:' .. key)
	return 1,key     
 end	
 
if string.match(url,"http://drm%.svc%.moyo%.tv/CAB/keyfile") then	
	httpLiveKeyLoader_Log('key request(m) id:' ..  id .. ',url:' .. url)
	url = url .. '&'
	local r_param = string.match(url,'r=(.-)&')
	local p_param = string.match(url,'p=(.-)&')

	httpLiveKeyLoader_Log('r:' ..  r_param .. ',p:'  .. p_param)

	local key,err = SmartDRM_M.getkey(id,p_param,r_param)
	if key==nil then 
	    httpLiveKeyLoader_Log('Get key failed ('  .. (err or 'undefined')  .. ')' ,1)
	  return 2,''
	end
	httpLiveKeyLoader_Log('Got key(m):' .. key)
	return 1,key     
 end
 
 return 0,''
end

local str =  'user/httpLiveKeyLoader/core'
if m_simpleTV.Common.isX64() then str = str .. '/x64' end
if not string.match(package.cpath,str , 0)  then
	package.cpath = package.cpath .. ';' .. m_simpleTV.MainScriptDir .. str .. '/?.' .. m_simpleTV.Common.GetCModuleExtension()
end

require('SmartDRM')
require('SmartDRM_M')
