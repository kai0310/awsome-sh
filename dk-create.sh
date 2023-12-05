#!/bin/bash

current_user=$(whoami)
current_dir_name=$(basename "$(pwd)")

default_image_name="${current_user}_${current_dir_name}"

default_mount_path="/home/$current_user/$current_dir_name"

read -p "Enter Docker image name (default: $default_image_name): " image_name
image_name=${image_name:-$default_image_name}

read -p "Enter path to mount (default: $default_mount_path): " mount_path
mount_path=${mount_path:-$default_mount_path}

if [ $(docker ps -a -q -f name=^/${image_name}$) ]; then
    echo "The Docker container named $image_name has already been created."

    docker start $image_name
    docker exec -it $image_name bash
else
    echo "The Docker container named $image_name has just been created!"
    docker run --gpus all -it --net=host -v $mount_path:/root/share --name $image_name nvcr.io/nvidia/pytorch:23.09-py3
fi
