#!/usr/bin/env bash

ip=47.102.214.252

./redis-cli --cluster create ${ip}:7000 ${ip}:7001 ${ip}:7002 ${ip}:7003 ${ip}:7004 ${ip}:7005 --cluster-replicas 1 -a passwd123


#./redis-cli -h 47.102.214.252 -p 7000
