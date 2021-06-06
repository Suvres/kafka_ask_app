#!/bin/bash

# ------------------------
# Help
# ------------------------

help() {
	echo -e "\nSAMPLE: sh ./client.sh [TOPIC] p=80 i=127.0.0.1\n"
	echo -e " h        show this message"
	echo -e " p=<port> set port number"
	echo -e " i=<ip>   set ip address\n"
	echo -e " m=<ip>   set mysql ip address\n"
} 

# ------------------------
# Config
# ------------------------

server_ip=127.0.0.1
server_port=9092
mysql_ip=127.0.0.1

echo -e "\033[34;44m                               \033[0m"
echo -e "\033[34;44m           \033[0;44mSubscriber\033[34;44m          \033[0m"
echo -e "\033[34;44m                               \033[m"


if [ $# -lt 1 ]; then
	help
	exit
fi

args=("$@")
unset args[0]

for arg in ${args[@]}
do

	arg_tmp=$(echo ${arg} | cut -c1-1 )
	arg_val=$(echo "${arg}"|cut -c3-)
	case $arg_tmp in
		h)
			help
			exit
			;;
		p)
			server_port=$arg_val
			;;
		i)
			server_ip=$arg_val
			;;
		m)
			mysql_ip=$arg_val
			;;
	esac
done

echo -e "\n\033[33m > \033[m Adres: \033[33m${server_ip}\033[m:\033[33m${server_port}\033[m mysql: \033[33m${mysql_ip}\033[m:\033[33m3306\033[m\n"

server="--bootstrap-server $server_ip:$server_port"
mysql="mysql --host=$mysql_ip -ukafkadb -pkafkadb -Dkafkadb -e"
topic=$1

count=1
avg=0

echo -e " [\033[32m*\033[m] Czyszczenie starych pomiarów"
$(${mysql} "DELETE FROM pomiary" &> /dev/null)

while read line;
do
	avg=$(echo "$line + $avg"|bc)
	count=$(($count + 1))
	if [ $count -eq 11 ]; then
		date_mes=$(date +"%Y-%m-%d %H:%M:%S")
		avg_mes=$(echo "scale=2; $avg / 10.0"|bc)
		echo -e "[\033[33m${date_mes}\033[m] Nowa średnia to: ${avg_mes}"
		$(${mysql} "INSERT INTO pomiary(id, date_at, average) VALUES (NULL, \"$(date +"%Y-%m-%d %H:%M:%S.%N")\", $(echo "${avg_mes}"|bc))" &> /dev/null)
		count=1
	fi
done < <(./kafka/bin/kafka-console-consumer.sh --topic ${topic} --from-beginning ${server})




