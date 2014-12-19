#!/bin/bash

sed -i 's|localhost|'"${DBHOST}"'|g' app.psgi
sed -i 's|server unix:.*/FrameworkBenchmarks/plack|server unix:'"${TROOT}"'|g' nginx.conf

export PATH=$PERL_HOME/bin:$PATH

start_server --backlog=16384 --pid-file=$TROOT/app.pid --path=$TROOT/app.sock -- plackup -E production -s Starlet --max-keepalive-reqs 1000 --max-reqs-per-child 50000 --min-reqs-per-child 40000 --max-workers=${MAX_THREADS} -a $TROOT/app.psgi
$NGINX_HOME/sbin/nginx -c $TROOT/nginx.conf