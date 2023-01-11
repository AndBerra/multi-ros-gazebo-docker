# ROS IMAGE
ARG ROS_VERSION
FROM ros:${ROS_VERSION} as base

# option shell not interactive
ENV DEBIAN_FRONTED=noninteractive



# install gazebo
ARG GAZEBO_MAJOR_VERSION
RUN apt-get update && \
    apt-get install -y wget 
RUN wget https://raw.githubusercontent.com/ignition-tooling/release-tools/master/jenkins-scripts/lib/dependencies_archive.sh \
    -O /tmp/dependencies.sh 
RUN /bin/bash -c '. /tmp/dependencies.sh'
RUN echo $BASE_DEPENDENCIES $GAZEBO_BASE_DEPENDENCIES | tr -d '\\' | xargs sudo apt-get -y install

# setup ros 
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc 
RUN mkdir -p ${HOME}/catkin_ws
WORKDIR ${HOME}/catkin_ws

# # setup entrypoint
# COPY ./entrypoint.sh /
# RUN chmod +x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]

# --------------------------------------------------------------------------------
# INSTALLING DEPENDENCIES
FROM base as dependencies

RUN rm -rf /var/lib/apt/lists/*

COPY requirements.sh /scripts/
RUN chmod +x /scripts/requirements.sh
RUN bash /scripts/requirements.sh 

# --------------------------------------------------------------------------------
# NVIDIA SETTINGS
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
