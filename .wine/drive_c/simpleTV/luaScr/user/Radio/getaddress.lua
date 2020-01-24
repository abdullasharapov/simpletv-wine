--get address
if TVSources_var==nil or TVSources_var and not TVSources_var.ChangeAdress then
    m_simpleTV.Control.EventPlayingInterval=3000
 end

require('json')

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

if not string.match( inAdr, '^http://101%.ru/radio/channel/' ) 
and not string.match( inAdr, '^http://101%.ru/radio/user/' ) 
and not string.match( inAdr, '^http://radio%.obozrevatel%.com/newplayer/rplaylists' ) 
and not string.match( inAdr, '^http://radio%.obozrevatel%.com/files/audio/' ) 
and not string.match( inAdr, '^https://www.obozrevatel.com/radio/' ) 
and not string.match( inAdr, '^difmid=' ) 
and not string.match( inAdr, '^rockradioid=' ) 
and not string.match( inAdr, '^jazzradioid=' ) 
and not string.match( inAdr, '^radiotunesid=' ) 
and not string.match( inAdr, '^classicalradioid=' ) then  return end 

--debug_in_file(inAdr .. '\n')

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'

local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36 OPR/49.0.2725.47")
if session == nil then return end

 --INTERNET_OPTION_CONNECT_TIMEOUT
 m_simpleTV.WinInet.SetOptionInt(session,2,10000,0)
 --INTERNET_OPTION_RECEIVE_TIMEOUT
 m_simpleTV.WinInet.SetOptionInt(session,6,6000,0)
----------------------------------------------------------------
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
----------------------------------------------------------------
--101 radio
if  string.match( inAdr, '^http://101%.ru/radio/channel/' )  or string.match( inAdr, '^http://101%.ru/radio/user/' ) then

--http://101.ru/api/channel/getServers/99/channel/MP3/128?rand=0.7368798567913473

--local num = findpattern(inAdr,'channel/(.+)',1,8,0)
--if num ==nil then return end

       local rc,answer=m_simpleTV.WinInet.Request(session,{url=inAdr})
        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
       	   return
        end
--debug_in_file(answer .. '\n')

local url = findpattern(answer,'data%-playlist="(.-)"',1,15,1)
if url==nil then return end

url = 'http://101.ru' .. url
--debug_in_file(url .. '\n')

--local url = 'http://101.ru/api/channel/getServers/' .. num .. '/channel/MP3/128?rand=' .. math.random()

        rc,answer=m_simpleTV.WinInet.Request(session,{url=url})
        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
       	   return
        end
  --debug_in_file(answer .. '\n')

 answer = string.gsub(answer,'%[%]','""')
 answer = answer:gsub('\u','\\u')

 local retAdr = ''
 local t = json.decode(answer) 

 if t == nil or t.playlist==nil then
    m_simpleTV.OSD.ShowMessage("Error - can't find address",255,5)
   return
 end 

local a={}
local i=1
local name,adr

while true do
  if t.playlist[i] == nil then break end
    adr = t.playlist[i].file
  --adr = string.gsub(adr,'setst=(%d+)&','setst=-1&')
    
  a[i] = {}
  a[i].Id   =  i
  a[i].Name =  unescape1(t.playlist[i].comment)
  a[i].Adress  = adr 
  --debug_in_file(a[i].Name  .. '\n' .. a[i].Adress .. '\n\n')
  i = i+1

