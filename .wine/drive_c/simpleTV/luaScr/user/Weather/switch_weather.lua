-- 0 - сокр. режим , 1 - полный, 2 - не отобржать

Weather.Param.fullmode = (Weather.Param.fullmode or 0) + 1

if Weather.Param.fullmode >= 3 then Weather.Param.fullmode = 0 end

weather_core.SaveParam(Weather.Param)

weather_core.Show(true)   -- notForce=[true,false]



