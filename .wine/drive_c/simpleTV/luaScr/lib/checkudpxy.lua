-----------------------------------------------------
module("checkudpxy", package.seeall )

require("socket")
-----------------------------------
--------- new ---------------------
function checkudpxy.checkhost(host, port,  timeout)
	if not host or not port or not host:find('%.') then  return -100   end  
	host = tostring(host)
	port = tonumber(port)
	if timeout == nil then timeout = 0.4 end
	local users = -99
	local conn = socket.tcp()
	if conn then
	    conn:settimeout(timeout) 
		conn:setoption('keepalive',true)
		conn:setoption('reuseaddr',true)
		conn:setoption('tcp-nodelay',true)
		local res, err = conn:connect(host, port)
		if res then	
		    local ret, err = conn:send("GET /status HTTP/1.0\r\n\r\n") 
		    local  s, err =  conn:receive("*l") 
		    if s then
		        if s:find("200 OK") then	    
			        str = conn:receive("*a") 
			        if str then users = str:match("    <td>(%d)</td>") or -1 end	 -- users not found -1
			    else users=-404   -- page not found
			    end 
			else users=-2        -- page /status not receive
			end
			conn:close()
		else users=-100           -- connect to host is bad
		end	    
	end
	return tonumber(users)
end

-----------------------------------------
function checkudpxy.checkstream(host, port, file, timeout)
	if not host or not port or not file or not host:find('%.') then  return false end  
  	if not timeout then  timeout = 6  end
  	local ret = false
	local conn = socket.tcp() 
    if conn ~= nil then
		conn:settimeout(0.3)
		conn:setoption('keepalive',true)		
		conn:setoption('reuseaddr',true)
		conn:setoption('tcp-nodelay',true)
		local res =conn:connect(host, port) 
		if res then 
		    conn:settimeout(timeout) 
		    conn:send("GET " .. (file or '/').. " HTTP/1.0\r\n\r\n")
		    local s, status = conn:receive(128)
		    if s ~= nil and s:find("200 OK") then
		      ret = true
		    end
		    conn:close()
		end
	end
  return ret
end
--------------------------------------
function checkudpxy.checkhostcon(host, port, timeout)
	if timeout == nil then  timeout = 0.4  end
	local ret = false
	local conn = socket.tcp() 
	conn:setoption('reuseaddr',true)
	conn:setoption('tcp-nodelay',true)	
	if conn ~= nil then
		conn:settimeout(timeout)
		if conn:connect(host, port) then  ret = true  end
		conn:close()
	end
	return ret
end

return checkudpxy