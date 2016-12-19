FROM ubuntu

# install some things
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git autoconf libtool wget gawk mingw-w64 bzip2 zip make man2html tofrodos nsis osslsigncode

RUN ln -s fromdos /usr/bin/unix2dos && ln -s fromdos /usr/bin/dos2unix

ADD build.sh /root
ADD build.vars /root
ADD codesign.p12 /root