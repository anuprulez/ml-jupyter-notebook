# Jupyter container used for Tensorflow
FROM jupyter/tensorflow-notebook:latest

MAINTAINER Anup Kumar, anup.rulez@gmail.com

ENV DEBIAN_FRONTEND noninteractive

# Install system libraries first as root
USER root

RUN apt-get -qq update && apt-get install --no-install-recommends -y libcurl4-openssl-dev libxml2-dev \
    apt-transport-https python-dev libc-dev pandoc pkg-config liblzma-dev libbz2-dev libpcre3-dev \
    build-essential libblas-dev liblapack-dev libzmq3-dev libyaml-dev libxrender1 fonts-dejavu \
    libfreetype6-dev libpng-dev net-tools procps libreadline-dev wget software-properties-common && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV CUDA_VERSION 11.0.3 

ENV CUDA_RT 11.0.221

ENV CUDA_PKG_VERSION 11-0=$CUDA_RT-1  

ENV CUDNN_VERSION 8.0.5.39 

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda-10.2/lib64:/usr/local/cuda-10.1/lib64//usr/local/cuda-11.0/lib64:$LD_LIBRARY_PATH

ENV NVIDIA_VISIBLE_DEVICES=all

ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Package location Ubuntu 20.04
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*

# Install CUDA
RUN apt-get update && apt-get install -y --no-install-recommends \
     cuda-11-0 \
     cuda-cudart-$CUDA_PKG_VERSION && \
     ln -s cuda-11.0 /usr/local/cuda && \
     rm -rf /var/lib/apt/lists/*

# Install cuDNN
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn8=$CUDNN_VERSION-1+cuda11.0 \
    libcudnn8-dev=$CUDNN_VERSION-1+cuda11.0 && \
    rm -rf /var/lib/apt/lists/*

# Python packages
RUN pip install --no-cache-dir tensorflow==2.4.1 \
    onnx onnx-tf \
    tf2onnx \
    skl2onnx \
    onnxruntime \
    bioblend \
    galaxy-ie-helpers \
    nbclassic \
    jupyterlab-git \
    jupyter_server \
    jupyterlab==3.0.7 \
    jupytext \ 
    lckr-jupyterlab-variableinspector \
    jupyterlab_execute_time \
    xeus-python \
    jupyterlab-kernelspy \
    jupyterlab-system-monitor \
    jupyterlab-fasta \
    jupyterlab-geojson \
    jupyterlab-logout \
    jupyterlab-topbar
    #thamos==1.18.3 \
    #jupyterlab-requirements==0.7.3

#RUN pip install --no-cache-dir elyra>=2.0.1 && jupyter lab build

ADD ./startup.sh /startup.sh
ADD ./get_notebook.py /get_notebook.py

RUN mkdir -p /home/$NB_USER/.ipython/profile_default/startup/
RUN mkdir /import

COPY ./ipython-profile.py /home/$NB_USER/.ipython/profile_default/startup/00-load.py
COPY ./jupyter_notebook_config.py /home/$NB_USER/.jupyter/
#ADD ./default_tensorflow_notebook.ipynb /home/$NB_USER/default_tensorflow_notebook.ipynb
ADD ./*.ipynb /home/$NB_USER/

RUN mkdir /home/$NB_USER/elyra/

COPY ./elyra/*.* /home/$NB_USER/elyra/

RUN mkdir /home/$NB_USER/data
COPY ./data/*.tsv /home/$NB_USER/data/

# ENV variables to replace conf file
ENV DEBUG=false \
    GALAXY_WEB_PORT=10000 \
    NOTEBOOK_PASSWORD=none \
    CORS_ORIGIN=none \
    DOCKER_PORT=none \
    API_KEY=none \
    HISTORY_ID=none \
    REMOTE_HOST=none \
    GALAXY_URL=none

RUN chown -R $NB_USER:users /home/$NB_USER /import

WORKDIR /import

CMD /startup.sh
