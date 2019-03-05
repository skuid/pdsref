# Private Data Service Reference Implementation

This provides an easy mode installation for the private data service. It will install docker, docker-compose, provide a sane default configuration, and start all related services.

# Grab the files

As root, run the following in a terminal:

```bash
curl -L https://github.com/skuid/pdsref/archive/master.tar.gz | tar --strip-components=1 -xzvf - -C /opt/skuid
```
# Usage

Make sure you answer `y` to both `make install` and `make start`. The scripts aren't smart enough yet to know if you've chosen to install the local postgres image or not.

## Install dependencies and set environment

`make install` will install the dependencies (like docker and docker-compose). It will also prompt for the database credentials for the Warden and Clortho persistence stores. Part of the install is to set the database encryption key. It should not overwrite this value.

```bash
make install
```

## Start it up

Running `make start` will pull and start all of the docker images that make up the data services. These images will use the environment files created during `make install`.

```bash
make start
```

## Test it out

You should see a 200/OK response from:

```bash
curl http://localhost/ping
```

And from this route:

```bash
curl http://localhost:3005/warden/ready
```

```javascript
{"status": "ready"}
```

## Updating

When there are new versions they will be changed in `docker-compose.yml`. To get the latest versions applied, just pull the latest from this repo and run `make upgrade`

```bash
curl -L https://github.com/skuid/pdsref/archive/master.tar.gz | tar --strip-components=1 -xzvf - -C /opt/skuid
cd /opt/skuid
make upgrade
```

# Using a local postgres docker image for Warden and Clortho

If you would rather run two PostgreSQL docker images for the Warden and Clortho persistence stores, you can move `env/warden` and `env/clortho` (if they already exist) and run the following commands. `make dbinstall` will create the env files for Clortho and Warden. `make dbstart` will pull the images, start them up, and then wait for the databases to be ready.


```bash
make dbinstall
make dbstart
```

# Architecture

Here are some architecture diagrams.

## Proof of concept

This is a quick POC way of running the Private Data Service (PDS) locally on an EC2 instance (or other VM). **Running PDS in this way in a production setting is not advisable**. We follow the [12 Factor App] principles and will fail fast for unexpected error condtions with the expectation that the service will be restarted by an orchestration layer like [Kubernetes].

![pocdiag]

## Reference

This is a conceptual diagram showing how PDS might be run in production and is similar to how we run the data service microservices in our cloud offering, using [Kubernetes] as the orchestration layer, log aggregators, and monitoring (which are not pictured here).

![refdiag]

[pocdiag]: https://github.com/skuid/pdsref/blob/master/imgs/poc.png "POC Diagram"
[refdiag]: https://github.com/skuid/pdsref/blob/master/imgs/ref.png "Reference Diagram"
[12 Factor App]: https://12factor.net/ "12 Factor App"
[Kubernetes]: https://kubernetes.io/ "Kubernetes"

## Clean everything

**Danger: this will delete all of your data. Use with caution**

If you would like to completely start over, you can run:

```bash
make clean
```

This will stop and remove all of your running docker images, including ones that were not created by this script. Hopefully we'll add some more smarts to limit it to just our docker images in the future, but for now, beware. It will also drop your database data and remove the settings in your environment file.

# Advanced mode 

If you want to use your own postgres database, answer `N` to the two questions above. During the install it will prompt for the postgresql database information. During `make start`, it will not start a local postgres instance and will instead rely on the values you provided.

# Useful commands for diagnosing problems (and other things)

To enter psql against clortho or warden (substituting out the appropriate environment variable file):

```bash
# Connect to clortho. Use a different environment variable file with the
# PG[HOST|USER|DATABASE|PASSWORD] environment variables for the instance
# to which you want to connect
docker run --rm --network skuid_pds --env-file /opt/skuid/env/clortho -it postgres:9.6 psql
```

To run pg_dump:

```bash
# Dump warden's database
docker run --rm --network skuid_pds --env-file /opt/skuid/env/warden postgres:9.6 pg_dump warden > warden_bak.sql
```

To restore a database using the docker image:

```bash
# Restore warden's database
docker run --rm --network skuid_pds --env-file /opt/skuid/env/warden -v "/opt/skuid:/opt/skuid" -it postgres:9.6 psql -f /opt/skuid/warden_bak.sql
```

Connect to a running container:

```bash
# Connection to warden. Find the container name using 'docker ps'
docker exec -ti skuid_warden_1 /bin/sh
```

