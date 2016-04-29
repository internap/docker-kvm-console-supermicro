#!/bin/bash

# Copyright 2016 Internap.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


docker build -t internap/kvm-console-supermicro $(dirname ${0})

id=$(docker run -P -d \
    -e IPMI_ADDRESS=${1} \
    -e IPMI_USERNAME=${2-ADMIN} \
    -e IPMI_PASSWORD=${3-ADMIN} \
    internap/kvm-console-supermicro)

sleep 2
vncviewer $(docker port $id | cut -d ' ' -f 3)
docker rm --force $id
