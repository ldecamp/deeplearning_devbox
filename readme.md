## Deep Learning Docker devbox

This repo creates a docker images with all the necessary tools & components for DL on aws P2 instance.

#### Components Installed

- Nvidia Drivers (375.26)
- Cuda 8
- CuDnn 5.1 (until tensorflow supports v6)
- python 3.6
- pip
- Jupyter Notebook
- Tensorflow 1.2
- Keras 2.0
- Pytorch 0.1.12


#### Build Docker image

```
docker build -t <your image tag> .
```

#### Use pre-built docker image. 

you can use the usual docker run command to start the docker container (with GPU support) see start_docker.sh script for detailled command.
Alternatively you can use the following.

```
# possibly need chmod+x for execution rights
./init_nvidia.sh
./init_uvm.sh
./start_docker.sh
```

Note: this has been built on ubuntu with ubuntu user in mind. If you use another distro/user, the start_docker.sh script will need to be adjusted for the local user.