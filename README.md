# Projekt: Apache Kafka

Projekt składa się z 2 aplikacji klienta i serwera, każdy z nich jest napisany w bashu. do poprawnego działania, należy stworzyć sieć:

```sh

 docker network create --subnet=172.17.1.0/24 --ip-range=172.17.1.2/24 kafka

```

a także zbudować poszczególne obrazy i skonfigurować `docker-compose.yml`, dla odpowiednich obrazów. U mnie to odpowiednie:

 - kafka-client:dev - ./client_docker
 - kafka-server:dev - ./server_docker
 - kafka-db:dev - ./db_docker

---

Oba skrypty zawierają kilka parametrów:  
./client.sh
 - [TOPIC] -  nazwa tematu z którego odbieramy dane z kafki
 - i=[ip_addr] - adres ip kafki
 - p=[port] - port kafki
 - m=[ip_addr] - adres ip serwera mysql  
Przykład: ./client.sh ask-topic i=172.17.1.55 m=172.17.1.54
  
---
  
./server.sh
 - [TOPIC] - temat na jaki wysyłamy wiadomość do kafki
 - i=[ip_addr] - adres ip kafki
 - p=[port] - port kafki  
Przykład: ./server.sh ask-topic i=172.17.1.55

---

należy ręcznie uruchomić podane skrypty, gdyż bez działającej kafki, program nie będzie działał. Można to zrobić poprzez
```sh

docker exec -it <obraz> bash

```
Domyślne polecenie uruchamiające klienta w obrazie  
```sh

./client.sh ask-topic i=172.17.1.55 m=172.17.1.54

```

Domyślne polecenie uruchamiające serwer w obrazie  
```sh

./client.sh ask-topic i=172.17.1.55

```
