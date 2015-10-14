#!/bin/bash

#make the local language is chinese
export LANG=zh_CN

#make the around command path

ECHO=/bin/echo
SED=/bin/sed
AWK=/bin/awk
UPTIME=/bin/uptime
VMSTAT=/usr/bin/vmstat
FREE=/usr/bin/free
IPTABLES=/sbin/iptables
GREP=/bin/grep
TOP=/usr/bin/top
HEAD=/usr/bin/head
DF=/bin/df
CAT=/bin/cat

#check the iostat file is exits
DATE_FILE=`date +%Y%m%d`
IOSTAT_FILE=~/log/iostat_$DATE_FILE.txt

if [ -e $IOSTAT_FILE ]
then	
	echo "The iostat file is exits!"
else
	touch $IOSTAT_FILE
fi

#setup the time of the check

DATE=`/bin/date +%c`
$ECHO "   " >> $IOSTAT_FILE
$ECHO "   " >> $IOSTAT_FILE
$ECHO "���μ���ʱ����:$DATE" >> $IOSTAT_FILE
$ECHO "---------------------------------------------------------------------------------------------" >>$IOSTAT_FILE

#check the cpu stat

$ECHO "��ǰʱ��CPUʹ��״�����£�" >> $IOSTAT_FILE
$ECHO "`$TOP -n 1 |$GREP  Cpu`"   >> $IOSTAT_FILE
$ECHO "---------------------------------------------------------------------------------------------" >>$IOSTAT_FILE

#check the memory stat

$ECHO "��ǰʱ���ڴ�ռ��������£�" >> $IOSTAT_FILE
$ECHO "`$FREE |$GREP  -1 Mem |$HEAD -n 2 `" >> $IOSTAT_FILE
$ECHO "----------------------------------------------------------------------------------------------" >>$IOSTAT_FILE

#check the disk stat

$ECHO "��ǰʱ�̴��̿ռ�ʹ��������£�" >> $IOSTAT_FILE
$ECHO "`$DF -h `" >> $IOSTAT_FILE
$ECHO "----------------------------------------------------------------------------------------------" >>$IOSTAT_FILE

#check the network stat

NETWORK_STAT=/proc/net/dev
$ECHO "��ǰʱ����������ͳ�����£�"  >> $IOSTAT_FILE
$ECHO "`$CAT $NETWORK_STAT|$GREP -v lo |$GREP -v sit0 `" >> $IOSTAT_FILE
$ECHO "##################################################################################################################################" >> $IOSTAT_FILE

exit 0







