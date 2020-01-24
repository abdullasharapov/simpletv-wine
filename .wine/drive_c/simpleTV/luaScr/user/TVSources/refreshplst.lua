--local tvs_core = require('tvs_core')

tvs_core.tvs_debug('KeyPressed Refresh PlayList.')
-----------------------------------------------------------------------

function UpdateSourceX(SID)   -- функция добавлена для получения плейлиста для IPTV из кеша , с подменой m3u и с последующим восстановлением. 
		local save_fname = TVSources_var.tmp.source[SID].m3u
	    TVSources_var.tmp.source[SID].m3u_saved = save_fname

		local out, err, fname = 'notemptytext', 'error', save_fname		
		if TVSources_var.tmp.source[SID].scraper:find("%.lua") and save_fname:find('http://') then
			out, err, fname = tvs_func.get_m3u(save_fname)  -- получаем имя файла шаблона: сайт или кэш
		end

		if out:len() > 1  then 
		
			TVSources_var.tmp.source[SID].m3u = fname
			local status, result = true, ''
			tvs_core.UpdateSource(SID, true)

			TVSources_var.tmp.source[SID].m3u = save_fname
			TVSources_var.tmp.source[SID].LastStart = os.time()
			   
		else 
			m_simpleTV.OSD.ShowMessage(TVSources_var.tmp.source[SID].name ..": " .. err,0xffffff,3) 	
		end
end
----------------------------------------------------------------------

----------------------------------------------------------------------

-------------------------------------------------------------------------

TVSources_var.tmp.source = {}
TVSources_var.tmp.source = tvs_core.tvs_GetSourceParam()

if not TVSources_var.tmp.source  then 
   m_simpleTV.OSD.ShowMessage_UTF8('Sources not found',0xffffff,3)  
  return 
end

--------------------------------------------------------------------------
if TVSources_var.AutoClearBase==1 then   
	tvs_core.tvs_debug('Autoclear base...')
 	tvs_core.ClearBase()
	tvs_core.tvs_debug('Autoclear base ok.')	
end
--------------------------------------------------------------------------
if TVSources_var.DelBase==1 then    
	tvs_core.tvs_debug('Delete TVS channels...')
 	if tvs_core.DelBaseTVS() then
	   tvs_core.tvs_debug('Delete TVS channels ok.')	
	end
end

--do return end
--------------------------------------------------------------------------
	local t={} 
	local i=0
	for k,v in pairs(TVSources_var.tmp.source) do
		 if v.TypeSource == 1 and v.RefreshButton == 1 then
			i=i+1
			t[i]={}
			t[i].Id = i
			t[i].SID = k
			t[i].Name = v.name
			if v.sortname=='' then t[i].sortname = v.name
			else t[i].sortname = v.sortname .. v.name
			end
		 end 
	end 
		
	tvs_func.quicksort(t,'sortname')
	
	for i=1,#t  do   -- после сортировки индекс тоже надо переприсвоить
	    t[i].Id = i
	end
--------------------------------------------------------------------
	local source_filter = {}
	if tvs_core.tvs_fcheck(TVSources_var.TVSdir .. "core\\sources_filter.lua") == "ok" then
	   source_filter = dofile(TVSources_var.TVSdir .. "core\\sources_filter.lua")
	end          
---------------------------------------------------------------------          
	local id_source 
	TVSources_var.tmp.RefreshPlst = true
	tvs_core.tvs_debug('','AddChannels.log',true,true)
	tvs_core.tvs_debug('','FilterChannels.log',true,true)
	for id=1,#t do 
		id_source = t[id].SID
		local tmp_src = TVSources_var.tmp.source[id_source]
		local tmp_ch_name = tvs_core.tvs_lowcase(tvs_core.tvs_clear_double_space(tmp_src.name))
    --------это внешний источник-----обновлять по кнопке "Обновить Плейлист" --- и нет в фильтре источников 
		if	tmp_src.TypeSource == 1 and tmp_src.RefreshButton == 1  and source_filter[tmp_ch_name] == nil then

			m_simpleTV.OSD.ShowMessage_UTF8(tvs_core.tvs_GetLangStr("src_group")..': '..t[id].Name,0x00ffff,3)
			tvs_core.tvs_debug('Update ExtSource: ' .. tmp_src.name .. '. Start process...')
			local ok, err = tvs_core.CheckVersion(tmp_src.scraper)		
			if ok then  
				--m_simpleTV.Common.Wait(500)
				TVSources_var.tmp.tvs_ch = nil
				UpdateSourceX(id_source)
			else
		        m_simpleTV.OSD.ShowMessage_UTF8(t[id].Name .. ": " .. (err or ''),0x00ffff,3)
				m_simpleTV.Common.Wait(3000)
			end
		    			
		end
	end
	TVSources_var.tmp.RefreshPlst = false
    
    tvs_core.tvs_SaveSources()  -- изменилось дата последнего обновления в источниках


if TVSources_var.KeyPlsMake then   
    os.remove(TVSources_var.TVSdir ..'ch_base_upd.flg') 
	tvs_core.tvs_debug('Update sources from SimpleTV base...')
 	tvs_core.tvs_BuildList(nil,nil)
	tvs_core.tvs_debug('Update sources from SimpleTV base... Build ok.')	
end

	
m_simpleTV.OSD.ShowMessage_UTF8(tvs_core.tvs_GetLangStr('tvs_refr_plst_end'),0xdddddd,10)
	

collectgarbage()


-----------------------
-- старая версия , без сортировки --

--	for id_source,_ in pairs(TVSources_var.tmp.source) do
    --------это внешний источник-----------------------------------стоит отметка обновления по кнопке "Обновить Плейлист"---
--		if	TVSources_var.tmp.source[id_source].TypeSource == 1 and TVSources_var.tmp.source[id_source].RefreshButton == 1 then
--			tvs_core.tvs_debug('Update ExtSource: ' .. TVSources_var.tmp.source[id_source].name .. '. Start process...')
--			collectgarbage("stop")
--			UpdateSourceX(id_source)
--			collectgarbage()
--		    m_simpleTV.Common.Wait(4000)			
--		end
--	end

--TVSources_var.tmp = nil
--TVSources_var.tmp = {}


