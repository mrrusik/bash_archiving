#!/bin/bash
USERS=$(sed 's/\(^[a-zA-Z0-9]*\).*/\1/g' /etc/passwd | tr '\n' ' ')
countUSERS=$(wc -l < /etc/passwd)
x=0 #Заглушка. проверка наличие юзера

if (($# ==  1 ||  $# == 2))
then
	if (($# == 1))
	then
		for (( index=1; index <= $countUSERS; index++))
		do
			word=$(sed 's/\(^[a-zA-Z0-9]*\).*/\1/g' /etc/passwd | tr '\n' ' ' | cut -d " " -f $index)

			if [ "$1" == "$word" ]
			then
				x=1 #user exist

				while read line
				do
					line=$(sed 's/ *//g' <<< "$line")

					IFS=:
					for i in $line
					do
						folder=$(cut -c 2- 2>/dev/null <<< "$i" | tr -d '\n')
						printf -v date "%(_%d_%m_%y-%H_%M_%S)T" -1

						if [[ $(find /$folder/ -type f -user $1 2>/dev/null) ]]
						then
							mkdir -p "$1_$folder"
							sudo find /$folder/ -type f -user $1 -exec cp -rp {} "$1_$folder"/ 2>/dev/null \;
							tar -czf "$1_$folder$date.tgz" "$1_$folder"/
							echo -e "\n$folder.tgz contain this files:\n"
							tar -ztvf "$1_$folder$date.tgz"
							rm -rf "$1_$folder" 2>/dev/null
						else
							continue
						fi
					done
				done < config
			fi
		done

		if [ "${x}" == 0 ] && [ "$1" != "$word" ]
		then
			echo "User $1 don't exist"
			x=0
			exit 2
		fi
	elif (($# == 2 ))
	then
		if [[ "$2" =~ ([0-9]*minutes|hours|days) ]]
		then
			if [[ "$2" =~ [0-9]*hours ]]
			then
				minutes=$(grep -o '[0-9]*' <<< "$2")
				minutes=$(($minutes * 60))
			elif [[ "$2" =~ [0-9]*days ]]
			then
				minutes=$(grep -o '[0-9]*' <<< "$2")
				minutes=$(($minutes * 1440)) #minutes in day
			else
				minutes=$(grep -o '[0-9]*' <<< "$2")
			fi

			for (( index=1; index <= $countUSERS; index++))
			do
				word=$(sed 's/\(^[a-zA-Z0-9]*\).*/\1/g' /etc/passwd | tr '\n' ' ' | cut -d " " -f $index)

				if [ "$1" == "$word" ]
				then
					x=1 #user founded
					while read line
					do
						line=$(sed 's/ *//g' <<< "$line")

						IFS=:
						for i in $line
						do
							folder=$(cut -c 2- 2>/dev/null <<< "$i" | tr -d '\n^')
							printf -v date "%(_%d_%m_%y-%H_%M_%S)T" -1

							if [[ $(find /$folder/ -type f -user $1 -amin "-$minutes" 2>/dev/null) ]]
							then
								mkdir -p "$1_$folder"
								sudo find /$folder/ -type f -user $1 -amin "-$minutes" -exec cp -rp {} "$1_$folder"/ 2>/dev/null \;
								tar -czf "$1_$folder$date.tgz" "$1_$folder"/
								echo -e "\n$folder.tgz contain this files:\n"
								tar -ztvf "$1_$folder$date.tgz" 2>/dev/null
								rm -rf "$1_$folder"
							else
								continue
							fi
						done
					done < config
				fi
			done

			if [ "${x}" == 0 ] && [ "$1" != "$word" ]
			then
				echo "User $1 don't exist"
				x=0
				exit 2
			fi
		else
			echo "Invalid period prefix"
		fi
	fi
else
	cat <<-EOF

		Usage: ${0##*/} username period
		username: required
		period: optional with prefix minutes,hours,days
		for example: ${0##*/} petya 4hours
		username: required

	EOF

	exit 2
fi



