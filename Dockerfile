# By Andrew Paradi | Source at https://github.com/andrewparadi/docker-uwaterloo
FROM ubuntu:16.04
LABEL Andrew Paradi <me@andrewparadi.com>

RUN apt-get update && \
	apt-get install build-essential -y && \
	apt-get install tmux -y && \
	apt-get install wget -y
