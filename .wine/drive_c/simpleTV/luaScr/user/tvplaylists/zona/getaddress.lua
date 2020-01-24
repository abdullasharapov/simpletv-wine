--script zona-iptv (13/08/2019)

--кол-во плейлистов на OSD, 0 - все
local num = 25
------------------------------------------------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr = m_simpleTV.Control.CurrentAdress
if inAdr==nil then return end

if not string.match(inAdr, '^$zonaiptv' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
m_simpleTV.Control.EventTimeOutInterval=10000

if string.match(inAdr, '^$zonaiptvstream=' ) then 
   m_simpleTV.Control.SetTitle('ZonaIPTV')
   m_simpleTV.Control.CurrentAdress = string.gsub(inAdr, '^$zonaiptvstream=', '')
   --debug_in_file(m_simpleTV.Control.CurrentAdress .. '\n')
   return 
end

------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
------------------------------------------------------------------------------
local function trim(str)
str = string.match(str,'^%s*(.-)%s*$')
  return str
end
------------------------------------------------------------------------------
local function GetPlaylistTable(adr)

    local url = string.gsub(adr, '^$zonaiptv=', '')

    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ZonaIPTV Connection error 2 - " .. rc ,255,5)
   	   return
    end
  
  --debug_in_file(answer .. '\n')
    if not string.match(answer, '%#EXTINF:' ) then
        m_simpleTV.OSD.ShowMessage("ZonaIPTV - Playlist not found" ,255,5)
       return 
    end

  answer = string.gsub(answer, '&#8211; ', '')

  local header =  findpattern( answer,'<title>(.-)<',1,7,1)
  if header==nil then header='ZonaIPTV' end

  local tmp = findpattern( answer,'%#EXTINF:(.-)</div>',1,0,0)
  if tmp~=nil then 
     tmp = string.gsub(tmp, '<.->', '')
     tmp = string.gsub(tmp, '&gt;', '')
     tmp = string.gsub(tmp, '&#215;', 'x')
     tmp = string.gsub(tmp, '&#176;', '')
     tmp = string.gsub(tmp, '(.-)?.-\n', '%1\n')
 end

 if tmp==nil then tmp=answer else answer=tmp end

  local tt={}
  local i=1
  for name, adr in string.gmatch(answer, '%#EXTINF:.-,(.-)\n(.-)\n') do 

       tt[i]={}
       tt[i].Id= i
       tt[i].Name = trim(name) --i .. '. ' .. name  
       tt[i].Address = '$zonaiptvstream=' .. trim(adr)
       --debug_in_file (tt[i].Name .. ' ' .. tt[i].Address .. '\n')
     
     i=i+1
  end

table.sort(tt, function(a, b) return a.Name < b.Name end)
for i=1, #tt do tt[i].Id=i end

  return tt, header
end
------------------------------------------------------------------------------
function ZonaIPTVPlaylists()

   local t = m_simpleTV.User.ZonaIPTV01.Playlists
   if t == nil then m_simpleTV.Control.PlayAddress('$zonaiptv') return end

   local index = m_simpleTV.User.ZonaIPTV01.PlaylistsIndex

   local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('ZonaIPTV',index-1,t,0,1+4+8)
   if id == nil then return end
   if ret==1 then

    m_simpleTV.User.ZonaIPTV01.PlaylistsIndex = t[id].Id
    m_simpleTV.User.ZonaIPTV01.PlaylistsName = t[id].Name
    --m_simpleTV.Control.SetNewAddress(t[id].Address) 
    m_simpleTV.Control.PlayAddress(t[id].Address) 
     
   end

end
------------------------------------------------------------------------------
function ZonaIPTVSavePlaylist()
   if m_simpleTV.User.ZonaIPTV01.CurrentPlaylist~=nil then
      local t=m_simpleTV.User.ZonaIPTV01.CurrentPlaylist
      local grp=m_simpleTV.Control.GetTitle()
      local m3ustr = '#EXTM3U\n'
      for i=1,#t do
          --m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. grp .. '",' .. t[i].Name .. '\n' .. string.gsub(t[i].Address, '^$zonaiptvstream=', '') .. '\n'
          m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. grp .. '",' .. t[i].Name .. '\n' .. t[i].Address .. '\n'
      end

       --опции  для загрузки плейлиста 
     local p={}
     p.Data = m3ustr
     p.TypeSourse = 1
     p.DeleteBeforeLoad = 0
     p.TypeSkip   = 1
     p.TypeFind =   0
     p.AutoSearch = 1
     p.NumberM3U =  0
     p.Find_Group = 1
     p.TypeCoding = 1  --  -1-auto  0 - plane text  1- UTF8  2- unicode
     p.BorpasFileFormat=1
     p.AutoNumber = 0
     p.ExtFilter = 'ZonaIPTV'
     
     local err,add,ref,names = m_simpleTV.Common.LoadPlayList_UTF8 ('',p,0,true,false)
     
     if err==true then
          local mess = grp .. " is saved in database (" .. add .. ")" 
     	  m_simpleTV.OSD.ShowMessage_UTF8(mess,0xFF00,10)
     end

   end
end
------------------------------------------------------------------------------
if string.match(inAdr, '^$zonaiptvslynet=' ) then 

    local url = string.gsub(inAdr, '^$zonaiptvslynet=', '')

    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ZonaIPTV Connection error 2 - " .. rc ,255,5)
   	   return
    end
  
--  debug_in_file(answer .. '\n')
    if not string.match(answer, '%#EXTINF:' ) then
        m_simpleTV.OSD.ShowMessage("ZonaIPTV - SlyNet Playlist not found" ,255,5)
       return 
    end

  local header = m_simpleTV.Control.GetTitle()
  local retAdr=''
  local tt={}
  local i=1
  for name, adr in string.gmatch(answer, '%#EXTINF:.-,(.-)\n(.-)\n') do 
   if not string.match(name, '^=') then
       tt[i]={}
       tt[i].Id= i
       tt[i].Name = trim(name) --i .. '. ' .. name  
       tt[i].Address = '$zonaiptvstream=' .. trim(adr)
       --debug_in_file (tt[i].Name .. ' ' .. tt[i].Address .. '\n')

     i=i+1
   end  
  end

table.sort(tt, function(a, b) return a.Name < b.Name end)
for i=1, #tt do tt[i].Id=i end

  if #tt>1 then
     if not string.match(tt[1].Address, '%.m3u8') then
        retAdr = string.gsub(tt[1].Address, '^$zonaiptvstream=', '') .. '?ZonaIPTV'
       else
        retAdr = string.gsub(tt[1].Address, '^$zonaiptvstream=', '') 
     end
  end

  if #tt>2 then
     m_simpleTV.OSD.ShowSelect_UTF8(header,0,tt,10000)
  end

 m_simpleTV.Control.CurrentAdress = retAdr 

   return 
end
------------------------------------------------------------------------------

if string.match(inAdr, '^$zonaiptv=' ) then 

    --m_simpleTV.User.ZonaIPTV01.Playlists=nil

    local retAdr=''
    local tt, header=GetPlaylistTable(inAdr)
    if tt==nil or header==nil then return end

    m_simpleTV.User.ZonaIPTV01.CurrentPlaylist=tt

    if m_simpleTV.User.ZonaIPTV01.PlaylistsName==nil then 
       m_simpleTV.User.ZonaIPTV01.PlaylistsName=header
    end
    m_simpleTV.Control.SetTitle(m_simpleTV.User.ZonaIPTV01.PlaylistsName)
  
       tt.ExtButton0 = {}
       tt.ExtButton0.ButtonEnable = true
       tt.ExtButton0.ButtonName = m_simpleTV.Common.multiByteToUTF8('ZonaIPTV Плейлисты')
       tt.ExtButton0.ButtonScript = "ZonaIPTVPlaylists()"

       tt.ExtButton1 = {}
       tt.ExtButton1.ButtonEnable = true
       tt.ExtButton1.ButtonName = m_simpleTV.Common.multiByteToUTF8('Сохранить в базе')
       tt.ExtButton1.ButtonScript = "ZonaIPTVSavePlaylist()"

  if #tt>1 then
     if not string.match(tt[1].Address, '%.m3u8') then
        retAdr = string.gsub(tt[1].Address, '^$zonaiptvstream=', '') .. '?ZonaIPTV'
       else
        retAdr = string.gsub(tt[1].Address, '^$zonaiptvstream=', '') 
     end
  end

  if #tt>2 then
     m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.ZonaIPTV01.PlaylistsName,0,tt,10000)
  end
 
 m_simpleTV.Control.CurrentAdress = retAdr 

    return
