#!/bin/bash
/usr/bin/Xvfb :20.0 -ac -screen 0 800x600x24 &
DISPLAY=:20.0 wine "/root/.wine/drive_c/simpleTV/tv.exe" -nooneinstance -execute "loadfile(m_simpleTV.MainScriptDir .. 'user/TVSources/srvr.lua')('192.168.10.172','10000')"
#(sleep 30 && DISPLAY=:20.0 wine "/root/.wine/drive_c/simpleTV/tv.exe" -nooneinstance -execute "loadfile(m_simpleTV.MainScriptDir .. 'user/TVSources/srvr.lua')('172.18.0.2','10002')") & #Second instance
#(sleep 60 && DISPLAY=:20.0 wine "/root/.wine/drive_c/simpleTV/tv.exe" -nooneinstance -execute "loadfile(m_simpleTV.MainScriptDir .. 'user/TVSources/srvr.lua')('172.18.0.2','10004')")   #Third instance etc. The last command must end without the '&' character
