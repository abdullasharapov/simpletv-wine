#!/bin/bash
#/opt/wine-stable/bin/wine reg ADD "HKLM\\System\\CurrentControlSet\\Control\\Session Manager\\Environment" /v "PATH" /t REG_SZ /d "c:\\windows;c:\\windows\\system32" &
/usr/bin/Xvfb :20.0 -ac -screen 0 800x600x24 & 
DISPLAY=:20.0 wine "/root/.wine/drive_c/simpleTV/tv.exe" -nooneinstance -execute "loadfile(m_simpleTV.MainScriptDir .. 'user/TVSources/core/x64/tvs_server.lua')('192.168.10.172','10000')"
#(sleep 30 && DISPLAY=:20.0 wine "/root/.wine/drive_c/simpleTV/tv.exe" -nooneinstance -execute "loadfile(m_simpleTV.MainScriptDir .. 'user/TVSources/core/x64/tvs_server.lua')('172.18.0.2','10002')") > /dev/null 2>&1 &
#(sleep 60 && DISPLAY=:20.0 wine "/root/.wine/drive_c/simpleTV/tv.exe" -nooneinstance -execute "loadfile(m_simpleTV.MainScriptDir .. 'user/TVSources/core/x64/tvs_server.lua')('172.18.0.2','10004')") > /dev/null 2>&1
