#!/usr/bin/env bash

docker exec -it -e PGPASSWORD=wardenDBpass -e PGDATABASE=warden \
	wardenpg pg_isready --host=localhost
