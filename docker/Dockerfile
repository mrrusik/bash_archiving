FROM ubuntu:18.04
#version
RUN apt-get update && apt-get install -y \
    software-properties-common \
    jq \
    curl \
    vim \
    rsyslog \
    inetutils-ping 


ADD runinbash.sh /root/runinbash.sh
WORKDIR /root/
RUN ln -sf /dev/stdout /var/log/docker.log \
	&& ln -sf /dev/stderr /var/log/dockererr.log
CMD ["/bin/bash", "./runinbash.sh"]



#ENTRYPOINT  /bin/bash &&  while true; do if [ $number -gt 0 ]; then day=$(date +%d.%m.%Y --date="$number days ago"); uah=$(curl -s  "https://api.privatbank.ua/p24api/exchange_rates?json&date=$day" | jq . | grep -A1 'USD' | tail -n -1 | awk '{print     $NF}' | cut -c -5); echo "$(date +%d-%m-%Y --date="$number days ago") 1usd = $uah""uah" | logger -n 172.16.15.110; number=$(($number-1)); sleep 1; else break; fi; done  
#exemple ENTRYPOINT service nginx start && service ssh start && /bin/bash "use && to separate your code"


