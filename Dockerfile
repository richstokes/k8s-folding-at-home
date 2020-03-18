# FROM ubuntu:latest
FROM nvidia/opencl:runtime-ubuntu18.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt upgrade -y
RUN apt install wget -y

# just creating the doc dir for fahclient and moving supplied config.xml there as a "sample"
RUN mkdir -p /usr/share/doc/fahclient/
ADD config.xml /usr/share/doc/fahclient/sample-config.xml

# Download/Install latest FAH client
# See here for latest - https://foldingathome.org/alternative-downloads/
RUN apt-get update && \
  wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.5/fahclient_7.5.1_amd64.deb && \
  dpkg -i --force-depends fahclient_7.5.1_amd64.deb && \
  rm fahclient*.deb && \
  apt-get autoremove -y && \
  apt install ocl-icd-opencl-dev -y

# EXPOSE 7396 36396

ADD config.xml /etc/fahclient/config.xml

WORKDIR /var/lib/fahclient
CMD	["/usr/bin/FAHClient", \
	"--config", "/etc/fahclient/config.xml", \
	"--config-rotate=false", \
	"--gpu=true", \
	# "--run-as", "fahclient", \
	"--pid-file=/var/run/fahclient.pid"]
