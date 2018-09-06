# Private Data Service Reference Implementation

This provides an easy mode installation for the private data service. It will install docker, docker-compose, provide a sane default configuration, and start all related services.

# Grab the files

As root, run the following in a terminal:

```bash
curl -L https://github.com/skuid/pdsref/archive/master.tar.gz | \
	tar --strip-components=1 -xzvf - -C /opt/skuid
```
# Usage

Make sure you answer `y` to both `make install` and `make start`. The scripts aren't smart enough yet to know if you've chosen to install the local postgres image or not.

## Install dependencies and set environment

Answer yes `y` when it asks if you want to use the local postgres image.

```bash
make install
```

## Start it up

Answer yes `y` when it asks if you want to use the local postgres image.

```bash
make start
```

# Advanced mode 

If you want to use your own postgres database, answer `N` to the two questions above. During the install it will prompt for the postgresql database information. During `make start`, it will not start a local postgres instance and sill instead rely on the values you provided.
