--get address 1 

if m_simpleTV.Control.ChangeAdress ~= 'No' or m_simpleTV.Control.ChangeAddress~='No' or m_simpleTV.Control.CurrentAddress==nil then return end
 tvs_core.tvs_debug('.do gataddress begin')

local inAdr =  m_simpleTV.Control.CurrentAddress 
TVSources_var.ChangeAddress 	= false
--    tvs_core.tvs_debug('   1 ServerOpt='..(TVSources_var.ServerOpt or 'nil')  )
tvs_core.tvs_debug('  1 inAdr=' .. inAdr)

tvs_core.tvs_debug('  1 EventPlayingInterval='.. (m_simpleTV.Control.EventPlayingInterval or 'nil') )
	
if not ( inAdr:find('^$TVSSTART') or inAdr:find("&tvssrc=") or inAdr:find('TVSources &') ) then return end


TVSources_var.ExtOpt = inAdr:match('(%$OPT:.+)') or ''

tvs_core.tvs_debug(' Control.MainMode='..m_simpleTV.Control.MainMode)
m_simpleTV.Control.EventPlayingInterval = 0
m_simpleTV.Control.EventTimeOutInterval = 0

tvs_core.tvs_debug(' EpgOffsetRequest='.. (m_simpleTV.Timeshift.EpgOffsetRequest or 'nil'))
TVSources_var.UseTimeShift = ( (m_simpleTV.Timeshift.EpgOffsetRequest or 0)>0 and true or false)
 
if inAdr:find('^$TVSSTART') then
	TVSources_var.CurrentSource = inAdr:match('tvs%d+') or 'Unknown'
	if not tvs_core.isUTF8(TVSources_var.CurrentSource) then
       TVSources_var.CurrentSource = m_simpleTV.Common.string_toUTF8(TVSources_var.CurrentSource) 
       inAdr = m_simpleTV.Common.string_toUTF8(inAdr)
	end	
	inAdr = inAdr:gsub('$TVSSTART=%b""_',''):gsub('_TVSEND','')
	tvs_core.tvs_debug('ChangeAdress: CurrentAddress=' .. inAdr .. ' CurrentSource=' .. (TVSources_var.CurrentSource or 'nil'))
	m_simpleTV.Control.CurrentAddress, m_simpleTV.Control.CurrentAddress_UTF8 = inAdr,  inAdr
	TVSources_var.ChangeAddress = true
	TVSources_var.IsTVS = true
	TVSources_var.CurrentAddress = inAdr
 	if not TVSources_var.ForceCurSource then  return end
end

if  not inAdr:find('TVSources &') then 
	TVSources_var.AutoErrorBuild = false
	if not TVSources_var.ForceCurSource then  return  end
end

TVSources_var.Offset = inAdr:match('([?&]offset.-)$') or inAdr:match('([?&]utcstart.-)$') or ''
tvs_core.tvs_debug('ChangeAdress: CurrentAddress=' .. inAdr )
tvs_core.tvs_debug('TVSources_var.Offset:' .. TVSources_var.Offset )

TVSources_var.CurrentAdr = inAdr

TVSources_var.AutoErrorBuild = true
TVSources_var.IsTVS = true

	
local tmpName,tmpSrc,tmpSrc2,default,Id, tmpSrcKey

local CurrentTitleUTF8 =  m_simpleTV.Control.CurrentTitle_UTF8:gsub("%b[]%s+","")  

local Id = inAdr:match('id="(.+)"') or inAdr:match("id='(.+)'") or tvs_core.tvs_clearname(CurrentTitleUTF8) 
if Id == nil then return end

local default = TVSources_var.Default or ''

tvs_core.tvs_debug(CurrentTitleUTF8 .. '. ID: ' .. Id  .. ', Default Source: ' .. default .. '. Address: ' .. inAdr)	


