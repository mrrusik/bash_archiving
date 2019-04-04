#!/bin/bash
USERS=$(cat /etc/passwd | sed 's/\(^[a-zA-Z0-9]*\).*/\1/g' | tr '\n' ' ') ;
countUSERS=$(wc -l /etc/passwd | grep -o '[0-9]*');
x=0 #Заглушка. проверка наличие юзера

if (($# ==  1 ||  $# == 2)) 
then
	if (($# == 1))
	then 
	for (( index=1; index <= $countUSERS; index++))
	do
        word=$(cat /etc/passwd | sed 's/\(^[a-zA-Z0-9]*\).*/\1/g' | tr '\n' ' ' | cut -d " " -f $index) 
		if [ "$1" == "$word" ];then
     		x=1 #user exist  
		
		cat config | while read line; do
 		line=$(echo  $line | sed 's/ *//g')
		
		IFS=:
		for i in  $line ; do
		folder=$(echo "$i" | cut -c 2- 2>/dev/null | tr -d '\n') 
	
		date=$( date +"_%d_%m_%y-%H_%M_%S" )
		
			if [[ $(find /$folder/ -type f -user $1 2>/dev/null;) ]];then 	
				mkdir -p "$1_$folder";
				sudo find /$folder/ -type f -user $1 -exec cp -rp {} "$1_$folder"/ 2>/dev/null \;
				tar -czf "$1_$folder$date.tgz" "$1_$folder"/;
				echo -e "\n$folder.tgz contain this files:\n";
				tar -ztvf "$1_$folder$date.tgz"; rm -rf "$1_$folder" 2>/dev/null ;
			else
				continue
			fi      			
		done
		done 
   		fi
	done
		
		if [ "${x}" == 0 ] && [ "$1" != "$word" ]; then 
	        	echo "User $1 don't exist"
			x=0 
			exit 2;
                fi

       
	elif (($# == 2 ))
	then
			
if [[ "$2" =~ ([0-9]*minutes|hours|days) ]];then
			
if [[ "$2" =~ [0-9]*hours ]];then
			
minutes=$( echo $2 | grep -o '[0-9]*' )
minutes=$(($minutes * 60))
			


elif [[ "$2" =~ [0-9]*days ]];then
 
minutes=$( echo $2 | grep -o '[0-9]*' )
minutes=$(($minutes * 1440)) #minutes in day
                        
else 
			
minutes=$( echo $2 | grep -o '[0-9]*' )			
fi
			
for (( index=1; index <= $countUSERS; index++))
do
word=$(cat /etc/passwd | sed 's/\(^[a-zA-Z0-9]*\).*/\1/g' | tr '\n' ' ' | cut -d " " -f $index) 
if [ "$1" == "$word" ];then
x=1 #user founded        
cat config | while read line; do
line=$(echo  $line | sed 's/ *//g')
			
IFS=:
for i in $line; do	
folder=$(echo "$i" | cut -c 2- 2>/dev/null | tr -d '\n' | tr -d '^') 
			
date=$( date +"_%d_%m_%y-%H_%M_%S" )
                
if [[ $(find /$folder/ -type f -user $1 -amin "-$minutes" 2>/dev/null;) ]];then 	
mkdir -p "$1_$folder";
sudo find /$folder/ -type f -user $1 -amin "-$minutes" -exec cp -rp {} "$1_$folder"/ 2>/dev/null \; 
tar -czf "$1_$folder$date.tgz" "$1_$folder"/ 
echo -e "\n$folder.tgz contain this files:\n" ;
tar -ztvf "$1_$folder$date.tgz" 2>/dev/null; 
rm -rf "$1_$folder"
else
continue
fi
done 
done
fi
done
		
if [ "${x}" == 0 ] && [ "$1" != "$word" ]; then
echo "User $1 don't exist"
x=0 
exit 2;
fi
       
						

else
echo "Invalid period prefix"
fi
fi
else 
echo -e "\nUsage: ${0##*/} username period
username: required
period: optional with prefix minutes,hours,days
for example: ${0##*/} petya 4hours\n";
exit 2;
fi



