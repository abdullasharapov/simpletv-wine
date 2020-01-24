-- погода ---------------

local function SetLangValuesOnHTML (Object)
	local filename = Weather.FullDir .."\\lang\\"..Weather.Param.Lang..'\\html.lua'
	if weather_core.exists(filename) then
		values = dofile (filename)
		for k,v in pairs(values) do
		  if k and v then   m_simpleTV.Dialog.SetElementHtml_UTF8(Object, k,  v  )	 end	
		end
	   --[[ m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idHtmlSettings",  values.idHtmlSettings  )
	    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idHtmlOSDLocality", values.idHtmlOSDLocality )
	    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idHtmlSelLocality", values.idHtmlSelLocality )
	    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idHtmlSearch", values.idHtmlSearch )
	    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idHtmlSelected", values.idHtmlSelected )
	    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idHtmlIdLocality", values.idHtmlIdLocality )
	    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idHtmlIdLocality", values.idHtmlIdLocality )
	   for i=0,3 do 
	      m_simpleTV.Dialog.SetElementText_UTF8(Object, "idHtmlUnits_"..i, values["idHtmlUnits_"..i] )
	   end
	   for i=0,3 do 
	      m_simpleTV.Dialog.SetElementText_UTF8(Object, "idHtmlTextAlign_"..i, values["idHtmlTextAlign_"..i] )
	   end
	   ]]
	 end
 	local v = weather_core.version()
	v = v:match('(v%d+%.%d+)') or '' 
	
	m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idHtmlSettings", values.idHtmlSettings ..' '.. (v or '') ) 

end
-------------------------------------
    local function ExampleCurrentIcons(iconset_name)
		    local example_img = ""
            local t_exam = {"00.png", "01.png", "08.png" , "15.png", "18.png", "19.png", "20.png", "23.png", "26.png", "27.png", "31.png", "32.png"}
             local path = Weather.FullDir ..  weather_core.GetIconsetPath(iconset_name)
             for k, v in pairs(t_exam) do
                       example_img = example_img .. '<img src="' ..path .. v ..'">'
             end
             return example_img
    end
    
 --------------------------------

------------------------------------------
local talign = {0x101, 0x102, 0x103, 0x201, 0x202, 0x203, 0x401, 0x402, 0x403 }
local tunits = {'metric', 'standart', 'imperial' }
local textparam = {0, 1, 2}

function OnNavigateComplete(Object)

    Weather.Param = weather_core.LoadParam()
    Weather.Param.xp = Weather.xp
	
	local value
    
------ Установки локализованных таблиц ---------------------------
	weather_core.SetLocalizedTables()  
------ надписи ---------------------------------------------------
	SetLangValuesOnHTML(Object)
	
-- Выключатель
    value  = (Weather.Param.enabled==1 and '1' or '0')
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'idSwitcher',value) 
    m_simpleTV.Dialog.ExecScript(Object,"setState(idSwitcher)","javascript") 
    
    
