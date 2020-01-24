local version, version_full = m_simpleTV.Common.GetVersion()
if version<800 then 
			m_simpleTV.Interface.MessageBox( "This version of TVSources-addon supports only the new version of SimpleTV above 0.5.x" , version_full, 0x0+0x30) --MB_OK | MB_ICONEXCLAMATION
			return
end

TVSources_var = {}
TVSources_var.TVSname = 'TVSources'

TVSources_var.TVSdir = m_simpleTV.MainScriptDir .. 'user/'..TVSources_var.TVSname..'/'
----- Проверяем есть ли в списке путей, путь к ядру TVSources, если нет, то прописываемся в системе -------
if not package.path:find(TVSources_var.TVSname..'[/\\]core' )  then
	if  m_simpleTV.Common.isX64()  then
		package.path = package.path .. ";" .. TVSources_var.TVSdir .. 'core/x64/?.lua'
	else 
		package.path = package.path .. ";" .. TVSources_var.TVSdir .. 'core/?.lua'
	end
end

if not package.path:find(TVSources_var.TVSname..'[/\\]scrapers') then 
	package.path = package.path .. ";" .. TVSources_var.TVSdir .. 'scrapers/?.lua'
end

require 'lfs'

lfs.mkdir(TVSources_var.TVSdir .."AutoSetup/")
lfs.mkdir(TVSources_var.TVSdir .."scrapers/")
lfs.mkdir(TVSources_var.TVSdir .."log/")
--lfs.mkdir(TVSources_var.TVSdir .."lists/")
lfs.mkdir(TVSources_var.TVSdir .."m3u/")
lfs.mkdir(TVSources_var.TVSdir .."m3u/cache/")

TVSources_var.TVSdirSave = TVSources_var.TVSdir .. "core\\"

TVSources_lng = {}

------ Подключаем ядро TVSources ---------------------------

require ("tvs_core")
require ('tvs_func')
require ('checkudpxy')

------ Объявляем переменные  ----------------
dofile (TVSources_var.TVSdir .. 'core/defines.lua')

------ Назначаем дефолтные  переменные TVSources ----------------------------------------------------------------------
TVSources_var.CurrentSource  = nil				-- Последний запущенный источник телеканала
TVSources_var.CurrentAddress  = nil				-- Последний запущенный адрес телеканала
TVSources_var.ChangeAddress  = false			-- Признак смены канала TVSources
TVSources_var.Logging		 = false			-- true - вести лог; false - не вести лог
TVSources_var.FilterName	 = '%%'				-- символы, которые будут искключены из названий каналов при обработке базы
TVSources_var.Default		 = ''				-- Источник по умолчанию
TVSources_var.NoSignal		 = true				-- true - то выбираем другой источник (для любых каналов, не только TVSources); false - останавливаемся
TVSources_var.SourceInFolder = false			-- true - каждый ресурс имеет собственную папку, false - только внешний фильтр
TVSources_var.NextSr		 = true				-- true - нет сигнала, запускаем следующий источник по порядку; false - выбираем источник вручную.
TVSources_var.LastPlay		 = false			-- true - при запуске канала включаем последний успешный источник (алгоритм последовательности: 1. LastPlay 2. Default (источник по умолчанию) 3. Первый в списке источников)
TVSources_var.CHNameFilter	 = true				-- true - фильровать имена каналов при поиске источников, false - не фильтровать
TVSources_var.OSDLang		 = 'Default'		-- Язык сообщений TVSources
TVSources_var.LangFile		 = ''               -- Имя языкового файла после инициализации языка
TVSources_var.LastStart		 = 0				-- Дата последней успешной обработки базы каналов
TVSources_var.BadSrcCount	 = 0				-- Счетчик переключений по неработающим источникам
TVSources_var.AutoErrorBuild = false			-- Флаг запуска автогруппировки при неисправном канале TVSources
TVSources_var.AutoBuild		 = true				-- Автоматический запуск обработки базы каналов: true - разрешен, false - ручной запуск в меню настроек 
TVSources_var.AutoBuildFL	 = true				-- Автоматический запуск обработки базы каналов по флагу события при просмотре телеканалов (работает при AutoBuild = true)
TVSources_var.AutoBuildDay	 = {1,0,0,0,0,0,0}	-- Дни недели, когда будет произведена автоматическая обработка базы каналов при запуске SimpleTV(работает при AutoBuild = true). {Вс,Пн,Вт,Ср,Чт,Пт,Сб}. 1 - включен, 0 - выключен 
TVSources_var.KeyPlsMake	 = false			-- Запуск обработки базы каналов при нажатии на кнопку "Загрузить Плей-лист": true - разрешен, false - запрещен
TVSources_var.HotKey		 = {string.byte('T'),2}           -- Shift + T, вызов меню выбора источника
TVSources_var.HotKeyUpd  = {string.byte('N'),3}         -- Ctrl + Shift +N , вызов меню обновления
TVSources_var.HotKeyServ  = {0,0}         -- не задано по умолчанию, старт/останов медиа-сервера
TVSources_var.MotherGroup	 = true  			-- true - Наследовать группу канала из источника; false - не наследовать
TVSources_var.TimeDelayTweak = 0                -- твик с задержкой (устарело)
TVSources_var.ChannelWaiting = 20               -- Ожидание воспроизведения канала, затем смена источника.
TVSources_var.DMode  		 = 0 			    --  Developer mode
TVSources_var.RestoreFav	 = 0 			    -- 1 - восстанавливать автоматически отметки любимых каналов после обновления источников; 0 - ничего не делать
TVSources_var.AutoClearBase	 = 0 			    -- 1 - автоматически очищать базу перед обновлением источников; 0 - ничего не делать
TVSources_var.DelBase		 = 0				-- 1 - удалять каналы TVS перед обновлением источников (кроме избранных); 0 - ничего не делать
TVSources_var.InfoButton	 = 1 			    -- 1 - добавить в плейлист инфо-кнопку; 0 - ничего не делать
TVSources_var.ErrRepeatCount = 1 	
TVSources_var.OSDMes         = {0,0,1}		    -- Показывать сообщения на экране: [1] - TVS,   [2] - источник при получении, [3] - источник при смене
TVSources_var.bwDown	     = 0                -- Разрешаем понижать битрейт для HD
TVSources_var.SetGroupOldCh  = 1                -- Приоритет получения группы у основного канала (без сдвига по времени)
TVSources_var.SetGroupRegional  = 0                -- Каналы  со сдвигом по времени перемещать в группу "Региональные" 
TVSources_var.SetGroupRegionalName="Региональные"
TVSources_var.UseExtFunc 	= 0                  -- depricated  -- Использовать патчи
TVSources_var.ExpandFav 	= 0                     -- Распространять избранное из TVSources на весь плейлист
TVSources_var.ActiveTab 	= 1   --  последний активный таб в настройках
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TVSources_var.tmp			 = {}				-- Временные переменные. Ветка .source (настройки источников), .tvs_ch (каналы TVSources)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local file_conf   = TVSources_var.TVSdir .. 'core\\config.lua'
if tvs_func.exists(file_conf) then
	dofile (file_conf)
	TVSources_var.UseExtFunc = 0 
	local log_f = TVSources_var.TVSdir .. 'log\\TVSources.log'
	if tvs_func.exists(log_f) then
	  if (lfs.attributes(log_f).size/1024)/1024 > 1 then 
	      TVSources_var.Logging = false 
	      tvs_core.tvs_SaveConfigInt()
	      os.remove(log_f)
	  end
	end	
	tvs_core.tvs_debug ('TVSources. Getting variables from the config file.')	
