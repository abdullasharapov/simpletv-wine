if m_simpleTV.Control.CurrentAdress==nil then return end

      function DeleteRadioTimer()

         if m_simpleTV.User.Radio.RadioTimerId1 then
            m_simpleTV.Timer.DeleteTimer (m_simpleTV.User.Radio.RadioTimerId1)
            m_simpleTV.User.Radio.isRadioTimer=true
            --debug_in_file('RadioTimerId 1\n')
         end

            if m_simpleTV.User.Radio.RadioTimerId2 then
               m_simpleTV.Timer.DeleteTimer (m_simpleTV.User.Radio.RadioTimerId2)
               m_simpleTV.User.Radio.isRadioTimer=true
               --debug_in_file('RadioTimerId 2\n')
            end

            if m_simpleTV.User.Radio.RadioTimerId3 then
               m_simpleTV.Timer.DeleteTimer (m_simpleTV.User.Radio.RadioTimerId3)
               m_simpleTV.User.Radio.isRadioTimer=true
               --debug_in_file('RadioTimerId 3\n')
            end
            m_simpleTV.User.Radio.RadioTimerId1=nil
            m_simpleTV.User.Radio.RadioTimerId2=nil
            m_simpleTV.User.Radio.RadioTimerId3=nil

      end

------------------------------------------------------------------------------
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
----------------------------------------------------------------
local function getLyric(q)
 
  m_simpleTV.User.Radio.TrackLyric='Lyric not found'

  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36 OPR/64.0.3417.92")
  if session == nil then return end

  local url = 'https://www.google.ru/search?as_q=lyrics+' .. url_encode(q)

  local rc,answer=m_simpleTV.Http.Request(session,{url=url})
  m_simpleTV.Http.Close(session)
  if rc~=200 then return end
  
  --debug_in_file(answer .. '\n')

  htmlEntities = require('htmlEntities')
  local str = string.match(answer, 'lyricid(.-)<path') or ''
  if str~='' then 
     str = string.gsub(str, 'class=".-&hellip; <', '')
     str = '<' .. htmlEntities.decode(str) --.. '>'
     str = string.gsub(str, '</div>', '\n\n')
     str = string.gsub(str, '<br>', '\n')
     str = string.gsub(str, '</span>', ' ')
     str = string.gsub(str, '<.->', '')
     str = string.gsub(str, '\n\n\n\n\n', '\n')
     --debug_in_file(str .. '\n')
     m_simpleTV.User.Radio.TrackLyric=str
  end

end

----------------------------------------------------------------
function ShowRadioLyric() 

 if m_simpleTV.User.Radio.TrackLyric~=nil and m_simpleTV.User.Radio.Title~=nil then 
    local lyric = m_simpleTV.User.Radio.TrackLyric
    local title = m_simpleTV.User.Radio.Title
    
    local t = {}
    t.message = lyric
    t.header = title
    t.showTime = 1000*60
    t.once = true
    t.addFontHeight = -2
    --t.addHeaderFontHeight = -1
    t.textAlignment = 1
    t.windowAlignment = 3 --0x0403
    t.textColor = ARGB(255,0,255,0)
    t.windowMaxSizeH = 0.55
    t.windowMaxSizeV = 1
    m_simpleTV.OSD.ShowMessageBox(t)
 end
end
----------------------------------------------------------------
local function getGoogleImg(q)

  m_simpleTV.User.Radio.StoOdinRuCover=nil
  local session = m_simpleTV.Http.New()
  if session == nil then return end

  if trim(q)=='' then 
     m_simpleTV.Http.Close(session) 
     m_simpleTV.User.Radio.GoogleImg = '' 
     return 
  end

  local url = 'https://www.google.ru/search?as_st=y&tbm=isch&hl=ru&as_epq=&as_oq=&as_eq=&cr=&as_sitesearch=&safe=images&tbs=iar:s&as_q=' .. url_encode(q)
  
  --debug_in_file(url .. '\n')
  
  local t={}
  t.url = url
  t.headers = 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8\nreferer: https://www.google.ru/\nsec-fetch-mode: navigate\nsec-fetch-site: same-origin\nuser-agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36 OPR/63.0.3368.107'
  t.callback = 'getGoogleImg_callback'

  m_simpleTV.Http.RequestA(session, t)
  
