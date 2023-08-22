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

#FROM ubuntu:14.04
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-get update && apt-get install -yyq --no-install-recommends \
    supervisor x11vnc xvfb xdotool x11-utils curl unzip openjdk-8-jre \
    x11-xserver-utils xmlstarlet iptables xloadimage git python3-pip \
	&& pip3 install numpy \
    && apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/* \
	|| exit ${?}

ADD etc /etc
ADD opt /opt

RUN tar xfz /opt/kvm-console/noVNC.tgz -C /opt/kvm-console

# The delay (in seconds) between connections before the container is terminated
ENV CONSOLE_TTL "3600"

# X11VNC_CLIP: The area of the application to show
ENV X11VNC_CLIP "4096x4096+0+21"
# Desktop title shown by X11VNC
ENV X11VNC_TITLE ""
# Image to show until we get the application working
ENV SPLASH_IMAGE ""
# Screen size to show until we get the application working
ENV SPLASH_SIZE ""

# The VNC password to use
ENV VNC_PASSWORD "no-password"

# The username to use when connecting to the BMC
ENV IPMI_USERNAME "ADMIN"
# The password to use when connecting to the BMC
ENV IPMI_PASSWORD "ADMIN"

# The noVNC inactivity timeout (in seconds)
ENV INACTIVITY_TIMEOUT 1800

# The address of the BMC to connect (MANDATORY)
# Define with `docker run <image_name> -e IPMI_ADDRESS=<address>`
#ENV IPMI_ADDRESS "192.0.2.10"

HEALTHCHECK --interval=10s --retries=3 --start-period=30s CMD /opt/kvm-console/bin/activity-watcher.sh

#EXPOSE 5900
EXPOSE 8080
ENTRYPOINT ["/opt/kvm-console/bin/startup.sh"]
