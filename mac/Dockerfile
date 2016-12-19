FROM ubuntu

# install some things
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git gcc g++ zlib1g-dev libmpc-dev libmpfr-dev libgmp-dev gzip patch sed bash tar xz-utils libssl-dev libxml2-dev tar uuid-dev clang llvm-dev wget cmake texinfo net-tools

ADD build.sh /root
COPY MacOSX10.11.sdk.tar.bz2 /root