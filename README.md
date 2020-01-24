# simpletv-wine
Simpletv-wine container 

# Building

 * Clone this repo ( `git clone https://github.com/abdullasharapov/simpletv-wine.git` ), cd into dir simpletv-wine
 * Change if need ip address of simpletv-wine container in script `start.sh` (ip address of container, not your host address). By default, container will start three instances of simpletv server.
   You can add or remove instances as you wish in `start.sh` script. Each next instance should start with a delay of about 30 seconds after the start of the previous. Delay is set by the argument `sleep'.
   Once instance occupies two ports (if port 10000, then 10001 also occulied). The fourth instance will have port 10006, the fifth will have 10008, etc.
 * To build run `docker build -t simpletv-wine .` Name of container `simpletv-wine` you can change as you wish

# Running
 ## With docker run
 * First create network for our container `docker network create --subnet=172.18.0.0/16 simpletv_net`. In `--subnet=` specify the subnet corresponding to the container address previously specified in the script `start.sh`.
 * Then start container `docker run --restart=always -p 10000:10000 -p 10002:10002 -p 10004:10004 -tid --ip=172.18.0.2 --net simpletv_net simpletv-wine:latest`. In `--ip=` specify ip address of container previously specified in the script `start.sh`.
 
 ## OR

 ## Run container with docker-compose.yml file
 * `docker-compose up -d`

# Next Steps

Once the container is running, try visiting :
 * http://localhost:10000
 * http://localhost:10002
 * http://localhost:10004 
 * etc

localhost - ip address of your host machine
