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

## Clean everything

**Danger: this will delete all of your data. Use with caution**

If you would like to completely start over, you can run:

```bash
make clean
```

This will stop and remove all of your running docker images, including ones that were not created by this script. Hopefully we'll add some more smarts to limit it to just our docker images in the future, but for now, beware. It will also drop your database data and remove the settings in your environment file.

# Advanced mode 

If you want to use your own postgres database, answer `N` to the two questions above. During the install it will prompt for the postgresql database information. During `make start`, it will not start a local postgres instance and sill instead rely on the values you provided.
