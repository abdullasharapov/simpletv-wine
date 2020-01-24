--script getaddress yandex tv (01/09/2019)

--highest quality Yes - 1 No - 0
local quality = 1
---------------------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr = m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

if not string.match(inAdr, '^$yandextv=' ) and not string.match(inAdr, '^$yandexstrm=' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'

if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.TVTimeShift==nil then m_simpleTV.User.TVTimeShift={} end

if quality==1 and m_simpleTV.User.YaTV.MaxResolution==nil then 
   m_simpleTV.User.YaTV.MaxResolution = 1080
end

if quality==0 and m_simpleTV.User.YaTV.MaxResolution==nil then 
   m_simpleTV.User.YaTV.MaxResolution = 360
end
------------------------------------------------------------------------------
local function GetMaxResolutionIndex(t)

   local index = m_simpleTV.Control.GetMultiAddressIndex()
   if index==nil and m_simpleTV.User.YaTV.MaxResolution==nil then
      m_simpleTV.User.YaTV.MaxResolution = t[#t].res
   elseif index~=nil then
      m_simpleTV.User.YaTV.MaxResolution = t[index+1].res
   end
   --debug_in_file(m_simpleTV.User.YaTV.MaxResolution .. '\n')

   if m_simpleTV.User.YaTV.MaxResolution > 0 then
      index=1 
      for u=1, #t do
         if t[u].res~=nil and  m_simpleTV.User.YaTV.MaxResolution < t[u].res then break end
         index = u
      end
    end
   return index
end
------------------------------------------------------------------------------

if string.match(inAdr, '^$yandexstrm=' ) then
   if m_simpleTV.User.YaTV.ResolutionTable then
      local index = GetMaxResolutionIndex(m_simpleTV.User.YaTV.ResolutionTable) or 1
      local retAdr=string.gsub(m_simpleTV.User.YaTV.ResolutionTable[index].Adress,'$yandexstrm=','')
      retAdr=decode64(retAdr)

      if m_simpleTV.User.TVTimeShift.isYaTV_Offset == true then
         local offset = m_simpleTV.User.TVTimeShift.YaTV_Offset
         retAdr=retAdr .. '&start=' .. os.time() + offset .. '&end=' .. os.time() + offset + 3*3600
      end

      m_simpleTV.Control.CurrentAdress = retAdr
   end
   return
end
------------------------------------------------------------------------------
local session = m_simpleTV.Http.New()
if session == nil then return end
------------------------------------------------------------------------------
m_simpleTV.User.TVTimeShift.isYaTV_Offset = false

inAdr=string.gsub(inAdr,'$yandextv=','')
local retAdr,url,id

 require('json')

if m_simpleTV.User.YaTV.Table==nil then
  
  local url = 'https://yandex.ru/portal/tvstream_json/channels?stream_options=hires&locale=ru&from=morda'
  local rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("YandexTV Connection error 1 - " .. rc ,255,5)
 	   return
  end

--debug_in_file(answer .. '\n')


  
    answer = string.gsub(answer, ':%[%]', ':""')
    answer = string.gsub(answer, '%[%]', ' ')

    local tab = json.decode(answer)
    if tab == nil then return end


local t={}
local i=1
local adr,id

while true do
   if tab.set[i]==nil then break end

      id = tab.set[i].channel_id
      adr = tab.set[i].content_url
  
      t[i]={}
      t[i].Id= i
      t[i].channel_id = id
      t[i].title = '' 
      t[i].channel_category = ''
      t[i].content_url = adr
      t[i].content_id = tab.set[i].content_id

 i=i+1
end

  m_simpleTV.User.YaTV.Table = t
end

for i, v in ipairs(m_simpleTV.User.YaTV.Table) do 
   v.channel_id = string.gsub(v.channel_id,'$yandextv=','')
   if tonumber(inAdr)==tonumber(v.channel_id) then
      url=v.content_url
      id=v.content_id
   end
end

--debug_in_file(url .. '\n')

 if url==nil then
 	   m_simpleTV.OSD.ShowMessage("YandexTV - канал не найден\nОбновите плейлист",255,5)
    m_simpleTV.User.YaTV.Table=nil
 end

if url~=nil and not string.match(url, 'vod%-content') then
   
   url = string.gsub(url, '?(.+)', '')
   url = url .. '?partner-id=288335&video-category-id=1011&vsid=834c74fa1d04ae2f7c3b3a924264758bd40e49523757d34fbb7edd536af90ace'

  rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("YandexTV Connection error 2 - " .. rc ,255,5)
 	   return
  end

--debug_in_file(answer .. '\n')

  if string.match(url, '1tv%.ru') then
  
      local cc = m_simpleTV.Http.GetCookies(session,"","s")
      --m_simpleTV.Http.Close(session)
      if cc==nil then return end
    
      url='http://stream.1tv.ru/api/playlist/1tvch_as_array.json'
      rc,answer = m_simpleTV.Http.Request(session,{url = url})
      --m_simpleTV.Http.Close(session)
      if rc~=200 then
     	   m_simpleTV.Http.Close(session)
     	   m_simpleTV.OSD.ShowMessage("YandexTV Connection error 3 - " .. rc ,255,5)
     	   return
      end
    
    --debug_in_file(answer .. '\n')
    
    url = string.match(answer , 'hls":%["(.-)&')
    if url==nil then return end
  
    url = url .. '&s=' .. m_simpleTV.Common.toPersentEncoding(cc)
  
      rc,answer = m_simpleTV.Http.Request(session,{url = url})
      m_simpleTV.Http.Close(session)
      if rc~=200 then
     	   m_simpleTV.Http.Close(session)
     	   m_simpleTV.OSD.ShowMessage("YandexTV Connection error 3 - " .. rc ,255,5)
     	   return
      end
    
    --debug_in_file(answer .. '\n')
  
    local t={}
    local name,adr
    local i=1
    
    for name,adr in string.gmatch(answer, 'RESOLUTION=(.-)\n(.-)\n') do 
    
      if not string.match(adr,'&redundant') then
       name = name:gsub('(.-),.+', '%1')
       t[i]={}
       t[i].Id= i
       t[i].Name = name
       t[i].Adress = '$yandexstrm=' .. encode64(adr)
       t[i].res = tonumber(name:match('x(%d+)') or 360)
       --debug_in_file(t[i].Name .. '  ' .. t[i].Adress .. '\n')
  
       i=i+1
      end
    end
    
    m_simpleTV.User.YaTV.ResolutionTable = t
  
    local index
  
    if i>1 then
       index = GetMaxResolutionIndex(t) or 1
       retAdr=string.gsub(t[index].Adress,'$yandexstrm=','')
       retAdr=decode64(retAdr)
    end
    
    if i>2 then
       m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.Common.string_toUTF8('Качество'),index-1,t,5000,32+64+128)
    end
  
     m_simpleTV.Control.CurrentAdress = retAdr
    
   -- m_simpleTV.Control.CurrentAdress = retAdr .. '&s=' .. m_simpleTV.Common.toPersentEncoding(cc)
  
    return
  end
  
  if string.match(url, 'strm%.yandex%.ru') then
  
    local t={}
    local name,adr
    local i=1
    
    for name,adr in string.gmatch(answer, 'RESOLUTION=(.-)\n(.-)\n') do 
    
      if not string.match(adr,'&redundant') then
       t[i]={}
       t[i].Id= i
       t[i].Name = name
       t[i].Adress = '$yandexstrm=' .. encode64('https://strm.yandex.ru' .. adr)
       t[i].res = tonumber(name:match('x(%d+)') or 360)
       --debug_in_file(t[i].Name .. '  ' .. t[i].Adress .. '\n')
  
       i=i+1
      end
    end
    
    m_simpleTV.User.YaTV.ResolutionTable = t
  
    local index
  
    if i>1 then
       index = GetMaxResolutionIndex(t) or 1
       retAdr=string.gsub(t[index].Adress,'$yandexstrm=','')
       retAdr=decode64(retAdr)
    end
    
    if i>2 then
       m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.Common.string_toUTF8('Качество'),index-1,t,5000,32+64+128)
    end
  
     m_simpleTV.Control.CurrentAdress = retAdr
     return
  end
