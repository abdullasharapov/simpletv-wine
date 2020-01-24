 --zona-iptv (13/08/2019)
------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
------------------------------------------------------------------------------
 local m3ustr = m_simpleTV.Common.multiByteToUTF8('#EXTM3U\n#EXTINF:-1 group-title="ZonaIPTV",ZonaIPTV\n$zonaiptv\n' 
 .. '#EXTINF:-1 group-title="ZonaIPTV",Плейлист IPTV спортивных каналов\n$zonaiptv=https://pastebin.com/raw/1tcKVSQ1\n'

 .. '#EXTINF:-1 group-title="ZonaIPTV - SlyNet",FreeBestTV\n$zonaiptvslynet=https://pastebin.com/raw/TV3nbexd\n'
 .. '#EXTINF:-1 group-title="ZonaIPTV - SlyNet",Веб-Камеры Мира\n$zonaiptvslynet=https://pastebin.com/raw/zDf9U3fi\n'
 .. '#EXTINF:-1 group-title="ZonaIPTV - SlyNet",FreeWorldTV (Зарубежные каналы)\n$zonaiptvslynet=https://pastebin.com/raw/2tqedVGU\n'
 .. '#EXTINF:-1 group-title="ZonaIPTV - SlyNet", 3G Low Quality for mobile\n$zonaiptvslynet=https://pastebin.com/raw/qEwU3y28\n'
 .. '#EXTINF:-1 group-title="ZonaIPTV - SlyNet",AdultsSlyNet (Только 18+)\n$zonaiptvslynet=https://pastebin.com/raw/xKNDz8AS\n'
 .. '#EXTINF:-1 group-title="ZonaIPTV - SlyNet",KinodromSlyNet (Фильмы и мульты) \n$zonaiptvslynet=https://pastebin.com/raw/EcW4MxNh\n'
 .. '#EXTINF:-1 group-title="ZonaIPTV - SlyNet",RadioSlyNet (Радио более 1000 станций)\n$zonaiptvslynet=https://pastebin.com/raw/smKzHhVt \n'

)

 local UpdateID = 'ZonaIPTV_TV01' 
--[[
    local url = 'http://iptv.slynet.tv/slynetlazywizard'
    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ZonaIPTV Connection error 2 - " .. rc ,255,5)
   	   return
    end
  
--debug_in_file(answer .. '\n')
  
   local t={}
   local i=1
   local name,adr
   local grp = 'ZonaIPTV - SlyNet'

  for w in string.gmatch(answer, '<playlist>(.-)</playlist>') do 
         name = string.match(w, '<comment>(.-)</comment>')
         adr = string.match(w, '<url>(.-)</url>')
         if name==nil or adr==nil then break end
    
         t[i]={}
         t[i].Id= i
         t[i].Name = name 
         t[i].Address = '$zonaiptvslynet=' .. adr
         --debug_in_file (t[i].Name .. ' ' .. t[i].Address .. '\n')
      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. t[i].Name .. '" group-title="' .. grp .. '",' .. t[i].Name .. '\n' .. t[i].Address .. '\n'
    i=i+1
  
  end
]]

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
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\default.jpg'   -- the logo of extended filter (from ver. 0.4.8 b9)

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,0,true,false)

if err==true then
     local mess = "ZonaIPTV playlists loaded"	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0xFF00,10)
end
 