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
    mkdocs build --strict 
    # ./tools/hidden.py site/index.html
    # ./tools/hidden.py site/search.html
    # find * -name index.html | xargs tools/hidden.py
    for partner in `find * -name *.html`
    do 
        echo $partner
        ./tools/hidden.py $partner
    done 
fi

if [ $1 == "push" ];then
    cd site
    git add .
    git commit -m "update"
    git push git@github.com:AplexOS/AplexOS.github.io.git master
fi
