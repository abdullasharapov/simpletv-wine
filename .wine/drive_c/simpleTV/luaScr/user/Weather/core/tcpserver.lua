------ команды -------------------
local Commands = {
['SHORT']=[[
	Weather.Param.fullmode = 0   
	weather_core.SaveParam(Weather.Param)
	weather_core.Show(true)
	]],
['FULL']=[[
	Weather.Param.fullmode = 1   
	weather_core.SaveParam(Weather.Param)
	weather_core.Show(true)
	]],
['HIDE']=[[
	Weather.Param.fullmode = 2   
	weather_core.SaveParam(Weather.Param)
	weather_core.Show(true)
	]],
['FORECAST']=[[
   dofile(Weather.FullDir..'\\show_forecast.lua')
	]],
['OPENWEATHERMAP']=[[
	Weather.Param.Provider = 0 
	weather_core.SaveParam(Weather.Param)
	weather_core.Run()
	]],
['YANDEX']=[[
	Weather.Param.Provider = 1 
	weather_core.SaveParam(Weather.Param)
	weather_core.Run()
	]]
}
-----------------------
local function RunData(data)
	 data = tostring(data):gsub('[\r\n]','')
	 assert( loadstring(Commands[data]) )()
end

local function CreateServer()
	 local p={}
	if Weather.Param.ServerIp=="" then Weather.Param.ServerIp = "127.0.0.1" end
	p.address = Weather.Param.ServerIp
	p.service = Weather.Param.ServerPort
	p.eventfunction = "WeatherTCPServer"
	Weather.server = m_simpleTV.TcpServer.CreateServer(p)
end

function WeatherTCPServer(Object,Event,Data)
     --debug_in_file("Event="..Event)
	  local d = tostring(Data)
	 if Event=="Receive" then
	    local success, result = pcall(RunData,Data)
	 end
end 


CreateServer()

