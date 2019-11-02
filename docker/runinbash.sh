#!/bin/bash  

#log=/var/log/dollars
number=60
echo "Write to log..." 
#if [ ! -f $log ]; then 
#  sudo touch /var/log/dollars;
#  sudo chmod o+rw /var/log/dollars;
#fi

while :
do

if [ $number -gt 0 ]; then

day=$(date +%d.%m.%Y --date="$number days ago")

uah=$(curl -s  "https://api.privatbank.ua/p24api/exchange_rates?json&date=$day" | jq . | grep -A1 'USD' | tail -n -1 | awk '{print $NF}' | cut -c -5)


echo "$(date +%d-%m-%Y --date="$number days ago") 1usd = "$uah"uah" > /dev/stdout ;


((number--));

sleep 1;
else

   break;

fi

done
