-- script for PCradio (14/10/2019)

--load images from local disc - '', source - 1, cloud.mail.ru - 2 
local source = 1
-----------------------------------

 local UpdateID='PCRADIO01'

 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.108 Safari/537.36 OPR/50.0.2762.45")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,10000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,10000,0)
-----------------------------------------------------------------
--[[]
 local url =  "http://pcradio.biz/player/listradio/pcradio_ru.xml"  

 local rc,answer=m_simpleTV.WinInet.Get(session,url)
 m_simpleTV.WinInet.Close(session)

 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
	   return
 end
]]

local weblink_view = ''

if source == 2 then

 local rc,answer=m_simpleTV.WinInet.Request(session,{url='https://cloud.mail.ru/public/4KYo/55jc6Vrvn/RadioAddonLogo/PCradio/'})
--m_simpleTV.WinInet.Close(session)
 if rc~=200 then
	   m_simpleTV.WinInet.Close(session)
	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
	   return
 end

--debug_in_file(answer .. '\n')

weblink_view = string.match(answer,'weblink_view.-url":.-"(.-)"') or ''

end
--do return end
--[[
--new url http://stream.pcradio.ru/list/list_ru/list_old_ru.zip
--p78951233215987

local url = "http://pc-radio.ru/player/listradio_zip/list_ru/radio_list_new.zip"

 local path  = m_simpleTV.Common.GetMainPath(2) .. 'unpack\\'
--debug_in_file (path)
 local file = path .. 'tmp.zip'

 local rc = m_simpleTV.WinInet.GetFile(session, url ,nil, file) 
 if rc~=200 then return end

 local shell = os.getenv('COMSPEC')
 if shell==nil then return end
 shell = m_simpleTV.Common.string_toUTF8(shell)
 if shell==nil then return end
 local processid = m_simpleTV.Common.Execute (shell, '/C cd /d "' .. path .. '" &7za.exe x -y -p7895123 "' .. file ..'" &rename *.xml tmp',0x08000000,1)
 if processid == nil then m_simpleTV.OSD.ShowMessage_UTF8('PCradio script error',255,5) return end



 local fhandle = io.open (path .. 'tmp' , "r")
 if fhandle == nil then return nil end
 local answer = fhandle:read('*a')
 fhandle:close()

 os.remove(file)
 os.remove(path .. 'tmp')
   
--debug_in_file(answer)
--do return end

 if not string.match(answer,'<channel>') then
	   m_simpleTV.OSD.ShowMessage("PCradio - ошибка обновления " ,255,10)
    return
end

 m_simpleTV.OSD.ShowMessage("PCradio - start updating" ,0xFF00,10)
 
local m3ustr='#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\PCradio\\"\n'

local t = {}
local i=1
local genre_id,genre_sait
local img=''

for ww in string.gmatch(answer, '<genre>(.-)</genre>') do

       genre_id = string.match(ww,'<id>(.-)</id>')   
       genre_sait = string.match(ww,'<name>(.-)</name>')
       if genre_id == nil or genre_sait == nil then break end
       genre_sait = string.gsub(genre_sait,',',' ')
       genre_sait = string.gsub(genre_sait,'%s+',' ')

       t[i] = {}
       t[i][1] = tonumber(genre_id)
       t[i][2] = genre_sait
--debug_in_file( t[i][1] .. '  ' ..  t[i][2] .. '\n')
   i=i+1
end

local function GetGrp(id)
      for i, v in ipairs(t) do 
        if id == v[1] then return v[2] end
     end 
 return id
end 

local name,adr,grp,id,desc
for w in string.gmatch(answer, '<channel>(.-)</channel>') do
       grp =''
       id = string.match(w,'<genre_id>(.-)</genre_id>')   
       name = string.match(w,'<title>(.-)</title>')
       adr = string.match(w,'<url_hi>(.-)</url_hi>')
       desc = string.match(w,'<desc>(.-)</desc>')
       if desc == nil then desc = '' end
       desc = desc:gsub('\n',' ')
       --grp = string.match(w,'<genre_sait>(.-)</genre_sait>')
       if id == nil or name == nil or adr == nil or grp == nil then break end
       name = string.gsub(name,',',' ')
       --grp = string.gsub(grp,',',' ')
       --if id =='27' then id ='2' end
       --if id =='28' then id ='3' end
       grp = GetGrp(tonumber(id))


    if id ~= '29' then

     if source == 1 then
       img = string.match(w,'<img>(.-)</img>') or ''
      elseif source == 2 then
          if weblink_view~='' then 
             name = name:gsub(' ', '%%20')
             name = name:gsub(',', '%%2C')
             name = name:gsub('&', '%%26')
             img = weblink_view .. '4KYo/55jc6Vrvn/RadioAddonLogo/PCradio/' .. name .. '.jpg'
          end
     end

      m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" update-code="' .. UpdateID .. grp .. name .. '" group-title="PCradio ' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '$OPT:http-user-agent=pcradio\n'
 
     -- m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" update-code="' .. UpdateID .. grp .. name .. '" video-title="' .. desc .. '" video-desk="' .. desc .. '",PCradio ' .. grp .. ':' .. name .. '\n' .. adr ..'$OPT:http-user-agent=pcradio' ..'\n' 
    end
end
--debug_in_file(m3ustr)

local  tmpName = m_simpleTV.Common.GetTmpName()
 if tmpName==nil then 
		return 
 end 
 local tfile = io.open(tmpName,'w+')
 if tfile==nil then 
	os.remove(tmpName)
	return
 end
  
 tfile:write(m3ustr)
 tfile:close() 

]]

 local list = m_simpleTV.MainScriptDir .. "user/radio/list.json"
 local fhandle = io.open (list, "r")
 if fhandle == nil then return end
 local answer = fhandle:read('*a')
 fhandle:close()

 require('json')

 answer = answer:gsub(':%[%]',':""')
 local t = json.decode(answer)
 if t == nil or t.stations==nil or t.genres==nil or t.subgenres == nil then return end
 
 local i=1
 local m3ustr = '#EXTM3U $LogoPath="..\\Channel\\logo\\RadioAddonLogo\\PCradio\\"\n'
 local name, adr, grp, desc, genre, subgenre
 local img=''
 local UpdateID='PCradio01'
 local j

