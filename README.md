# busbud-couchdb-docker

## Build it like this:

    sudo docker build --tag="busbud-couchdb" .

This will give you an image called busbud-couchdb that you can then run.

## Run it like this:

    sudo docker start busbud-couchdb || sudo docker run -d \
      --name="busbud-couchdb" \
      -p 80:80 \
      busbud-couchdb

## Run with custom data dir from host:

    sudo docker start busbud-couchdb || sudo docker run -d -p 80:80 \
      --name="busbud-couchdb" \
      -v /mnt/local_data_dir:/usr/local/var/lib/couchdb \
      busbud-couchdb

## Restart after configuration change:

    sudo docker restart busbud-couchdb

## Logging
By default the container will log CouchDB at `/usr/local/var/log/couchdb/couchdb.log`. The logrotate config will create a new file every day and keep the previous day archived.

If you want to inspect the log file from time to time, you can use:

    docker cp busbud-couchdb:/usr/local/var/log/couchdb/couchdb.log /tmp/couchdb.log

And read the log file locally. If you find that you need to inspect the log file often, you can run the docker container with an added:

    -v /mnt/local_log_dir:/usr/local/var/log/couchdb

This will enable you to use `tail -f /mnt/local_log_dir/couchdb.log` to inspect the log file at all times when the container is running, while still taking advantage of logrotate.

## Authentication
Authentication is handled by nginx. The default image has an htpasswd file at `/secret/htpasswd`, configured with a username and password of `couchdb`.

In order to run the container with a different set of usernames/passwords, you have to:

1. Create your own htpasswd file:

    mkdir -p /some/place/
    htpasswd -c /some/place/htpasswd user # this will ask you for a password for user 'user'

2. When running the `busbud-couchdb` image, add the volume mounted at `/secret`: `-v /some/place:/secret`. This will replace the default htpasswd file with your own.

If you don't have the `htpasswd` command, you can find it thru the package `apache2-utils`.
