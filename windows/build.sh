#!/bin/bash

cd ~
mkdir src

cd ~/src
git clone https://github.com/OpenVPN/openvpn-build.git
cp ~/build.vars ~/src/openvpn-build/generic/build.vars
cd openvpn-build/windows-nsis
./build-complete --sign --sign-pkcs12=/root/codesign.p12 --sign-timestamp="http://timestamp.verisign.com/scripts/timstamp.dll"

cd ~/src/openvpn-build/windows-nsis/tmp/build-x86_64/openvpn-2.3.14/src/openvpn/
x86_64-w64-mingw32-gcc \
  -I/root/src/openvpn-build/windows-nsis/tmp/image-x86_64/openvpn/include \
  -municode \
  -UUNICODE \
  -std=gnu89 \
  -o \
  .libs/openvpn.exe \
  base64.o \
  buffer.o \
  clinat.o \
  crypto.o \
  crypto_openssl.o \
  crypto_polarssl.o \
  dhcp.o \
  error.o \
  event.o \
  fdmisc.o \
  forward.o \
  fragment.o \
  gremlin.o \
  helper.o \
  httpdigest.o \
  lladdr.o \
  init.o \
  interval.o \
  list.o \
  lzo.o \
  manage.o \
  mbuf.o \
  misc.o \
  platform.o \
  console.o \
  mroute.o \
  mss.o \
  mstats.o \
  mtcp.o \
  mtu.o \
  mudp.o \
  multi.o \
  ntlm.o \
  occ.o \
  pkcs11.o \
  pkcs11_openssl.o \
  pkcs11_polarssl.o \
  openvpn.o \
  options.o \
  otime.o \
  packet_id.o \
  perf.o \
  pf.o \
  ping.o \
  plugin.o \
  pool.o \
  proto.o \
  proxy.o \
  ps.o \
  push.o \
  reliable.o \
  route.o \
  schedule.o \
  session_id.o \
  shaper.o \
  sig.o \
  socket.o \
  socks.o \
  ssl.o \
  ssl_openssl.o \
  ssl_polarssl.o \
  ssl_verify.o \
  ssl_verify_openssl.o \
  ssl_verify_polarssl.o \
  status.o \
  tun.o \
  win32.o \
  cryptoapi.o \
  openvpn_win32_resources.o \
  ../../src/compat/.libs/libcompat.a \
  -L/root/src/openvpn-build/windows-nsis/tmp/image-x86_64/openvpn/lib \
  /root/src/openvpn-build/windows-nsis/tmp/image-x86_64/openvpn/lib/liblzo2.a \
  /root/src/openvpn-build/windows-nsis/tmp/image-x86_64/openvpn/lib/libpkcs11-helper.a \
  /root/src/openvpn-build/windows-nsis/tmp/image-x86_64/openvpn/lib/libssl.a \
  /root/src/openvpn-build/windows-nsis/tmp/image-x86_64/openvpn/lib/libcrypto.a \
  -lgdi32 \
  -lws2_32 \
  -lwininet \
  -lcrypt32 \
  -liphlpapi \
  -lrpcrt4 \
  -lwinmm \
  -L/root/src/openvpn-build/windows-nsis/tmp/image-x86_64/openvpn/lib


# ~/src/openvpn-build/windows-nsis/tmp/build-x86_64/openvpn-2.3.14/src/openvpn/.libs/openvpn.exe