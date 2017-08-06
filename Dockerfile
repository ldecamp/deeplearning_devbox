FROM ubuntu:16.10
MAINTAINER Laurent Decamp <laurent.decamp@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# Install Core Tools
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y \
        libblas-dev \
        liblapack-dev \
        gfortran \
        gcc \
        g++ \
        git \
        wget \
        linux-headers-generic \
        build-essential \
 && rm -rf /var/lib/apt/list/* \
 && rm -rf /usr/share/doc/* \
 && rm -rf /tmp/*

# Install Base deps + update kernel
RUN apt-get update \
 && apt-get install -y \
        wget \
        git \
        curl \
        nano \
        vim \
        net-tools \
        libssl-dev \
        python3.6-dev \
        python3.6 \
        python3-pip \
        python3-setuptools \
        libfreetype6-dev \
        libhdf5-dev \
        pkg-config \
        zip \
        zlib1g-dev \
        unzip \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        kmod \
        tmux \
        libjpeg8-dev \
        libfreetype6-dev \
        python-gtk2-dev \
        libffi-dev \
        libxft-dev \
        libjpeg-turbo8-dev \
        xclip \
        libprotobuf-dev \
        libleveldb-dev \
        libsnappy-dev \
        libopencv-dev \
        libhdf5-serial-dev \
        protobuf-compiler \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /usr/share/doc/* \
 && rm -rf /tmp/*


# install cuda first then override driver
RUN wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run -O /tmp/cuda_8.0.61_375.26_linux.run
RUN sh /tmp/cuda_8.0.61_375.26_linux.run --silent  --toolkit  --override \
 && rm /tmp/cuda_8.0.61_375.26_linux.run

# Install cuda + cudnn
RUN wget http://us.download.nvidia.com/XFree86/Linux-x86_64/375.66/NVIDIA-Linux-x86_64-375.66.run -O /tmp/NVIDIA-Linux-x86_64-375.66.run
RUN sh /tmp/NVIDIA-Linux-x86_64-375.66.run --no-kernel-module --silent \
 && rm /tmp/NVIDIA-Linux-x86_64-375.66.run

WORKDIR /usr/local
RUN wget https://s3.amazonaws.com/tractable-nvidia-drivers/cudnn-8.0-linux-x64-v5.1.tar -O cudnn.tgz
RUN mkdir cudnn \
 && tar -xvf cudnn.tgz -C cudnn \
 && cp /usr/local/cudnn/cuda/lib64/* /usr/local/cuda/lib64 \
 && cp /usr/local/cudnn/cuda/include/* /usr/local/cuda/include \
 && rm -rf /tmp/* \
 && rm -r cudnn.tgz cudnn

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64/
WORKDIR $HOME

# Point all python commands to python3 and pip3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 100
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 100
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 100

COPY requirements.txt requirements.txt
# Install Python packages (Base utils + tensorflow/keras + pytorch)
RUN pip3 --no-cache-dir install --upgrade pip \
 && pip3 install -r requirements.txt \
 && rm -f requirements.txt

# install pytorch
RUN pip3 install http://download.pytorch.org/whl/cu80/torch-0.1.12.post2-cp36-cp36m-linux_x86_64.whl  \
 && pip3 install torchvision

# JPEG Optimisation (WIP)
#RUN apt-get update && apt-get install -y libturbojpeg libffi-dev libjpeg-dev \
# && pip3 install --no-cache-dir jpegtran-cffi jpeg4py \
# && ln -s /usr/lib/x86_64-linux-gnu/libturbojpeg.so.0.1.0 /usr/lib/x86_64-linux-gnu/libturbojpeg.so \
# && python3 -c "import jpeg4py" \
# && python3 -c "import jpegtran" \

# Create system wide rc files:
COPY bashrc /.bashrc

CMD ['usr/bin/bash']
