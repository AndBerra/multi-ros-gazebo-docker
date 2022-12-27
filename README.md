# multi-ros-gazebo-docker

Repo to create docker images with ROS+gazebo and launch containers with volume attached.

Tested for ROS_DISTRO: melodic, noetic, foxy, humble and rolling

Gazebo version per ROS_DISTRO -> [documentation](https://classic.gazebosim.org/tutorials?tut=ros_wrapper_versions&cat=connect_ros)

## Dependencies

docker -> [installation](https://docs.docker.com/engine/install/ubuntu/)

nvidia-docker2 -> [installatiion](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

## Example: docker image with ROS noetic and Gazebo 11.0

Creating docker image

```sh
./build_docker noetic 11
```

From the image launching a docker with a volume attached (catkin_ws)

```sh
./launch_docker.sh test_container ros-noetic-gazebo11 ~/catkin_ws
```
