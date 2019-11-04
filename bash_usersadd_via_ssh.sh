#!/bin/bash 
        
if [[ $# -eq 2 ]]
then
    case $2 in 
    ("add")
        
      # while [ $Exit -eq 0 ]
       # do
        
       
        
        creatUser=;
        while [[ -z "$creatUser" ]];do

        random=$((1 + RANDOM % 41)) #от 1 до 40
        randomUser=$( cat users | sed -n "$random""p" | cut -d: -f1)
        randomPass=$( cat users | sed -n "$random""p" | cut -d: -f2)
        
        
        creatUser=$(ssh virtualubuntu1@IP "getent passwd $randomUser" && 1>/dev/null);
        
        if [[ -n "$creatUser" ]];then
        echo "User exist" && echo "user: $randomUser";
        creatUser=;
        else
        
        ssh -t -t  virtualubuntu1@IP "sudo useradd -M -N $randomUser 2>/dev/null ; echo $randomUser:$randomPass | sudo chpasswd; echo 'User - $randomUser created'"
        creatUser="user";
        break;
        fi
        
        done;

     

    ;; 
    ("remove") 
        
        ARRAY=();
        
            
        
    
        
        if [ sshpass ]; then 
     
         while IFS=":" read user pass; do
       
       sshpass -p $pass ssh -n $user@IP "echo "SUCCES"; exit;"

            if [ $(echo $?) -eq 5 ]; then #Permission denide
                echo "User don't found";
                
           else
               ARRAY+=("$user")    
           fi
            continue; 
       
        done <./users
        
        else

         sudo apt install sshpass;
     
        fi 
    ;;
    esac
else
    echo "You need one argument: 'add' or 'remove'"
fi
