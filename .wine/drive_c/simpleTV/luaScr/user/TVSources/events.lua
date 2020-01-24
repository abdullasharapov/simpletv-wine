--input
--m_simpleTV.Control.Reason              addressready | Playing| Error | EndReached | Stopped | ScrambledOn | ScrambledOff 
--m_simpleTV.Control.CurrentAddress      Address from database
--m_simpleTV.Control.RealAddress			 Real Address

--output
--m_simpleTV.Control.CurrentAddress      Address from database
--m_simpleTV.Control.Action              dodefault | repeat
--m_simpleTV.Control.EventPlayingInterval = 5000

--[[
tvs_core.tvs_debug(' >>>>>>> Action='.. (m_simpleTV.Control.Action or 'nil'))
tvs_core.tvs_debug(' >>>>>>> Reason='.. (m_simpleTV.Control.Reason or 'nil'))
tvs_core.tvs_debug(' >>>>>>> EventPlayingInterval='.. (m_simpleTV.Control.EventPlayingInterval or 'nil') )
tvs_core.tvs_debug(' >>>>>>> CurrentAddress='.. (m_simpleTV.Control.CurrentAddress or 'nil') )
tvs_core.tvs_debug(' >>>>>>> RealAddress='.. (m_simpleTV.Control.RealAddress or 'nil') )
]]
-----------------------------------------------------------------------------------
if TVSources_var.ServerObj then
	--tvs_core.tvs_debug('+Reason='.. (m_simpleTV.Control.Reason or ''))
	--tvs_core.tvs_debug('+Action='.. (m_simpleTV.Control.Action or ''))
	--tvs_core.tvs_debug('+EventPlayingInterval='.. (m_simpleTV.Control.EventPlayingInterval or 'nil'))
	--tvs_core.tvs_debug('+EventTimeOutInterval='.. (m_simpleTV.Control.EventTimeOutInterval or 'nil'))
	    if  m_simpleTV.Control.Reason=="Error"   then
	           TVSources_var.server.SetStatus("Ready")
	           TVSources_var.server.DoNotFound() 
	   elseif m_simpleTV.Control.Reason=="Stopped" and TVSources_var.server.Status=='Play'  then
	         TVSources_var.server.SetStatus("Ready") 
	   end
	   if  TVSources_var.server.Status=="NeedRedirect"  and m_simpleTV.Control.Reason=='Playing'   then
					local inAdr = m_simpleTV.Control.RealAddress or m_simpleTV.Control.CurrentAddress or ""
					tvs_core.tvs_debug( " Events. Redirect: inAdr=" ..(inAdr or 'nil' ) )
					m_simpleTV.Control.EventTimeOutInterval = 0
					m_simpleTV.Control.EventPlayingInterval = 0
				   if  inAdr=="error"  then    TVSources_var.server.DoNotFound()
				   elseif  inAdr~="" and inAdr~="wait"  then   
						    if  (not TVSources_var.ServerAnswerDelay) or (TVSources_var.ServerAnswerDelay<100)  then
								    TVSources_var.server.DoRedirect()
						    else
								   	local ddd = [[ if TVSources_var.timerServerDelay then  
															        m_simpleTV.Timer.DeleteTimer(TVSources_var.timerServerDelay)  
																    tvs_core.tvs_debug('Media-server: redirect after a delay.')
																	TVSources_var.server.DoRedirect()
														  end	]]
					                 TVSources_var.timerServerDelay =  m_simpleTV.Timer.SetTimer(TVSources_var.ServerAnswerDelay, ddd)
						    end
				   end
	    end
end
----- не TVSources ------------ не iptv ---------------------------------//---- [не нужен редирект в медиасервере] ---------------------------
if  (not TVSources_var.IsTVS and not TVSources_var.IsTVSsrc ) then return end
-----------------------------------------------------------------------------------
local IsAd = (m_simpleTV.Control.IsAD and m_simpleTV.Control.IsAD() or false)
local IsDRM = (m_simpleTV.Control.GetScrambled and m_simpleTV.Control.GetScrambled() or false)

local showme = false