-- 1 таб ---------------------------------------------------------

   for i=1,3 do 
      if Weather.Param.units==tunits[i] then m_simpleTV.Dialog.SetCheckBoxValue(Object,'idUnits_'..i, 1)  end
   end
   
   m_simpleTV.Dialog.SetCheckBoxValue(Object,'idProv_'.. (Weather.Param.Provider or 0), 1)
   
   
	m_simpleTV.Config.SetElementValueString_UTF8(Object,'CITY_NAME',Weather.Param.CITY_NAME or '') 		
	m_simpleTV.Config.SetElementValueString_UTF8(Object,'CITY_ID',Weather.Param.CITY_ID or 0) 	
	m_simpleTV.Config.SetElementValueString_UTF8(Object,'CITY_ID_YA',Weather.Param.CITY_ID_YA or 0) 	
	m_simpleTV.Config.SetElementValueString_UTF8(Object,'CITY_lat',Weather.Param.CITY_lat or '') 	
	m_simpleTV.Config.SetElementValueString_UTF8(Object,'CITY_lon',Weather.Param.CITY_lon or '') 	
	m_simpleTV.Config.SetElementValueString_UTF8(Object,'CITY_TEXT',Weather.Param.CITY_TEXT or '') 
	m_simpleTV.Config.SetElementValueString_UTF8(Object,'CITY_TEXT_YA',Weather.Param.CITY_TEXT_YA or '') 
  
  value =""
  if Weather.Param.fullmode==2 then value = "Mode: not show. (shift+7 to switch) <br>" end 
  if Weather.Param.enabled==0 then value = value.."Status:  Disabled. (Click Switcher in right up corner to enable)" end 
	m_simpleTV.Dialog.SetElementHtml_UTF8(Object, 'idStatus', value or '') 


    m_simpleTV.Dialog.AddEventHandler(Object, "OnClick", "idHtmlBtnSearch", "OnClickButtonSEARCH") 
    m_simpleTV.Dialog.AddEventHandler(Object, "OnClick", "idHtmlBtnUpdate","GoUpdate")


-------------------  Iconset   
    value = ""
    for  k, v in pairs(Weather.t_iconset) do
        if v.name == Weather.Param.IconSet then
           value = value ..'<option  class="SelectOption" style="background: #fff099;" selected="selected" value="' .. v.name  .. '">' .. v.name  .. '</option>'
        else
           value = value ..'<option  class="SelectOption"  value="' .. v.name  .. '">' .. v.name .. '</option>'
        end
    end
   -- value = '<select id="idIconSet"  onchange="OnSelect();" size="1"  class="" >' .. value .. "</select>"  
    --m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idListIconSet", value)
    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idIconSet", value)
    
    
    local example_img =  ExampleCurrentIcons(Weather.Param.IconSet)
    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idExampleIconSet", example_img)
    


-- debug_in_file(example_img)
	------------------xp ---
	--value = m_simpleTV.Config.GetElementValueString_UTF8(Object,'ie8') and 1 or 0
	--Weather.Param.xp = value
	--m_simpleTV.OSD.ShowMessage_UTF8('value='..value)
-- 2 таб ---------------------------------------------------------
-- положение на экране
   for i=1,9 do 
      if Weather.Param.align==talign[i] then m_simpleTV.Dialog.SetCheckBoxValue(Object,'pos_'..i, 1)  end
   end
-- показывать время
    m_simpleTV.Dialog.SetCheckBoxValue(Object,'showtime',Weather.Param.showtime or 0) 
-- иконку 
    m_simpleTV.Dialog.SetCheckBoxValue(Object,'showicon',Weather.Param.showicon or 0) 
 
-- цвет фона
    local a,rgb = weather_core.ARGBsplit(Weather.Param.backcolor0)
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'backcolor0',string.format("#%06X",rgb) ) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'backcolor0a',a) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'backcolor0res',string.format("0x%X",Weather.Param.backcolor0 or 0x80000080)) 
-- цвет фона 2    
    a,rgb = weather_core.ARGBsplit(Weather.Param.backcolor1)
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'backcolor1',string.format("#%06X",rgb) ) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'backcolor1a',a) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'backcolor1res',string.format("0x%X",Weather.Param.backcolor1 or 0x80000080)) 
 
-- тип градиента   
    local index = (Weather.Param.background or 0) + 1
    m_simpleTV.Dialog.SelectComboIndex(Object,'type_background',index)
   
-- радиус бордюра
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'backroundcorner',Weather.Param.backroundcorner or 4) 
-- бордюр
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'borderwidth',Weather.Param.borderwidth or 1) 
-- цвет бордюра
    a,rgb = weather_core.ARGBsplit(Weather.Param.bordercolor)
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'bordercolor0',string.format("#%06X",rgb) ) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'bordercolor0a',a) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'bordercolor0res',string.format("0x%X", Weather.Param.bordercolor or 0x70ffffff))

