#!/bin/bash

port=3050
data="$(pwd)"
dopts=
fake=no

done=no
while [ $done = no ]; do
  case "$1" in
    --port=*)	port="$(echo $1 | sed 's/[^=]*=//')"
		shift
		;;
    --data=*)	data="$(echo $1 | sed 's/[^=]*=//')"
		shift
		;;
    --with-R=*) from="$(echo $1 | sed 's/[^=]*=//')"
		dopts="$dopts --volumes-from $from"
		shift
		;;
    --with-R)	dopts="$dopts --volumes-from rserve"
		shift
		;;
    -n)		fake=yes
		shift
		;;
    -d)		dopts="$dopts -d"
		shift
		;;
    -it)	dopts="$dopts -it"
		shift
		;;
    *)		done=yes
		;;
  esac
done

if [ $fake = no ]; then
  docker run -p $port:3050 -v "$data":/data $dopts docker.io/swipl/swish  $*
else
  echo docker run -p $port:3050 -v "$data":/data $dopts docker.io/swipl/swish  $*
fi
