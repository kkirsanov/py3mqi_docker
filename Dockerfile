FROM ubuntu:16.04

ENV TZ 'UTC'
ENV LD_LIBRARY_PATH=/opt/mqm/lib64/

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:jonathonf/python-3.6

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update -y \
  && apt-get install -y \
    bash \
    bc \
    rpm \
    tar \
    libxml2 \
    python3.6 \
    python3.6-dev \
    python3-pip \
    git \
    tzdata \
    openssl

RUN mkdir -p /tmp/mq
COPY ./7.5.0.8-WS-MQC-LinuxX64.tar.gz /tmp/mq

RUN cd /tmp/mq \
  && tar -zxvf /tmp/mq/7.5.0.8-WS-MQC-LinuxX64.tar.gz \
  && ./mqlicense.sh -text_only -accept \
  && rpm --prefix /opt/mqm -ivh --nodeps --force-debian MQSeriesRuntime-7.5.0-8.x86_64.rpm  \
  && rpm --prefix /opt/mqm -ivh --nodeps --force-debian MQSeriesClient-7.5.0-8.x86_64.rpm \
  && rpm --prefix /opt/mqm -ivh --nodeps --force-debian MQSeriesSDK-7.5.0-8.x86_64.rpm \
  && rm -rf /tmp/mq


# python2
# RUN python -m pip install pymqi

RUN python3.6 -m pip install py3mqi
run ln -s /opt/mqm/lib64/libmq* /lib64/