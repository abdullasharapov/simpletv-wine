-- кириллица  - ANSI win 1251 
-- forecast / прогноз
--------------
local ID = 'BM_WEATHER_ID5'
local names = {'day','sep','temp','humm','press','wind','winddir'}
local RW = 8
local F = {
	{ day="пн" , sep=string.rep("_",RW), temp="+5" , humm="80", press="760", wind="4", winddir="Ю" },
	{ day="вт" , sep=string.rep("_",RW), temp="-5" ,humm="83", press="740", wind="3.4", winddir="СЮ" },
	{ day="ср" , sep=string.rep("_",RW), temp="+5" ,humm="82", press="750", wind="2.5", winddir="СВ" }
}

local function FormatForecast(t)
		if type(t)~='table' then return 'table error' end
		local str , text = {}  , ""
		for row, col in pairs(t) do
			   for k,v in pairs(col) do   
			            local tmp =  ( row==1 and RW+1 or (row==2 and RW-1 or RW   ) )
				        str[k] = (str[k] or '') .. string.format("%".. (tmp).."s", v)
			   end
		end
	    for _,v  in pairs(names) do      
	       		if str[v] then 
	       		   if v=='ico'  then    text = text .. '\n'   
	       		   else  text = text .. str[v] .. '\n'     
	       		   end 
	       		   --debug_in_file(str[v])		
	       		end    
	    end
	    return text
end
local function fmt(s)
         return string.format("%.1f",s)
end
local function tableprint(t)
              level = level or 0
              local ret= {}
              if  Weather.Param.Lang=="ru" then
		              ret[1] = { dd='.:OWM:.', ico='', morn='утро',day='день', eve='вечер', night='ночь', pressure='давление', humidity='влажность', speed='ск.ветра', deg='ветер', precipitation='осадки'}   
             else
                      ret[1] = { dd='.:OWM:.', ico='', morn='morn',day='day', eve='eve', night='night', pressure='pressure', humidity='humidity', speed='speed', deg='deg', precipitation='precip.'}        
              end
              local n, d
              if t.cod=='200' then 
	                 for k,v in pairs(t.list) do
	                 	n, d = weather_core.get_iconnew(v.weather[1].id)
                        if v.temp and #ret<7 then
		                    ret[#ret+1] = { dd = os.date("%d",v.dt), ico =   d or n,    --  новые иконки :  день или ночь                         -- старые: v.weather[1].icon,  
		                                           morn=fmt(v.temp.morn), day=fmt(v.temp.day), eve=fmt(v.temp.eve), night=fmt(v.temp.night),
		                                           pressure=fmt(v.pressure*0.75), humidity=v.humidity, speed=fmt(v.speed), 
		                                           deg = m_simpleTV.Common.string_fromUTF8(  weather_core.get_wind_direction(v.deg,true) )  , 
		                                           precipitation= v.rain or v.snow
		                                 
		                   						 }       
		                end                               
	                    --debug_in_file( v.weather[1].icon )
                     end
              else return "Invalid API key."
	          end 
	          return ret
end
if not Weather.ForecastID then
    -- OWM
    O = weather_core.GetOWMTableForecast()
    F = tableprint(O)
    names = {'dd', 'ico', 'morn', 'day', 'eve', 'night', 'pressure', 'humidity', 'speed', 'deg', 'precipitation'}
    -- YANDEX
    --F = weather_core.GetYandexTableForecast()
    --names = {'dd','ico','temp_from','temp_to'}

    local t = {}
	t.id = ID
	t.class="TEXT"
	t.text =  m_simpleTV.Common.string_toUTF8( FormatForecast(F) )  
	t.align =0x202
	t.font_name  = "Lucida Console" --"Consolas"  
	local font_height = (Weather.SimpleVersion >= 800) and 11 or 13    -- Weather.Param.font_height                 -- fixed, beacause changing  font size  makes  ShowIcon broken
	--font_height =13
	t.font_height = math.floor( font_height * weather_core.GetKoef()	 )
	t.font_weight = 200 --Weather.Param.font_weight
	t.font_renderingmode = Weather.Param.font_renderingmode * 3
	t.textparam = 0x00 +  0x04  --- textparam : DT_LEFT 0x00 DT_CENTER 0x01 DT_RIGHT 0x02 DT_VCENTER 0x04
	t.glow = Weather.Param.glow
	t.glowcolor = weather_core.ARGB(Weather.Param.glowcolor)
	t.zorder=0	
	t.padding=8
	t.background = 0
	t.backcolor0 = weather_core.ARGB(Weather.Param.backcolor0)
	t.backroundcorner =8
	t.borderround = 4
	t.borderwidth = 1
	t.bordercolor = weather_core.ARGB(Weather.Param.bordercolor)
	t.smothingmode = 2
	t.createXPrgn = (Weather.Param.xp==nil) and 0 or Weather.Param.xp

	Weather.ForecastID = m_simpleTV.OSD.AddElement(t)	
	
	local function ShowIcon(ico_name, index)
			-- local path = Weather.FullDir .. '\\icon\\'..(ico_name or '')..'.png'
			local path = Weather.FullDir .. weather_core.GetIconsetPath(Weather.Param.IconSet) ..(ico_name or '') ..'.png'

			--debug_in_file(path)
			if weather_core.exists(path)  then 
			        local t ={}
					t.id = ID  .. '_' .. index
					t.class="IMAGE"	
					t.imagepath = path
					--t.textparam = 0x00 +  0x04 
					local k = (Weather.SimpleVersion >= 800)  and 1.3 or 1
					t.cx = k * math.floor( font_height  *  weather_core.GetKoef() )
					t.cy = t.cx  
					t.background = nil
					t.borderwidth = nil
					t.transparency = 255
					t.zorder=1
					t.align =  0x0101
					--local lambda =   1/ k 
					if Weather.SimpleVersion >= 800 then  -- simpletv 0.5.0
						t.left =  10 + t.cx * (4 +  6.6 * index ) / k  
					else -- simpletv 0.4.8
						t.left =  10 + t.cx * (3.5 +  5 * index ) / k  
					end
					t.top = t.cx 
					m_simpleTV.OSD.AddElement(t, ID)
					
			end	  
	end
 
	 for i=2,#F do
	    if type(F)=='table' and F[i]  then	    ShowIcon(F[i].ico,  i-1 )
	    end
	 end

	local timer_script = " if Weather.ForecastIDtimer then  m_simpleTV.Timer.DeleteTimer(Weather.ForecastIDtimer)    Weather.ForecastIDtimer=nil  end " .. 
	                                " m_simpleTV.OSD.RemoveElement('"..ID.."')   Weather.ForecastID = nil "
	Weather.ForecastIDtimer =  m_simpleTV.Timer.SetTimer(30000, timer_script)	
	
else
   m_simpleTV.OSD.RemoveElement(ID)
   Weather.ForecastID = nil
   if Weather.ForecastIDtimer then  m_simpleTV.Timer.DeleteTimer(Weather.ForecastIDtimer)    Weather.ForecastIDtimer=nil  end
end
