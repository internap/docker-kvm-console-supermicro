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


read screen_width screen_height < <(xdotool getdisplaygeometry)

if [ "${SPLASH_IMAGE-}" ]; then
    read image_width image_height < <(\
        xview -identify $SPLASH_IMAGE | \
        sed 's/.* \([0-9]*\)x\([0-9]*\) .*/\1 \2/g')
    
    splash_width=$image_width
    splash_width=$image_height
    image_clip_x=$((screen_width/2-image_width/2))
    image_clip_y=$((screen_height/2-image_height/2))
    image_clip=${image_width}x${image_height}+${image_clip_x}+${image_clip_y}

    xview -center -onroot $SPLASH_IMAGE
    xview $SPLASH_IMAGE -geometry $image_clip &
    xview_pid=$!
    xview_winid=$(xdotool search --sync --name $SPLASH_IMAGE)
    while xdotool windowraise $xview_winid; do true; done &
    (sleep ${SPLASH_TIMEOUT-20} && kill $xview_pid) &
fi
