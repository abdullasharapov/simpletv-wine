--script for http://spbtv.com (07/06/2018)

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

if  not string.match( inAdr, '^spbfreetv=' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
----------------------------------------------------------------
local session = m_simpleTV.Http.New()
if session == nil then return end
---------------------------------------------------------------

 local id = string.match(inAdr, '^spbfreetv=ch_(.+)')
 if id == nil then return end
-- debug_in_file(id .. '\n')

 local  url = ' http://tv3.spr.spbtv.com/v1/channels/' .. id .. '/stream?protocol=hls' 
 
 local rc,answer= m_simpleTV.Http.Request(session,{url=url,headers='Referer: http://spbtv.online/'})
 --m_simpleTV.Http.Close(session)
 
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("spbtv Connection error - 1 " .. rc ,255,10)
 	   return
  end

  --debug_in_file(answer ..  '\n')

  url = findpattern(answer,'"url":"(.-)"',1,7,1)
  if url == nil then return end

 local strm = string.match(url,'^http.+/')

 local rc,answer= m_simpleTV.Http.Request(session,{url=url,headers='Referer: http://spbtv.online/'})
 m_simpleTV.Http.Close(session)
 
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("spbtv Connection error - 2 " .. rc ,255,10)
 	   return
  end

--debug_in_file(answer ..  '\n')
--do return end

 local t={}
 local i=1
 local name,adr
 local retAdr
 
 for w in string.gmatch(answer,'#EXT%-X%-STREAM%-INF(.-\n.-)\n') do 
 
     name = string.match(w,'RESOLUTION=(.-)\n')
     adr = string.match(w,'\n(.+)')
 
    if not name or not adr then break end
 
     t[i]={}
     t[i].Id=i
     t[i].Name=name
     t[i].Adress=strm..adr
     --debug_in_file(t[i].Name .. '  ' .. t[i].Adress .. '\n')
     i=i+1
 
 end
 
 if i>1 then
   retAdr = t[1].Adress
 end
 
 if i>2 then
    m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.Common.string_toUTF8('Качество') ,0,t,10000,32+64+128)
 end

m_simpleTV.Control.CurrentAdress = retAdr 
