#!/bin/bash

cd ~
mkdir build
mkdir src

cd ~/src
wget http://ftp.gnu.org/gnu/glibc/glibc-2.24.tar.gz
tar -xzf glibc-2.24.tar.gz
cd glibc-2.24
mkdir build
cd build
../configure --prefix=/root/build --enable-lock-elision=yes --enable-static-nss --disable-nscd CFLAGS="-fPIC -static -O3"
make -j 8
make install

cd ~/src
wget https://www.openssl.org/source/openssl-1.0.2j.tar.gz
tar -xzf openssl-1.0.2j.tar.gz
cd openssl-1.0.2j
./Configure no-dso --prefix=/root/build no-shared -fPIC linux-x86_64
make -j 8
make install

cd ~/src
wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz
tar -xzf lzo-2.09.tar.gz
cd lzo-2.09
./configure --prefix=/root/build CFLAGS="-fPIC -static -O3"
make -j 8
make install

cd ~/src
wget https://swupdate.openvpn.org/community/releases/openvpn-2.3.14.tar.gz
tar -xzf openvpn-2.3.14.tar.gz
cd openvpn-2.3.14
./configure --enable-shared=no --enable-iproute2 --disable-plugins --disable-plugin-down-root --prefix=/root/build --disable-plugin-auth-pam CFLAGS='-static' CPPFLAGS='-I/root/build/include -I/root/build/include/openssl' LDFLAGS='-L/root/build/lib' LIBS='/root/build/lib/libc.a /root/build/lib/libnsl.a /root/build/lib/libdl.a /root/build/lib/libpthread.a'
make -j 8
cd src/openvpn
gcc -static -std=gnu89 -o openvpn base64.o buffer.o clinat.o crypto.o crypto_openssl.o crypto_polarssl.o dhcp.o error.o event.o fdmisc.o forward.o fragment.o gremlin.o helper.o httpdigest.o lladdr.o init.o interval.o list.o lzo.o manage.o mbuf.o misc.o platform.o console.o mroute.o mss.o mstats.o mtcp.o mtu.o mudp.o multi.o ntlm.o occ.o pkcs11.o pkcs11_openssl.o pkcs11_polarssl.o openvpn.o options.o otime.o packet_id.o perf.o pf.o ping.o plugin.o pool.o proto.o proxy.o ps.o push.o reliable.o route.o schedule.o session_id.o shaper.o sig.o socket.o socks.o ssl.o ssl_openssl.o ssl_polarssl.o ssl_verify.o ssl_verify_openssl.o ssl_verify_polarssl.o status.o tun.o win32.o cryptoapi.o  -L/root/build/lib ../../src/compat/.libs/libcompat.a -lnsl -lresolv /root/build/lib/liblzo2.a -lssl -lcrypto /root/build/lib/libc.a /root/build/lib/libnsl.a /root/build/lib/libdl.a /root/build/lib/libpthread.a