local function getGrpName(t,grp,genre)

     j=1
     while true do
      if t.genres[j] == nil then break end
         if tonumber(t.genres[j].id) == tonumber(genre) then 
            grp = grp .. t.genres[j].name
            break
         end
      j=j+1
     end
     return grp
end



 while true do
   m_simpleTV.OSD.ShowMessage("PCradio - start updating" ,0xFF00,10)
   if t.stations[i] == nil then break end
     name =  t.stations[i].name
     name = name:gsub(',', '.')
     adr  =  t.stations[i].stream  
     desc = t.stations[i].descr
     desc = desc:gsub('\r','')
     desc = desc:gsub('\n','')
     genre = t.stations[i].genres_ids[1]
     grp = 'PCradio '
     grp = getGrpName(t,grp,genre)

     --if i > 50 then break end   
     
     if source == 1 then
        if t.stations[i].logo~=nil then
           img = t.stations[i].logo
        end
      elseif source == 2 then
          if weblink_view~='' then 
             name = name:gsub(' ', '%%20')
             name = name:gsub(',', '%%2C')
             name = name:gsub('&', '%%26')
             img = weblink_view .. '4KYo/55jc6Vrvn/RadioAddonLogo/Classicalradio/' .. name .. '.png'
          end
      end
   	
--debug_in_file(name .. ' ' .. adr .. ' ' .. grp .. '\n')
      m3ustr = m3ustr .. '#EXTINF:-1 skipepg="1" video-title="' .. desc .. '" video-desk="' .. desc .. '" update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr ..'-hi$OPT:http-user-agent=pcradio' .. '\n'
 
   i = i+1
 end

--debug_in_file(m3ustr)

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
p.ExtFilter = 'Radio'
p.AutoNumber = 0
p.UpdateID=UpdateID
p.ExtFilterLogo =  '..\\Channel\\logo\\icons\\radio.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'PCradio playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList_UTF8 ('',p,m_simpleTV.User.Radio.TypeMedia,true,false)
   if err==true then
        local mess = "PCradio - радиостанции обновлены (" .. add .. ")"
   	 if add > 0 and add < 25 then 
   	    names = string.gsub(names,'%$end','\n')
   		mess = mess .. '\n' .. names
   	 end
   	 
   	 m_simpleTV.OSD.ShowMessage(mess,0xFF00,5)
   	 
   end
