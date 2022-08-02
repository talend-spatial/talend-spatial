# README #

Docker image for running metadata crawler. Based on https://github.com/fcwu/docker-ubuntu-vnc-desktop

## What is this repository for? ##

* Provides a docker image to run an ubuntu server (gui) with Talend Open Source (v7.4) and Talend Spatial installed and configured, that you can connect to from any operating system as long as you have a vnc client.

## How do I get set up? ##

### Build Dependencies ###

* docker
* a vnc client

### Installation ###

Clone or otherwise download this repository. 

Build docker image inside the `docker` folder using:

	docker build . -t crawler

Start crawler using:

	docker run --name crawler -p 5900:5900 crawler

Optionally add a volume mount for your data (use the correct syntax for the host files- the example below is for a linux host):

	docker run --name crawler -p 5900:5900 -v /host/path/to/files:/data crawler


### Connecting and Running ###

Check the status of the container using `docker ps`. If you cannot see a container with name `crawler` in the output then consult the output of the `docker run` command above.

Once it's running then you can connect to it using vnc using the following address:

	localhost:5900

Access the menu using the icon in the bottom left corner of the desktop and choose System Tools&rarr;File Manager PCManFM, then navigate to `/root/TOS_DI-20210406_1041-V7.4.1M8/` and execute (double-click) `TOS_DI-linux-gtk-x86_64`. If it asks you to confirm that you want to execute the file, choose the button marked "Execute". 

When Talend loads, accept any licenses that you're asked to accept and start a new project. If you have added a volume mount as described above, your files will be located at `/data`.
