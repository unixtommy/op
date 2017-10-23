#!/bin/bash
HOSTNAME="$1"
if [ $(grep "172.17.0.58 jms.centrixlink.com" /etc/hosts |wc -l) -eq 0 ];then
	echo "172.17.0.58 jms.centrixlink.com" >> /etc/hosts
	/etc/init.d/dns-clean start 
fi
if [ -e "/etc/zabbix/zabbix_agentd.conf.bak" ];then
	rm -f /etc/zabbix/zabbix_agentd.conf.bak
fi
if [  -e "/etc/zabbix/zabbix_agentd.conf" ];then
	mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak
	wget -P /etc/zabbix/  http://jms.centrixlink.com/zabbix/zabbix_agentd.conf
	sed -i "s/Hostname=Centrixlink/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
else
	 wget -P /etc/zabbix/  http://jms.centrixlink.com/zabbix/zabbix_agentd.conf
        sed -i "s/Hostname=Centrixlink/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
fi
service zabbix-agent restart

