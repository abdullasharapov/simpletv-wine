--script 123tvnow (12/04/2019)

------------------------------------------------------------------------------
  local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36 OPR/58.0.3135.127")
  if session == nil then return end
------------------------------------------------------------------------------

 m_simpleTV.OSD.ShowMessage("USTVNOW: start updating" ,0xFF00,10)

    local url = 'http://123tvnow.com/category/united-states-usa/'

    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    --m_simpleTV.Http.Close(session)
    if rc~=200 then
   	   m_simpleTV.Http.Close(session)
   	   m_simpleTV.OSD.ShowMessage("ustvnow Connection error 1 - " .. rc ,255,5)
   	   return
    end
  
 --debug_in_file(answer .. '\n')

 local str = answer
 local i=1

 while true do
    if string.match(answer, 'video%-thumb')==nil then break end
 
    local tt={}
    tt.url = 'http://123tvnow.com/wp-admin/admin-ajax.php'
    tt.body = 'action=_123tv_load_more_videos_from_category&cat_id=1&page_num=' .. i
    tt.method = 'post'
    tt.headers = 'Referer: http://123tvnow.com/category/united-states-usa/\nContent-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest'
    
    rc,answer = m_simpleTV.Http.Request(session, tt)
    if rc~=200 then return end
   
    str = str .. answer
  i=i+1
 end

m_simpleTV.Http.Close(session)

str=str:gsub('&#038;','&')

--debug_in_file(str .. '\n')

 local m3ustr = '#EXTM3U\n'
 local UpdateID = 'USTVNOW_TV01'

 local t={}
 local name,adr,img
 local grp = 'USTVNOW'
 i=1
 for w in string.gmatch(str, '<div class="video%-thumb">(.-)<div') do 
       name = string.match(w, 'alt="(.-)"')
       adr = string.match(w, 'href="(.-)"')
       img = string.match(w, 'src="(.-)"') or ''
       if name==nil or adr==nil then break end
  
       t[i]={}
       t[i].Id= i
       t[i].Name = name 
       t[i].Address = adr
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
p.NumberM3U =  1
p.Find_Group = 1
p.TypeCoding = 1  --  -1-auto  0 - plane text  1- UTF8  2- unicode
p.BorpasFileFormat=1
p.AutoNumber = 0
p.ExtFilter = 'USTVNOW'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\123tvnow.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'USTVNOW playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,0,true,false)

if err==true then
     local mess = "USTVNOW - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end