end

  local index = math.random(#a)
  if retAdr == '' then retAdr = a[index].Adress end

--[[m_simpleTV.User.Radio.Servers = a

 if i>2 then
     m_simpleTV.OSD.ShowSelect_UTF8('101RU',index,a,5000,32+64)
 end 
]]
m_simpleTV.WinInet.Close(session)
m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-referrer=' .. inAdr
m_simpleTV.User.Radio.isRadioTimer=true
  return
end

------------------------------------------

--myradio playlist

local function GetMyRadioAdr(inAdr)

 --INTERNET_FLAG_NO_AUTO_REDIRECT 0x00200000
 m_simpleTV.WinInet.SetOpenRequestFlags(session,0x00200000)

     local rc,answer = m_simpleTV.WinInet.Request(session,{url=inAdr})
     --m_simpleTV.WinInet.Close(session)
   
     if rc~=302 then return end
     --debug_in_file(rc .. '\n\n')

    local rawheader = m_simpleTV.WinInet.GetRawHeader(session)
    local adr = findpattern(rawheader,'Location: (.-)\n',1,10,0)
    if adr == nil then return end
    adr = trim(adr)

    adr = url_encode(adr)
    adr = string.gsub(adr, '+','%%20')
    adr = string.gsub(adr, '%%26','&')
    adr = string.gsub(adr, '%%2F', '/')
    adr = 'http://radio.obozrevatel.com' .. adr

  return adr
end

if  string.match( inAdr, '^http://radio%.obozrevatel%.com/newplayer/rplaylists' ) then 

       local rc,answer=m_simpleTV.WinInet.Request(session,{url=inAdr})
        if rc~=200 then
       	   m_simpleTV.WinInet.Close(session)
       	   m_simpleTV.OSD.ShowMessage("myradio Connection error - " .. rc ,255,10)
       	   return
        end
--debug_in_file(answer .. '\n')
--do return end

local t={}
local i=1
local name1,name2,dir,code
local retAdr

for w in string.gmatch(answer,'<li index=(.-)</li>') do

       name1,name2 = string.match(w, '<a.->(.-)</a>.->(.-)</a')
       dir,code = string.match(w, 'dir="(.-)".-code="(.-)"')
       if name1==nil or name2==nil or dir==nil or code==nil then break end

      t[i] = {}
      t[i].Id = i
      t[i].Name = i .. '. ' .. name1 .. ' - ' .. name2
      t[i].Adress  = 'http://radio.obozrevatel.com/files/audio/' .. dir .. '/' .. code .. '.mp3'
       --debug_in_file(t[i].Name .. '  ' .. t[i].Adress .. '\n')
    i=i+1
end
if #t==0 then return end

m_simpleTV.User.Radio.MyRadio = t

 if i>2 then 
    m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.Common.string_toUTF8(m_simpleTV.Control.CurrentTitle),0,t,10000,32+64)
 end

   if i>1 then
      retAdr = GetMyRadioAdr(t[1].Adress) 
      --debug_in_file(retAdr .. '\n')
   end
  
  if retAdr == nil then return end
  
  m_simpleTV.Control.CurrentAdress = retAdr ..  '$OPT:POSITIONTOCONTINUE=0$OPT:http-referrer=' .. inAdr 
  m_simpleTV.WinInet.Close(session)
  return
end

if string.match( inAdr, '^http://radio%.obozrevatel%.com/files/audio/' ) then

   local retAdr = GetMyRadioAdr(inAdr)
   if retAdr == nil then return end
   
   m_simpleTV.Control.CurrentAdress = retAdr
   m_simpleTV.WinInet.Close(session)
  return
end

if string.match( inAdr, '^https://www.obozrevatel.com/radio/' ) then

   local rc,answer = m_simpleTV.WinInet.Request(session,{url=inAdr})
   if rc~=200 then return end
 
   local retAdr = findpattern(answer, 'data%-player%-source%-url="(.-)"',1,24,1) or ''

   m_simpleTV.Control.CurrentAdress = retAdr
   m_simpleTV.WinInet.Close(session)
  return
end

---------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
--DI radio
if string.match( inAdr, '^difmid=' ) or string.match( inAdr, '^rockradioid=' )or  string.match( inAdr, '^jazzradioid=' ) or string.match( inAdr, '^radiotunesid=' ) or string.match( inAdr, '^classicalradioid=' ) then

local host, id, u
local retAdr
if m_simpleTV.User.Radio.AudioAddictPlaylist==nil then m_simpleTV.User.Radio.AudioAddictPlaylist={} end

