--script getaddress filmon (14/04/2018)

---------------------------------------------------
require('json')

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr = m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

if not string.match(inAdr, '^filmonlivetv=' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
------------------------------------------------------------------------------
local session = m_simpleTV.Http.New()
if session == nil then return end

local retAdr = m_simpleTV.MainScriptDir .. "user/tvplaylists/filmon/tmp/tmp.m3u8"

m_simpleTV.User.Filmon01.Adress = nil
m_simpleTV.User.Filmon01.TimerOff = false
------------------------------------------------------------------------------
function filmon_callback_fun(session,rc,answer)
   if rc~=200 then m_simpleTV.Http.Close(session) return end
   --debug_in_file(answer .. '\n')
   
   local t = json.decode(answer)
   if t==nil then return end
   
   if t.data.streams[2].url~=nil then
   
      url = t.data.streams[2].url
 
      local p = string.gsub(url,'(.-stream/).-$','%1')
 
      rc,answer = m_simpleTV.Http.Request(session,{url = url})
      m_simpleTV.Http.Close(session)
      if rc~=200 then
     	   m_simpleTV.Http.Close(session)
     	   m_simpleTV.OSD.ShowMessage("Filmon - Connection error 3 " .. rc ,255,5)
     	   return
      end
 
      local str = string.gsub(answer,'(#EXTINF.-\n)','%1' .. p)
      --debug_in_file(str .. '\n')
 
      local fhandle = io.open(retAdr, 'w+')
      if fhandle == nil then return end
      fhandle:write(str)
      fhandle:close()
 
   end
 end
------------------------------------------------------------------------------
function GetFilmonStream()

  local session = m_simpleTV.Http.New()
  if session == nil then return end
  
  m_simpleTV.Http.RequestA(session,{url = m_simpleTV.User.Filmon01.Adress , callback = 'filmon_callback_fun'})

end
------------------------------------------------------------------------------
  
  local id = string.match(inAdr,'%d+')
  if id == nil then return end
  
  local url = 'http://www.filmon.com/api-v2/channel/' .. id .. '?protocol=hls'
  --debug_in_file(url .. '\n\n')
  
  if m_simpleTV.User.Filmon01.Adress == nil then
     m_simpleTV.User.Filmon01.Adress = url
  end

  local rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("Filmon - Connection error 1 " .. rc ,255,5)
 	   return
  end
    -- debug_in_file(answer .. '\n\n')


  local t = json.decode(answer)
  if t==nil then return end
   
  if t.data.streams[2].url~=nil then
  
     url = t.data.streams[2].url
     --debug_in_file(url .. '\n')

     local p = string.gsub(url,'(.-stream/).-$','%1')

     rc,answer = m_simpleTV.Http.Request(session,{url = url})
     m_simpleTV.Http.Close(session)
     if rc~=200 then
    	   m_simpleTV.Http.Close(session)
    	   m_simpleTV.OSD.ShowMessage("Filmon - Channel is currently unavailable "  ,255,5)
    	   return
     end

     local str = string.gsub(answer,'(#EXTINF.-\n)','%1' .. p)
     if string.match(str , 'TYPE:VOD') then
        m_simpleTV.User.Filmon01.TimerOff = true
     end
     --debug_in_file(str .. '\n')

     local fhandle = io.open(retAdr, 'w+')
     if fhandle == nil then return end
     fhandle:write(str)
     fhandle:close()

  end


  m_simpleTV.Control.CurrentAdress = retAdr 

