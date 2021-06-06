#!/bin/bash

# ------------------------
# Help
# ------------------------

help() {
	echo -e "\nSAMPLE: bash ./server.sh [TOPIC] p=80 i=127.0.0.1\n"
	echo -e " h        show this message"
	echo -e " p=<port> set port number"
	echo -e " i=<ip>   set ip address\n"
} 

# ------------------------
# Config
# ------------------------

server_ip=127.0.0.1
server_port=9092


echo -e "\033[34;44m                               \033[0m"
echo -e "\033[34;44m           \033[0;44mPublisher\033[34;44m           \033[0m"
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
	esac
done

echo -e "\n\033[33m > \033[m Adres: \033[33m${server_ip}\033[m:\033[33m${server_port}\033[m\n"

server="--bootstrap-server $server_ip:$server_port"
# =================================================
# Topics
# =================================================

echo -e " [\033[32m*\033[m] Sprawdzanie tematów"
topics=$(sh ./kafka/bin/kafka-topics.sh --list ${server})

topic=$1
tp_is=0

topics=( "$topics" )

for topic_tmp in ${topics[@]} 
do
	if [ "$topic_tmp" = "$topic" ]; then
		tp_is=1
		break	
	fi
done

if [ $tp_is -eq 0 ]; then
	read -p " Brakuje Tematu o podanej nazwie: \"${topic}\", czy utworzyć nowy? [y/n] > " add_topic
	
	if [ "$add_topic" = "y" ]; then
		$(sh ./kafka/bin/kafka-topics.sh --create --topic ${topic} ${server})
		echo -e " [\033[32m*\033[m] Dodanie tematu \033[33m${topic}\033[m"	
	else
		echo -e " [\033[31mx\033[m] Nie utworzono tematu. Zakończenie działania"
		exit
	fi
	
fi

# =================================================
# Sending
# =================================================

count=1

echo -e " [\033[32m*\033[m] Wysyłanie wiadomości do ${server_ip}:${server_port}"

while true
do 
	date_mes=$(date +"%Y-%m-%d %H:%M:%S")
	rand_mes=$[$RANDOM % 1000000 + 1000 ]
	count_mes=$(echo "${count} " | cut -c1-2)

	$(echo ${rand_mes}|kafka/bin/kafka-console-producer.sh --topic ${topic} ${server})
	echo -e " [${count_mes}] [\033[33m${date_mes}\033[m] [\033[32m${topic}\033[m] SENDING: ${rand_mes}"
	
	count=$(( $count + 1))
	[ $count -gt 10 ] && count=1
	sleep 1
done



