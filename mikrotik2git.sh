#!/bin/bash
# USAGE: mikrotik2git.sh admin@192.168.1.1 mikrotik-config 

SERVER="$1"
FILENAME="config.rsc"
DIRNAME="$2"
AUTHOR="backup <backup@$(hostname -f)>"

cd $DIRNAME || exit 1
[ -d .git ] || git init

ssh ${SERVER} /export | tr -d '\015' | sed ':x; /\\$/ { N; s/\\\n\s*//; tx }' > $FILENAME

MESSAGE="$(head $FILENAME -n1 | sed 's/# //g')"
sed -i '1s/^# .*$/#/g' $FILENAME

git add $FILENAME
git commit --author="$AUTHOR" -m "$MESSAGE"
git push origin master
