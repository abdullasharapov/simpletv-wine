FROM ubuntu:18.04
MAINTAINER achilles_85 "abdullasharapov@gmail.com"
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN export DEBIAN_FRONTEND="noninteractive" \
    && apt-get update && apt-get install -y wget pgp software-properties-common gnupg psmisc xvfb \
    && dpkg --add-architecture i386 \
    && wget -qO- 'https://external.comss.ru/url.php?url=https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key' | apt-key add - \
    && apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./' \
    && apt-get update && apt-get install -y --no-install-recommends winehq-staging \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir /root/.wine
COPY .wine /root/.wine
COPY start.sh /root/start.sh
RUN chmod +x //root/start.sh
CMD ["/bin/bash", "/root/start.sh"]
