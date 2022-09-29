#FROM nvidia/opencl:runtime-ubuntu18.04
FROM nvidia/cuda:11.0.3-runtime-ubuntu18.04

# expose TARGETARCH as a build arg
ARG TARGETARCH
# Env Variables for nvidia
ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=8.0"

# just creating the doc dir for fahclient and moving supplied config.xml there as a "sample"
RUN mkdir -p /usr/share/doc/fahclient/
ADD config.xml /usr/share/doc/fahclient/sample-config.xml

# Download/Install latest FAH client
# See here for latest - https://foldingathome.org/alternative-downloads/
RUN apt-get update && apt-get install -y wget
RUN if [ "$TARGETARCH" = "arm64" ]; then \
    wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-arm64/v7.6/fahclient_7.6.21_arm64.deb && \
    dpkg -i --force-depends fahclient_7.6.21_arm64.deb; \
  fi
RUN if [ "$TARGETARCH" = "amd64" ]; then \
    wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb && \
    dpkg -i --force-depends fahclient_7.6.21_amd64.deb; \
  fi
RUN rm fahclient*.deb

# Install Opencl 
RUN apt install ocl-icd-opencl-dev ocl-icd-libopencl1 -y
# nvidia-opencl-dev not available for arm64
RUN if [ "$TARGETARCH" = "amd64" ]; then \
    apt install nvidia-opencl-dev -y; \
  fi

# To keep down the size of the image, clean out that cache when finished installing packages.
RUN apt-get clean -y && apt-get autoclean -y && rm -rf /var/lib/apt/lists/* && apt-get autoremove -y

# EXPOSE 7396 36396

ADD config.xml /etc/fahclient/config.xml

WORKDIR /var/lib/fahclient
CMD	["/usr/bin/FAHClient", \
	"--config", "/etc/fahclient/config.xml", \
	"--config-rotate=false", \
	"--pid-file=/var/run/fahclient.pid"]
