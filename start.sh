#!/usr/bin/env bash

printf "Would you like to start the local postgres image? [y|N]"
read startpg

if [ "${startpg}" == "y" ]
then
	source env/warden
	docker-compose -p pds up -d postgres

	while ! ./ready.sh 
	do
		sleep 5
	done
fi

docker-compose -p pds up -d redis seaquill
docker-compose -p pds run --rm warden migrate up
docker-compose -p pds up -d warden sluice
