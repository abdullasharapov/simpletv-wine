--script ustvgo (11/11/2019)

------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36 OPR/64.0.3417.92")
  if session == nil then return end
------------------------------------------------------------------------------
 require('jsdecode')

 m_simpleTV.OSD.ShowMessage("USTVGO: start updating" ,0xFF00,10)

--m_simpleTV.Http.SetCookies(session, 'http://ustvgo.tv/', '','sucuri_cloudproxy_uuid_a4115a454=401e0c472a6d7d547a0f54b7e64b8483')

    local url = 'http://ustvgo.tv/'

    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    --m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ustvgo Connection error 1 - " .. rc ,255,5)
   	   return
    end
  
   -- debug_in_file(answer .. '\n')
   
    local scr = string.match(answer,'<script>(.-)e%(r%);</script>')
    if scr == nil then return end
   
    local res = jsdecode.DoDecode('r', false, scr, 0)
    if res == nil then return end
    --debug_in_file (res .. '\n')
   
    res = string.gsub(res, 'document%.cookie','cc')
   
   local cc = jsdecode.DoDecode('cc', false, res, 0)
   if cc == nil then return end
   --debug_in_file (cc .. '\n')
      
   m_simpleTV.Http.SetCookies(session, 'http://ustvgo.tv/', '', cc)

    url = 'http://ustvgo.tv/'

    rc,answer = m_simpleTV.Http.Request(session,{url = url})
    --m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ustvgo Connection error 2 - " .. rc ,255,5)
   	   return
    end
  
 --debug_in_file(answer .. '\n')

 local str = answer
 local i=2

 while true do
    if string.match(answer, 'next page%-numbers')==nil then break end
 
    url='http://ustvgo.tv/page/' .. i .. '/'
    rc,answer = m_simpleTV.Http.Request(session,{url = url})
    if rc~=200 then return end
   
    str = str .. answer
  i=i+1
 end

m_simpleTV.Http.Close(session)
--debug_in_file(str .. '\n')

 local m3ustr = '#EXTM3U\n'
 local UpdateID = 'USTVGO_TV01'

 local t={}
 local name,adr,img
 local grp = 'USTVGO'
 i=1

 for w in string.gmatch(str, '<a class="mh%-thumb%-icon mh%-thumb%-icon%-small%-mobile"(.-)</a>') do 

       img=string.match(w, 'src="(.-)"') or ''

       t[i]={}
       t[i].Id= i
       t[i].Img = img 
       --debug_in_file (t[i].Img .. '\n')

   i=i+1
 end

 i=1
 for w in string.gmatch(str, '<h3 class="entry%-title mh%-posts%-list%-title">(.-)</h3') do 
       name = string.match(w, 'title="(.-)"')
       adr = string.match(w, 'href="(.-)"')
       if name==nil or adr==nil then break end
  
      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '" tvg-logo="' .. t[i].Img .. '",' .. name .. '\n' .. adr .. '\n'
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
p.NumberM3U =  1
p.Find_Group = 1
p.TypeCoding = 1  --  -1-auto  0 - plane text  1- UTF8  2- unicode
p.BorpasFileFormat=1
p.AutoNumber = 0
p.ExtFilter = 'USTVGO'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\ustvgo.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'USTVGO playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,0,true,false)

if err==true then
     local mess = "USTVGO - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end

