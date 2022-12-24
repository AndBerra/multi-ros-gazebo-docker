#!/bin/bash

my_ros_version=$1
my_gazebo_version=$2

echo "-----------------------------------------"
echo "DOCKER IMAGE SETTINGS"
echo "ros version -> $my_ros_version"
echo "gazebo version -> $my_gazebo_version"
echo "----------------------------------------"

DOCKER_BUILDKIT=1 docker build  --build-arg ROS_VERSION="$my_ros_version"\
                                --build-arg GAZEBO_VERSION=$my_gazebo_version\
                                -t ros-$my_ros_version-gazebo$my_gazebo_version\
                                .

