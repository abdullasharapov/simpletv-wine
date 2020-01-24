 --tunein (08/10/2019)
------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
------------------------------------------------------------------------------
local function clearStr(str)
  str=str:gsub('\\r\\n',' ')
  return str
end

 require('json')

local UpdateID = 'TuneIn01' 
local m3ustr = '#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\TuneIn\\"\n'
local count=1

local function getStations(url,grp)

    m_simpleTV.OSD.ShowMessage("TuneIn Playlist updating. Channels: " .. count ,0xFF00,10)

    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    if rc~=200 then return end

    answer = string.gsub(answer,'\\r','')
    answer = string.gsub(answer,'\\n','')

    answer = string.gsub(answer,'%[%]','""')
    local tab = json.decode(answer)
    if tab==nil then return end
   
    local i=1
    local name,adr,desc,img,ctype,cnavUrl
    local j,a

    while true do
       if tab.Items[i]==nil or tab.Items[i].ContainerType==nil then break end
   
       ctype=tab.Items[i].ContainerType

       if ctype~=nil and ctype=='Categories' then
       j=1
        while true do  
         if tab.Items[i].Children[j]==nil then break end  
            grp = tab.Items[i].Children[j].Title
            if grp==nil then grp='TuneIn Other' end
   
            adr = tab.Items[i].Children[j].Actions.Browse.Url
            if adr~=nil then    
            --debug_in_file( adr .. '\n')    
               getStations(adr,grp)
            end   
           j=j+1
         end
       end

      if ctype~=nil and ctype=='Stations' then
      j=1
        while true do  
         if tab.Items[i].Children[j]==nil then break end  

            name = tab.Items[i].Children[j].Title or ''
            adr = tab.Items[i].Children[j].Actions.Play.GuideId  or ''
            adr = '$tuneinId=' .. adr
            desc = tab.Items[i].Children[j].Description or 'TuneIn'
            if desc=='' then desc='TuneIn ' .. grp end
            desc = clearStr(desc)
            img = tab.Items[i].Children[j].Image or ''
           -- debug_in_file(i .. '  ' .. grp .. '  ' .. name .. '  ' .. adr .. '  ' .. desc ..'\n')  
           

            m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" update-code="' .. UpdateID .. grp .. adr .. '" group-title="TuneIn ' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'

           j=j+1
           count=count+1
         end

          if tab.Items[i] and tab.Items[i].ContainerNavigation and tab.Items[i].ContainerNavigation.Url then
             cnavUrl = tab.Items[i].ContainerNavigation.Url
          
             if cnavUrl~=nil then
                cnavUrl = cnavUrl:gsub('limit=30','limit=30') .. '&offset=25' --çàìåíÿòü íà limit=60 è áîëüøå íåæåëàòåëüíî
                --debug_in_file(cnavUrl .. '\n')
                  getStations(cnavUrl,grp)
             end  
          end
       end

      if ctype~=nil and ctype=='Undefined' then

         if tab.Items[i]==nil then break end  

         if tab.Items[i].Type=='Station' then
            name = tab.Items[i].Title or ''
            adr = tab.Items[i].Actions.Play.GuideId  or ''
            adr = '$tuneinId=' .. adr
            desc = tab.Items[i].Description or 'TuneIn'
            if desc=='' then desc='TuneIn ' .. grp end
            desc = clearStr(desc)
            img = tab.Items[i].Image or ''
            --debug_in_file(i .. '  ' .. grp .. '  ' .. name .. '  ' .. adr .. '  ' .. desc ..'\n') 

            m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" update-code="' .. UpdateID .. grp .. adr .. '" group-title="TuneIn ' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'

         end

      end

      i=i+1
      count=count+1
    end

end

    m_simpleTV.OSD.ShowMessage("TuneIn Playlist start updating" ,0xFF00,10)

    local url = 'https://tunein.com/radio/music/'
    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    --m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("TuneIn Connection error 1 - " .. rc ,255,5)
   	   return
    end
  
--debug_in_file(answer .. '\n')

   local tuneInUserSerial = string.match(answer, 'tuneInUserSerial":"(.-)"')
   if tuneInUserSerial==nil then return end

    url = 'https://api.tunein.com/categories/music?formats=mp3,aac,ogg,hls&partnerId=RadioTime&serial=' .. tuneInUserSerial
    rc,answer = m_simpleTV.Http.Request(session,{url = url})
    --m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("TuneIn Connection error 2 - " .. rc ,255,5)
   	   return
    end

--debug_in_file(answer .. '\n')
 
 answer = string.gsub(answer,'%[%]','""')
 local tab = json.decode(answer)
 if tab==nil then return end

 local i=1
 local name,adr,grp,cat
 local j

 while true do
    if tab.Items[i]==nil or tab.Items[i].ContainerType==nil then break end
    cat=tab.Items[i].ContainerType
    if cat~=nil and cat=='Categories' then
    j=1
     while true do  
      if tab.Items[i].Children[j]==nil then break end  
         grp = tab.Items[i].Children[j].Title
         if grp==nil then grp='TuneIn Other' end

         adr = tab.Items[i].Children[j].Actions.Browse.Url
         if adr==nil then adr='' end  

         if not string.match(adr,  'c100001772') then   
            --debug_in_file(grp .. '  ' ..  adr .. '\n') 
            getStations(adr,grp)
	 end 
        j=j+1
      end
     
    end
   i=i+1
 end

--test
--url = 'https://api.radiotime.com/categories/g390?serial=b066904a-7151-4ed6-a12f-0e88ab0f84f2&partnerId=RadioTime&formats=mp3%2caac%2cogg%2chls&viewModel=False&itemToken=BgcHAAIAAgABAAEAEREMFHsGAAEHExYAAAATFgAAAA'
--grp = '50s'
--getStations(url,grp)

m_simpleTV.Http.Close(session)
--debug_in_file(m3ustr .. '\n')

  --îïöèè  äëÿ çàãğóçêè ïëåéëèñòà 
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
p.ExtFilter = 'TuneIn'
p.ExtFilterLogo =  '..\\Channel\\logo\\icons\\tunein.png'    -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'TuneIn Playlist loading progress'


local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList_UTF8 ('',p,m_simpleTV.User.Radio.TypeMedia,true,false)

   if err==true then
        local mess = "TuneIn playlist updated (" .. add .. ")"
   	 if add > 0 and add < 25 then 
   	    names = string.gsub(names,'%$end','\n')
   		mess = mess .. '\n' .. names
   	 end
   	 
   	 m_simpleTV.OSD.ShowMessage_UTF8(m_simpleTV.Common.multiByteToUTF8(mess),0xFF00,5)
   	 
   end
 