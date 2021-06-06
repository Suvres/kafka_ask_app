FROM ubuntu:20.04
WORKDIR /server_kafka

COPY . .

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \	
		default-jdk \
		default-jre
# CMD ["bash", "./server.sh", "ask-topic", "i=172.17.1.55", "p=29092"]
