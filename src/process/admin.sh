function GetPID #User #Name
 {
 PsUser=$1
 PsName=$2
 pid=`ps -u $PsUser|grep $PsName|grep -v grep|grep -v vi|grep -v dbx\n
 |grep -v tail|grep -v start|grep -v stop |sed -n 1p |awk '{print $1}'`
 echo $pid
 }

function GetCpu
 {
 CpuValue=`ps -p $1 -o pcpu |grep -v CPU | awk '{print $1}' | awk - F. '{print $1}'`
 echo $CpuValue
 }

function GetMem
 {
 MEMUsage=`ps -o vsz -p $1|grep -v VSZ`
 (( MEMUsage /= 1000))
 echo $MEMUsage
 }

function GetDes
 {
 DES=`ls /proc/$1/fd | wc -l`
 echo $DES
 }

function Listening
 {
 TCPListeningnum=`netstat -an | grep ":$1 " | \n
 awk '$1 == "tcp" && $NF == "LISTEN" {print $0}' | wc -l`
 UDPListeningnum=`netstat -an|grep ":$1 " \n
 |awk '$1 == "udp" && $NF == "0.0.0.0:*" {print $0}' | wc -l`
 (( Listeningnum = TCPListeningnum + UDPListeningnum ))
 if [ $Listeningnum == 0 ]
 then
 {
 echo "0"
 }
 else
 {
 echo "1"
 }
 fi
 }

function GetSysCPU
 {
 CpuIdle=`vmstat 1 5 |sed -n '3,$p' \n
 |awk '{x = x + $15} END {print x/5}' |awk -F. '{print $1}'
 CpuNum=`echo "100-$CpuIdle" | bc`
 echo $CpuNum
 }

function GetDiskSpc
 {
 if [ $# -ne 1 ]
 then
 return 1
 fi
Folder="$1$"
 DiskSpace=`df -k |grep $Folder |awk '{print $5}' |awk -F% '{print $1}'
 echo $DiskSpace
 }

 
