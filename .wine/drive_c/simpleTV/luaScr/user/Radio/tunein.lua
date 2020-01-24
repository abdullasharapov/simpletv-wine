--script for tunein.com (31/10/2019) 
-- open address https://tunein.com/radio/Rock-FM-952-s107263/

------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress

if inAdr==nil then return end

 if not string.match( inAdr, 'tunein%.com/radio/') and not string.match( inAdr, '^$tuneinId=') then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = 'error'
----------------------------------------

 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)

---------------------------------------------------------------------------

local id,name,adr,img,desc
local grp=m_simpleTV.User.Radio.RadioTuneInGrpName
local m3ustr = '#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\TuneIn\\"\n'

 if string.match( inAdr, 'tunein%.com/radio/') then
   local rc,answer = m_simpleTV.WinInet.Request(session,{url=inAdr})
   --m_simpleTV.WinInet.Close(session)
       
   if rc~=200 then
      m_simpleTV.WinInet.Close(session)
      m_simpleTV.OSD.ShowMessage("tunein Connection error 1 " .. rc ,255,3)
      return
   end
--debug_in_file(answer .. '\n\n')

  answer = string.gsub(answer,'\\u002F', '/')
  answer = string.gsub(answer,'\\r\\n', ' ')

  id = findpattern(answer,'"profiles":{"(.-)"',1,13,1)
  if id == nil then return end

  name = findpattern(answer,'"title":"(.-)"',1,9,1)
  if name == nil then return end

  adr='$tuneinId=' .. id

  img = findpattern(answer,'"image":"(.-)"',1,9,1) or ''
  desc = findpattern(answer,'"description":"(.-)"',1,15,1) or ''

   m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'

end

if string.match( inAdr, '^$tuneinId=') then
   id = string.gsub(inAdr, '$tuneinId=', '')
   name = m_simpleTV.Control.CurrentTitle
end


  local url = 'https://opml.radiotime.com/Tune.ashx?id=' .. id .. '&render=json&formats=mp3,aac,ogg,hls'

    rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
    m_simpleTV.WinInet.Close(session)
       
   if rc~=200 then
      m_simpleTV.WinInet.Close(session)
      m_simpleTV.OSD.ShowMessage("tunein Connection error 2 " .. rc ,255,3)
      return
   end
--debug_in_file(answer .. '\n\n')

  require('json')

  local tab = json.decode(answer)
  if tab ==nil or tab.body == nil then return end
  
  local t={}
  local i=1
  local retAdr

    while true do
        if tab.body[i] == nil or tab.body[i].url == nil or tab.body[i].bitrate == nil then break end     

            t[i]={} 
            t[i].Id=i
            t[i].Name=tab.body[i].bitrate 
            t[i].Adress=tab.body[i].url

            --debug_in_file(t[i].Name .. '  ' .. t[i].Adress .. '\n\n')  

           i=i+1
 
     end

    local tt={}
    local bitrate=0
    local index=0
    
    for i=1, #t do
    
            tt[i]={}
            tt[i].Id=i
            tt[i].Name=t[i].Name .. 'kbps'
            tt[i].Adress=t[i].Adress
    
            if tonumber(t[i].Name) > bitrate then
               bitrate = tonumber(t[i].Name)
               retAdr = tt[i].Adress
               index = i-1
            end
    end

  if #t>1 then
     m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.Common.multiByteToUTF8(name),index,tt,10000,32+64)
  end

 m_simpleTV.Control.CurrentAdress = retAdr .. '$OPT:http-user-agent=TuneIn'

if string.match( inAdr, 'tunein%.com/radio/') then

  if m_simpleTV.User.Radio.RadioAddTuneIn == true then

      --опции  для загрузки плейлиста 
    local p={}
    p.Data = m3ustr
    p.TypeSourse = 1
    p.DeleteBeforeLoad = 0
    p.TypeSkip   = 1
    p.TypeFind =   0
    p.AutoSearch = 1
    p.NumberM3U =  1
    p.Find_Group = 1
    p.TypeCoding = 1  --  -1-auto  0 - plane text  1- UTF8  2- unicode
    p.BorpasFileFormat=1
    p.AutoNumber = 0
    p.ExtFilter = 'TuneIn'
    p.ExtFilterLogo =  '..\\Channel\\logo\\icons\\tunein.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
    p.ExtFilterLogoForce = 0
    --p.UpdateID=UpdateID
    --p.ShowProgressWindow = 1
    --p.ProgressWindowHeader = 'TuneIn playlist loading progress'
    
      local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,m_simpleTV.User.Radio.TypeMedia,true,false)
      
      if err==true then
           local mess = "TuneIn - " 
      	 if add ~= 0 then 
      	    names = string.gsub(names,'%$end','')
    		mess = mess .. names .. " added"
      	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0xFF00,5)
      
      	 end	 
      	 
      end
  end
end







