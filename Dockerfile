# FROM ubuntu:latest
FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt install wget -y

# Download/Install latest FAH client
# See here for latest - https://foldingathome.org/alternative-downloads/
RUN wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.5/fahclient_7.5.1_amd64.deb
RUN dpkg -i --force-depends fahclient_7.5.1_amd64.deb

# EXPOSE 7396 36396

ADD config.xml /etc/fahclient/config.xml

WORKDIR /var/lib/fahclient
CMD	["/usr/bin/FAHClient", \
	"--config", "/etc/fahclient/config.xml", \
	"--config-rotate=false", \
	"--gpu=true", \
	# "--run-as", "fahclient", \
	"--pid-file=/var/run/fahclient.pid"]