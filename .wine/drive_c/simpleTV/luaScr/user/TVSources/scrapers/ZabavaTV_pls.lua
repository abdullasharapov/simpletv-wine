
module('ZabavaTV_pls', package.seeall)    
local my_src_name  = "Zabava"             
-------------------------------------------------------------------------
-------------------------------------------------------------------------
local my_file_name = decode64('aHR0cDovL3Bhc3RlYmluLmNvbS9yYXcvNGNSYkRFeFA=') 
-------------------------------------------------------------------------
--------------------------------------------------------------------------
-- Локальный фильтр для переименования каналов. Заполнять не обязательно.
-- Если встретится первое название, то оно заменяется на второе.
--------------------------------------------------------------------------
local filter={ 
    {'О%2C кино!', 'О!Кино'},
	{'О, кино!', 'О!Кино'},      
    {"",""},
}
-------------------------------------------------------------------------
local function ProcessFilterTableLocal(t) -- применяем локальный фильтр
	if not type(t)=='table' then return end
	for i = 1, #t do
	    t[i].name = t[i].name:gsub("%s+$","")
        if t[i].name:find('не работает') then t[i].skip = true end
	    for _,ff in ipairs(filter) do   
	      if (type(ff)=='table' and t[i].name==ff[1]) then 
	        t[i].name = ff[2]
	      end
	    end
	end 
    return t
end

--------------------------------------------------------------------------
function GetSettings()

    local scrap_settings
	scrap_settings ={
	name	 		= my_src_name,   -- Имя источника                
	sortname 		='',			 -- имя для сортировки (если не указано, берется name)               
	scraper 		='',		     -- * Путь и название скрапера (будет автоматически присвоено)     
	m3u     		='out_'..my_src_name..'.m3u',        --  название m3u         
	logo     		='..\\Channel\\logo\\Icons\\Zabava.png', --  путь и файл лого относительно папки work         
	TypeSourse		=1,				 -- * Тип источника: 0 - внутренний, 1 - внешний (будет автоматически присвоено 1)  
	TypeCoding		=1,				 -- Кодировка M3U (0 - ANSI, 1 - UTF8, 2 - UNICODE)         
	DeleteM3U		=1,				 -- Удалять m3u по завершению обработки (1 - включено, 0 - выключено)      
	RefreshButton   =1,				 -- Обновлять по кнопке "Обновить плей-лист" (1 - включено, 0 - выключено)    
	AutoBuild		=0,				 -- Авто-обновление (1 - включено, 0 - выключено)           
	AutoBuildDay	={0,0,0,0,0,0,0},-- Дни недели авто-обновления {вс,пн,вт,ср,чт,пт,сб}           
	LastStart		=0,				 -- Последняя успешная загрузка         
------------------------------------------------------------------------------------------------
	TVS				={				 -- Ветка настроек для загрузки в базу TVSources (1 - включено, 0 - выключено)   
		add			=1,				 -- Загружать в базу TVSources (1 - включено, 0 - выключено)           
		FilterCH	=1,				 -- Фильтровать названия каналов (1 - включено, 0 - выключено)          
		FilterGR	=1,				 -- Фильтровать названия групп каналов (1 - включено, 0 - выключено)     
		GetGroup	=1,				 -- Наследовать группу (1 - включено, 0 - выключено)     
		LogoTVG		=1},			 -- Наследовать логотип и программу передач (1 - включено, 0 - выключено)         
------------------------------------------------------------------------------------------------
	STV				={				 -- Ветка настроек для загрузки в базу SimpleTV            
		add			=1,				 -- Загружать в базу SimpleTV (1 - включено, 0 - выключено)         
		ExtFilter	=1,				 -- Создавать внешний фильтр (1 - включено, 0 - выключено)     
		FilterCH	=1,				 -- Фильтровать названия каналов (1 - включено, 0 - выключено)     
		FilterGR	=1,				 -- Фильтровать названия групп (1 - включено, 0 - выключено)          
		GetGroup	=1,				 -- Учитывать группы из M3U  (1 - включено, 0 - выключено)       
		HDGroup		=1,				 -- HD каналы отдельной группой  (1 - включено, 0 - выключено) Зависит от скрапера     
		AutoSearch	=1,				 -- Искать логотип и программу передач (1 - включено, 0 - выключено)       
		AutoNumber	=1,				 -- Автонумерация каналов (1 - включено, 0 - выключено)      
		NumberM3U	=0,				 -- Учитывать номера из M3U (1 - включено, 0 - выключено)       
		GetSettings	=1,				 -- Учитывать настройки из M3U (1 - включено, 0 - выключено)        
		NotDeleteCH =0,				 -- Не удалять отсутствующие каналы при обновлении (1 - включено, 0 - выключено)     
		TypeSkip	=1,				 -- Если канал существует в базе: 0 - пропускать, 1 - обновлять, 2 - загружать как новый 
		TypeFind	=0}				 -- ^^^^^^^^^^^^^^^^^^^^ проверять совпадение по: 0 - названию канала, 1 - адресу канала
	}                                                                                                                                          
	return scrap_settings
