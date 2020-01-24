if not Weather.Param then return end

--debug_in_file ('Weather.Frequence='.. (Weather.Frequence or '')  ..  "  s=" ..os.date("%S"))

local ok, text, icon = weather_core.GetFullWeather( Weather.notForce )
----------------------------------------------------------------------

if  Weather.Param.IconSet =="" or Weather.Param.IconSet==nil then
	    if      Weather.Param.Provider==0  then  Weather.Param.IconSet = "Open Weather Map" 
	    elseif  Weather.Param.Provider==1  then	 Weather.Param.IconSet = "Yandex"  
	    end
end

--------------------------------------------------------------------------
 Weather.CurrentTemperature = ( ok and text or (Weather.CurrentTemperature or 'NaN') )
 Weather.CurrentIcon = (ok and icon or (Weather.CurrentIcon or '') )
   
 --debug_in_file ('\n'..os.date ("%H:%M") ..' Current: \n'..Weather.CurrentTemperature.. ' text='..text)
 --debug_in_file ('\n CITY=' .. Weather.Param.CITY_TEXT ..' ID='..Weather.Param.CITY_ID )
 
local err = ( (not Weather.notForce and not ok ) and '\n'..text or '' )
local textvalue = ( Weather.Param.showtime==1 and (os.date ("%H:%M") .. '\n') or '' )


if Weather.Param.showicon==1 and Weather.Param.fullmode==0 then  
    -- иконка снизу 
	-- textvalue = textvalue .. Weather.CurrentTemperature .. err .. '\n '
	-- иконка слева
	textvalue = string.rep(' ', Weather.Param.iconspaces or 4)  ..textvalue .. Weather.CurrentTemperature .. err  -- &thinsp;&emsp;
else
	textvalue = textvalue .. Weather.CurrentTemperature .. err
end
if Weather.Param.fullmode==2 then
   m_simpleTV.OSD.RemoveElement('BM_WEATHER_ID0')
   --m_simpleTV.Interface.ControlElement('BM_WEATHER_ID1','SET_VISIBLE',false)
   return
end
if m_simpleTV.Control.MainMode~=nil and m_simpleTV.Control.MainMode~=0 then
  return
end



local font_height = Weather.Param.font_height * weather_core.GetKoef()

-----DIV--------------
local t={}
 t.id = 'BM_WEATHER_ID0'
 t.class = "TEXT"
   
 t.top  = Weather.Param.top
 t.left = Weather.Param.left
 t.align = Weather.Param.align
 t.color = weather_core.ARGB(Weather.Param.color)
 t.padding = 1
  
 t.background = Weather.Param.background
 t.backcolor0 = weather_core.ARGB(Weather.Param.backcolor0)
 t.backcolor1 = weather_core.ARGB(Weather.Param.backcolor1)
 t.backroundcorner = Weather.Param.backroundcorner*2
 t.borderround = Weather.Param.backroundcorner
 t.borderwidth = Weather.Param.borderwidth
 t.bordercolor = weather_core.ARGB(Weather.Param.bordercolor)
 t.smothingmode = 2
 t.createXPrgn = (Weather.Param.xp==nil) and 0 or Weather.Param.xp
 
-- t.zorder=0  --(0 - base, 1 -top, 2 - bottom)  (родитель всегда внизу) 
-- m_simpleTV.OSD.AddElement(t)
 	
-------TEXT-----------------------
	--t.id = 'BM_WEATHER_ID1'
	--t.class="TEXT"
	t.text = textvalue 
	t.font_name = Weather.Param.font_name
	t.font_height = font_height 	   
	t.font_weight = Weather.Param.font_weight
	t.font_renderingmode = Weather.Param.font_renderingmode * 3
	t.textparam = Weather.Param.textparam + 4   --- textparam : DT_LEFT 0x00 DT_CENTER 0x01 DT_RIGHT 0x02 DT_VCENTER 0x04
	t.glow = Weather.Param.glow
	t.glowcolor = weather_core.ARGB(Weather.Param.glowcolor)
	t.zorder=0	
	m_simpleTV.OSD.AddElement(t)	
	 
--------ICON---------------------------------------------------	 

 local function get_rows_cols(text)
		local _, rows = text:gsub('\n',function () return nil end)
		rows = (rows==0 and 1 or rows+1)
        local str = m_simpleTV.Common.string_fromUTF8(text) 
		local str = str:match('(.-)\n') or str
		if str:find(":") then return rows,  3 + Weather.Param.iconspaces
		end
		return rows, str:len() /2
 end
----------

local path = Weather.FullDir .. weather_core.GetIconsetPath(Weather.Param.IconSet) ..(Weather.CurrentIcon or '') ..'.png'
--debug_in_file(path)
if weather_core.exists(path)  then 
        
		t.id = 'BM_WEATHER_ID2'    
		t.class="IMAGE"
			
		t.imagepath = path
		local rows, cols = get_rows_cols(textvalue)
		local ok, cx, cy = m_simpleTV.OSD.ControlElement('BM_WEATHER_ID0','GET_VALUE_TEXT_SIZE')
        --debug_in_file("ok="..(ok and "true" or "false").." rows="..rows.." cols="..cols.." cx="..cx.." cy="..cy)
        if  ok==true and cy>0 and cx>0 then  
			t.cx = cy / rows - 2
			t.cy = t.cx 
		else -- при ошибке в функции
			t.cx = font_height 
			t.cy = font_height 
			cx = cols * t.cx * 0.6
		end
		t.cx = t.cx * Weather.Param.iconkoeff
		t.cy = t.cy * Weather.Param.iconkoeff
		t.background = nil
		t.borderwidth = nil
		t.transparency = 225
		t.zorder=1
		if Weather.Param.fullmode==1 then
			t.align = (Weather.Param.textparam==2 and 0x0103 or 0x0101)
			--t.left = 2
			--t.top  = 9 - font_height/2
			t.left = cx - t.cx 
			t.top = 1
			m_simpleTV.OSD.AddElement(t,'BM_WEATHER_ID0')
		end
		if Weather.Param.fullmode==0  then 
		  if Weather.Param.showicon==1 then
		    -- внизу 
			--t.align = (Weather.Param.textparam==2 and 0x0103 or 0x0101)
			--t.left = 2
			--t.top  =  t.cy + t.cy * Weather.Param.showtime
			-- слева
			t.align = 0x0103
			t.left = cx - t.cx 
			t.top =  1
			m_simpleTV.OSD.AddElement(t,'BM_WEATHER_ID0')
		  else
		    m_simpleTV.OSD.RemoveElement('BM_WEATHER_ID2')
		  end
		end	
				
end
	 
-----------------------------------------------------------------------------
