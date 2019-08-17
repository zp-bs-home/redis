#!/usr/bin/env bash

for port in `seq 7000 7005`; do
   docker stop redis-${port} \
   && docker rm redis-${port}
done

for port in `seq 7000 7005`; do
  mkdir -p ./${port}/conf \
  && PORT=${port} envsubst < ./redis-cluster.tmpl > ./${port}/conf/redis.conf \
  && mkdir -p ./${port}/data
done

pwd=`cd $(dirname $0); pwd -P`

echo ${pwd}

for port in `seq 7000 7005`; do
  docker run -d -ti \
  --privileged=true -v ${pwd}/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf \
  --privileged=true -v ${pwd}/${port}/data:/data \
  --restart always --name redis-${port} --net host \
  --sysctl net.core.somaxconn=1024 redis redis-server /usr/local/etc/redis/redis.conf
done

#for port in `seq 7000 7005`; do
#  docker run -d -ti \
#  -p ${port}:${port} -p 1${port}:1${port} \
#  --privileged=true -v ${pwd}/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf \
#  --privileged=true -v ${pwd}/${port}/data:/data \
#  --restart always --name redis-${port} \
#  --sysctl net.core.somaxconn=1024 redis redis-server /usr/local/etc/redis/redis.conf
#done


matches=""
for port in `seq 7000 7005`; do
    matches=${matches}`docker inspect --format='{{.NetworkSettings.IPAddress}}' redis-${port}`:${port}" ";
done

echo ${matches}

#./redis-cli --cluster create --cluster-replicas 1 ${matches}

#redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1



