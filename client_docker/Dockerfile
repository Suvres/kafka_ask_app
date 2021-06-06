FROM ubuntu:20.04
WORKDIR /client_kafka

COPY . .

ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get upgrade -y && apt-get install -y default-jdk default-jre bc mysql-server
# CMD ["bash", "./client.sh", "ask-topic", "i=172.17.1.55", "p=29092"]
