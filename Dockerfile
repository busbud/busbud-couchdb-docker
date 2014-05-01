FROM klaemo/couchdb

MAINTAINER Ziad Saab ziad.saab@gmail.com

# Change default CouchDB's log rotation to daily, and keep only 1 day
RUN sed -i "s/weekly/daily/;s/rotate 10/rotate 1/" /usr/local/etc/logrotate.d/couchdb

# Install nginx
RUN apt-get -y update
RUN apt-get -y install software-properties-common python-software-properties
RUN add-apt-repository ppa:nginx/stable
RUN apt-get -y update
RUN apt-get -y install nginx

# Change default nginx log rotation to daily, and keep only 1 day
RUN sed -i "s/weekly/daily/;s/rotate 52/rotate 1/" /etc/logrotate.d/nginx

# Procure htpasswd
RUN apt-get -y install apache2-utils

# Use htpasswd to generate a default htpasswd file with user couchdb:couchdb
RUN mkdir /secret && htpasswd -b -c /secret/htpasswd couchdb couchdb

# Install logrotate
RUN apt-get -y install logrotate

# Install newrelic agent.sockets
RUN apt-get -y install python-pip
RUN pip install newrelic-plugin-agent

# Install supervisor
RUN apt-get -y install supervisor

# Overwrite the start_couch script with our own version that starts logrotate, couchdb and nginx
ADD ./opt /opt

# Add the newrelic config file with %LICENSE_KEY% template
ADD ./config/newrelic /etc/newrelic

# Add couchdb configuration
ADD ./config/couchdb /usr/local/etc/couchdb

# Add nginx config
ADD ./config/nginx /etc/nginx

# Add supervisor config
ADD ./config/supervisor /etc/supervisor