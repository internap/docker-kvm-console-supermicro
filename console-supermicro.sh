#!/bin/bash

# Copyright 2016 Internap.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	 http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

_console_supermicro() {
	if [ 0 = ${#} ] || [ 3 -lt ${#} ] ; then
		echo 'usage: console-supermicro.sh <host> [username] [password]'
		return 
	fi
	docker build -t internap/kvm-console-supermicro $(dirname ${0})

	id=$(docker run -P -d \
	-e IPMI_ADDRESS=${1} \
	-e IPMI_USERNAME=${2-ADMIN} \
	-e IPMI_PASSWORD=${3-ADMIN} \
	internap/kvm-console-supermicro)
	if [ "" = "${id}" ] ; then
		echo could not get containter id:
		docker ps | grep internap/kvm-console-supermicro
		return 1
	fi

	sleep 2

	local port=$( docker port $id | sed 's,.*:,,' )
	echo -----------------------------------------------------------------------------
	# TODO: add password for vnc... (&password=xxx)
	echo "http://localhost:${port}/vnc.html?host=localhost&port=${port}&autoconnect=true"
	echo -----------------------------------------------------------------------------

	echo hit enter to end me
	read

	docker rm --force ${id}

	echo bye
}

_console_supermicro ${*}
