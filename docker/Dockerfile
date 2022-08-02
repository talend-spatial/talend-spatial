# Custom Dockerfile for building Talend Spatial
# Based on dorowu/ubuntu-desktop-lxde-vnc
# Build with docker build -t crawler .


FROM dorowu/ubuntu-desktop-lxde-vnc

MAINTAINER Jo Cook "jocook@astuntechnology.com"
ENV REFRESHED_AT 2022-08-02

# install some utilities
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN apt-get update && apt-get install -y openjdk-8-jdk gdal-bin libgdal-java unzip curl gedit

# Download the additional files that we need

RUN wget --no-check-certificate https://sourceforge.net/projects/sdispatialetl/files/sdispatialetl/TOS.spatial.7.4.1/TOS-Spatial-7.4.1.zip/download -O TOS-Spatial-7.4.1.zip && \
	wget --no-check-certificate https://sourceforge.net/projects/talend-studio/files/Talend%20Open%20Studio/7.4.1M8/TOS_DI-20210406_1041-V7.4.1M8.zip/download -O TOS_DI-20210406_1041-V7.4.1M8.zip && \
	wget --no-check-certificate https://talend-update.talend.com/nexus/content/repositories/libraries/org/talend/libraries/log4j-1.2.15/6.0.0/log4j-1.2.15-6.0.0.jar -O log4j-1.2.15-6.0.0.jar

RUN unzip TOS_DI-20210406_1041-V7.4.1M8.zip && \
	unzip TOS-Spatial-7.4.1.zip

RUN cp -r target/TOS-Spatial-7.4.1/plugins/* TOS_DI-20210406_1041-V7.4.1M8/plugins



