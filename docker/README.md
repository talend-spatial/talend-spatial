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

	docker run --rm --name crawler -p 5900:5900 crawler

Optionally add a volume mount for your data (use the correct syntax for the host files- the example below is for a linux host):

	docker run --rm --name crawler -p 5900:5900 -v /host/path/to/files:/data crawler


### Connecting and Running ###

Check the status of the container using `docker ps`. If you cannot see a container with name `crawler` in the output then consult the output of the `docker run` command above.

Once it's running then you can connect to it using vnc using the following address:

	localhost:5900

Access the menu using the icon in the bottom left corner of the desktop and choose System Tools&rarr;File Manager PCManFM, then navigate to `/root/TOS_DI-20181026_1147-v7.1.1/` and run  `TOS_DI-linux-gtk-x86_64` (press the execute button).

When Talend loads, accept any licenses that you're asked to accept and start a new project. If you have added a volume mount as described above, your files will be located at `/data`.

### No spatial component in the palette ? ###

As detailed in the installation instructions at https://github.com/talend-spatial/talend-spatial/blob/7.4/INSTALL.md if you don't have the **geo** component in your palette when you open Talend-Spatial then you will need to edit `/root/TOS_DI-20181026_1147-v7.1.1/configuration/config.ini` and add:

```
,org.talend.libraries.sdi-7.4.1@4,org.talend.sdi.designer.components-7.4.1@4,
org.talend.sdi.designer.routines-7.4.1@4,org.talend.sdi.repository.ui.actions.metadata-7.4.1@4,
org.talend.sdi.repository.ui.actions.metadata.ogr-7.4.1@4,
org.talend.sdi.workspace.spatial-7.4.1@4 

```

to the **osgi.bundles=...** property.

Note that this will not persist beyond a restart of the docker container. If you wish to permanently fix this then save the edited `/root/TOS_DI-20181026_1147-v7.1.1/configuration/config.ini` file to your local computer, then mount it as a volume for the docker command. For example:

	docker run --rm --name crawler -p 5900:5900 -v /host/path/to/files:/data -v /host/path/to/config.ini:/root/TOS_DI-20181026_1147-v7.1.1/configuration/config.ini crawler
