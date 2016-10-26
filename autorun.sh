#!/bin/bash

# ip=127.0.0.1
# ip=183.39.159.19
ip=0.0.0.0
port=9000

getPid()
{
    pid=`ps aux | grep /usr/local/bin/mkdocs | head -n1 | awk '{print $2}'`
}

if [ $1 == "server" ];then
    getPid
    if [ ! -z $pid ];then
        kill -9 $pid
        echo "Have kill process $pid"
    fi

    mkdocs serve --dev-addr=$ip:$port --strict &
    echo "mkdocs server has start."

    exit 0
fi

if [ $1 == "build" ];then
    mkdocs build
fi
