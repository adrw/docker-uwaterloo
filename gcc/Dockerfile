# By Andrew Paradi | Source at https://github.com/andrewparadi/docker-uwaterloo 
FROM ubuntu:16.04
LABEL Andrew Paradi <me@andrewparadi.com>
LABEL Tag: gcc

ARG	DEBIAN_FRONTEND=noninteractive

RUN	apt-get update && \
	apt-get install apt-utils -y && \
	apt-get install build-essential -y && \
	apt-get install tmux -y && \
	apt-get install wget -y && \
	apt-get clean && \
	rm -rf /var/log
RUN	echo 'set-option -g mouse on' > ~/.tmux.conf