local function EventsShow(showme)
	 if showme then   --  тестовый блок 
		local  text = 'Events values:\n'
		text = text ..'TVSCurrentSource='.. (TVSources_var.CurrentSource or '') .. '\n'
		text = text ..'TVSCurrentAddress='.. (TVSources_var.CurrentAddress or '') .. '\n'
		text = text ..'CurrentTitle='.. (m_simpleTV.Control.CurrentTitle_UTF8 or 'nil') .. '\n'
		text = text ..'RealAddress='.. (m_simpleTV.Control.RealAddress or 'nil') .. '\n' 
		text = text ..'CurrentAddress='.. (m_simpleTV.Control.CurrentAddress or 'nil') .. '\n' 
		text = text ..'ChangeAddress=' .. (m_simpleTV.Control.ChangeAddress or 'nil') .. '\n' 
		text = text ..'Reason='.. (m_simpleTV.Control.Reason or 'nil') .. '\n'
		text = text ..'Action='.. (m_simpleTV.Control.Action or 'nil')..'\n'
		text = text ..'EventPlayingInterval='.. (m_simpleTV.Control.EventPlayingInterval or 'nil') .. '\n'
		text = text ..'EventTimeOutInterval='.. (m_simpleTV.Control.EventTimeOutInterval or 'nil') .. '\n'
		text = text ..'Peers='.. (m_simpleTV.Control.Peers or 'nil') .. '\n'
		text = text ..'Buffering='.. (m_simpleTV.Control.Buffering or 'nil') .. '\n'
		text = text ..'IsAd='.. (IsAd==true and 'true' or 'false') .. '\n'
		text = text ..'IsDRM='.. (IsDRM==true and 'true' or 'false') .. '\n\n' 
		text = text ..'IsTVS='.. (TVSources_var.IsTVS==true and 'true' or 'false') .. '\n'
		
		m_simpleTV.OSD.ShowMessage_UTF8(text ,0xD7EBFA,6)
	 --debug_in_file(text)
	 end 
end

tvs_core.tvs_debug(' Reason='.. m_simpleTV.Control.Reason or '')
tvs_core.tvs_debug(' Action='.. m_simpleTV.Control.Action or '')

if m_simpleTV.Control.Reason=='addressready' or (m_simpleTV.Control.Peers or -1) == -1  or  (m_simpleTV.Control.Buffering or 0) < 0.1 then
	m_simpleTV.Control.EventPlayingInterval = 5000
	m_simpleTV.Control.EventTimeOutInterval = TVSources_var.ChannelWaiting * 1000 -- ожидание начала воспроизведения
end


 EventsShow(showme)

------------- Для IPTV - смена сервера по ctrl+m -------------------------------
if m_simpleTV.Control.RealAddress and m_simpleTV.Control.RealAddress:find('/udp/.+:') then 
	if m_simpleTV.Control.Reason=='addressready' then
	   if not TVSources_var.tmp.MenuId  then
	      --m_simpleTV.OSD.ShowMessage_UTF8('ADD' , 0xffffff, 3)	      
	      	local t ={}
			t.name = 'Смена сервера'
			t.luastring = 'user\\TVSources\\refreshserv.lua'
			t.key = string.byte('M')
			t.ctrlkey = 1
			t.image = TVSources_var.TVSdir .. '\\settings\\img\\btn_refresh_focus.png'
			TVSources_var.tmp.MenuId = m_simpleTV.Interface.AddExtMenuT(t)
	      --TVSources_var.tmp.MenuId = m_simpleTV.Interface.AddExtMenu_UTF8('Смена сервера','user\\TVSources\\refreshserv.lua',string.byte('M'),1)
	   end
	end
end


if m_simpleTV.Control.Reason=='Stopped'   then

    if TVSources_var.tmp.MenuId then
	  --m_simpleTV.OSD.ShowMessage_UTF8('REMOVE' , 0xffffff, 3)
      m_simpleTV.Interface.RemoveExtMenu(TVSources_var.tmp.MenuId)
      TVSources_var.tmp.MenuId=nil
    end  
    m_simpleTV.Control.EventTimeOutInterval = 0
   	TVSources_var.IsTVS = false
   	TVSources_var.IsTVSsrc = false
    if not TVSources_var.ForceCurSource then 
	  TVSources_var.BadSrcCount = 0
	  TVSources_var.tmp.Attempt = 1         
    end
	TVSources_var.RetryCount = 0
	TVSources_var.ErrorRepeatCount = 0   
	--m_simpleTV.Control.RealAddress='' 
    return 
end

if not TVSources_var.IsTVS  then return end

