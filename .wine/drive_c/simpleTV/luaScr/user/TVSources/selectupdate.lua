tvs_core.tvs_debug('KeyPressed Select Update.')
-------------------------------------------------------------------
 
function UpdateSourceX(SID)   -- функция добавлена для получения плейлиста для IPTV из кеша , с подменой m3u и с последующим восстановлением. 
		local save_fname = TVSources_var.tmp.source[SID].m3u
	    TVSources_var.tmp.source[SID].m3u_saved = save_fname
		
		local out, err, fname = 'notemptytext', 'error', save_fname
		if TVSources_var.tmp.source[SID].scraper:find("%.lua") and save_fname:find('^https?://') then
		    out, err, fname = tvs_func.get_m3u(save_fname)  -- получаем имя файла шаблона: сайт или кеш
		end

		if out:len() > 1  then 
			
			TVSources_var.tmp.source[SID].m3u = fname   
			
			local status, result = true, ''
			--status, result = pcall(function () tvs_core.UpdateSource(SID, true) end)  
			tvs_core.UpdateSource(SID, false)
			
			TVSources_var.tmp.source[SID].m3u = save_fname
			TVSources_var.tmp.source[SID].LastStart = os.time()
			tvs_core.tvs_SaveSources()
			   
		else 
			m_simpleTV.OSD.ShowMessage_UTF8( TVSources_var.tmp.source[SID].name ..": " .. err,0xffffff,3) 	
		end
end
--------------------------------------------------------------------

--------------------------------------------------------------------
local src = tvs_core.tvs_GetSourceParam()
if not src then 
   m_simpleTV.OSD.ShowMessage_UTF8('Sources not found',0xffffff,3)  
  return 
end
local t={} 

local i=0
local name
for k,v in pairs(src) do
     if v.STV.add==1 or v.TVS.add==1 then
		i=i+1
		t[i]={}
		t[i].Id = i
		t[i].SID = k
		name = v.name
		t[i].Name = name
		if v.sortname=='' then t[i].sortname = name
		else t[i].sortname = v.sortname .. name
		end
     end 
end 
	
	assert(tvs_func.quicksort(t,'sortname'))
	
	for i=1,#t  do   -- после сортировки индекс тоже надо переприсвоить
	    t[i].Id = i
	end

TVSources_var.tmp.source = src
TVSources_var.tmp.tvs_ch = nil
----------------------------------------------------------
TVSources_var.tmp.RefreshPlst = true

if i>0 then
   local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(tvs_core.tvs_GetLangStr('source_upd'),0,t,10000,1+4+8)
   if t[id] then
    local SID = t[id].SID
	os.remove(TVSources_var.TVSdir .. 'ch_base_upd.flg')
	local ok, err = tvs_core.CheckVersion(TVSources_var.tmp.source[SID].scraper)		
	if ok then  
	    tvs_core.tvs_debug('','AddChannels.log',true,true)
	    tvs_core.tvs_debug('','FilterChannels.log',true,true)
		UpdateSourceX(SID)
	else
		m_simpleTV.OSD.ShowMessage_UTF8(t[id].Name .. ": " .. (err or ''),0x00ffff,3)
		m_simpleTV.Common.Wait(3000)
	end
   end 
end
TVSources_var.tmp.RefreshPlst = false

collectgarbage()