-- шрифт наименование
    value = Weather.Param.font_name or "Arial"
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'fontPicker1font',Weather.Param.font_name or "Arial") 
-- антиалиасинг
    m_simpleTV.Dialog.SetCheckBoxValue(Object,'font_renderingmode',Weather.Param.font_renderingmode or 1) 

-- шрифт размер
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'font_height',Weather.Param.font_height or 12) 
-- шрифт жирность
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'font_weight',Weather.Param.font_weight or 400) 
-- шрифт цвет 
    a,rgb = weather_core.ARGBsplit(Weather.Param.color)
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'color0',string.format("#%06X",rgb) ) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'color0a',a) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'color0res',string.format("0x%X",Weather.Param.color or 0xA0f0f0f0))

-- свечение ширина 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'glow',Weather.Param.glow or 0) 
-- свечение цвет
    a,rgb = weather_core.ARGBsplit(Weather.Param.glowcolor)
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'glowcolor',string.format("#%06X",rgb) ) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'glowcolora',a) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'glowcolorres',string.format("0x%X",Weather.Param.glowcolor or 0xFF000000))
     
-- текст прижат
   for i=1,3 do 
      if Weather.Param.textparam==textparam[i] then m_simpleTV.Dialog.SetCheckBoxValue(Object,'idTextAlign_'..i, 1)  end
   end
 -- отступы  
   m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'id_top',Weather.Param.top or 0) 
   m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'id_right',Weather.Param.right or 0) 
   m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'id_bottom',Weather.Param.bottom or 0) 
   m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'id_left',Weather.Param.left or 0) 

-- 3 таб ---------------------------------
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'iconkoeff',Weather.Param.iconkoeff or 1.0) 
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'iconspaces',Weather.Param.iconspaces or 4) 
    
    m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'fullscreen_fontkoeff',Weather.Param.fullscreen_fontkoeff or 1.0) 
    
-- запускать сервер
	m_simpleTV.Dialog.SetCheckBoxValue(Object,'ServerUse', Weather.Param.ServerUse or 0)
	m_simpleTV.Config.SetElementValueString_UTF8(Object,'ServerIp',Weather.Param.ServerIp or '127.0.0.1') 
	m_simpleTV.Config.SetElementValueString_UTF8(Object,'ServerPort',Weather.Param.ServerPort or 7007) 

  
-- 4 таб ---------------------------------

-- обновление Example окошка 
    m_simpleTV.Dialog.ExecScript(Object,"example.refresh()","javascript")

    if Weather.Param.enabled == 1 and m_simpleTV.Config.GetConfigInt(111)==0 then
  	   m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "ERR", "Для работы дополнения необходимо включить в настойках OSD любой эффект для фона. ")
    else m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "ERR", "")
    end
    
   -- только 1 раз После всех установок и загрузки страницы ( эквивалент window.onload)

    m_simpleTV.Dialog.ExecScript(Object,"ready()","javascript") 

   
end
local HtmlOnload = 1
-----------------------------------------------------------------
local function ClearCityTable(Object)
	local value = [[
			<table id="city_table" class="city_table">
	           <thead><tr> <th id="idHtmlThead1" >Locality </th>  <th id="idHtmlThead2" >Country</th> <th id="idHtmlThead3" >Map</th> 
	           </tr></thead>
	        <tbody id="city_table_tbody" >  </tbody></table>	
	]] 
	m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "CityList", value)
    SetLangValuesOnHTML(Object) 
end

local function OpenBrowser(url)
                  local sh = m_simpleTV.Common.string_toUTF8(os.getenv('COMSPEC'))
	  		    m_simpleTV.Common.Execute( sh, "/c start " .. url,  0x08000000 + 0x00000400 )  		         

