#!/usr/bin/env bash

docker run --rm --network skuid_pds --env-file $1 -e PGPORT=5432 -it postgres:9.6 pg_isready