if TVSources_var.LastPlay and TVSources_var.LastPlay==true  and not TVSources_var.ForceCurSource   then 

	tmpSrc = tvs_core.tvs_GetLastPlay(Id) 
	tvs_core.tvs_debug("LastPlay tmpSrc=".. (tmpSrc or 'nil')) 
	tmpSrc, tmpName, tmpSrcKey = tvs_core.tvs_GetUrlById (Id, tmpSrc, true, TVSources_var.UseTimeShift)  -- берем свежий урл
    if not tvs_core.isUTF8(tmpSrc) then
       tmpSrc = m_simpleTV.Common.string_toUTF8(tmpSrc)
	end
	if tmpName ~= nil then
		if TVSources_var.OSDMes[2]==1 then
		   tvs_core.tvs_ShowError('['.. tmpSrc .. ']',0xffffff,1) 
	    end
		tvs_core.tvs_debug(CurrentTitleUTF8 .. '. ID: ' .. Id .. '. Start Play last success source: ' .. tmpSrc .. ', URL: ' .. tmpName .. "  tmpSrcKey=" .. (tmpSrcKey or ''))
	else
		tvs_core.tvs_debug(CurrentTitleUTF8 .. '. ID: ' .. Id .. '. Start Play last success source: error')
	end
end
-----------------------------------------------------
if TVSources_var.ForceCurSource  then
  default = TVSources_var.ForceCurSource
else
  TVSources_var.BadSrcCount = 0
end
TVSources_var.ForceCurSource = nil
-----------------------------------------------------

if tmpName == nil then
	tmpSrc, tmpName, tmpSrcKey = tvs_core.tvs_GetUrlById (Id, default, nil, TVSources_var.UseTimeShift)
	--m_simpleTV.Control.tmpCounter = (m_simpleTV.Control.tmpCounter or 0) + 1
    --tvs_core.tvs_debug('getaddress ID: ' .. Id .. ' Count='..m_simpleTV.Control.tmpCounter.. ' ret='..(tmpSrc or ''))
    if tmpSrc == 'stop' then 
       m_simpleTV.Control.ChangeAdress = 'Yes' 
       m_simpleTV.Control.ChangeAddress = 'Yes' 
       m_simpleTV.Control.ExecuteAction(11)  -- 11   Stop (KEYSTOP)
    end
	if tmpSrc == nil then tmpSrc = '' end
    if not tvs_core.isUTF8(tmpSrc) then
       tmpSrc = m_simpleTV.Common.string_toUTF8(tmpSrc)
	end	
	
	if tmpName ~= nil then
		if TVSources_var.OSDMes[2]==1 then
		   tvs_core.tvs_ShowError('['.. tmpSrc .. ']',0xffffff,1) 
	    end
		tvs_core.tvs_debug(CurrentTitleUTF8 .. '. ID: ' .. Id .. '. Source: ' .. tmpSrc .. ', Start Play: ' .. tmpName .. "  tmpSrcKey=" .. (tmpSrcKey or ''))	
	else
		tvs_core.tvs_debug(CurrentTitleUTF8 .. '. ID: ' .. Id .. '. Source: ' .. tmpSrc .. '. Start Play: error GetUrlById.')
	end
end

if tmpName==nil then return end

if TVSources_var.Offset~="" and not tmpName:find("offset") then tmpName = tmpName ..TVSources_var.Offset end

tmpName = tmpName .. TVSources_var.ExtOpt 
TVSources_var.ChangeAddress 	= true
TVSources_var.CurrentAddress = tmpName 
TVSources_var.CurrentSource = tmpSrcKey --  tmpSrc
--TVSources_var.SrcKey = tmpSrcKey or ''
m_simpleTV.Control.CurrentAddress = tmpName
m_simpleTV.Control.CurrentAddress_UTF8 = tmpName

tvs_core.tvs_debug('..getaddress end.')

-------------------------------------------------------------------------------------
-- завершение обработки адресов в getfinish.lua после прохождения video скриптами 
--  в т.ч. установка m_simpleTV.Control.ChangeAdress = 'Yes'
-------------------------------------------------------------------------------------