end
--------------------------------------------------------------------------
function GetVersion()
	return 1, 'UTF-8'
end
--------------------------------------------------------------------------

-------------------------------------------------------------------------- 
function GetList(UpdateID,m3u_file)
   
		 if UpdateID == nil then return end
		 if m3u_file == nil then return end
		 if TVSources_var.tmp.source[UpdateID] == nil then return end
		 local Source=TVSources_var.tmp.source[UpdateID]  -- Наследуем настройки источника, чтобы не таскать

	tvs_core.tvs_debug("Scraper for "..Source.name.." begin.") 	
	m_simpleTV.OSD.ShowMessage_UTF8(Source.name..' -> ',0xffff00,5)


---------------- скачивание файла -----------------------------
	local fpath, file_name = tvs_core.tvs_GetFile(my_file_name)	
	if not fpath or not file_name then return end		
	local tmp_file = fpath .. file_name
	os.remove(fpath .. 'out_zabava.m3u')
    os.rename(tmp_file, fpath .. 'out_zabava.m3u')
	tmp_file = fpath .. 'out_zabava.m3u'
---------------- читаем файл с диска-----------------------------
    --local tmp_file = m_simpleTV.MainScriptDir .. "user/TVSources/iptv/m3u/template_zabava.m3u"     
---------------------------------------------------------------    
    tvs_core.tvs_debug("m3u filename: "..tmp_file) 
    local f = assert(io.open(tmp_file, "r"))
	if f == nil then 
	  m_simpleTV.OSD.ShowMessage_UTF8(Source.name..' -> Error open *.m3u file.',0xffff00,5)
	  return 
	end
    local str = f:read("*all")
    f:close()    

---------------------------------------------------------------	
	str = str:gsub("%/tvs%/","/hls/")
	
---------------- получаем таблицу  -----------------------------
    local t_pls = tvs_core.GetPlsAsTable(str)    	
      
	for i = 1, #t_pls do
     if t_pls[i].name:match('[#=]')  then t_pls[i].skip = true end
    end
	
---------------- проходим локальным фильтром ------------------
    t_pls = ProcessFilterTableLocal(t_pls)
---------------- обрабатываем таблицу общими фильтрами  --------

    local m3ustr = tvs_core.ProcessFilterTable(UpdateID,Source,t_pls)      
	
	tvs_core.tvs_debug("Scraper for "..Source.name..": filtered 'm3u' info push into file "..m3u_file)

	local handle = io.open (m3u_file, "w+")   -- m3u_file - не меняем название, из него грузится потом все каналы
	if handle == nil then return nil end
	handle:write (m3ustr)
	handle:close ()
	
	tvs_core.tvs_debug("Scraper for "..Source.name.." end: return 'ok'.")

	return 'ok'

------------------------------------------------------------------------------------------------------------------

end 

