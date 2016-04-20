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

set -e
set -o pipefail

ip_address="$1"
username=${2:-ADMIN}
password=${3:-ADMIN}

get_session_id() {
  local login_url="${proto}://${ip_address}/cgi/login.cgi"
  curl --insecure -s -X POST "${login_url}" --data "name=${username}&pwd=${password}" -i | awk '/SID=[^;]/ { print $2 }'
}

proto=http
session_id=$(get_session_id)
if [ -z "${session_id}" ]; then
  proto=https
  session_id=$(get_session_id)
fi

# Download jnlp
mkdir -p "workspace-${ip_address}"
cd "workspace-${ip_address}"
jnlp_url="${proto}://${ip_address}/cgi/url_redirect.cgi?url_name=ikvm&url_type=jwsk"
curl -s --insecure "${jnlp_url}" -H 'Referer: http://localhost' -H "Cookie: ${session_id}" > launch.jnlp

# Download resource
codebase_url=$(xmlstarlet sel -t -v '/jnlp/@codebase' launch.jnlp)
jars="$(xmlstarlet sel -t -v 'concat(//*/jar/@href, //*/jar/@version)' launch.jnlp | sed 's/.jar\(..*\)$/__V\1.jar/g')"
query='@os="'"$(uname | sed 's/Darwin/Mac OS X/')"'" and @arch="'"$(uname -m)"'"'
libs="$(xmlstarlet sel -t -v 'concat(//*/resources['"$query"']/nativelib/@href, //*/nativelib[position()]/@version)' launch.jnlp | sed 's/.jar\(..*\)$/__V\1.jar/g')"

for resource in $jars $libs; do
    [ -f $resource ] || curl --insecure -L -H 'Referer: http://localhost' -H "Cookie: ${session_id}" "${codebase_url}/${resource}.pack.gz" | unpack200 - $resource
done

# Extract libraries
for lib in $libs; do
    unzip -o $lib > /dev/null
done

# Start application
java_vm_args=$(xmlstarlet sel -t -v '//*/j2se/@java-vm-args' launch.jnlp || true)
main_class=$(xmlstarlet sel -t -v '//*/application-desc/@main-class' launch.jnlp)
arguments=$(xmlstarlet sel -t -v '//*/application-desc/argument' launch.jnlp)
exec java -Djava.library.path=. -cp $(echo $jars|tr ' ' ':') $java_vm_args $main_class $arguments
