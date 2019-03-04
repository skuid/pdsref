#!/usr/bin/env bash
set -e

source env/warden
docker-compose -f docker-compose-dbs.yml up -d

while ! ./ready.sh env/warden warden_postgres
do
  sleep 2
done

source env/clortho

while ! ./ready.sh env/clortho clortho_postgres
do
  sleep 2
done
