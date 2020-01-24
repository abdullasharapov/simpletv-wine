--script for https://www.arconaitv.us (08/09/2019)

------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
------------------------------------------------------------------------------

 m_simpleTV.OSD.ShowMessage("ArconaiTV: start updating" ,0xFF00,10)

    local url = 'https://www.arconaitv.us'

    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ArconaiTV Connection error 1 - " .. rc ,255,5)
   	   return
    end
  
 --debug_in_file(answer .. '\n')

   answer = string.match(answer, "<div class='box%-content stream%-info'>(.+)")
   if answer==nil then return end

   answer = answer .. 'stream-nav'

   local m3ustr = '#EXTM3U\n'
   local UpdateID='Arconai_TV01'
  
   local t={}
   local name,adr,grp
   local group = 'ArconaiTV - '
   local i=1, j

   for ww in string.gmatch(answer, 'stream%-category(.-)stream%-nav') do
       grp = findpattern(ww, ">(.-)<",1,1,1) or ''

     for w in string.gmatch(ww, "<div class='box%-content'>(.-)</div>") do
       name = findpattern(w, "title='(.-)'",1,7,1) or ''
       adr = findpattern(w, "href='(.-)'",1,6,1) or ''
       
       t[i]={}
       t[i].Id= i
       t[i].Name = name 
       t[i].Address = 'https://www.arconaitv.us/' .. adr
       t[i].Grp = group .. grp
       t[i].Img = ''
       --debug_in_file (t[i].Name .. ' ' .. t[i].Address .. '\n')

      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. t[i].Grp .. t[i].Name .. '" group-title="' .. t[i].Grp .. '" tvg-logo="' .. t[i].Img .. '",' .. t[i].Name .. '\n' .. t[i].Address .. '\n'

       i=i+1
     end
   end
--debug_in_file(m3ustr .. '\n')
 
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
p.ExtFilter = 'ArconaiTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\arconaitv.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'ArconaiTV playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,0,true,false)

if err==true then
     local mess = "ArconaiTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end


