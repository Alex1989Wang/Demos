#!/bin/bash

export PATH="../../bin:$PATH"

OUT_DIR="../../src/protocol"
CWD=`pwd`

if [ ! -z "$1" ]; then
	OUT_DIR=$1
fi

if [ ! -z "$1" ]; then
	shift 1
fi

if [ ! -d $OUT_DIR ]; then
	mkdir -p $OUT_DIR
fi 

AVAIL_DIRS=""
if [ ! -z "`ls *.proto`" ]; then
	protoc $* --go_out=$OUT_DIR *.proto
	if [ "$?" != "0" ]; then
		exit 1
	fi
	AVAIL_DIRS="protocol"
fi

for e in `ls` 
do
	if [ ! -d "$e" ]; then
		continue
	fi

	if [ -z "`ls ${e}/*.proto`" ]; then
		continue
	fi

	if [ ! -d "$OUT_DIR/$e" ]; then
		mkdir -p $OUT_DIR/$e
	fi

	protoc $* --go_out=$OUT_DIR/$dir $e/*.proto
	if [ "$?" != "0" ]; then
		exit 1
	fi
	
	if [ ! -z "$AVAIL_DIRS" ]; then
		AVAIL_DIRS=${AVAIL_DIRS}" protocol/"${e}
	else
		AVAIL_DIRS="protocol/"${e}
	fi
done

cd ../../
for dir in $AVAIL_DIRS
do
	sh ./run_go.sh install $dir
done
cd $CWD

exit $?

