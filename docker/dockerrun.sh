#!/bin/bash

#add if $syslogtag contains 'script' then /var/log/docker.log to rsyslog.conf and RESTART

cat /dev/null > /var/log/docker.log;
docker build -t uah2 . ;
docker run --rm --name uah2 --log-driver=syslog --log-opt tag=script -d uah2

echo "reading /var/log/docker.log:"
tail -F /var/log/docker.log
