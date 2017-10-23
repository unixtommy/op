#!/bin/bash
LOG_DIR="/var/log/audit"
LOG_NAME="shell_audit.log"
PROFILE="/etc/profile"
HOST="https://jms.centrixlink.com"
if [ $(grep '100.100.2.136' /etc/resolv.conf|wc -l) -eq 1 ];then
		if [ $(grep "172.17.0.58 jms.centrixlink.com" /etc/hosts|wc -l) -eq 0 ];then
               		echo "172.17.0.58 jms.centrixlink.com" >> /etc/hosts
		fi	
fi
if [ ! -d $LOG_DIR ];then
	mkdir $LOG_DIR
fi
if [ ! -e $LOG_DIR/$LOG_NAME ];then
	touch $LOG_DIR/$LOG_NAME
	chown nobody:nobody $LOG_DIR/$LOG_NAME
	chmod 002 $LOG_DIR/$LOG_NAME
	chattr +a $LOG_DIR/$LOG_NAME
	chmod 755 $LOG_DIR
fi
num=`grep "export AUDIT_FILE=$LOG_DIR/$LOG_NAME" $PROFILE |wc -l`
num2=`grep "export PROMPT_COMMAND" $PROFILE|wc -l`
echo "$num"
echo "$num2"
if [ $num -eq 0 ];then
	echo  -e "export AUDIT_FILE=$LOG_DIR/$LOG_NAME\n" >> $PROFILE
fi
if [ $num2 -eq 0 ];then
	curl ${HOST}/shell/prompt.txt >> $PROFILE
	source $PROFILE
fi
