#!/bin/bash
hbase thrift start -p 9090 --infoport 16010 &
/opt/hbase-$HBASE_VERSION/bin/hbase master start

tail -f /opt/hbase-$HBASE_VERSION/logs/*
