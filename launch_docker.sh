#!/bin/bash

xhost +local:root

# container name
ctr_name="$1"
# image name
img_name="$2"
# abs path to the src folder desired in the volume 
path_src="$3"


if [ "$#" != "3" ];
    then
    echo "<container_name> <image_name> <abs_path_to_src>"
    exit 1
fi

echo "----------------------------"
echo "running container: $ctr_name"
echo "generated from image: $img_name "
echo "volume folder: $path_src"
echo "-----------------------------"

docker run --gpus all -it \
--runtime=nvidia \
--network=host \
--env="DISPLAY"  \
--env="QT_X11_NO_MITSHM=1"  \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--workdir="/home/$USER" \
--volume="$path_src:/home/$USER/catkin_ws/src" \
--volume="/etc/group:/etc/group:ro" \
--volume="/etc/passwd:/etc/passwd:ro" \
--volume="/etc/shadow:/etc/shadow:ro" \
--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
--volume="$HOME/host_docker:/home/user/host_docker" \
-e LOCAL_USER_ID=`id -u $USER` \
-e LOCAL_GROUP_ID=`id -g $USER` \
-e LOCAL_GROUP_NAME=`id -gn $USER` \
--device /dev/snd \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
	-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
	--group-add $(getent group audio | cut -d: -f3) \
--name=$ctr_name $img_name

xhost -local:root