end
------------------------------------------------------------------------------

  require('json')

  m_simpleTV.Control.SetTitle('ZonaIPTV')

  local url = 'https://www.zona-iptv.ru/feeds/posts/summary?alt=json&max-results=9999'
  local rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("ZonaIPTV Connection error 1 - " .. rc ,255,5)
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
 local retAdr=''
 
 local j=1

 while true do
    if num~=0 then
      if i==num+2 then break end
    end
    if tab.feed==nil or tab.feed.entry[i]==nil or tab.feed.entry[i].link==nil or tab.feed.entry[i].link[3]==nil or tab.feed.entry[i].link[3].href==nil or tab.feed.entry[i].link[3].title==nil then break end
 
       name = tab.feed.entry[i].link[3].title
       adr = tab.feed.entry[i].link[3].href
  if not string.match(name, '/ IPTV Playlists m3u') then
       t[j]={}
       t[j].Id= j
       t[j].Name = j .. '. ' .. name 
       t[j].Address = '$zonaiptv=' .. adr
       --debug_in_file (t[i].Name .. ' ' .. t[i].Address .. '\n')
     j=j+1
   end
    i=i+1

 end
 
 m_simpleTV.User.ZonaIPTV01.Playlists = t

 local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('ZonaIPTV',0,t,0,1+4+8)
 if id == nil then return end
 if ret == 1 then

    m_simpleTV.Control.SetTitle(t[id].Name)
    m_simpleTV.User.ZonaIPTV01.PlaylistsIndex = t[id].Id

    url = t[id].Address

    local tt=GetPlaylistTable(url)
    if tt==nil then return end

    m_simpleTV.User.ZonaIPTV01.CurrentPlaylist=tt

       tt.ExtButton0 = {}
       tt.ExtButton0.ButtonEnable = true
       tt.ExtButton0.ButtonName = m_simpleTV.Common.multiByteToUTF8('ZonaIPTV Плейлисты')
       tt.ExtButton0.ButtonScript = "ZonaIPTVPlaylists()"

       tt.ExtButton1 = {}
       tt.ExtButton1.ButtonEnable = true
       tt.ExtButton1.ButtonName = m_simpleTV.Common.multiByteToUTF8('Сохранить в базе')
       tt.ExtButton1.ButtonScript = "ZonaIPTVSavePlaylist()"

  if #tt>1 then
     if not string.match(tt[1].Address, '%.m3u8') then
        retAdr = string.gsub(tt[1].Address, '^$zonaiptvstream=', '') .. '?ZonaIPTV'
       else
        retAdr = string.gsub(tt[1].Address, '^$zonaiptvstream=', '') 
     end
  end

  if #tt>2 then
     m_simpleTV.OSD.ShowSelect_UTF8(t[id].Name,0,tt,10000)
  end

 m_simpleTV.Control.CurrentAdress = retAdr 

end



