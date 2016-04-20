#!/bin/sh

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

tries=30

no_active_vnc_session() {
    [ `ps x | grep -c '[0-9] nc 127.0.0.1 5901'` -eq 0 ]
}

establish_reverse_proxy() {
    nc 127.0.0.1 5901 2>/dev/null
}

supervisorctl stop 'idle_timeout_job' > /dev/null 2>&1
supervisorctl start 'console:*' > /dev/null 2>&1
while [ $tries -gt 0 ]; do
    if establish_reverse_proxy; then
        if no_active_vnc_session; then
            supervisorctl start 'idle_timeout_job' > /dev/null 2>&1
            supervisorctl stop 'console:*' > /dev/null 2>&1
        fi
        exit 0
    else
        sleep .5
        tries=$((tries-1))
    fi
done
supervisorctl stop 'console:*' > /dev/null 2>&1
exit 1