end
-----------------------------------------------------------------
 function JSCallBack1(Object, param_utf8)  
		  if  param_utf8=="provider" then             -- Provider changed
			     Weather.ProviderChanged =true
			     OnOk(Object)
			     ClearCityTable(Object)  
		   elseif param_utf8 == "iconset" then -- IconSet OnChange
			      local selected_iconset = m_simpleTV.Dialog.GetComboValue_UTF8(Object, "idIconSet") or ""
			      local example_img =  ExampleCurrentIcons(selected_iconset)
			       m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "idExampleIconSet", example_img)
		  elseif param_utf8 == "u_owm" then  -- open URL in default browser
                   OpenBrowser('https://openweathermap.org/city/')
		  elseif param_utf8 == "u_yandex" then  -- open URL in default browser
                   OpenBrowser('https://pogoda.yandex.ru/')                   
		  elseif param_utf8 == "u_info" then  -- open URL in default browser
                   OpenBrowser(Weather.FullDir ..'/iconset/icons.html')                   
		   end
  end
-----------------------------------------------------------------
  function JSCallBack2(Object ,param1_utf8 , param2_utf8)  
 		 if  param1_utf8 == "xp" then     -- XP detecting
     			Weather.xp = (tonumber(param2_utf8)==0 and 1 or 0)
		elseif param1_utf8 == "url" then  -- open URL in default browser
		        -- m_simpleTV.OSD.ShowMessage_UTF8(param2_utf8,127,5)
		end
  end
------------------------------------------------------------------

  
function OnOk(Object)

	local value

-- Выключатель
    Weather.Param.enabled = tonumber(m_simpleTV.Config.GetElementValueString_UTF8(Object,'idSwitcher') )
   -- Weather.Param.enabled = (Weather.Param.enabled==nil and 1 or Weather.Param.enabled)
  	if not m_simpleTV.OSD.AddElement then   
  	   Weather.Param.enabled = 0   
  	   m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "ERR", "Дополнение не может работать. Устаревшая версия tv.exe!")
  	end	
 
    if Weather.Param.enabled == 1 and m_simpleTV.Config.GetConfigInt(111)==0 then
  	   Weather.Param.enabled = 0   
  	   m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "ERR", "Для работы дополнения необходимо включить в настойках OSD любой эффект для фона. ")
    end
 -- 1 таб    	
	for i=1,3 do 
	  if m_simpleTV.Config.GetCheckBoxValue(Object,'idUnits_'..i) == 1 then Weather.Param.units=tunits[i]  end
	end
	for i=0,1 do 
	  if m_simpleTV.Config.GetCheckBoxValue(Object,'idProv_'..i) == 1 then Weather.Param.Provider = i  end
	end	   

	Weather.Param.CITY_NAME = m_simpleTV.Config.GetElementValueString_UTF8(Object,'CITY_NAME') or Weather.Param.CITY_NAME or ''
	Weather.Param.CITY_NAME = Weather.Param.CITY_NAME:gsub('"','')
	Weather.Param.CITY_ID = tonumber(m_simpleTV.Config.GetElementValueString_UTF8(Object,'CITY_ID')) or Weather.Param.CITY_ID	or 0
	Weather.Param.CITY_ID_YA = tonumber(m_simpleTV.Config.GetElementValueString_UTF8(Object,'CITY_ID_YA')) or Weather.Param.CITY_ID_YA	or 0
	Weather.Param.CITY_lat = m_simpleTV.Config.GetElementValueString_UTF8(Object,'CITY_lat') or Weather.Param.CITY_lat or ''
	Weather.Param.CITY_lon = m_simpleTV.Config.GetElementValueString_UTF8(Object,'CITY_lon') or Weather.Param.CITY_lon or ''
	Weather.Param.CITY_TEXT = m_simpleTV.Config.GetElementValueString_UTF8(Object,'CITY_TEXT') or Weather.Param.CITY_TEXT or ''
	Weather.Param.CITY_TEXT_YA = m_simpleTV.Config.GetElementValueString_UTF8(Object,'CITY_TEXT_YA') or Weather.Param.CITY_TEXT_YA or ''

