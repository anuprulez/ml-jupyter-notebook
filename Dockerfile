# Jupyter container used for Tensorflow
FROM jupyter/tensorflow-notebook:latest

MAINTAINER Anup Kumar, anup.rulez@gmail.com

ENV DEBIAN_FRONTEND noninteractive

# Install system libraries first as root
USER root

RUN apt-get -qq update && apt-get install --no-install-recommends -y libcurl4-openssl-dev libxml2-dev \
    apt-transport-https python-dev libc-dev pandoc pkg-config liblzma-dev libbz2-dev libpcre3-dev \
    build-essential libblas-dev liblapack-dev gfortran libzmq3-dev libyaml-dev libxrender1 fonts-dejavu \
    libfreetype6-dev libpng-dev net-tools procps libreadline-dev wget software-properties-common octave \
    protobuf-compiler libprotoc-dev \
    # IHaskell dependencies
    zlib1g-dev libtinfo-dev libcairo2-dev libpango1.0-dev && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

######################## Nvidia

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
RUN mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
RUN apt-get update

RUN http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb

RUN apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
RUN apt-get update

# Install NVIDIA driver
RUN apt-get install --no-install-recommends nvidia-driver-450
# Reboot. Check that GPUs are visible using the command: nvidia-smi

RUN https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libnvinfer7_7.1.3-1+cuda11.0_amd64.deb
RUN apt install ./libnvinfer7_7.1.3-1+cuda11.0_amd64.deb
RUN apt-get update

# Install development and runtime libraries (~4GB)
RUN apt-get install --no-install-recommends \
    cuda-11-0 \
    libcudnn8=8.0.4.30-1+cuda11.0  \
    libcudnn8-dev=8.0.4.30-1+cuda11.0


# Install TensorRT. Requires that libcudnn8 is installed above.
RUN apt-get install -y --no-install-recommends libnvinfer7=7.1.3-1+cuda11.0 \
    libnvinfer-dev=7.1.3-1+cuda11.0 \
    libnvinfer-plugin7=7.1.3-1+cuda11.0

#################################################

USER $NB_USER

# Python packages
RUN pip install --no-cache-dir tensorflow-gpu=2.4.1 onnx onnx-tf
# tf2onn

ADD ./startup.sh /startup.sh

USER root

RUN mkdir /import

COPY ./jupyter_notebook_config.py /home/$NB_USER/.jupyter/
ADD ./default_notebook_ml.ipynb /home/$NB_USER/tensorflow_notebook.ipynb

RUN mkdir -p /home/$NB_USER/.jupyter/custom/

ADD ./custom.js /home/$NB_USER/.jupyter/custom/custom.js
ADD ./useGalaxyeu.svg /home/$NB_USER/.jupyter/custom/useGalaxyeu.svg
ADD ./custom.css /home/$NB_USER/.jupyter/custom/custom.css

ENV DEBUG=false \
    NOTEBOOK_PASSWORD=none \
    CORS_ORIGIN=none \
    DOCKER_PORT=none \
    REMOTE_HOST=none

RUN chown -R $NB_USER:users /home/$NB_USER /import

WORKDIR /import 

CMD /startup.sh
