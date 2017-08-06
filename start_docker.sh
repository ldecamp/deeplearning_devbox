#!/bin/bash
USER=ubuntu
DOCKER_USER=root
container_name=lolo62/dl_sandbox
read -d '' run_docker << EOF
$(docker run -it -v /home/${USER}:/home/${DOCKER_USER} \
                 -v /lib/modules/4.6.1-1.el7.elrepo.x86_64:/lib/modules/4.6.1-1.el7.elrepo.x86_64 \
                 --net=host \
                 --device /dev/nvidia-uvm:/dev/nvidia-uvm \
                 --device /dev/nvidiactl:/dev/nvidiactl \
                 --device /dev/nvidia0:/dev/nvidia0 \
                 -p 8888 \
                 -u ${DOCKER_USER} \
                 -w /home/${DOCKER_USER} \
                 ${container_name} /bin/bash)
EOF

echo "$run_docker"
