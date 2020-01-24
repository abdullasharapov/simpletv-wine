if TVSources_var.timerStartID then 	
	m_simpleTV.Timer.DeleteTimer(TVSources_var.timerStartID)
end

--------------добавляем инфо-кнопку в плейлист ----------------
dofile(TVSources_var.TVSdir .. 'core\\tvs_info_button.lua')


--------------подгружаем модули iptv-----------------------------
tvs_func.Preload_iptv_modules()

------- автообновление списка источников ------------------
local ch_base_update_flag = TVSources_var.TVSdir ..'ch_base_upd.flg'
-- обновление разрешено ------- разрешено именно сегодня ---------------------------- проверяем не обновлялись ли сегодня -----------------------------------
if TVSources_var.AutoBuild and (TVSources_var.AutoBuildDay[os.date('%w')+1] == 1) and (os.date('%d.%m.%Y') ~= os.date('%d.%m.%Y', TVSources_var.LastStart)) then
	local flg = io.open (ch_base_update_flag,"w+") 
    if flg ~= nil then
		flg:write()
		flg:close()
		tvs_core.tvs_debug('Autoupdate. Creating the autoupdate flag... ok.')
	else
		tvs_core.tvs_debug('Autoupdate. Creating the autoupdate flag... error.')
	end
end

------------- проверяем флаг автообновления ---------------
if TVSources_var.AutoBuild and (tvs_core.tvs_fcheck(ch_base_update_flag,'yes') == 'ok') then
	os.remove(ch_base_update_flag)
	tvs_core.tvs_debug('Autoupdate. Detected the autoupdate flag. Start autoupdate...')
	tvs_core.tvs_BuildList(nil,nil)
end

if type(TVSources_var.tmp.source)~='table' then TVSources_var.tmp.source = tvs_core.tvs_GetSourceParam() end

if type(TVSources_var.tmp.source)=='table' then 
	local id_source,content 
	for id_source,content in pairs(TVSources_var.tmp.source) do
-------------это внешний источник---------------------------------------------стоит отметка обновления при старте--------------------------день недели обновления--------------------------------------------------сегодня еще не обновлялись-------------------------------------------------------
		if	TVSources_var.tmp.source[id_source].TypeSource == 1 and TVSources_var.tmp.source[id_source].AutoBuild == 1 and (TVSources_var.tmp.source[id_source].AutoBuildDay[os.date('%w')+1] == 1) and (os.date('%d.%m.%Y') ~= os.date('%d.%m.%Y', TVSources_var.tmp.source[id_source].LastStart)) then
			tvs_core.tvs_debug('Autoupdate ExtSource: ' .. TVSources_var.tmp.source[id_source].name .. '. Start process...')
			tvs_core.UpdateSource(id_source)		
		end
	end
else 
	TVSources_var.tmp.source = {}
end

----------------------------------------------------------

--- в режиме разработчика --------------------------------
if TVSources_var.DMode==1 and TVSources_var.DMtimer then 
	--m_simpleTV.OSD.ShowMessage_UTF8(string.format('TVS: Время загрузки %.3f sec.',TVSources_var.DMtimer),0xffffff,10)
	TVSources_var.DMtimer = nil
end