-- запускать сервер
	Weather.Param.ServerUse = m_simpleTV.Dialog.GetCheckBoxValue(Object,'ServerUse') or Weather.Param.ServerUse or 0
-- порт
	Weather.Param.ServerPort = m_simpleTV.Config.GetElementValueString_UTF8(Object,'ServerPort') or Weather.Param.ServerPort or 7007
	Weather.Param.ServerIp = m_simpleTV.Config.GetElementValueString_UTF8(Object,'ServerIp') or Weather.Param.ServerIp or '127.0.0.1'

   Weather.Param.IconSet  = m_simpleTV.Dialog.GetComboValue_UTF8(Object, "idIconSet") or ""

-- 2 таб 
-- положение на экране    
   for i=1,9 do 
      if m_simpleTV.Config.GetCheckBoxValue(Object,'pos_'..i) == 1 then Weather.Param.align=talign[i]  end
   end
   
   
-- показывать время
   Weather.Param.showtime = m_simpleTV.Dialog.GetCheckBoxValue(Object,'showtime') or Weather.Param.showtime or 0
-- показывать иконку
   Weather.Param.showicon = m_simpleTV.Dialog.GetCheckBoxValue(Object,'showicon') or Weather.Param.showicon or 0
-- цвет фона
   Weather.Param.backcolor0 = m_simpleTV.Config.GetElementValueString_UTF8(Object,'backcolor0res') or Weather.Param.backcolor0  
   Weather.Param.backcolor1 = m_simpleTV.Config.GetElementValueString_UTF8(Object,'backcolor1res') or Weather.Param.backcolor1  
   
-- тип фона (-1 - нет,0 - сплошной,1 - гор. градиент,2 вер. градиент,3 - диаг. градиент, 4 - круговой)

   Weather.Param.background = tonumber(m_simpleTV.Dialog.GetComboValue(Object,'type_background',true) )  or Weather.Param.background  or  0
   --m_simpleTV.OSD.ShowMessage_UTF8('value='..Weather.Param.background)
-- радиус закругления фона
   Weather.Param.backroundcorner = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'backroundcorner') or Weather.Param.backroundcorner
-- бордюр
   Weather.Param.borderwidth = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'borderwidth') or Weather.Param.borderwidth
-- цвет бордюра
   Weather.Param.bordercolor = m_simpleTV.Config.GetElementValueString_UTF8(Object,'bordercolor0res') or Weather.Param.bordercolor

-- цвет шрифта 
    Weather.Param.color = m_simpleTV.Config.GetElementValueString_UTF8(Object,'color0res') or Weather.Param.color
-- шрифт наименование
    Weather.Param.font_name = m_simpleTV.Config.GetElementValueString_UTF8(Object,'fontPicker1font') or Weather.Param.font_name or "Arial"
-- антиалиасинг
   Weather.Param.font_renderingmode = m_simpleTV.Dialog.GetCheckBoxValue(Object,'font_renderingmode') or Weather.Param.font_renderingmode or 1
-- шрифт размер
    Weather.Param.font_height = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'font_height') or Weather.Param.font_height or 12
-- шрифт жирность
    Weather.Param.font_weight = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'font_weight') or Weather.Param.font_weight or 400

-- свечение цвет 
    Weather.Param.glowcolor = m_simpleTV.Config.GetElementValueString_UTF8(Object,'glowcolorres') or Weather.Param.glowcolor
-- свечение ширина
    Weather.Param.glow = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'glow') or Weather.Param.glow or 0

-- текст прижат
   for i=1,3 do 
      if m_simpleTV.Dialog.GetCheckBoxValue(Object,'idTextAlign_'..i, 1) == 1  then Weather.Param.textparam = textparam[i]   end
   end

 -- отступы  
 Weather.Param.top    = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'id_top') or Weather.Param.top or 0
 Weather.Param.left   = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'id_left') or Weather.Param.left or 0
