#!/usr/bin/env bash

printf "Would you like to start the local postgres images? [y|N] "
read startpg

if [ "${startpg}" == "y" ]
then
  source env/warden
  docker-compose up -d -f docker-compose-dbs.yml

  while ! ./ready.sh
  do
    sleep 5
  done

  source env/clortho

  while ! ./ready.sh
  do
    sleep 5
  done
fi

docker-compose up -d redis seaquill
docker-compose run --rm warden migrate up
docker-compose run --rm clortho migrate up
docker-compose up -d clortho warden sluice
