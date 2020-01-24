----------------------------------------------------------------------------------------------
-- Продолжение, начало -  в getaddress.lua (до обработки video скриптами)
-----------------------------------------------------------------------------------------------
local inAdr =  m_simpleTV.Control.CurrentAddress 
if  inAdr==nil or inAdr=="" then return end
tvs_core.tvs_debug('.do finish begin')

----------------------------------------------------
--tvs_core.tvs_debug('   ServerOpt='..(TVSources_var.ServerOpt or 'nil')  )
--tvs_core.tvs_debug('   inAdr=' .. (inAdr or 'nil') )
local retAdr =  tvs_func.SetExtOpt(inAdr) 
if retAdr~=inAdr then
	   m_simpleTV.Control.ChangeAdress = 'Yes'
	   m_simpleTV.Control.ChangeAddress = 'Yes'
       inAdr, m_simpleTV.Control.CurrentAddress,  m_simpleTV.Control.CurrentAddress_UTF8 = retAdr, retAdr, retAdr
       m_simpleTV.Control.CurrentAddress_UTF8 = retAdr
end

if TVSources_var.ServerOpt then 
	if inAdr~="" and inAdr~="wait" and inAdr~="error"  then
	     inAdr = inAdr .. TVSources_var.ServerOpt  
         tvs_core.tvs_debug('Media adr ='.. inAdr )
	    m_simpleTV.Control.CurrentAddress ,  m_simpleTV.Control.CurrentAddress_UTF8 = inAdr, inAdr 
	    TVSources_var.ChangeAddress=true	    
	    TVSources_var.ServerOpt=nil
	end
end

		
if  TVSources_var.IsTVS then
		if  TVSources_var.bwDown==1 and  (inAdr:find("variant%.m3u8") or inAdr:find("variable%.m3u8")  )  then
		    local ok
		    --debug_in_file("BW!")
		    inAdr, ok = tvs_func.BWChange(inAdr) -- тут фиксируем битрейт и опционально понижаем битрейт для HD
		    if ok then 
		       TVSources_var.ChangeAddress = true
	    		m_simpleTV.Control.CurrentAddress ,  m_simpleTV.Control.CurrentAddress_UTF8 = inAdr, inAdr 
		    end
		end
end

----------------------------------------------------
TVSources_var.tmp.iptv_sign = inAdr:match("&tvssrc=(%w+)")
if TVSources_var.tmp.iptv_sign then 
	      tvs_core.tvs_debug('IPTV find: ' .. inAdr)
		  TVSources_var.tmp.Attempt = TVSources_var.tmp.Attempt or 1
	      tvs_core.tvs_debug('Attempt: ' .. TVSources_var.tmp.Attempt)
		  local tmp = inAdr:match('(%d+%.%d+%.%d+%.%d+:%d+&tvssrc=%w+)')
		  if TVSources_var.tmp.OldAdr ~= tmp  then 
		     TVSources_var.tmp.OldAdr = tmp
		     TVSources_var.tmp.Attempt = 1
		  end
		  if TVSources_var.tmp.Attempt == 1 then
		     inAdr = tvs_func.ChangeIpPort(inAdr, TVSources_var.tmp.iptv_sign) or inAdr 
		     --if inAdr=='error' then inAdr='wait' end
		     tvs_core.tvs_debug('IPTV adress: ' .. inAdr)
		  end
		  if inAdr:find('^http') then inAdr = inAdr:gsub("&tvssrc=%w+","") end
		   tvs_core.tvs_debug('IPTV adress 2: ' .. inAdr)
		  TVSources_var.IsTVSsrc = true 
		  TVSources_var.ChangeAddress = true
	      m_simpleTV.Control.CurrentAddress ,  m_simpleTV.Control.CurrentAddress_UTF8 = inAdr, inAdr 

end
----------------------------------------------------
--m_simpleTV.Control.EventPlayingInterval = 4000 
if TVSources_var.ChangeAddress==true then
        TVSources_var.ChangeAddress = false
		tvs_core.tvs_debug('.do finish ok.')
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.ChangeAddress = 'Yes'
		--m_simpleTV.Control.CurrentAddress_UTF8 = m_simpleTV.Control.CurrentAddress
		if TVSources_var.IsTVS and inAdr == '' then 
			m_simpleTV.Control.CurrentAddress = 'wait' 
		end
		if  m_simpleTV.Control.RealAddress or (m_simpleTV.Control.Peers or -1)==-1 or (m_simpleTV.Control.Buffering or 0) < 0.1 then
		    m_simpleTV.Control.EventPlayingInterval = 4000 
			m_simpleTV.Control.EventTimeOutInterval = TVSources_var.ChannelWaiting * 1000 -- ожидание начала воспроизведения
		end
		-- зуглушка, чтобы отработали events в случае ручного переключения каналов 
		-- ( в надежде, что исправится наличие playing с зеленой стрелкой без факта воспроизведения)
		m_simpleTV.Common.Wait(200) 
end

