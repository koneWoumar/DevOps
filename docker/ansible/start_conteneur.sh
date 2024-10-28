#!/bin/bash

#build the image if an argument is pass via the interface
if [ $# -gt 0 ]; then
    docker build -t ansible_controler_node .

    if [ $? -ne 0 ]; then
        exit 1  # Exit the script with a non-zero status
    fi  
fi

# run the image
docker stop controler_node
docker rm controler_node
docker run -d -p 2222:22 --name controler_node ansible_controler_node


docker exec -it controler_node /bin/bash

# ssh albarry@locahost 
#albarry20
