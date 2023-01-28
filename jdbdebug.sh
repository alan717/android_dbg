
if [ -z "$1" ]
then
	v=$(cat .default_packagename)
	set -- $v
else
	echo $1> .default_packagename
	echo "$1" >>.history_package
fi	
adb shell am start -D -n $1 #com.devgame66.csshot/com.unity3d.player.UnityPlayerActivity 
str=$1
array=(${str//\// })
#for var in ${array[@]}
#do 
#	echo $var
#done
echo "包名:"${array[0]}
adb shell ps -ef |grep ${array[0]}


str=$(adb shell ps |grep ${array[0]} |awk '{print "包pid===>> "$2" !"}')
echo $str
pid=$(echo $str|awk '{print $2}')
#sleep 1
adb forward tcp:8600 jdwp:$pid
#sleep 2
echo "gdb or only jdb"
read n 
echo $n
if [ -z "$n" ]
then
	echo "just and inject so ,and run jdb"
	#adb shell su -c "/data/local/tmp/inject /data/local/tmp/libdick.so $pid"
	#adb forward tcp:12345 tcp:12345
	#adb shell su -c "pkill gdbserver"
	#adb shell su -c "/data/local/tmp/gdbserver :12345 --attach ${pid}" &
else

	adb forward tcp:12345 tcp:12345
	adb shell su -c "pkill gdbserver"
	adb shell su -c "/data/local/tmp/gdbserver :12345 --attach ${pid}" &
fi
echo "{*}ready for jdb debug?"
read m
echo $m
echo "i am going to jdb debug!!!"
# add -dbgtrace to find more info.
jdb  -connect com.sun.jdi.SocketAttach:hostname=localhost,port=8600<<ECIX
exit
ECIX
