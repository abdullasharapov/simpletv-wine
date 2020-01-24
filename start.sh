#!/bin/bash

/usr/bin/Xvfb :20.0 -ac -screen 0 800x600x24 > /dev/null 2>&1 & 
DISPLAY=:20.0 wine "/root/.wine/drive_c/simpleTV/tv.exe" -nooneinstance -execute "loadfile(m_simpleTV.MainScriptDir .. 'user/TVSources/core/x64/tvs_server.lua')('172.17.0.2','10000')" > /dev/null 2>&1 &
(sleep 30 && DISPLAY=:20.0 wine "/root/.wine/drive_c/simpleTV/tv.exe" -nooneinstance -execute "loadfile(m_simpleTV.MainScriptDir .. 'user/TVSources/core/x64/tvs_server.lua')('172.17.0.2','10002')") > /dev/null 2>&1 &
(sleep 60 && DISPLAY=:20.0 wine "/root/.wine/drive_c/simpleTV/tv.exe" -nooneinstance -execute "loadfile(m_simpleTV.MainScriptDir .. 'user/TVSources/core/x64/tvs_server.lua')('172.17.0.2','10004')") > /dev/null 2>&1
