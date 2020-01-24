 --shaluntv (11/04/2019)
------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
------------------------------------------------------------------------------
 local m3ustr = '#EXTM3U\n'
 local UpdateID = 'ShalunTV_TV01' 

    local url = 'http://shalun-tv.com'
    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ShalunTV Connection error 1 - " .. rc ,255,5)
   	   return
    end
  
--debug_in_file(answer .. '\n')
--do return end

   answer = findpattern(answer, '<tbody>(.-)</tbody>',8000,0,0)
   if answer == nil then return end

   local t={}
   local i=1
   local name,adr,img
   local grp = 'ShalunTV 18+'

  for w in string.gmatch(answer, '<a(.-)</a>') do 
         name = string.match(w, 'center;">(.-)<')
         adr = string.match(w, 'href="(.-)"')
         img = string.match(w, 'src="(.-)"')
         if name==nil or adr==nil or img==nil then break end

         img = url .. img
    
         t[i]={}
         t[i].Id= i
         t[i].Name = name 
         t[i].Address = url .. adr
         --debug_in_file (t[i].Name .. ' ' .. t[i].Address .. '\n')

      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. t[i].Name .. '" group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. t[i].Name .. '\n' .. t[i].Address .. '\n'
    i=i+1
  
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
p.ExtFilter = 'ShalunTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\shaluntv.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'ShalunTV playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,0,true,false)

if err==true then
     local mess = "ShalunTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end
 