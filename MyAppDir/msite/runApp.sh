#!/bin/bash

docker stop my-site-app
docker rm my-site-app
# docker rmi my-site-app-image

[ -n "$1" ] && docker rmi my-site-app-image && docker build . -t my-site-app-image



docker run -d --name my-site-app -p 8080:8000 my-site-app-image
