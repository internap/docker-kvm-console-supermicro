#!/bin/bash	

export DIRECTORY=/opt/kvm-console/noVNC
export COMMAND="${DIRECTORY}/utils/launch.sh"

export LISTEN_PORT=8080
export VNC_URI="localhost:5900"

_novnc_main() {
	cd ${DIRECTORY} || return {?}

	if [ -f /certificate.pem ] ; then 
		echo certificate found, starting securely
		_novnc_tls
	else
		echo no certificate found, starting insecurely
		_novnc_basic
	fi
}

_novnc_basic() {
	${COMMAND} --web ${DIRECTORY} --listen ${LISTEN_PORT} --vnc ${VNC_URI}
}

_novnc_tls() {
	cat /certificate.pem /certificate-authority.pem > /tmp/combined.pem
	${COMMAND} \
		--listen ${LISTEN_PORT} \
		--vnc ${VNC_URI} \
		--cert /tmp/combined.pem \
		--key /private-key.key \
		--ssl-only \
		--web ${DIRECTORY}
}

_novnc_main ${*}
