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

while true; do
    read winid width height < <(xwininfo -root -tree \
        | grep -iE 'Java iKVM Viewer.+Resolution' \
        | sed 's/^\(.*\)".*Resolution \([0-9]*\) X \([0-9]*\).*/\1 \2 \3/g')

    [ -z "$winid" ] && [ -z "$width" ] && [ -z "$height" ] && \
        sleep 1 && continue

    width=$((width + 4))
    height=$((height + 24))
    actual_width=$(x11vnc -query wdpy_x 2>/dev/null | cut -d':' -f 2)
    actual_height=$(x11vnc -query wdpy_y 2>/dev/null | cut -d':' -f 2)

    [ "$width" -eq "$actual_width" ] && [ "$height" -eq "$actual_height" ] && \
        sleep 1 && continue

    xdotool windowfocus $winid windowsize $winid $width $height
    x11vnc -remote "clip:$X11VNC_CLIP" --sync
    x11vnc -remote "id:$winid" --sync

    /opt/kvm-console/bin/splash-hide.sh
done
