#!/usr/bin/env bash
set -e

## Stop docker containers and pull images
docker-compose down
docker-compose pull

## Start containers and run migrations
docker-compose up -d redis seaquill

docker-compose run --rm clortho /bin/clortho migrate up
docker-compose run --rm warden migrate up

docker-compose up -d clortho warden sluice
