#!/bin/bash
#$1 backup_dir_path $2:file_path $3:file_name
DATE_DIR="$(date -I)/$(date +%s)"
TARGET_DIR="/alidata/op/repos"
if [[ ! -d $TARGET_DIR ]]; then
	mkdir -p $TARGET_DIR
fi

if [[ $# -lt 3 ]]; then
	echo "no argument！！！"
	exit -1
else
	if [[ ! -d $1  ]]; then
		echo "目录$1不存在"
		mkdir -p $1
	fi
	if [[ ! -d $1/$DATE_DIR/ ]]; then
		mkdir -p $1/$DATE_DIR/
	fi
	if [ -d $2/$3 ];then
		mv $2/$3 $1/$DATE_DIR/
	fi
fi