end

function getGoogleImg_callback(session, rc, answer)

  if rc~=200 then m_simpleTV.Http.Close(session) return end
  --debug_in_file(answer .. '\n')

  local img = ''
  local tt={}
  for w in string.gmatch(answer,'"ou":"(.-)"')  do
    if w == nil then break end
     if not string.match(w, 'fbsbx%.com') then
        tt[#tt+1] = unescape3(w)
     end
  end

  for i=1, #tt do
    rc = m_simpleTV.Http.Request(session, {url=tt[i]})
    if rc==200 then img=tt[i] break end 
  end

  m_simpleTV.User.Radio.GoogleImg=img
  m_simpleTV.Http.Close(session)

   --debug_in_file('GoogleImg   ' .. img .. '\n')
end
------------------------------------------------------------------------------
local function clearTrack(Track)
      htmlEntities = require('htmlEntities')
      local str = Track:gsub('(- 0:00)','')
      str = str:gsub('^(.-)%[.+','%1')
      str = str:gsub('other %-%s+','')
      str = str:gsub('^(.-)||.+','%1')
      str = str:gsub('^%s+%-%s+','')
      str = htmlEntities.decode(str)

  return trim(str)
end
-----------------------------------------------------------------------------------------

if not string.match( m_simpleTV.Control.CurrentAdress, '^http://101%.ru/radio/channel/' ) 
and not string.match( m_simpleTV.Control.CurrentAdress, '^http://101%.ru/radio/user/' )  
and not string.match( m_simpleTV.Control.CurrentAdress, '^http%://101%.ru/%?an=personal' )
and not string.match( m_simpleTV.Control.CurrentAdress, '^http://stream%.pcradio%.ru')
and not string.match( m_simpleTV.Control.CurrentAdress, '^difmid=' ) 
and not string.match(m_simpleTV.Control.CurrentAdress, '^rockradioid=') 
and not string.match(m_simpleTV.Control.CurrentAdress, '^jazzradioid=') 
and not string.match(m_simpleTV.Control.CurrentAdress, '^radiotunesid=') 
and not string.match(m_simpleTV.Control.CurrentAdress, '^classicalradioid=') 
and not string.match(m_simpleTV.Control.CurrentAdress, '^http://hot%.friezy%.ru/%?radio') 
and not string.match(m_simpleTV.Control.CurrentAdress, '^http://relay%.radio%.obozrevatel%.com') 
and not string.match(m_simpleTV.Control.CurrentAdress, '^http://radio%.obozrevatel%.com') 
and not string.match(m_simpleTV.Control.CurrentAdress, '^https://www.obozrevatel.com/radio/') 
and not string.match( m_simpleTV.Control.CurrentAdress, '^http://radio%.promodj%.com' ) 
and not string.match( m_simpleTV.Control.CurrentAdress, 'tunein%.com/radio/')
and not string.match( m_simpleTV.Control.CurrentAdress, '^$tuneinId=')
then return end 

m_simpleTV.User.Radio.isActive = true
-----------------------------------------------------------------------------------------
--[[
if m_simpleTV.Control.Reason=='Error' or m_simpleTV.Control.Reason=='Timeout' then

   if m_simpleTV.User.Radio.PlayCount == nil then
      m_simpleTV.User.Radio.PlayCount = 5
   end
      --debug_in_file(m_simpleTV.User.Radio.PlayCount .. '\n')

     local title = m_simpleTV.Control.CurrentTitle_UTF8

      m_simpleTV.Control.ExecuteAction(63)
      m_simpleTV.User.Radio.PlayCount = m_simpleTV.User.Radio.PlayCount-1   

   if m_simpleTV.User.Radio.PlayCount == 0 then 
      --m_simpleTV.OSD.ShowMessage_UTF8("Error - " .. title .. " not found" ,255,5)
	  m_simpleTV.OSD.ShowMessageT({text= "Error - " .. title .. " not found",color=ARGB(255,255,0,0),showTime=5*1000,id="radioError"})
	  
      m_simpleTV.Control.ExecuteAction(11)
      m_simpleTV.User.Radio.PlayCount = nil      
   end
end
]]
-----------------------------------------------------------------------------------------
if m_simpleTV.User.AudioTitle.ATisEnable ~= 1 then

  if not m_simpleTV.Control.IsVideo() and m_simpleTV.Control.Reason == 'Playing' or m_simpleTV.Control.Reason=='addressready' then

    m_simpleTV.User.Radio.PlayCount = nil
    m_simpleTV.Control.EventPlayingInterval=3000 

--//layout menu--------------------------------------------------------------------------

    if m_simpleTV.User.Radio.ShowMenu==nil then
       m_simpleTV.User.Radio.ShowMenu = true
    end

    if m_simpleTV.User.Radio.ShowMenu then

       local t={}
       t.utf8 = true
       t.name = 'Show Track Lyric'
       t.luastring = 'ShowRadioLyric()'
       t.lua_as_scr = true 
       t.submenu = 'Radio'
       t.key = string.byte('Y')
       t.ctrlkey = 0
       t.location = 0
       m_simpleTV.User.Radio.ShowMenuId1 = m_simpleTV.Interface.AddExtMenuT(t)

       t={}
       t.utf8 = true
       t.name = 'Switch Layout'
       t.luastring = 'user/radio/layouts/switcher.lua'
       t.submenu = 'Radio'
       t.key = string.byte('Y')
       t.ctrlkey = 2
       t.location = 0     
       m_simpleTV.User.Radio.ShowMenuId2 = m_simpleTV.Interface.AddExtMenuT(t)
    end

    m_simpleTV.User.Radio.ShowMenu = false

--end layout menu----------------------------------------------------------------------------------

    local Name=''
    local Logo=''
    local Track=''
    local Station=''

    local t = m_simpleTV.Control.GetCurrentChannelInfo()
       if t~=nil and t.Name~=nil and t.Logo~=nil then
   --[[
      	for i,v in pairs(t) do 
   	    debug_in_file(i .. ' = ' .. v .. '\n')
           end
   ]]
           Name=t.Name
           Logo=t.Logo
    end

    local title=Name
    local cover, artistCover 

    if m_simpleTV.User.Radio.RadioBgPic~=nil then
      if not string.match(m_simpleTV.User.Radio.RadioBgPic, '.:') then 
         cover = m_simpleTV.MainScriptDir .. m_simpleTV.User.Radio.RadioBgPic
       else
         cover = m_simpleTV.User.Radio.RadioBgPic
      end
    end
   
    if m_simpleTV.User.Radio.RadioCoverPic~=nil then
      if not string.match(m_simpleTV.User.Radio.RadioCoverPic, '.:') then 
         artistCover = m_simpleTV.MainScriptDir .. m_simpleTV.User.Radio.RadioCoverPic
       else
         artistCover = m_simpleTV.User.Radio.RadioCoverPic
      end
    end

--//101.ru------------------------------------------------------------------------------------------------
    if string.match(m_simpleTV.Control.CurrentAdress, '^http://101%.ru/radio/channel/') or string.match( m_simpleTV.Control.CurrentAdress, '^http://101%.ru/radio/user/' ) then       

         if m_simpleTV.User.Radio.isRadioTimer==true then

            m_simpleTV.User.Radio.StoOdinRuTitle=nil
            m_simpleTV.User.Radio.StoOdinRuCover=nil          

          local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36 OPR/49.0.2725.47")
          if session ~= nil then 

             local inAdr =  m_simpleTV.Control.CurrentAdress
             
             local num = findpattern(inAdr,'channel/(.+)',1,8,0) 
             if num==nil then
		num = findpattern(inAdr,'user/(.+)',1,5,0) or ''
	     end
             
             --http://101.ru/api/channel/getTrackOnAir/99/channel/?dataFormat=json
             if num~='' then
             
               local url = 'http://101.ru/api/channel/getTrackOnAir/' .. num .. '/channel/?dataFormat=json'
             
               local rc,answer=m_simpleTV.Http.Request(session,{url=url})
               m_simpleTV.Http.Close(session)
               
               if rc==200 and (answer~=nil or answer~='') then 
                   
                  answer = string.gsub(answer,'%[%]','""')
                  answer = unescape1(answer)
                  answer = unescape3(answer)
                  --debug_in_file('answer   ' .. answer .. '\n')

                  local t = json.decode(answer)
   
                  if t ~= nil and t.errorCode~=204 then
                   if t.result~=nil and t.result.short~=nil and t.result.short.title~=nil and t.result.short.cover~=nil then 
                      m_simpleTV.User.Radio.StoOdinRuTitle = Name .. ': ' .. trim(t.result.short.title)
       
                    if t.result.short.cover~=false then
                       if t.result.short.cover.coverHTTP~=nil then
                          m_simpleTV.User.Radio.StoOdinRuCover = trim(t.result.short.cover.coverHTTP) 
                          else
                          if t.result.short.cover.cover400~=nil then
                             m_simpleTV.User.Radio.StoOdinRuCover = trim(t.result.short.cover.cover400) 
                          end
                       end
                    end
   
                    local ms=2500
                    if t.result.stat~=nil and t.result.stat.lastTime~=nil then
                       ms = tonumber(t.result.stat.lastTime)*1000--ms
                    end

                     --debug_in_file('ms   ' .. ms .. '\n')

                     if ms > 1000 then
                        m_simpleTV.User.Radio.RadioTimerId1=nil
                        m_simpleTV.User.Radio.RadioTimerId1= m_simpleTV.Timer.SetTimer(ms,'DeleteRadioTimer()')
                     else
                        m_simpleTV.User.Radio.RadioTimerId1=nil
                        m_simpleTV.User.Radio.RadioTimerId1= m_simpleTV.Timer.SetTimer(6000,'DeleteRadioTimer()')
                     end
   
                   end
                  end
                  
                  if t ~= nil then
                      if t.errorCode==204 then
                         m_simpleTV.User.Radio.StoOdinRuTitle=nil
                         m_simpleTV.User.Radio.StoOdinRuCover=nil
             
                         Track = m_simpleTV.Control.GetMetaInfo(12)
                         if Track~=nil then
                            Track = unescape1(Track)
                            Track = unescape3(Track)
                            Track = string.gsub(Track, '\\', '')
                      
                            --debug_in_file('Track   ' .. Track .. '\n')
             
                           local TrackTitle = string.match(Track, '"title":"(.-)"')
                           if TrackTitle==nil then TrackTitle=clearTrack(Track) end
                           
                           if TrackTitle~=nil and TrackTitle~='' then
                              m_simpleTV.User.Radio.StoOdinRuTitle = Name .. ': ' .. trim(TrackTitle) 
             	           end        	        
             	        
                           local TrackCover = string.match(Track, '"coverHTTP":"(.-)"')
                           if TrackCover~=nil then
                             m_simpleTV.User.Radio.StoOdinRuCover = trim(TrackCover) 
                           end
                           
                           --local ms = string.match(Track, '"duration":"(.-)"') or 6000
                           local ms = 6000
                           m_simpleTV.User.Radio.RadioTimerId2=nil
                           m_simpleTV.User.Radio.RadioTimerId2= m_simpleTV.Timer.SetTimer(ms,'DeleteRadioTimer()')  
                         end         
                      end
                  end
               end
             end

               if m_simpleTV.User.Radio.StoOdinRuTitle==nil then
                  m_simpleTV.User.Radio.RadioTimerId3=nil
                  m_simpleTV.User.Radio.RadioTimerId3= m_simpleTV.Timer.SetTimer(6000,'DeleteRadioTimer()')
               end             
          end   
         end

               m_simpleTV.User.Radio.isRadioTimer=false 

    end  
--end 101.ru---------------------------------------------------------------------------------------------------------

--//PCRadio / TuneIn / MyRadio / promodj-------------------------------------------------------------------------------------------
   if string.match( m_simpleTV.Control.CurrentAdress, '^http://stream%.pcradio%.ru') or string.match( m_simpleTV.Control.CurrentAdress, 'tunein%.com/radio/') or string.match( m_simpleTV.Control.CurrentAdress, '^$tuneinId=') or string.match(m_simpleTV.Control.CurrentAdress, '^https://www.obozrevatel.com/radio/') or string.match( m_simpleTV.Control.CurrentAdress, '^http://radio%.promodj%.com' ) then
   
     m_simpleTV.User.Radio.StoOdinRuTitle=nil
     m_simpleTV.User.Radio.StoOdinRuCover=nil
     
      Track = m_simpleTV.Control.GetMetaInfo(12)
      if Track~=nil then
   
         Track = unescape1(Track)
         Track = unescape3(Track)
         Track = string.gsub(Track, '\\', '')
   
         --debug_in_file('PCRadio   ' .. Track .. '\n')
   
         Track=clearTrack(Track)
   
         if Track~='' then
            title = Name .. ': ' .. Track 
         end
      end
   end
--end PCRadio / TuneIn / MyRadio / promodj--------------------------------------------------------------

--//AudioAddictPlaylist-----------------------------------------------------------------------

     if string.match(m_simpleTV.Control.CurrentAdress, '^difmid=' ) 
     or string.match(m_simpleTV.Control.CurrentAdress, '^rockradioid=') 
     or string.match(m_simpleTV.Control.CurrentAdress, '^jazzradioid=') 
     or string.match(m_simpleTV.Control.CurrentAdress, '^radiotunesid=') 
     or string.match(m_simpleTV.Control.CurrentAdress, '^classicalradioid=') 
     then
         title = Name .. ': ' .. clearTrack(m_simpleTV.Control.CurrentTitle_UTF8) 
     end
--end AudioAddictPlaylist-----------------------------------------------------------------------

     
   if m_simpleTV.User.Radio.StoOdinRuTitle~=nil then
      title = m_simpleTV.User.Radio.StoOdinRuTitle
   end 
      
   --debug_in_file('title   ' .. title .. '\n')  
   --m_simpleTV.Control.SetTitle(title)

--//cover----------------------------------------------------------------------- 
   m_simpleTV.User.Radio.isCover=false
      
   if m_simpleTV.User.Radio.StoOdinRuCover~=nil then
      m_simpleTV.User.Radio.GoogleImg=nil
      cover = m_simpleTV.User.Radio.StoOdinRuCover
      artistCover = cover
      m_simpleTV.User.Radio.isCover = true
   end
   
   if m_simpleTV.User.Radio.AudioAddictPlaylist~=nil then
      cover = m_simpleTV.User.Radio.AudioAddictPlaylist.Cover
      artistCover = cover
      m_simpleTV.User.Radio.isCover = true
   end
   
   if m_simpleTV.User.Radio.GoogleImg~=nil and m_simpleTV.User.Radio.GoogleImg~='' then 
      cover = m_simpleTV.User.Radio.GoogleImg
      artistCover = cover
      m_simpleTV.User.Radio.GoogleImgCount = nil
   end

   if m_simpleTV.User.Radio.GoogleImg=='' then
     
      if m_simpleTV.User.Radio.GoogleImgCount == nil then
         m_simpleTV.User.Radio.GoogleImgCount = 5
      end
      
      GoogleImgCount = m_simpleTV.User.Radio.GoogleImgCount 
      
      if GoogleImgCount > 0 then 
         local q = title:gsub('^.-:.', '')
         getGoogleImg(q)
         GoogleImgCount = GoogleImgCount-1
      else
        if not string.match(m_simpleTV.User.Radio.RadioBgPic, '.:') then 
           cover = m_simpleTV.MainScriptDir .. m_simpleTV.User.Radio.RadioBgPic
         else
           cover = m_simpleTV.User.Radio.RadioBgPic
        end
         m_simpleTV.User.Radio.GoogleImgCount = nil
      end   
      
      --debug_in_file('GoogleImgCount   ' .. GoogleImgCount .. '\n')

   end

    if cover=='' then
        if not string.match(m_simpleTV.User.Radio.RadioBgPic, '.:') then 
           cover = m_simpleTV.MainScriptDir .. m_simpleTV.User.Radio.RadioBgPic
         else
           cover = m_simpleTV.User.Radio.RadioBgPic
        end
    end

    if artistCover=='' then
        if not string.match(m_simpleTV.User.Radio.RadioCoverPic, '.:') then 
           cover = m_simpleTV.MainScriptDir .. m_simpleTV.User.Radio.RadioCoverPic
         else
           cover = m_simpleTV.User.Radio.RadioCoverPic
        end
    end
   
   --debug_in_file('artistCover   ' .. artistCover .. '\n')
   --debug_in_file('cover   ' .. cover .. '\n')


--//RadioOSDTitle always on OSD------------------------------------------------------
   if m_simpleTV.User.Radio.RadioOSDTitle then
      m_simpleTV.OSD.ShowMessageT({text= title,color=ARGB(255,255,255,255),showTime=1000*5,id="channelName"})
   end
------------------------------------------------------------------------------------

   local layout = m_simpleTV.User.Radio.Layout

--//SetTitle---------------------------------------------------------------------------
  
   if m_simpleTV.User.Radio.WinHead==nil or m_simpleTV.User.Radio.WinHead~=title then 

      m_simpleTV.User.Radio.WinHead = title 
      m_simpleTV.Control.SetTitle(m_simpleTV.User.Radio.WinHead)

      --debug_in_file('WinHead   ' .. m_simpleTV.User.Radio.WinHead .. '\n') 

      if not m_simpleTV.User.Radio.isCover then
         local q = title:gsub('^.-:.', '')
         getGoogleImg(q)
      end
    
      if layout==0 or layout==1 then
         m_simpleTV.OSD.ShowMessageT({text= title,color=ARGB(255,255,255,255),showTime=1000*10,id="channelName"})
      end

      title = title:gsub('^.-:.', '')
      m_simpleTV.User.Radio.Title = title
      m_simpleTV.User.Radio.StationName = Name

      if m_simpleTV.User.Radio.Background~=cover then
         m_simpleTV.User.Radio.Background=nil
      end

      getLyric(title)

   end
-------------------------------------------------------------------------------------------

--//Show radio logo------------------------------------
   if m_simpleTV.User.Radio.RadioLogo then
      if layout==1 then
         cover = Logo  
      end
      if layout==2 or layout==3 or layout==4 or layout==5 or layout==6 then        
         artistCover = Logo
      end     
   end
------------------------------------------------------


--//Layouts------------------------------------------

     if layout==0 then
        m_simpleTV.OSD.RemoveElement('DEV_DIV_DEFAULT')
        m_simpleTV.OSD.RemoveElement('DIV_UNDER_BACKGROUND')
        m_simpleTV.OSD.RemoveElement('MAIN_DIV')
        m_simpleTV.Interface.RestoreBackground()

     elseif layout==1 then
         if m_simpleTV.User.Radio.Background~=cover then  
            m_simpleTV.User.Radio.Background = cover
            dofile (m_simpleTV.MainScriptDir .. "user/radio/layouts/layout1.lua")
         end
     elseif layout==2 then
         if m_simpleTV.User.Radio.Background~=cover then  
            m_simpleTV.User.Radio.Background = cover
            m_simpleTV.User.Radio.ArtistCover = artistCover
            dofile (m_simpleTV.MainScriptDir .. "user/radio/layouts/layout2.lua")
         end
     elseif layout==3 then
         if m_simpleTV.User.Radio.Background~=cover then  
            m_simpleTV.User.Radio.Background = cover
            m_simpleTV.User.Radio.ArtistCover = artistCover
            dofile (m_simpleTV.MainScriptDir .. "user/radio/layouts/layout3.lua")
         end
     elseif layout==4 then
         if m_simpleTV.User.Radio.Background~=cover then  
            m_simpleTV.User.Radio.Background = cover
            m_simpleTV.User.Radio.ArtistCover = artistCover
            dofile (m_simpleTV.MainScriptDir .. "user/radio/layouts/layout4.lua")
         end
     elseif layout==5 then
         if m_simpleTV.User.Radio.Background~=cover then  
            m_simpleTV.User.Radio.Background = cover
            m_simpleTV.User.Radio.ArtistCover = artistCover
            dofile (m_simpleTV.MainScriptDir .. "user/radio/layouts/layout5.lua")
         end
     elseif layout==6 then
         if m_simpleTV.User.Radio.Background~=cover then  
            m_simpleTV.User.Radio.Background = cover
            m_simpleTV.User.Radio.ArtistCover = artistCover
            dofile (m_simpleTV.MainScriptDir .. "user/radio/layouts/layout6.lua")
         end
     end
   end
end
-----------------------------------------------------------------------------------------

if m_simpleTV.Control.Reason == 'Stopped' then

     m_simpleTV.Control.EventPlayingInterval=0 
     m_simpleTV.Control.EventTimeOutInterval=0
     if m_simpleTV.User.Radio.WinHead ~= nil then
        m_simpleTV.Control.SetTitle(' ')
     end
     m_simpleTV.User.Radio.WinHead=nil
     m_simpleTV.User.Radio.Background = nil
     m_simpleTV.Control.CurrentTitle_UTF8 = ''
     m_simpleTV.User.Radio.AudioAddictPlaylist = nil
     m_simpleTV.User.Radio.isActive = false
     m_simpleTV.User.Radio.AudioAddictCurrentTitle=nil
     m_simpleTV.User.Radio.isRadioTimer=nil
     m_simpleTV.User.Radio.RadioTimerId1=nil
     m_simpleTV.User.Radio.RadioTimerId2=nil
     m_simpleTV.User.Radio.RadioTimerId3=nil
     m_simpleTV.User.Radio.StoOdinRuTitle = nil
     m_simpleTV.User.Radio.StoOdinRuCover = nil
     m_simpleTV.User.Radio.ShowMenu = nil
     m_simpleTV.User.Radio.GoogleImg = nil
     m_simpleTV.User.Radio.GoogleImgCount = nil

   if m_simpleTV.User.Radio.ShowMenuId2 then
      m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.Radio.ShowMenuId2)
   end

   if m_simpleTV.User.Radio.ShowMenuId1 then
      m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.Radio.ShowMenuId1)
   end

end
-----------------------------------------------------------------------------------

if m_simpleTV.Control.Reason=='EndReached' then

  m_simpleTV.User.Radio.Background = nil
  m_simpleTV.User.Radio.isActive = false
  m_simpleTV.User.Radio.ShowMenu = nil

  if string.match(m_simpleTV.Control.CurrentAdress, '^difmid=' ) 
  or string.match(m_simpleTV.Control.CurrentAdress, '^rockradioid=') 
  or string.match(m_simpleTV.Control.CurrentAdress, '^jazzradioid=') 
  or string.match(m_simpleTV.Control.CurrentAdress, '^radiotunesid=') 
  or string.match(m_simpleTV.Control.CurrentAdress, '^classicalradioid=') 
  then
       local index = #m_simpleTV.User.Radio.AudioAddictPlaylist
       m_simpleTV.User.Radio.AudioAddictPlaylist[index]=nil
       m_simpleTV.Control.Action = 'repeat'
  end
  
   if m_simpleTV.User.Radio.ShowMenuId2 then
      m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.Radio.ShowMenuId2)
   end

   if m_simpleTV.User.Radio.ShowMenuId1 then
      m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.Radio.ShowMenuId1)
   end
end

