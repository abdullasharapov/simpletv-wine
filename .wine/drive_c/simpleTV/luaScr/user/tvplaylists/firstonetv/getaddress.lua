
if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr = m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

if not string.match( inAdr, '^https://www%.firstonetv%.' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
-----------------------------------------------
 local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393")
 if session == nil then return end
-----------------------------------------------

  local rc,answer = m_simpleTV.Http.Request(session,{url=inAdr})
    --m_simpleTV.Http.Close(session)

     if rc~=200 then
    	   m_simpleTV.Http.Close(session)
    	   m_simpleTV.OSD.ShowMessage("firstonetv connection error - " .. rc ,255,10)
    	   return
     end
    
    --debug_in_file(answer .. "\n\n")

 c = string.match(answer,"country%s+= '(.-)'")
 id = string.match(answer,"channelID%s+= '(.-)'")
 token = string.match(answer,"cToken%s+= '(.-)'")
 if c == nil or id == nil or token == nil then
     	   m_simpleTV.OSD.ShowMessage("firstonetv - can't find params "  ,255,10)
    return 
 end

-- debug_in_file('ctoken='..token ..'&c='..c..'&id=' .. id .. '\n')

 local t={}
 local url = 'https://www.firstonetv.net/api/?cacheFucker=' .. math.random()
 local head =
 'Accept: */*\n' .. 
 'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7\n' ..
 'Referer: ' .. inAdr .. '\n' ..
 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\n' ..
 'X-Requested-With: XMLHttpRequest'

 if token=='' then

     t.url = url
     t.method = 'post' 
     t.headers = head
     t.body = 'action=hiro&result=get'
 
     local rc,answer = m_simpleTV.Http.Request(session,t)
     --m_simpleTV.Http.Close(session)
     if rc~=200 then
    	   m_simpleTV.Http.Close(session)
    	   m_simpleTV.OSD.ShowMessage("Connection error " .. rc ,255,3)
    	   return
     end

--debug_in_file(answer .. "\n\n")
--do return end

local hiro, hash, time, rss =string.match(answer,'hiro":(.-),"hash":"(.-)","time":(.-),"rss":(.-)}')
--debug_in_file (rss .. '\n')
if hiro==nil or hash==nil or time==nil or rss==nil then return end

hiro = string.gsub(hiro, 'p', 186)

 require('jsdecode')
 local result = jsdecode.DoDecode('eval(' .. hiro .. ')')
 --debug_in_file (result .. '\n')

--action=hiro&result=7979096657694&time=1494370486&hash=269248e52e0767eb9d16583f1480ce23

     t.url = url
     t.method = 'post' 
     t.headers = head
     t.body = 'action=hiro&result=' .. result .. '&time=' .. time .. '&hash=' .. hash
 
     rc,answer = m_simpleTV.Http.Request(session,t)
     --m_simpleTV.Http.Close(session)
     if rc~=200 then
    	   m_simpleTV.Http.Close(session)
    	   m_simpleTV.OSD.ShowMessage("Connection error " .. rc ,255,3)
    	   return
     end

--debug_in_file(answer .. "\n\n")

    token = string.match(answer,'ctoken":"(.-)"')
    if token == nil then return end 

 end

--action=channel&ctoken=1a38ea13-a547-b9f8-05aa-0ad51f353d7b&c=uk&id=16

     t.url = url
     t.method = 'post' 
     t.headers = head
     t.body = 'action=channel&ctoken='..token ..'&c='..c..'&id=' .. id
 
     rc,answer = m_simpleTV.Http.Request(session,t)
     m_simpleTV.Http.Close(session)
     if rc~=200 then
    	   m_simpleTV.Http.Close(session)
    	   m_simpleTV.OSD.ShowMessage("Connection error " .. rc ,255,3)
    	   return
     end
    
    answer = string.gsub(answer,'\\','')
    --debug_in_file(answer .. "\n\n")
   
   local a,b=string.match(answer,'"surl":"{(.-),(.-)}"')
   if a==nil or b==nil then 
   --debug_in_file(a .. '\n' .. b .. "\n")
   
        local retAdr = string.match(answer,'"surl":"(.-)"')
         if retAdr == nil then
            	   m_simpleTV.OSD.ShowMessage("firstonetv - stream not found "  ,255,10)
           return 
        end
       --debug_in_file(retAdr .. "\n\n")
       
       m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-referrer=' .. inAdr .. '$OPT:http-user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393'
       return 
   end
   
   
   local name1,adr1=string.match(a,'"(.-)":"(.-)"')
   local name2,adr2=string.match(b,'"(.-)":"(.-)"')
   
     local tt={} tt[1]={} tt[2]={}
   
     tt[1].Id=1
     tt[1].Name=name1
     tt[1].Adress=adr1
    
     tt[2].Id=2
     tt[2].Name=name2
     tt[2].Adress=adr2
   
     local retAdr
     local ret,id = m_simpleTV.OSD.ShowSelect('Select stream',0,tt,0,1+4+8)
     if id==nil then return end 
     retAdr=tt[id].Adress
   
   m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-referrer=' .. inAdr .. '$OPT:http-user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393'