-- Weather.Param.right  = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'id_right') or Weather.Param.right or 0
-- Weather.Param.bottom = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'id_bottom') or Weather.Param.bottom or 0

-- 3 таб ---------------------------------

 Weather.Param.iconkoeff   = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'iconkoeff')  or Weather.Param.iconkoeff  or 1.0
 Weather.Param.iconspaces  = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'iconspaces') or Weather.Param.iconspaces or 4 

 Weather.Param.fullscreen_fontkoeff   = m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'fullscreen_fontkoeff')  or Weather.Param.fullscreen_fontkoeff  or 1.3


  weather_core.SaveParam(Weather.Param)
end

function GoUpdate(Object)
 
    local cur_CITY_ID = Weather.Param.CITY_ID
    local cur_CITY_lat, cur_enabled =  Weather.Param.CITY_lat, Weather.Param.enabled 
    local cur_Server = Weather.Param.ServerUse
    local cur_Units = Weather.Param.units
    OnOk(Object)
   
    local CITY_ID  =  Weather.Param.CITY_ID
    local new = (Weather.ProviderChanged==true) or (cur_Units~=Weather.Param.units) or (CITY_ID<=0) or (cur_CITY_ID ~= CITY_ID) or (cur_CITY_lat ~= Weather.Param.CITY_lat) or (cur_enabled ~= Weather.Param.enabled) or (cur_Server ~= Weather.Param.ServerUse)
    
    Weather.ProviderChanged=false
    if new then
       --m_simpleTV.OSD.ShowMessage_UTF8('new '  .. Weather.Param.enabled)
       Weather.appid = nil
       weather_core.Run()
    else
       weather_core.Show(true)
    end
    OnNavigateComplete(Object)
    
end
------------------------------------------------------------------
local lower_t= {
["А"]="а", ["Б"]="б", ["В"]="в", ["Г"]="г",  ["Д"]="д", ["Е"]="е",  ["Ё"]="ё", ["Ж"]="ж",["З"]="з",  ["И"]="и",   ["Й"]="й",  ["К"]="к",   ["Л"]="л",  ["М"]="м", ["Н"]="н", ["О"]="о", ["П"]="п",  
 ["Р"]="р",   ["С"]="с",  ["Т"]="т",  ["У"]="у",  ["Ф"]="ф", ["Х"]="х", ["Ц"]="ц", ["Ч"]="ч", ["Ш"]="ш", ["Щ"]="щ",["Ъ"]="ъ", ["Ы"]="ы",  ["Ь"]="ь", ["Э"]="э", ["Ю"]="ю", ["Я"]="я", 
}
local function ru_lower(s)
	local	str = ''
	local	i = 1
	while i <= string.len(s) do
		local byte = s:byte(i)
		local c 
		if (byte > 0xC1) then  -- с 0x00 до 0x7F идут 1-байтовые, а начиная с 0xC2 идут 2-х байтовые коды
		 c = string.char(byte,s:byte(i+1)) 
		 c = (lower_t[c] or c )
		 i=i+2 
		else 
		 c = string.char(byte)
		 i=i+1 
		end	
		str = str .. c
	end
	return str
end

function OnClickButtonSEARCH(Object)

    local value = m_simpleTV.Config.GetElementValueString_UTF8(Object,'SEARCH_CITY')
    local err = ""
    if not value or value=='' or value:len()<3 then  
        m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "ERR", "Error: Empty or too short string!")
        return
    end    

	local t, i = {}, 0
