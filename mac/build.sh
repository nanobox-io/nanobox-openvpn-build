#!/bin/bash

cd ~
mkdir src
cd ~/src
git clone https://github.com/tpoechtrager/osxcross.git
cp ~/MacOSX10.11.sdk.tar.bz2 ~/src/osxcross/tarballs/MacOSX10.11.sdk.tar.bz2
cd osxcross
tools/get_dependencies.sh
SDK_VERSION=10.11 UNATTENDED=1 ./build.sh
./build_gcc.sh
./build_binutils.sh
export PATH=$PATH:/root/src/osxcross/target/bin:/root/src/osxcross/target/binutils/bin
cd ~
mkdir build

cd ~/src
wget https://www.openssl.org/source/openssl-1.0.2j.tar.gz
tar -xzf openssl-1.0.2j.tar.gz
cd openssl-1.0.2j
./Configure no-dso --prefix=/root/build darwin64-x86_64-cc
make -j 8 CC=x86_64-apple-darwin15-gcc AR="x86_64-apple-darwin15-ar cr" RANLIB=x86_64-apple-darwin15-ranlib
x86_64-apple-darwin15-ranlib libssl.a
x86_64-apple-darwin15-ranlib libcrypto.a
make install CC=x86_64-apple-darwin15-gcc AR="x86_64-apple-darwin15-ar cr" RANLIB=x86_64-apple-darwin15-ranlib

cd ~/src
wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz
tar -xzf lzo-2.09.tar.gz
cd lzo-2.09
CC=x86_64-apple-darwin15-gcc AR=x86_64-apple-darwin15-ar RANLIB=x86_64-apple-darwin15-ranlib ./configure --host=x86_64-apple-darwin15 --prefix=/root/build CFLAGS="-fPIC -O3"
make -j 8
make install

cd ~/src
wget https://swupdate.openvpn.org/community/releases/openvpn-2.3.14.tar.gz
tar -xzf openvpn-2.3.14.tar.gz
cd openvpn-2.3.14
CC=x86_64-apple-darwin15-cc AR=x86_64-apple-darwin15-ar RANLIB=x86_64-apple-darwin15-ranlib ./configure --host=x86_64-apple-darwin15 --enable-shared=no --disable-plugins --disable-plugin-down-root --prefix=/root/build --disable-plugin-auth-pam CPPFLAGS='-I/root/build/include -I/root/build/include/openssl -I/root/src/osxcross/target/SDK/MacOSX10.11.sdk/usr/include -D__APPLE_USE_RFC_3542' LDFLAGS='-L/root/build/lib'
make -j 8
