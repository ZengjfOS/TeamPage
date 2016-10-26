#!/bin/bash

# ip=127.0.0.1
# ip=183.39.159.19
ip=0.0.0.0
port=9000

getPid()
{
    pid=`ps aux | grep /usr/local/bin/mkdocs | head -n1 | awk '{print $2}'`
}

if [ $# -ne 1 ];then
    echo "autorun.sh [server][build][pushweb][pushres]"
    exit -1
fi

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
    mkdocs build --strict 
    for partner in `find * -name *.html`
    do 
        echo $partner
        ./tools/hidden.py $partner
    done 

    exit 0
fi

if [ $1 == "pushweb" ];then
    cd site
    git add .
    git rm $(git ls-files --deleted)
    git commit -m "update"
    git push git@github.com:AplexOS/AplexOS.github.io.git master

    exit 0
fi

if [ $1 == "pushres" ];then
    git add .
    git rm $(git ls-files --deleted)
    git commit -m "update"
    git push git@github.com:AplexOS/TeamPage.git master

    exit 0
fi

echo "autorun.sh [server][build][pushweb][pushres]"