if string.match( inAdr, '^difmid=' ) then
   m_simpleTV.User.Radio.AudioAddictStation = 'Digitally Imported'
   host = 'https://www.di.fm'
   id = string.gsub(inAdr, '^difmid=','')
   u = 'di'
end

if string.match( inAdr, '^rockradioid=' ) then
   m_simpleTV.User.Radio.AudioAddictStation = 'Rockradio.com'
   host = 'https://www.rockradio.com/'
   id = string.gsub(inAdr, '^rockradioid=','')
   u = 'rockradio'
end

if string.match( inAdr, '^jazzradioid=' ) then
   m_simpleTV.User.Radio.AudioAddictStation = 'Jazzradio'
   host = 'https://www.jazzradio.com/'
   id = string.gsub(inAdr, '^jazzradioid=','')
   u = 'jazzradio'
end

if string.match( inAdr, '^radiotunesid=' ) then
   m_simpleTV.User.Radio.AudioAddictStation = 'RadioTunes'
   host = 'https://www.jazzradio.com/'
   id = string.gsub(inAdr, '^radiotunesid=','')
   u = 'radiotunes'
end

if string.match( inAdr, '^classicalradioid=' ) then
   m_simpleTV.User.Radio.AudioAddictStation = 'ClassicalRadio'
   host = 'https://www.classicalradio.com/'
   id = string.gsub(inAdr, '^classicalradioid=','')
   u = 'classicalradio'
end

if m_simpleTV.User.Radio.AudioAddictCurrentTitle == nil then
   m_simpleTV.User.Radio.AudioAddictCurrentTitle = m_simpleTV.Control.CurrentTitle_UTF8
end

if #m_simpleTV.User.Radio.AudioAddictPlaylist==0 then

 if m_simpleTV.Control.CurrentTitle_UTF8~=nil then
    m_simpleTV.Control.CurrentTitle_UTF8=nil
 end
 
 local url = host .. '/_papi/v1/' .. u .. '/routines/channel/' .. id .. '?tune_in=true&audio_token=03c6587600d0ee27d7598212bb27f161'--&_=1519203900771'

  local rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
 --m_simpleTV.WinInet.Close(session)

 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("AudioAddict Connection error " .. rc ,255,3)
	   return
 end

  --debug_in_file(answer .. '\n')
  answer = string.gsub(answer,'%[%]','""')
  answer = string.gsub(answer,'null','""')
  local t = json.decode(answer)
  
  if t == nil then
     m_simpleTV.OSD.ShowMessage("Error - json not found"  ,255,10)
     return
  end
  
  local tab={}
  local i=1
  local img
  while true do
    if t.tracks[i] == nil or t.tracks[i].content == nil or t.tracks[i].content.assets[1] == nil or t.tracks[i].content.assets[1].url == nil then break end
   
    img = t.tracks[i].asset_url 
    if img then img = 'https:' .. img else img='' end
    tab[i] = {}
    tab[i].Id   =  i
    tab[i].Name =  t.tracks[i].track
    tab[i].Adress  = 'https:' .. t.tracks[i].content.assets[1].url
    tab[i].Img =  img

    --debug_in_file(tab[i].Name .. '  ' .. tab[i].Adress .. '  ' ..  tab[i].Img .. '\n ')
    i = i+1
  
  end

  if #tab==0 then return end
 
 m_simpleTV.User.Radio.AudioAddictPlaylist = table_reverse(tab)
end

local index = #m_simpleTV.User.Radio.AudioAddictPlaylist

m_simpleTV.User.Radio.AudioAddictPlaylist.Track = m_simpleTV.User.Radio.AudioAddictPlaylist[index].Name

m_simpleTV.User.Radio.AudioAddictPlaylist.Cover = m_simpleTV.User.Radio.AudioAddictPlaylist[index].Img

retAdr = m_simpleTV.User.Radio.AudioAddictPlaylist[index].Adress

m_simpleTV.Control.CurrentTitle_UTF8 = m_simpleTV.User.Radio.AudioAddictPlaylist.Track 


m_simpleTV.WinInet.Close(session)
m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:POSITIONTOCONTINUE=0'

end 

