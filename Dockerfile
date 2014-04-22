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

# Overwrite the start_couch script with our own version that starts logrotate, couchdb and nginx
ADD ./opt /opt
