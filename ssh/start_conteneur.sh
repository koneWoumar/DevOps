#!/bin/bash

#build the image if an argument is pass via the interface
if [ $# -gt 0 ]; then
    docker build -t remote_node .

    if [ $? -ne 0 ]; then
        exit 1  # Exit the script with a non-zero status
    fi  
fi

# run the image
docker stop remote_node
docker rm remote_node
docker run -d -p 2223:22 --name remote_node remote_node


docker exec -it remote_node /bin/bash
