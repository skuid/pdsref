#!/usr/bin/env bash

printf "Are you sure? This will delete all of your docker images and your warden data. [y|N] "
read answer

if [ ${answer} != "y" ]
then
	echo "Exiting without cleaning."
	exit 1
fi

docker stop $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
rm env/warden
rm -rf pgdata
