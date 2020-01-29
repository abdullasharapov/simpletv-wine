# simpletv-wine
Simpletv-wine container based on stable release from official repo

# Building

 * Clone this repo ( `git clone https://github.com/abdullasharapov/simpletv-wine.git` ) into /opt dir, then cd /opt/simpletv-wine.
 * Change if need ip address of simpletv-wine instances in script `start_stv.sh` (host ip address, where  container will be run). By default, container will start one instance of simpletv server.
   You can add or remove instances as you wish in `start_stv.sh` script. Each next instance should start with a delay of about 30 seconds after the start of the previous. Delay is set by the argument `sleep'.
   The last command for start instance must end without the '&' character
   Once instance occupies two ports (if port 10000, then 10001 also occulied). The fourth instance will have port 10006, the fifth will have 10008, etc.
 * To build run `docker build -t simpletv-wine .` Name of container `simpletv-wine` you can change as you wish

# Running
 ## With docker run
 * `cd /opt/simpletv-wine`
 * Download SimpleTV archive `wget https://github.com/abdullasharapov/simpletv-wine/releases/download/1.0/simpleTV.tar.bz2`. Unpack `tar xjf simpleTV.tar.bz2 -C /opt/simpletv-wine`.
 * Copy start script to simpleTV dir `cp start_stv.sh simpleTV`
 * Start container `docker run --restart=always -tid --net=host -v /opt/simpletv-wine/simpleTV:/root/.wine/drive_c/simpleTV simpletv-wine /root/stv.sh`.
 
 ## With docker-compose
 * Not yet ready


# Next Steps

Once the container is running, try visiting :
 * http://localhost:10000
 * http://localhost:10002
 * http://localhost:10004 
 * etc

localhost - ip address of your host machine