------- поиск по geonames  -------------------------------------------
	if Weather.Param.Provider==0 then
	    local url = 'http://www.geonames.org/search.html?q='.. escape(value)
	
		local c, answer = weather_core.site_load(url)
		if c~=200 or answer:find('Not found city') then 
		    err = 'Error: Error net load: '.. (c==200 and answer or c)
		    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "ERR", err)	
		    return	
		end
	    m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "ERR", "")
		
		answer = answer:match('<table class="restable">(.-)</table>')
		if not answer or answer:len()<40 then
	        m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "ERR", "Geo name not found!")
	        return	
		end

		--debug_in_file('\n'..url .. '\n'..answer)
		local id, name, coord, country

		for line in answer:gmatch('<tr(.-)</tr>') do
			 id, name = line:match('<a href="/(%d+)/.-html">([^%<].-)</a>')
			 if id and name then
				 i=i+1
				 t[i] = {}
				 t[i].id = id
				 t[i].name = name:gsub('&nbsp;',' ')
				 t[i].country  = ""
				 t[i].lat =  line:match('class="latitude">([%-%.%d]+)') or ''
				 t[i].lon =  line:match('class="longitude">([%-%.%d]+)') or ''
			     t[i].map = 'https://openweathermap.org/weathermap?basemap=map&cities=true&layer=temperature&lat='..t[i].lat..'&lon='..t[i].lon..'&zoom=11'
				 
				 if i>30 then break end
			 end
		end 
	----- поиск по яндекс списку ----------------
	else  
	   local fname = Weather.FullDir .."\\core\\cities.xml"
		local handle = io.open(fname,"r+b")
		local text = handle:read('*all')
		handle:close()
       local name, id, name_ansi
       local find_str = string.lower( m_simpleTV.Common.string_fromUTF8( ru_lower(value), 1251)  or '' )  
       find_str = find_str:gsub("%-","%%-")
	   --debug_in_file('find_str=' ..find_str)
	   for line in text:gmatch('(.-)%c') do
	        name = line:match('>(.-)<%/city>')
	        id  = line:match('id="(%d+)"')
	        if name and id then
	           name_ansi = string.lower( m_simpleTV.Common.string_fromUTF8( ru_lower(name), 1251) or '' )
	           --debug_in_file('name_ansi=' ..name_ansi)
		        if name_ansi:find(find_str)  or name_ansi==find_str then
	                --debug_in_file('find_str=' ..find_str .. ' name_ansi=' ..name_ansi)
					 i=i+1
					 t[i] = {}
					 t[i].id = id
					 t[i].name = name
					-- local country, part = line:match('country="(.-)" ') or '', line:match('part="(.-)" ') 
					 t[i].country = '' --country .. (part and ", "..part or '')
					 t[i].lat =  ''
					 t[i].lon =  ''
					 t[i].map =  'javascript:void(0)'
				 	 if i>30 then break end
			    end 
		    end
	   end
	
	end
   -- if i==0 then return end
------- вывод --------------------------------------------
    local link 
	value = [[
			<table id="city_table" class="city_table">
	           <thead><tr> <th id="idHtmlThead1" >Locality </th>  <th id="idHtmlThead2" >Country</th> <th id="idHtmlThead3" >Map</th> 
	           </tr></thead>
	        <tbody id="city_table_tbody" > 	
	]]
	for i=1,#t do
		 if  t[i].map then link = '<a href="'..t[i].map ..'" target="_blank" > map </a>'
		 else link = '' end
		 local tmp =''
		 if t[i].lat~='' and t[i].lat~='' then
		        tmp= string.format("%8.3f %8.3f",t[i].lat , t[i].lon):gsub(' ','&nbsp;')
		 end
		 value=value.. '<tr> <td>' .. t[i].name  .. '</td><td>'..t[i].country .. '</td><td> <a style="text-decoration:none;" target="_blank" href="' ..t[i].map .. '">' .. tmp  ..' </td>'
		 value=value.. '<td class="hidden">'.. t[i].id.. '</td><td class="hidden">'.. t[i].lat .. '</td><td class="hidden">'.. t[i].lon ..'</td>   </tr>'
	end
   value = value .. " </tbody></table> "

	m_simpleTV.Dialog.SetElementHtml_UTF8(Object, "CityList", value)
 
    SetLangValuesOnHTML(Object)

end



