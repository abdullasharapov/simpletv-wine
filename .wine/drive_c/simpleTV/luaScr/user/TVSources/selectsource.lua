-- выбор источника --
-------------------------------------------------------------------
if TVSources_var.isMenuShowSelect  then
   m_simpleTV.Control.ExecuteAction(108)
   TVSources_var.isMenuShowSelect = false
   return
end
--------------------------------------------------------------------
local cur_title, cur_address = tvs_core.PlaylistGetSelectedItem()

local inAdr = m_simpleTV.Control.CurrentAddress_UTF8 or m_simpleTV.Control.CurrentAddress or TVSources_var.CurrentAddress
local inTitle = m_simpleTV.Control.CurrentTitle_UTF8 or ''

--m_simpleTV.OSD.ShowMessage_UTF8('Выбор источника ' ..inAdr , 0xffffff, 5)

TVSources_var.BadSrcCount = 0
TVSources_var.tmp.Attempt = 1

if not TVSources_var.isMenuShowSelect and inAdr and (TVSources_var.IsTVS == true or inAdr:find("^TVSources &")) then

    inAdr = inAdr:gsub("'",'"')
	local retAdr = inAdr 
	
	local Id
	if inAdr:find('TVSources &') then 
		Id = inAdr:match('id="(.-)"')  or tvs_core.tvs_clearname(inTitle)
	else
		Id = tvs_core.tvs_clearname(inTitle)
	end
	if Id == nil then return end
	
	local ch_list =  tvs_core.tvs_ListQuery(Id)
	if  not ch_list then return end
	
	local source = tvs_core.tvs_GetSourceParam()  -- TVSources_var.tmp.source = tvs_core.tvs_GetSourceParam()
	
	local t={}

	local users, str_users
	local i = 1

	for i=1,#ch_list do
	    str_users =''
	    t[i] = {}
	    t[i].Id  =  i
        --- предобработка --
			local SourceNumber = ch_list[i][1]:match('(#.-)$') or ''
			if SourceNumber ~= '' then 
				ch_list[i][1] = string.gsub(ch_list[i][1],'#(.-)$','')
			end
			if source[ch_list[i][1]] then
				ch_list[i][3] = ch_list[i][1]
				ch_list[i][1] = source[ch_list[i][1]].name or tvs_core.tvs_GetLangStr('src_group')
				 if SourceNumber ~= '' then 
				     ch_list[i][1] = ch_list[i][1] .. ' ' ..SourceNumber
				end
			else
				ch_list[i][1] = '[unknown]'
				ch_list[i][3] = ''
			end	        
		    if ch_list[i][2]:find(':') and ch_list[i][3] then
		    	if source[ch_list[i][3]] and source[ch_list[i][3]].ip then
		    	 users = checkudpxy.checkhost( source[ch_list[i][3]].ip, source[ch_list[i][3]].port, 0.3 )
		    	 if users>=0 then str_users = ' (' .. users .. ' польз.)' end
		    	end
		    end	
		--------------------   
		t[i].Source = ch_list[i][1] 
		t[i].Name =  ch_list[i][1] .. str_users
		t[i].sortname =''
		if source[ch_list[i][3]] then
		      t[i].sortname = (source[ch_list[i][3]].sortname or '').. ch_list[i][1] 
		end
	    t[i].Src_key = ch_list[i][3] .. SourceNumber
	    t[i].Adress = '$TVSSTART="' .. t[i].Src_key ..'"_' .. ch_list[i][2] .. '_TVSEND'
		t[i].Adr1 = ch_list[i][2]
		i = i+1
	end

	--tvs_func.quicksort(t,'sortname')
	
	local b=1
	
	for i=1,#t  do   -- после сортировки индекс тоже надо переприсвоить
	    --if TVSources_var.CurrentSource == t[i].Name:gsub(' %b()','') then b=i end
	    if t[i].Src_key == TVSources_var.CurrentSource then b=i end
	    t[i].Id = i
	    t[i].Name =  i ..'. ' ..t[i].Name 
	    --[[
	    debug_in_file("i="..i)
	    debug_in_file(t[i].Source)
	    debug_in_file(t[i].Name)
	    debug_in_file( t[i].Adress )
	    ]]
	end	
	
   --m_simpleTV.Control.SetTitle(m_simpleTV.Control.CurrentTitle_UTF8:gsub("%b[]%s+",""))
   local  ret,id = m_simpleTV.OSD.ShowSelect_UTF8( "TVS: " ..(inTitle or tvs_core.tvs_GetLangStr('source_sel')),b-1,t,5000,  8+64, "user\\TVSources\\core\\onselectsrc.lua")	  
   TVSources_var.isMenuShowSelect = true

   --  m_simpleTV.OSD.ShowMessage_UTF8( 'id= '.. (id or 'nil') .. '\n' .. 'ret= '.. (ret or 'nil') , 0xffffff, 5)

  -- m_simpleTV.Common.SetForeground()
   
end