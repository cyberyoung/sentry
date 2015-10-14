cd /home/supertool/bin

#make the local language is chinese
#export LANG=zh_CN


removedate=`date +%d`
curdate=`date +%H`
logdir=/home/supertool/log
logcpuuse=$logdir/cpuuse.log
logcpuload=$logdir/cpuload.log
logioload=$logdir/ioload.log
lognetworkload=$logdir/networkload.log
logsysprocess=$logdir/sysprocess.log
logmemuse=$logdir/memuse.log
lognetsession=$logdir/netsession.log
logprocess=$logdir/process.log


################################
#统计cpu的使用率信息
################################

#判断文件是否存在
if [ -f $logcpuuse ]
then
#echo "logfile is exist !"
if [ "$curdate" == "23" ]
then
date +"%D %r" >>$logcpuuse
sar -u 2 1 |grep all |head -1 >> $logcpuuse
else
sar -u 2 1 |grep all |head -1 >> $logcpuuse
fi
else
#touch $logfile

date > $logcpuuse
sar -u 2 2 | grep CPU >> $logcpuuse

fi


#...... logprocess
date +"%D %r" >> $logprocess
echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" >> $logprocess
ps aux|grep -v COMMAND |sort -n -r -k4|head -n 10  >> $logprocess
echo " --------------------" >> $logprocess 
ps aux|grep -v COMMAND |sort -n -r -k3|head -n 10  >> $logprocess
echo "===========================================" >> $logprocess 

###############################
#统计cpu的负载信息
###############################

if [ -f $logcpuload ]
then
#echo "logfile is exist !"

uptime  >> $logcpuload
else
#touch $logfile
date > $logcpuload
uptime >> $logcpuload
fi


##############################
#磁盘io的负载的信息
##############################

if [ -f $logioload ]
then
date +"%D %r" >> $logioload
iostat -xd 1 1 | sed -n '2,$p' >> $logioload

else
date +"%D %r" > $logioload
iostat -xd 1 1 | sed -n '2,$p' >> $logioload
fi


#################################
#统计网络负载的信息
################################

if [ -f $lognetworkload ]
then
date +"%D %r" >> $lognetworkload
sar -n DEV 1 3| grep eth0 >> $lognetworkload

else
date +"%D %r" > $lognetworkload
sar -n DEV 1 3|head -3 |tail -1 >> $lognetworkload
sar -n DEV 1 3| grep eth0 >> $lognetworkload
fi

###################################
#统计系统进程总数信息
###################################
if [ -f $logsysprocess ]
then
date +"%D %r" >> $logsysprocess
sysnum=`ps aux | wc -l` 
oranum=` ps -ef |awk '/ora/&&/dbticket/' |wc -l`
echo "processes of system is: $sysnum" >> $logsysprocess
else

date +"%D %r" > $logsysprocess
sysnum=`ps aux | wc -l` 
oranum=` ps -ef |awk '/ora/&&/dbticket/' |wc -l`
echo "processes of system is: $sysnum" >> $logsysprocess


fi

##############################
#统计内存的信息
##############################
if [ -f $logmemuse ]
then
date +"%D %r" >> $logmemuse
free |grep -1 Mem |head -n 2|tail -1 >> $logmemuse
free | grep Swap >> $logmemuse
else
date +"%D %r" > $logmemuse
free |grep -1 Mem |head -n 2 >> $logmemuse
free | grep Swap >> $logmemuse
fi


###############################
#查看网络连接数，tcp协议
###############################
if [ -f $lognetsession ]
then
date +"%D %r" >> $lognetsession
netstat -an | grep -E "^(tcp)" | cut -c 74- | sort | uniq -c | sort -n >> $lognetsession
else
date +"%D %r" >> $lognetsession
netstat -an | grep -E "^(tcp)" | cut -c 74- | sort | uniq -c | sort -n >> $lognetsession
fi


##############################
#定期清除统计信息
#############################

if [ "$removedate" == "01" ]
then

tail -1000 $logcpuuse > $logcpuuse_bak
tail -1000 $logcpuload > $logcpuload_bak
tail -1000 $logioload > $logioload_bak
tail -1000 $lognetworkload > $lognetworkload_bak
tail -1000 $logsysprocess > $logsysprocess_bak
tail -1000 $logmemuse >  $logmemuse_bak
tail -1000 $lognetsession > $lognetsession_bak

rm -rf $logcpuuse $logcpuload $logioload $lognetworkload $logsysprocess $logmemuse $lognetsession

fi

exit 0

[root@ticket-A sh]# vi monilog_timeswitch.sh

#!/bin/bash

###################################################
#time    : 2009/03/10
#author  :skate
#desc    :auto switch log ,keep lasted five logfile
#         the lasted logfile of order is: 04,03,02,01
#####################################################

cd /home/supertool/log

DIR=/home/supertool/log
for file in `ls $DIR |grep -v "[0-9]"`
do
echo $file
size=`ls -l $file |awk '{print $5}'`
echo $size
if [ $size -gt 100 ]
then
if [ -f "$file"_01 ]
then
if [ -f "$file"_02 ]
then
if [ -f "$file"_03 ]
then
if [ -f "$file"_04 ]
then
mv -f "$file"_02  "$file"_01
mv -f "$file"_03  "$file"_02
mv -f "$file"_04  "$file"_03
renamefile="$file"_04
else
renamefile="$file"_04
fi
else
renamefile="$file"_03
fi
else
renamefile="$file"_02
fi
else
renamefile="$file"_01
fi
mv $file $renamefile
fi

done