else
	tvs_core.tvs_debug ('TVSources. Error in config file or file miss.')
end


------запускаем таймер для подсчета времени загрузки в режиме разработчика--------------
if TVSources_var.DMode==1 then
   TVSources_var.DMtimer = os.clock()
end
------------ Инициализация языка интерфейса ---------------
tvs_core.tvs_LangInitialization()

------------ Проверка локалей языкового файла -------------
-- depricated
-- if TVSources_var.Logging then tvs_core.tvs_LocaleTest() end

----------- Прописываемся в списке конфигураций -----------
AddFileToExecute('onconfig',TVSources_var.TVSdir .. "initconfig.lua")

----------- прописываемся в кнопке "Обновить плейлист" ----
AddFileToExecute('refreshplst',TVSources_var.TVSdir .. "refreshplst.lua")

--------------- Инициализируем меню ----------------------
dofile (TVSources_var.TVSdir .. 'core\\initmenu.lua')

---- проверка правильности установки TVSources -------------------------------------
---- тут же прописываемся в событиях events и в действиях при получении адреса -----
tvs_core.tvs_setup()
------------------------------------------------------------------------------------
TVSources_var.tmp.source = tvs_core.tvs_GetSourceParam()
if TVSources_var.tmp.source==nil then 	
   TVSources_var.tmp.source = {}  
end
tvs_core.tvs_SaveSources()
------- инициализация таблицы сохранения tvs_Save избранных каналов и их настроек
tvs_core.CreateSQLtables()   
tvs_core.InitFav()
--------------скачиваем новые скраперы из репозитория -------------------------
--tvs_core.UpdateSourcesFromRepo()
--------------обновляем скраперы из папки AutoUpdate---------------------------
tvs_core.UpdateSourcesFromFolder()
--------------------------------------------------------------------------------
-----------запускаем различные автообновления по таймеру -------------------
TVSources_var.timerStartID =  m_simpleTV.Timer.SetTimer(3000, " dofile( TVSources_var.TVSdir .. 'core/tvs_start.lua') ")

-----------------------------------
if TVSources_var.DMode==1 and TVSources_var.DMtimer then 
	TVSources_var.DMtimer  = os.clock() - TVSources_var.DMtimer
end
----------------------------------------------------------