end


--vod content
if id~=nil then
   url ='https://frontend.vh.yandex.ru/v16/episodes.json?parent_id=' .. id .. '&limit=50&end_date__from=' ..os.time() .. '&stream_options=hires&locale=ru&from=morda'
   
     rc,answer = m_simpleTV.Http.Request(session,{url = url})
     --m_simpleTV.Http.Close(session)
     if rc~=200 then
    	   m_simpleTV.Http.Close(session)
    	   m_simpleTV.OSD.ShowMessage("YandexTV Connection error 2 - " .. rc ,255,5)
    	   return
     end
   
   --debug_in_file(answer .. '\n')
   
       answer = string.gsub(answer, ':%[%]', ':""')
       answer = string.gsub(answer, '%[%]', ' ')
   
       local tab = json.decode(answer)
       if tab == nil then return end
   
   
   local t={}
   local i=1
   local name,adr
   
   while true do
      if tab.set[i]==nil then break end
   
         name = tab.set[i].title
         adr = tab.set[i].content_url
     
         t[i]={}
         t[i].Id= i
         t[i].Name = i .. '. ' .. name
         t[i].Adress = adr
   
    i=i+1
   end
   
   m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.Control.CurrentTitle_UTF8,0,t,10000,32)
   
   local retAdr = t[1].Adress
   if retAdr==nil then return end
          
   m_simpleTV.Control.CurrentAdress = retAdr
   m_simpleTV.WinInet.Close(session)

end
