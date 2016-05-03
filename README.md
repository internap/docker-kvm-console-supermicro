kvm-console-supermicro
======================

[![pulls](https://img.shields.io/docker/pulls/internap/kvm-console-supermicro.png?maxAge=86400)](https://hub.docker.com/r/internap/kvm-console-supermicro/) [![stars](https://img.shields.io/docker/stars/internap/kvm-console-supermicro.png?maxAge=86400)](https://hub.docker.com/r/internap/kvm-console-supermicro/)


This docker image provides standard VNC on Supermicro's BMC using its native iKVM Viewer.  The iKVM Viewer is downloaded at runtime from the BMC itself to avoid version mismatches.

Configuration
-------------

The following settings are configurable using env variables:

 - X11VNC_CLIP: The area of the application to show
 - X11VNC_TITLE: Desktop title shown by X11VNC (default to "")
 - SPLASH_IMAGE: Image to show until we get the application working
 - SPLASH_SIZE: Screen size to show until we get the application working (default to splash image size or 1x1)
 - CONSOLE_TTL: The delay (in seconds) between connections before the container is terminated
 - IPMI_USENAME: The username to use when connecting to the BMC
 - IPMI_PASSWORD: The password to use when connecting to the BMC
 - IPMI_ADDRESS: The address of the BMC to connect to (MANDATORY)

Usage
-----

    $ console-supermicro.sh 192.0.2.10 unsername password

Contributing
============

Feel free to raise issues and send some pull request, we'll be happy to look at them!
