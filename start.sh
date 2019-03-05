#!/usr/bin/env bash
set -e

docker-compose up -d redis seaquill

## We want to fail first trying to install the uuid extension, otherwise we get dirty migrations
docker run --rm --network skuid_pds --env-file /opt/skuid/env/warden -it postgres:9.6 psql -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'
docker run --rm --network skuid_pds --env-file /opt/skuid/env/clortho -it postgres:9.6 psql -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'

docker-compose run --rm clortho /bin/clortho migrate up
docker-compose run --rm warden migrate up

docker-compose up -d clortho warden sluice