------------- Автообновление базы -------------------------------
local ch_base_update_flag = TVSources_var.TVSdir ..'ch_base_upd.flg'
if TVSources_var.AutoBuild and TVSources_var.AutoBuildFL and (tvs_core.tvs_fcheck(ch_base_update_flag,'yes') == 'ok')   then
	local dd = [[
		if TVSources_var.timerAutoUpdFL then  m_simpleTV.Timer.DeleteTimer(TVSources_var.timerAutoUpdFL)  end
	    tvs_core.tvs_debug('Autoupdate in watching TV. Start autoupdate BuildList ...')
		tvs_core.tvs_BuildList(nil,nil)
	]]
	os.remove(ch_base_update_flag)
	TVSources_var.timerAutoUpdFL =  m_simpleTV.Timer.SetTimer(6000, dd)
	tvs_core.tvs_debug('Autoupdate in watching TV. Detected the autoupdate flag. Start autoupdate timer...')	
	
end

------------- Сохраняем удачный источник -------------------------
if (not IsAd and not IsDRM and m_simpleTV.Control.CurrentTitle_UTF8 and 
    m_simpleTV.Control.Reason=='Playing' and 
    m_simpleTV.Control.IsVideo()==true and
    m_simpleTV.Control.EventPlayingInterval >0) then
 
	local CurrentTitleUTF8 = m_simpleTV.Control.CurrentTitle_UTF8:gsub("%b[]%s+","")  	or ""
    local isNoTimeShift =  m_simpleTV.Control.GetPosition()==1 or m_simpleTV.Control.GetPosition()==0
	if TVSources_var.CurrentSource  then 
	            tvs_core.tvs_debug("TVSources_var.CurrentSource=" ..TVSources_var.CurrentSource)
				 local source = tvs_core.tvs_GetSourceParam()
				 local num = TVSources_var.CurrentSource:match("#(.+)$")  
				 local key = TVSources_var.CurrentSource:gsub("#.+$","")  
			     local CurrentSrcUTF8 =  source[key] and source[key].name or "unknown"
			     CurrentSrcUTF8 = num and CurrentSrcUTF8 .. " #" .. num or CurrentSrcUTF8
			    if not tvs_core.isUTF8(CurrentSrcUTF8) then     CurrentSrcUTF8 = m_simpleTV.Common.string_toUTF8(CurrentSrcUTF8)
				end
					    
				m_simpleTV.Control.SetTitle('['..CurrentSrcUTF8..'] ' .. CurrentTitleUTF8)
			         	
				TVSources_var.BadSrcCount = 0 -- обнуляем счетчик неудачных источников
				TVSources_var.RetryCount = 0
				TVSources_var.ErrorRepeatCount = 0
				local Id,inAdr
				inAdr = string.gsub(m_simpleTV.Control.CurrentAddress,'\'','"')
				if  TVSources_var.IsTVS or inAdr:find('TVSources' ) then
							Id = findpattern(inAdr,'id=%b""',0,4,1) or tvs_core.tvs_clearname(CurrentTitleUTF8) or ''
							tvs_core.tvs_debug (Id ..'. Save last successed stream: ' .. TVSources_var.CurrentAddress.. ' CurrentSrcName='.. CurrentSrcUTF8)
							tvs_core.tvs_SaveLastPlay (Id, TVSources_var.CurrentSource )
							--tvs_core.tvs_debug('inAdr=' ..inAdr )
							TVSources_var.ChangeAddress = false		
				end	
	else
	  	tvs_core.tvs_debug (' Error save last successed stream. CurrentSource is nil. ')
	end
    if  TVSources_var.IsTVS or inAdr:find('TVSources' ) then
							m_simpleTV.Control.EventPlayingInterval = 0
							m_simpleTV.Control.EventTimeOutInterval = 0
	end
	-- EventsShow(showme)

end

-------------------------- нет сигнала в источнике -----------------------------------------------
         
