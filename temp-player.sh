echo "Enabling Mod Probes"
sudo modprobe w1-gpio && sudo modprobe w1_therm
SENS1="$(cat /sys/bus/w1/devices/28-031097794acb/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x/1000)}' |sed 's/.\{1\}$//' | awk '{printf "%.0f\n", $1}')" #Exhaust
SENS2="$(cat /sys/bus/w1/devices/28-0310977932e1/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x/1000)}' |sed 's/.\{1\}$//' | awk '{printf "%.0f\n", $1}')" #Ambient
SENS3="$(cat /sys/bus/w1/devices/28-0309977936f5/w1_slave | sed -n 's/^.*\(t=[^ ]*\).*/\1/p' | sed 's/t=//' | awk '{x=$1}END{print(x/1000)}' |sed 's/.\{2\}$//' | awk '{printf "%.0f\n", $1}')" #Air Intake
echo    '{' > /var/www/html/SENS1
echo   '"temperature": '$SENS1 >> /var/www/html/SENS1
echo    '}' >> /var/www/html/SENS1
echo    '{' > /var/www/html/SENS2
echo   '"temperature": '$SENS2 >> /var/www/html/SENS2
echo    '}' >> /var/www/html/SENS2
echo    '{' > /var/www/html/SENS3
echo   '"temperature": '$SENS3 >> /var/www/html/SENS3
echo    '}' >> /var/www/html/SENS3
echo "" >> /home/pi/temps.log
echo "Probe Results as Follows:" >> /home/pi/temps.log
echo $SENS1 >> /home/pi/temps.log
echo $SENS2 >> /home/pi/temps.log
echo $SENS3 >> /home/pi/temps.log

if [ $SENS2 -ge 30 ]; then
	wemo -s --host 10.0.0.181 --action on
	sleep 0.2
	wemo -s --host 10.0.0.90 --action on
	FAN="Active"
else
	wemo -s --host 10.0.0.181 --action off
	sleep 0.2
	wemo -s --host 10.0.0.90 --action off
	FAN="De-Activated"
fi
echo "Fan Status:" $FAN >> /home/pi/temps.log
echo "---------------------------"  >> /home/pi/temps.log
dt=`date '+%d/%m/%Y %H:%M:%S'` >> /home/pi/temps.log
echo "Last Checked At $dt" >> /home/pi/temps.log
echo "" >> /home/pi/temps.log
