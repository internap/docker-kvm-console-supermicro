kvm-console-supermicro
======================

[![](https://badge.imagelayers.io/internap/kvm-console-supermicro:latest.svg)](https://imagelayers.io/?images=internap/kvm-console-supermicro:latest 'Get your own badge on imagelayers.io')

This docker image provides standard VNC on Supermicro's BMC using its native iKVM Viewer.  The iKVM Viewer is downloaded at runtime from the BMC itself to avoid version mismatches.

Usage
-----

    $ docker build -t internap/kvm-console-supermicro .
    Successfully built fdfff106efbe
    $ docker run -d -t -i -e IPMI_ADDRESS=192.0.2.10 -e IPMI_USERNAME=username -e IPMI_PASSWORD=password --publish-all internap/kvm-console-supermicro
    fc4644be6959404d6d65252bb5b5e6ea8edc0b2019e43447b6b36e06da4d6ec0
    $ docker ps
    CONTAINER ID        IMAGE                                    COMMAND                    CREATED             STATUS              PORTS                     NAMES
    fc4644be6959        internap/kvm-console-supermicro:latest   "/opt/kvm-console/bi   6 seconds ago       Up 6 seconds        0.0.0.0:32780->5900/tcp   nostalgic_mayer     
    $ vncviewer 127.0.0.1:32780

Contributing
============

Feel free to raise issues and send some pull request, we'll be happy to look at them!
