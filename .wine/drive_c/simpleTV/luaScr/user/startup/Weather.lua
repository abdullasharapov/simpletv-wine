-- глобальные переменные ---------------
Weather = {}
Weather.NameDir = 'Weather'

Weather.FullDir = m_simpleTV.MainScriptDir .. "user/" .. Weather.NameDir 

local version, version_full = m_simpleTV.Common.GetVersion()
Weather.SimpleVersion = version
if not package.path:find(Weather.NameDir ..'[/\\]core')  then
	if Weather.SimpleVersion >=800 and m_simpleTV.Common.isX64()   then
		package.path = Weather.FullDir ..'/core/x64/?.lua;' .. package.path 
	else 
		package.path = Weather.FullDir ..'/core/?.lua;' .. package.path
	end
end

require 'lfs'
require 'weather_core'

AddFileToExecute('onconfig',Weather.FullDir .. "\\core\\initconfig.lua")

-- загрузка настроек ---------------------
Weather.Param = weather_core.LoadParam()

-- инициализация локализованных данных ---
weather_core.SetLocalizedTables()  

-- запуск и перерисовка с небольшой задержкой ------------------
function WeatherEventCallback(typeEvent)
    local etype = tonumber(typeEvent) or 0
  -- m_simpleTV.OSD.ShowMessage_UTF8 ( etype)
  --debug_in_file("etype=" ..etype)
	if etype==1 then
		   local script = [[
		         if Weather.StartWaitingID then
		            m_simpleTV.Timer.DeleteTimer(Weather.StartWaitingID)
		            Weather.StartWaitingID=nil
		         end
				 if (Weather.timerIDbig or Weather.timerIDsmall) then  weather_core.Show(true) -- без обновления
				 elseif Weather.Param.enabled==1 then weather_core.Run()
				 end
			]]
			Weather.StartWaitingID =  m_simpleTV.Timer.SetTimer(300, script)
	end
end

local version, version_full = m_simpleTV.Common.GetVersion()
 local id = m_simpleTV.OSD.AddEventListener( { type = 1, callback = 'WeatherEventCallback' } )

if version>=800 then
   WeatherEventCallback(1)
end

-----------------------------

