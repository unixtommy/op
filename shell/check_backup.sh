#!/bin/bash
echo "检测 backup.sh 是否存在。。。。。。。"
if [ ! -d /home/northloong ];then
	mkdir /home/northloong
fi
if [ ！ -e "/mnt/shell/backup.sh" ];then
	echo "目录：/mnt/shell/backup.sh 不存在，请先挂载阿里云-15服务器的共享资源目录，再执行构建"
	exit -1
fi