--script for http://spbtv.online/channels/ (07/06/2018)

 local UpdateID='SPBTV_TV01'

 local session = m_simpleTV.Http.New()
 if session == nil then return end

-------------------------------------------

 m_simpleTV.OSD.ShowMessage("SPB TV - start channels updating" ,0xFF00,10)


 local host  = 'http://spbtv.online'
 local url = host .. '/channels/'
 local rc,answer= m_simpleTV.Http.Request(session,{url=url})
 m_simpleTV.Http.Close(session)
 
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("SPB TV Connection error - " .. rc ,255,10)
 	   return
  end

--debug_in_file(answer .. '\n')

 local tmp = findpattern (answer,'<div class="channel_lang_select">(.-)</div>',1,1,0)
 if tmp == nil then return end
--debug_in_file(tmp .. '\n')

 local lang,langName
 local t={}
 local i=1
   for w in string.gmatch(tmp,'<li>(.-)</li>') do

      lang = findpattern (w,'href="#(.-)"',1,7,1)
      langName = findpattern (w,'%b><',1,1,1)
      if lang == nil or langName == nil then break end
      t[i] = {}
      t[i][1] = lang
      t[i][2] = langName
--debug_in_file(lang .. '  ' .. langName .. '\n')
  i=i+1
   end

 local tmp2 = findpattern (answer,'<div id="channel_list2">(.-)</div>',1,1,0)
 if tmp2 == nil then return end
--debug_in_file(tmp2 .. '\n')

 local adr,name,img,grp
 local m3ustr = '#EXTM3U\n'

  local function GetGrp(lang)
    grp = ''
      for k, v in ipairs(t) do 
          if lang == v[1] then grp = v[2] end
     end 
    return grp
  end 

    for ww in string.gmatch(tmp2,'free tv(.-)</li>') do

      adr = findpattern (ww,'id="(.-)"',1,4,1)
      grp = findpattern (ww,'class="lang">(.-)<',1,13,1)
      img = findpattern (ww,'span><img src="(.-)"',1,15,1)
      name = findpattern (ww,'autoplay">(.-)<',1,10,1)
      if adr == nil or grp == nil or img == nil or name == nil then break end
      grp = GetGrp(grp)
      if grp=='' then grp='Other' end
      grp = 'SPBTV - ' .. grp
      img = host .. img
      adr = 'spbfreetv=' .. adr
      --debug_in_file(grp .. '  ' .. name .. '  ' .. img .. '  ' .. adr .. '\n')

      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. adr .. '\n'

   end

--debug_in_file(m3ustr .. '\n')
--do return end

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
p.ExtFilter = 'SPBTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\spbtv.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'SPBTV playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8 ('',p,0,true,false)

if err==true then
     local mess = "SPBTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end
