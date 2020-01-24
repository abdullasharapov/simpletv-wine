local function GetFilterID() 
	local data = m_simpleTV.Database.GetTable('SELECT Id FROM ExtFilter WHERE Name="' .. TVSources_var.TVSname..'";' )
	if data and data[1] then return data[1].Id or 0  end
	return 0	
end

--------------добавляем / удаляем инфо-кнопку в плейлист ----------------

if  m_simpleTV.PlayList.AddItemButton  then
	if TVSources_var.InfoButton==1 then
	   if not TVSources_var.InfoButtonID0 then
			local t ={}			
			t.Image = TVSources_var.TVSdir .. 'settings\\img\\TVSourcesButton.png' 
			t.EventFunction = 'tvs_ShowExtInfo_OnToolTip'
			t.IsTooltip = true --opt default = false
			t.Mode = 7   --opt default=7 ( bitmask  1 - main playlist  2 - OSD playlist 4 - OSD playlist fullscreen) 
			t.DrawOnChannel = true   --opt default =true
			t.DrawOnGroup   = false   --opt default =false
			t.MediaMode =  0 --opt default -1 (-1 all, 0 - channels, 1 - files, etc)  
			t.AlignH = 1 --opt default 0 (0 - left,1-right )
			t.ExtFilterID = GetFilterID()  --opt default 0
			t.MaxSize =16   --opt default 0
			if tvs_func.exists(t.Image) then			
				TVSources_var.InfoButtonID0 = m_simpleTV.PlayList.AddItemButton(t)
			else 
				m_simpleTV.Interface.MessageBox( t.Image,'Файл не найден',0)
			end 
	   end
	else
	    if TVSources_var.InfoButtonID0 then 
			m_simpleTV.PlayList.RemoveItemButton(TVSources_var.InfoButtonID0)	
			TVSources_var.InfoButtonID0 = nil   
	    end 
	end
end
----------------------------------------------------------------------
local function TablePrepare(t)
   -- for i=1,15 do     t[#t+1] = i ..". Новый X"     end
    if type(t)~='table' then return '' end
	local str, rows= "", 15
  	for y=1, rows do
	   for x=y, #t, rows do	   
	        str = str .. string.format("%-15s\t", t[x])
	   end
	   str = str .. '\n'
	end
  	return str:gsub("\n\n","")     -- table.concat(txt,'\n') 
end

local ver = m_simpleTV.Common.GetVersion()

function tvs_ShowExtInfo_OnToolTip(ChannelID) --event function if t.IsTooltip = true
    local header, sql = '' , ''
   if ver<800 then
        sql = "SELECT m.Name as Name, m.Adress as Adress, e.Name as Filter FROM Main AS m LEFT JOIN ExtFilter AS e ON m.ExtFilter = e.Id  WHERE m.Id=" .. ChannelID 
   else
        sql = "SELECT m.Name, m.Address, e.Name as Filter FROM Channels AS m LEFT JOIN ExtFilter AS e ON m.ExtFilter = e.Id  WHERE m.Id=" .. ChannelID             
   end
	local data = m_simpleTV.Database.GetTable(sql)
	if data==nil or data[1] == nil then return end	

    local Id = data[1].Address:match('id="(.-)"') or data[1].Address:match("id='(.-)'") 	
    header = (data[1].Filter==TVSources_var.TVSname) and 'Источники:' or data[1].Filter 
	local txt = data[1].Address
    --debug_in_file(Id)
    --debug_in_file(txt)
    	
	if Id  then
	    local ch_list =  tvs_core.tvs_ListQuery(Id)
		if ch_list then 				
			local tmp_t = TVSources_var.tmp.source	
			if type(tmp_t)~='table' then 
			   TVSources_var.tmp.source = tvs_core.tvs_GetSourceParam() 
			   tmp_t = TVSources_var.tmp.source	
			end				
			if tmp_t  then
			    local  txt_tbl, src, num = {}, '', ''
				for i,_ in pairs(ch_list) do
				    src, num = '',''
				    if type(ch_list[i]) == 'table' then
				   		src = ch_list[i][1]:gsub('#(%d+)$','') 
				    	num = ch_list[i][1]:match('(#%d+)$') or ''				    
				    end
					if tmp_t[src] then
						txt_tbl[#txt_tbl+1]  = i ..'. '..tmp_t[src].name .. num 
					else
					    txt_tbl[#txt_tbl+1]  = i ..'. [empty]'	
					end
				end
				txt = TablePrepare(txt_tbl)
				--debug_in_file(txt)
			end
		end
    end
    	 
	return header, txt
end

function tvs_ShowExtInfo_OnPress(ChannelID) --event function if t.IsTooltip = false
 --m_simpleTV.Interface.MessageBox( '' .. ChannelID,m_simpleTV.Common.string_toUTF8('Тест'),0) --MB_OK 
end  	
-----------------------------------------------------------