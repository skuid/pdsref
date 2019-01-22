#!/usr/bin/env bash
set -e

printf "Would you like to start the local postgres images? [y|N] "
read startpg

if [ "${startpg}" == "y" ]
then
  source env/warden
  docker-compose -f docker-compose-dbs.yml up -d

  while ! ./ready.sh env/warden warden_postgres
  do
    sleep 5
  done

  source env/clortho

  while ! ./ready.sh env/clortho clortho_postgres
  do
    sleep 5
  done
fi

## We want to fail first trying to install the uuid extension, otherwise we get dirty migrations
docker run --rm --network skuid_pds --env-file /opt/skuid/env/warden -it postgres:9.6 psql -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'
docker run --rm --network skuid_pds --env-file /opt/skuid/env/clortho -it postgres:9.6 psql -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'

docker-compose run --rm clortho /bin/clortho migrate up
docker-compose run --rm warden migrate up

docker-compose up -d redis seaquill
docker-compose up -d clortho warden sluice