if ( not IsAd  and  m_simpleTV.Control.CurrentTitle~=nil and 
   (   m_simpleTV.Control.Reason == 'ScrambledOn'  or
       m_simpleTV.Control.Reason == 'Stopped' or 
       m_simpleTV.Control.Reason == 'Error' or m_simpleTV.Control.RealAddress=="error" or
       m_simpleTV.Control.Reason == 'EndReached' or 
       m_simpleTV.Control.Reason == 'Timeout' and m_simpleTV.Control.Buffering < 0.1 )  
   and 
   (   m_simpleTV.Control.Action == 'dodefault' or m_simpleTV.Control.Action == 'repeat') 
   ) then
    
	local CurrentTitleUTF8 = m_simpleTV.Control.CurrentTitle_UTF8 
	local inAdr = string.gsub(m_simpleTV.Control.CurrentAddress,"'",'"')
	local retAdr = TVSources_var.CurrentAddress or 'empty'
			
	local tmpName,tmpSrc,default,Id, tmpSrcKey

	Id = findpattern( inAdr,'id=%b""',0,4,1) or tvs_core.tvs_clearname(CurrentTitleUTF8) or ''
	default = findpattern( inAdr,'df=%b""',0,4,1) or TVSources_var.Default or ''
	
	local rrr = m_simpleTV.Control.Reason
    if rrr == 'Timeout' then
       rrr = rrr .. ' '..TVSources_var.ChannelWaiting ..' sec.'
	   tvs_core.tvs_debug(CurrentTitleUTF8 .. '. 0 ID: ' .. Id .. ', No signal on URL: ' .. retAdr .. ' Reason='..rrr)
    end   

	if Id == ''  then return end 
	
    --  для  iptv пробуем 3 раза подключиться 
	if m_simpleTV.Control.Reason == 'Error' and TVSources_var.IsTVSsrc then
	    TVSources_var.ErrorRepeatCount = (TVSources_var.ErrorRepeatCount or 0 ) + 1
	    if   TVSources_var.ErrorRepeatCount < 3 then
			m_simpleTV.Control.Action = 'repeat'
			return
		end 
	end
	-- если влючена настройка искать сл. источник
	if TVSources_var.NextSr  then
		TVSources_var.BadSrcCount = TVSources_var.BadSrcCount + 1
		tmpSrc, tmpName, tmpSrcKey = tvs_core.tvs_GetUrlById (Id, default, retAdr, TVSources_var.UseTimeShift)
		tmpSrc = tmpSrc or ''
		CurrentTitleUTF8 = CurrentTitleUTF8 or ''
		--TVSources_var.SrcKey = tmpSrcKey or  ''
		if tmpSrc=='stop'  then
		    --TVSources_var.BadSrcCount = 0
			TVSources_var.RetryCount = (TVSources_var.RetryCount or 0 ) + 1
			tvs_core.tvs_debug(CurrentTitleUTF8 .. '. Event 1: ID: ' .. Id .. '. Need stop. Retry=' .. TVSources_var.RetryCount )
			---------------------------------------------------------     режим воспроизведения "не останавливать при ошибке"
			if TVSources_var.RetryCount >= TVSources_var.ErrRepeatCount or m_simpleTV.Config.GetConfigInt(2700)==0 then
			  tvs_core.tvs_debug('stop')
			  m_simpleTV.Control.ExecuteAction(11) -- 11 (KEYSTOP)
			  TVSources_var.RetryCount = 0
			  return
			end 
            m_simpleTV.Control.CurrentAddress = 'wait'
		end				

	    if tmpName and tmpSrc then 		
			tvs_core.tvs_debug(CurrentTitleUTF8 .. '. Event 2: ID: ' .. Id .. '. Source: ' .. tmpSrc .. ', Start play URL: ' .. tmpName)
			if TVSources_var.OSDMes[3]==1 then
			   tvs_core.tvs_ShowError('['.. tmpSrc .. ']',0xffffff,3) 
	        end
			TVSources_var.CurrentAddress = tmpName
			TVSources_var.CurrentSource = tmpSrcKey -- tmpSrc
			m_simpleTV.Control.CurrentAddress = tmpName
	        TVSources_var.IsTVS = true
		end
		EventsShow(showme)
		TVSources_var.ChangeAddress = true
		if m_simpleTV.Control.Reason == 'ScrambledOn' then  
		     TVSources_var.ForceCurSource = TVSources_var.CurrentSource
		     tvs_core.tvs_debug('restart ' .. m_simpleTV.Control.Action .. ' ' ..m_simpleTV.Control.Reason..' '..TVSources_var.CurrentSource)
			 m_simpleTV.Control.PlayAddress_UTF8(TVSources_var.CurrentAdr,CurrentTitleUTF8)
			 return
		end
		
		m_simpleTV.Control.Action = 'repeat'
		
	else
		dofile (TVSources_var.TVSdir .. '\\selectsource.lua')
	end
end
