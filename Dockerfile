FROM ubuntu:18.04
MAINTAINER achilles_85 "abdullasharapov@gmail.com"
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV WINE_VERSION 5.0.0~bionic
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get install --no-install-recommends -y wget pgp software-properties-common gnupg psmisc xvfb \
    && dpkg --add-architecture i386 \
    && wget --no-check-certificate -qO- 'https://dl.winehq.org/wine-builds/winehq.key' | apt-key add - \
    && apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' \
    && add-apt-repository ppa:cybermax-dexter/sdl2-backport \
    && apt-get update && apt-get install -y --no-install-recommends "winehq-stable=$WINE_VERSION*" \
    && rm -rf /var/lib/apt/lists/*
RUN Xvfb :20.0 -ac -screen 0 800x600x24 > /dev/null 2>&1 & DISPLAY=:20.0 winecfg > /dev/null 2>&1 & sleep 10 && wineserver -k \
    && cp /root/.wine/drive_c/windows/system32/netstat.exe  /root/.wine/drive_c/windows/netstat.exe \
    && cp /root/.wine/drive_c/windows/system32/find.exe  /root/.wine/drive_c/windows/find.exe \
    && killall -9 Xvfb
# Specify the required ports, for each instance, the new port will be the previous + 2. Below is an example for three server instances
EXPOSE 10000 10002 10004
COPY stv.sh /root/stv.sh
COPY system.reg /root/.wine/
RUN chmod +x /root/stv.sh \
    && chown root:root /root/.wine/system.reg
CMD ["/bin/bash", "/root/stv.sh"]
