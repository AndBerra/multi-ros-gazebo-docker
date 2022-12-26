# ROS IMAGE
ARG ROS_VERSION
FROM ros:${ROS_VERSION} as base

# option shell not interactive
ENV DEBIAN_FRONTED=noninteractive



# install gazebo
RUN apt-get update && \
    apt-get install -y wget 

ARG GAZEBO_VERSION
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update && apt-get install -y \
    gazebo${GAZEBO_VERSION} \
    libgazebo${GAZEBO_VERSION}-dev 

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
RUN apt-get update && \
    apt-get install -y apt-utils git nano ros-$ROS_DISTRO-gazebo-ros-pkgs \
    && rm -rf /var/lib/apt/lists/* 

# --------------------------------------------------------------------------------
# NVIDIA SETTINGS
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
