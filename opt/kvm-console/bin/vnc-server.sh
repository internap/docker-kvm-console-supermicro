#!/bin/bash -e

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

splash_width=1
splash_height=1

read screen_width screen_height < <(xdotool getdisplaygeometry)

[ "${SPLASH_IMAGE-}" ] && \
    read splash_width splash_height < <(\
        xview -identify $SPLASH_IMAGE | \
        sed 's/.* \([0-9]*\)x\([0-9]*\) .*/\1 \2/g')

[ "${SPLASH_SIZE-}" ] && \
    read splash_width splash_height < <(echo $SPLASH_SIZE | tr 'x' ' ')

clip_x=$((screen_width/2-splash_width/2))
clip_y=$((screen_height/2-splash_height/2))
splash_clip=${splash_width}x${splash_height}+${clip_x}+${clip_y}

/opt/kvm-console/bin/splash-show.sh

# Disable the screen saver
xset s off s reset

_run_novnc() {
	sleep 3
	supervisorctl start novnc
}
_run_novnc 2>&1 | tee -a /tmp/novnc.txt &

x11vnc -storepasswd ${VNC_PASSWORD} /tmp/vnc-password.txt
exec x11vnc -rfbport 5900 -rfbauth /tmp/vnc-password.txt -ncache 10 --xkb -shared -forever -desktop "${X11VNC_TITLE-}" -clip $splash_clip
