#!/bin/bash
bool=yes
init() {
	if [ $bool = 'yes' ];then
		echo "yum 安装 ntpdate vim unzip wget screen.....,时间同步"
		rm -rf /etc/localtime && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
		yum install svn ntpdate vim unzip wget screen gcc gcc-c++ lrzsz -y && ntpdate pool.ntp.org && echo 'UTC=false' >> /etc/sysconfig/clock && echo 'ARC=false' >> /etc/sysconfig/clock && hwclock --systohc
	fi
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
	setenforce 0
	if [ $(grep "1024" /etc/security/limits.d/90-nproc.conf|wc -l) -eq 1 ];then
		sed -i 's/1024/65536/' /etc/security/limits.d/90-nproc.conf
	fi
	if [ $(grep  "soft.*nofile" /etc/security/limits.conf|wc -l ) -eq 0 ];then
		echo -e "*\tsoft\tnofile\t102400" >>  /etc/security/limits.conf 
	fi
	if [ $(grep  "hard.*nofile" /etc/security/limits.conf|wc -l ) -eq 0 ];then
		echo -e "*\thard\tnofile\t102400" >>  /etc/security/limits.conf 
	fi
	if [ $(grep  "\*.*soft.*nproc" /etc/security/limits.conf|wc -l ) -eq 0 ];then
		echo -e "*\tsoft\tnproc\t102400" >>  /etc/security/limits.conf 
	fi
	if [ $(grep  "\*.*hard.*nproc" /etc/security/limits.conf|wc -l) -eq 0 ];then
		echo -e "*\thard\tnproc\t102400" >>  /etc/security/limits.conf 
	fi
	if [ $(grep '10.143.22.116' /etc/resolv.conf|wc -l) -eq 1 ];then
		if [ $(grep "10.25.199.48 mirrors.91power.com" /etc/hosts|wc -l) -eq 0 ];then
               		echo "10.25.199.48 mirrors.91power.com" >> /etc/hosts
		fi	
	fi
	if [ $(grep "fs.file-max" /etc/sysctl.conf |wc -l) -eq 0 ];then
		curl https://mirrors.91power.com/shell/sysctl.txt >> /etc/sysctl.conf
		sysctl -p
	fi
}
init
