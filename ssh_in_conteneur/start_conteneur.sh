#!/bin/bash

#build the image
if [ $# -gt 0 ]; then
    docker build -t ssh_worker_image .

    if [ $? -ne 0 ]; then
        exit 1  # Exit the script with a non-zero status
    fi  
fi

# run the image
docker stop ssh_worker_conteneur
docker rm ssh_worker_conteneur
docker run -d -p 2222:22 --name ssh_worker_conteneur ssh_worker_image


# docker exect -it worker_node /bin/bash