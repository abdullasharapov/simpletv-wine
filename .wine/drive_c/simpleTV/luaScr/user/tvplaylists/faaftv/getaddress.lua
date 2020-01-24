--script for faaf.tv (15/08/2018)

--quality High - 1 / Medium - 2 / Low - 0
local quality = 1
------------------------------------------------------------------------------

require('json')

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

if  not string.match( inAdr, '^faaftv=' ) and not string.match(inAdr, '^faafstrm=' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = ''

if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.Faaf01==nil then m_simpleTV.User.Faaf01={} end

if quality==1 and m_simpleTV.User.Faaf01.MaxResolution==nil then 
   m_simpleTV.User.Faaf01.MaxResolution = 1080
elseif quality==2 and m_simpleTV.User.Faaf01.MaxResolution==nil then
   m_simpleTV.User.Faaf01.MaxResolution = 480
elseif quality==0 and m_simpleTV.User.Faaf01.MaxResolution==nil then 
   m_simpleTV.User.Faaf01.MaxResolution = 360
end

----------------------------------------------------------------
local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.168 Safari/537.36 OPR/51.0.2830.40")
if session == nil then return end

 --INTERNET_OPTION_CONNECT_TIMEOUT
 m_simpleTV.WinInet.SetOptionInt(session,2,5000,0)
 --INTERNET_OPTION_RECEIVE_TIMEOUT
 m_simpleTV.WinInet.SetOptionInt(session,6,5000,0)
--INTERNET_FLAG_SECURE
 --m_simpleTV.WinInet.SetOpenRequestFlags(session, 0x00800000 + 0x00002000 + 0x00001000)
---------------------------------------------------------------
local function GetMaxResolutionIndex(t)

   local index = m_simpleTV.Control.GetMultiAddressIndex()
   if index==nil and m_simpleTV.User.Faaf01.MaxResolution==nil then
      m_simpleTV.User.Faaf01.MaxResolution = t[#t].Name
   elseif index~=nil then
      m_simpleTV.User.Faaf01.MaxResolution = t[index+1].Name
   end
   --debug_in_file(m_simpleTV.User.Faaf01.MaxResolution .. '\n')

   if m_simpleTV.User.Faaf01.MaxResolution > 0 then
      index=1 
      for u=1, #t do
         if t[u].Name~=nil and  m_simpleTV.User.Faaf01.MaxResolution > t[u].Name then break end
         index = u
      end
    end
   return index
end
------------------------------------------------------------------------------
local function GetVimeoAdr (answer)
   
  local url =  findpattern(answer,'<iframe src="(.-)"',1,13,1)

  if url == nil then
     url =  findpattern(answer,'<iframe id="player1" src="(.-)"',1,26,1)

     if url == nil then
         local ret = {}
         return ret,answer
     end
  end
--debug_in_file(url .. '\n')
    if string.match(url,'player%.vimeo%.com') then
   
       if not string.match(url, 'https:') then
          url = 'https:' .. url
       end


               local head = 
               'Referer: ' .. inAdr .. '\n' .. 
               'User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; ru; rv:2.0) Gecko/20100101 Firefox/4.0'

    local tt={}
    tt.url = url
    tt.method = 'get' 
    tt.headers = head
   
    local rc,answer = m_simpleTV.WinInet.Request(session,tt)
          
               -- rc,answer=m_simpleTV.WinInet.Get(session,url,nil,0,head)
                m_simpleTV.WinInet.Close(session)
                if rc~=200 then
               	   m_simpleTV.WinInet.Close(session)
               	   m_simpleTV.OSD.ShowMessage("faaf.tv Connection error 2 - " .. rc ,255,10)
               	   return
                end
     --debug_in_file(answer .. "\n\n")
   
--     local tmp =  findpattern(answer,'var r={(.-);if',1,6,3)
     local tmp =  string.match(answer,'var config =(.-);')
     if tmp == nil then m_simpleTV.OSD.ShowMessage("faaf.tv - can't find json" ,255,10) return end
     tmp = string.gsub(tmp,'%[%]','""')
     --debug_in_file(tmp .. "\n\n")
   
    local t = json.decode(tmp)
    if t == nil or t.request==nil or t.request.files==nil or t.request.files.progressive==nil then return end
     
    local ret={}
    
    for i, w in ipairs(t.request.files.progressive) do
        ret[i] = {}
   	ret[i].url = w.url
   	ret[i].height = w.height
    end
   
    if ret == nil or #ret==0 then
     m_simpleTV.OSD.ShowMessage("faaf.tv error - video not found",255,10)
     return
    end
  --[[]
   local t={}
   local width=0
   local retAdr=nil
   local index = 0
   
   for i=1,#ret do
   	t[i]={}
   	t[i].Id = i
   	t[i].Address = ret[i].url
   	t[i].Name = 'Resolution - ' .. ret[i].width

   	if ret[i].width > width then
   	  retAdr = t[i].Address
   	  width = ret[i].width
   	  index = i-1
   	end
   end
 
    if retAdr==nil then 
   	retAdr = t[i].Address
    end
]]
      return ret--retAdr
  end
end
------------------------------------------------------------------------------
if string.match(inAdr, '^faafstrm=' ) then
   if m_simpleTV.User.Faaf01.ResolutionTable then
      local index = GetMaxResolutionIndex(m_simpleTV.User.Faaf01.ResolutionTable) or 1
      local retAdr=string.gsub(m_simpleTV.User.Faaf01.ResolutionTable[index].Address,'^faafstrm=','')
      retAdr=decode64(retAdr)
      --debug_in_file(retAdr .. '\n')
      m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:NO-STIMESHIFT'
   end
   return
end
------------------------------------------------------------------------------

  local logurl ='https://faaf.tv/login'

 --INTERNET_FLAG_NO_AUTO_REDIRECT 0x00200000
-- m_simpleTV.WinInet.SetOpenRequestFlags(session,0x00200000)

 local body ='login=xps66582%40iaoss.com&password=xps66582%40iaoss.com&vx=%D0%92%D0%A5%D0%9E%D0%94'
 local head = 
'Content-Type: application/x-www-form-urlencoded\n' .. 
'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8\n' .. 
'Referer: https://faaf.tv/login\n' .. 
'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7\n'

  local rc,answer=m_simpleTV.WinInet.Request(session,{url=logurl,method='post',headers=head,body=body})


  inAdr = string.gsub(inAdr,'faaftv=', 'https://faaf.tv')
  local  rc,answer=m_simpleTV.WinInet.Request(session,{url=inAdr,headers='Referer: https://faaf.tv/'})
  --m_simpleTV.WinInet.Close(session)
   if rc~=200 then
  	   m_simpleTV.WinInet.Close(session)
  	   m_simpleTV.OSD.ShowMessage("faaf.tv Connection error 1 - " .. rc ,255,10)
  	   return
   end
  
  --debug_in_file(answer .. "\n\n")

local ret = GetVimeoAdr (answer)
if ret==nil or #ret==0 then return end

   local t={}
   local width=0
   local retAdr=nil
   local index = 0
   
   for i=1,#ret do
   	t[i]={}
   	t[i].Id = i
   	t[i].Address = 'faafstrm=' .. encode64(ret[i].url)
   	t[i].Name = ret[i].height
--[[
   	if ret[i].width > width then
   	  retAdr = t[i].Address
   	  width = ret[i].width
   	  index = i-1
   	end
]]
   end

 table.sort(t, function(a,b) return a.Name>b.Name end)

 m_simpleTV.User.Faaf01.ResolutionTable = t

 index = GetMaxResolutionIndex(t) or 1
 retAdr=string.gsub(t[index].Address,'faafstrm=','')
 retAdr=decode64(retAdr)

 if #ret>1 then    
   local head
   if title == nil then
		head = 'Select quality'
    else
	 head = title .. ' - select quality'
   end
   m_simpleTV.OSD.ShowSelect_UTF8( head, index-1, t, 5000,32+128)
 end   


m_simpleTV.Control.CurrentAdress =  retAdr .. '$OPT:NO-STIMESHIFT'
m_simpleTV.WinInet.Close(session)
