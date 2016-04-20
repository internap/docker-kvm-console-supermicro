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

pid="$(pidof "$1")"
[ "$pid" ]
window_id=$(xdotool search --pid "$pid" --onlyvisible --limit 1 .+)
xdotool windowfocus "$window_id"
x11vnc -display :1 -rfbport 5901 -xkb -shared -forever -id "$window_id" -clip 4096x4096+0+21 -desktop ""
