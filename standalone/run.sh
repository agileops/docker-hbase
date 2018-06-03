#!/bin/bash

/opt/hbase-$HBASE_VERSION/bin/start-hbase.sh
tail -f /opt/hbase-$HBASE_VERSION/logs/*  &
sleep 10 &&
hbase thrift start -p 9090 --infoport 9095 &
./bin/tephra &
/opt/phoenix/bin/queryserver.py
