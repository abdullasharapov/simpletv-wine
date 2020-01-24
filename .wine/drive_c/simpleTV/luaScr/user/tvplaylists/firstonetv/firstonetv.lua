--script for firstonetv (15/04/2018)

 local UpdateID='firstonetv_TV01'

 local host = 'https://www.firstonetv.net' 
--------------------------------------------------------------------------

 local session = m_simpleTV.Http.New()
 if session == nil then return end

--------------------------------------------------------------------------

 m_simpleTV.OSD.ShowMessage("FirstOneTV: start loading playlist" ,0xFF00,10)

 local url = host .. '/Live'
 local rc,answer = m_simpleTV.Http.Request(session,{url=url})
 --m_simpleTV.Http.Close(session)

 if rc~=200 then
	   m_simpleTV.Http.Close(session)
	   m_simpleTV.OSD.ShowMessage("FirstOneTV connection error - " .. rc ,255,3)
	   return
 end

--debug_in_file(answer ..  '\n')
--do return end

 local m3ustr='#EXTM3U\n'
 local name,adr,grp,img

 local t ={}
 local i=1
 for w in string.gmatch(answer,'<div class="post%-des">(.-)</a>') do

     url = findpattern (w,'href="(.-)"',1,6,1)
     grp = findpattern (w,'title="(.-)"',1,7,1)
     if url == nil or grp == nil then break end
        
     url = host.. url
--debug_in_file(grp .. '  ' .. url .. '\n')

	t[i] =  {}
	t[i].url = url
	t[i].grp = 'FirstOneTV - ' .. grp
  i=i+1
 end
--do return end

  local j=1
  for i=1,#t do

     url = t[i].url
     grp = t[i].grp

     m_simpleTV.Common.Wait(400)
     rc,answer=m_simpleTV.Http.Request(session,{url=url})
   
     if rc~=200 then
    	   m_simpleTV.Http.Close(session)
    	   m_simpleTV.OSD.ShowMessage("FirstOneTV connection error - " .. rc ,255,3)
    	   return
     end

      for ww in string.gmatch(answer,'<div class="post%-thumb">(.-)</a>') do
      m_simpleTV.OSD.ShowMessage("FirstOneTV: start loading playlist ("..j..")" ,0xFF00,5)

             adr = findpattern (ww,'href="(.-)"',1,6,1)
             name = findpattern (ww,'alt="(.-)"',1,5,1)

             img = findpattern (ww,'<img src="(.-)"',1,10,1)
        
             if adr == nil or name == nil then break end
             if img == nil then img = '' end
                
             img = host .. img 
             adr = host .. adr 

             if not string.match(name, 'Hidden') then
                m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'

               j=j+1
            end
      end  

  end
m_simpleTV.Http.Close(session)
--debug_in_file(m3ustr)
--do return end


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
p.ExtFilter = 'FirstOneTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\firstonetv.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'FirstOneTV playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList_UTF8 ('',p,0,true,false)
if err==true then
     local mess = "FirstOneTV: channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0xFF00,5)
	 
end
