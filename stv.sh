#!/bin/sh
chown -R root:root /root/.wine/drive_c/simpleTV
chmod +x /root/.wine/drive_c/simpleTV/start_stv.sh &
/root/.wine/drive_c/simpleTV/start_stv.sh > /dev/null 2>&1
