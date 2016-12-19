SHELL := /bin/bash

.PHONY: default clean linux-env mac-env windows-env publish

default: dist/darwin/openvpn dist/linux/openvpn dist/windows/openvpn.exe
	@true

clean: clean-linux clean-mac clean-windows
	@true

linux-env:
	if [[ ! $$(docker images nanobox/build-openvpn-linux) =~ "nanobox/build-openvpn-linux" ]]; then \
		docker build --no-cache -t nanobox/build-openvpn-linux -f linux/Dockerfile linux; \
	fi

mac-env: mac/MacOSX10.11.sdk.tar.bz2
	if [[ ! $$(docker images nanobox/build-openvpn-mac) =~ "nanobox/build-openvpn-mac" ]]; then \
		docker build --no-cache -t nanobox/build-openvpn-mac -f mac/Dockerfile mac; \
	fi

windows-env: windows/codesign.p12
	if [[ ! $$(docker images nanobox/build-openvpn-windows) =~ "nanobox/build-openvpn-windows" ]]; then \
		docker build --no-cache -t nanobox/build-openvpn-windows -f windows/Dockerfile windows; \
	fi

windows/codesign.p12: certs
	openssl pkcs12 -export -nodes -out windows/codesign.p12 -inkey certs/win/codesign.key -in certs/win/codesign.crt -passout pass:

mac/MacOSX10.11.sdk.tar.bz2:
	aws s3 cp \
		s3://private.nanobox.io/sdk/MacOSX10.11.sdk.tar.bz2 \
		mac/MacOSX10.11.sdk.tar.bz2 \
		--region us-west-2

linux-container: linux-env
	if [[ ! $$(docker ps -a) =~ "build-linux" ]]; then \
		docker run -d --name build-linux nanobox/build-openvpn-linux sleep 365d; \
	else \
		if [[ ! $$(docker ps) =~ "build-linux" ]]; then \
			docker start build-linux; \
		fi \
	fi

mac-container: mac-env
	if [[ ! $$(docker ps -a) =~ "build-mac" ]]; then \
		docker run -d --name build-mac nanobox/build-openvpn-mac sleep 365d; \
	else \
		if [[ ! $$(docker ps) =~ "build-mac" ]]; then \
			docker start build-mac; \
		fi \
	fi

windows-container: windows-env
	if [[ ! $$(docker ps -a) =~ "build-windows" ]]; then \
		docker run -d --name build-windows nanobox/build-openvpn-windows sleep 365d; \
	else \
		if [[ ! $$(docker ps) =~ "build-windows" ]]; then \
			docker start build-windows; \
		fi \
	fi

dist/darwin/openvpn: mac-container
	mkdir -p dist/darwin
	docker exec -it build-mac /root/build.sh
	docker cp build-mac:/root/src/openvpn-2.3.14/src/openvpn/openvpn dist/darwin/openvpn

dist/linux/openvpn: linux-container
	mkdir -p dist/linux
	docker exec -it build-linux /root/build.sh
	docker cp build-linux:/root/src/openvpn-2.3.14/src/openvpn/openvpn dist/linux/openvpn

dist/windows/openvpn.exe: windows-container
	mkdir -p dist/windows
	docker exec -it build-windows /root/build.sh
	docker cp build-windows:/root/src/openvpn-build/windows-nsis/tmp/build-x86_64/openvpn-2.3.14/src/openvpn/.libs/openvpn.exe dist/windows/openvpn.exe

clean-linux:
	if [[ $$(docker ps) =~ "build-linux" ]]; then \
		docker stop build-linux; \
	fi
	if [[ $$(docker ps -a) =~ "build-linux" ]]; then \
		docker rm build-linux; \
	fi

clean-mac:
	if [[ $$(docker ps) =~ "build-mac" ]]; then \
		docker stop build-mac; \
	fi
	if [[ $$(docker ps -a) =~ "build-mac" ]]; then \
		docker rm build-mac; \
	fi

clean-windows:
	if [[ $$(docker ps) =~ "build-windows" ]]; then \
		docker stop build-windows; \
	fi
	if [[ $$(docker ps -a) =~ "build-windows" ]]; then \
		docker rm build-windows; \
	fi

certs:
	mkdir -p certs
	aws s3 sync \
		s3://private.nanobox.io/certs \
		certs/ \
		--region us-west-2

publish:
	aws s3 sync \
		dist/ \
		s3://tools.nanobox.io/openvpn \
		--grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers \
		--region us-east-1
