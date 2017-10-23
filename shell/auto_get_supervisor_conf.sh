#!/bin/bash
env=$1
project_name=$2
OS_VERSION=`lsb_release  -a|grep Description:|cut -d ":" -f 2|tr "[A-Z]" "[a-z]"`
mirrors_server="https://jms.centrixlink.com/"
#os version
if [ $(echo $OS_VERSION|grep "ubuntu"|wc -l) -eq 1 ];then
		conf_dir="/etc/supervisord/conf.d/"
elif [ $(echo $OS_VERSION|grep "centos"|wc -l) -eq 1  ];then
		conf_dir="/etc/supervisord/"
else
	echo "OS not match!!"
	exit -1
fi


get_conf_aliyun() {
    if [ $(grep "172.17.0.58 jms.centrixlink.com" /etc/hosts |wc -l) -eq 0 ];then
        	echo "172.17.0.58 jms.centrixlink.com" >> /etc/hosts
        if [ -e /etc/init.d/dns-clean ];then
                /etc/init.d/dns-clean start 
        fi
	fi
	if [ ! -e ${conf_dir}/${project_name}.conf ];then

		wget -P $conf_dir/ ${mirrors_server}/op/supervisor/$project_name.conf
		if [ -e  $conf_dir/$project_name.conf ]; then
			outlog_dir=` grep -E "stdout_logfile" $conf_dir/$project_name.conf |grep "/"|cut -d "=" -f 2 `
			errlog_dir=` grep -E "stderr_logfile" $conf_dir/$project_name.conf |grep "/"|cut -d "=" -f 2 `
			echo -e "$outlog_dir \n $errlog_dir"
			if [ ! -d $outlog_dir ]; then
				mkdir -p ${outlog_dir%/*}
			fi
			if [ ! -d $errlog_dir ]; then
				mkdir -p ${errlog_dir%/*}
			fi
		fi


		/usr/bin/supervisorctl reread
		/usr/bin/supervisorctl update
	else
		outlog_dir=` grep -E "stdout_logfile" $conf_dir/$project_name.conf |grep "/"|cut -d "=" -f 2 `
		errlog_dir=` grep -E "stderr_logfile" $conf_dir/$project_name.conf |grep "/"|cut -d "=" -f 2 `
		echo -e "$outlog_dir \n $errlog_dir"
		if [ ! -d $outlog_dir ]; then
			mkdir -p ${outlog_dir%/*}
		fi
		if [ ! -d $errlog_dir ]; then
			mkdir -p ${errlog_dir%/*}
		fi
		/usr/bin/supervisorctl start $project_name
	fi
}

get_conf() {
	if [ ! -e ${conf_dir}/${project_name}.conf ];then
		wget -P $conf_dir/ ${mirrors_server}/op/supervisor/$project_name.conf
		if [ -e  $conf_dir/$project_name.conf ]; then
			outlog_dir=` grep -E "stdout_logfile" $conf_dir/$project_name.conf |grep "/"|cut -d "=" -f 2 `
			errlog_dir=` grep -E "stderr_logfile" $conf_dir/$project_name.conf |grep "/"|cut -d "=" -f 2 `
			echo -e "$outlog_dir \n $errlog_dir"
			if [ ! -d $outlog_dir ]; then
				mkdir -p ${outlog_dir%/*}
			fi
			if [ ! -d $errlog_dir ]; then
				mkdir -p ${errlog_dir%/*}
			fi
		fi
		/usr/bin/supervisorctl reread
		/usr/bin/supervisorctl update
	else
		outlog_dir=` grep -E "stdout_logfile" $conf_dir/$project_name.conf |grep "/"|cut -d "=" -f 2 `
		errlog_dir=` grep -E "stderr_logfile" $conf_dir/$project_name.conf |grep "/"|cut -d "=" -f 2 `
		echo -e "$outlog_dir \n $errlog_dir"
		if [ ! -d $outlog_dir ]; then
			mkdir -p ${outlog_dir%/*}
		fi
		if [ ! -d $errlog_dir ]; then
			mkdir -p ${errlog_dir%/*}
		fi
		/usr/bin/supervisorctl start $project_name
	fi
}
case "$env" in
	#dev* ) 
	#	echo "branch dev"
		#conf_dir="/etc/supervisord/conf.d"
	#	get_conf ;;
	"qa" ) echo "branch qa"
		get_conf_aliyun;;
	pre* )
		get_conf_aliyun;;
	"prod" )
		get_conf_aliyun;;
	* ) echo "输入的env  not exsit!! Usage: $0 |preview|prod project_name";;
esac
