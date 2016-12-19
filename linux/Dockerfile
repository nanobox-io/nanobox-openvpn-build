FROM ubuntu

# install some things
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git autoconf libtool net-tools iproute2 wget gawk build-essential

ADD build.sh /root