#!/bin/sh
set -o pipefail

if [ $HOSTNAME ] && [ $SERVICE_NAME ]; then
    brokerIp=$HOSTNAME"."$SERVICE_NAME
    echo "brokerIP1="$brokerIp > ../conf/broker.conf
    sh mqbroker -c ../conf/broker.conf
else
    sh mqbroker autoCreateTopicEnable=true
fi

exec "$@"
