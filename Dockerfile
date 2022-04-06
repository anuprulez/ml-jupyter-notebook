## Jupyter container used for Tensorflow
#FROM tensorflow/tensorflow:latest-gpu-jupyter

FROM jupyter/tensorflow-notebook:tensorflow-2.6.0

MAINTAINER Anup Kumar, anup.rulez@gmail.com

ENV DEBIAN_FRONTEND noninteractive

USER root 

RUN apt-get -qq update && apt-get install --no-install-recommends -y libcurl4-openssl-dev libxml2-dev \
    apt-transport-https python3-dev python3-pip libc-dev pandoc pkg-config liblzma-dev libbz2-dev libpcre3-dev \
    build-essential libblas-dev liblapack-dev libzmq3-dev libyaml-dev libxrender1 fonts-dejavu \
    libfreetype6-dev libpng-dev net-tools procps libreadline-dev wget software-properties-common gnupg2 curl ca-certificates && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
#   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
#   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

#RUN wget https://us.download.nvidia.com/XFree86/Linux-x86_64/510.47.03/NVIDIA-Linux-x86_64-510.47.03.run
#RUN bash NVIDIA-Linux-x86_64-510.47.03.run -s -N --no-kernel-module 

#RUN apt-get update

#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
#      && curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add - \
#      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

#RUN curl -s -L https://nvidia.github.io/libnvidia-container/experimental/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

#RUN apt-get update && apt-get install -y nvidia-docker2 nvidia-container-toolkit

#RUN mkdir /usr/local/cuda-11.6
#ADD /usr/local/cuda-11.6 /usr/local/cuda-11.6
#RUN ls -la /usr/local/cuda-11.6/*

#RUN apt-get update && ln -s /usr/local/cuda-11.6 /usr/local/cuda && ln -s /usr/local/cuda-11.6 /usr/local/cuda-11.6

#RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.6/lib64

#RUN export PATH=/usr/local/cuda-11.6/lib64${PATH:+:${PATH}}
#RUN export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

#RUN sudo chmod a+r /usr/local/cuda-11.6/lib64/libcuda*

#RUN mkdir /usr/local/cuda-11.6
#COPY /usr/local/cuda-11.6/ /usr/local/cuda-11.6/

#RUN touch /etc/ld.so.conf.d/cuda.conf

#RUN apt-get update

#RUN wget "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb"
#RUN dpkg -i libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb

#RUN touch /etc/ld.so.conf.d/cuda.conf

#RUN sudo systemctl restart docker

#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
#RUN mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600

#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

#RUN echo $distribution
#
#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
#RUN curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
#RUN curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

#RUN apt-get update && apt-get install -y nvidia-container-runtime

#RUN sudo systemctl restart docker

##########

#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
#RUN curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -
#RUN curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
#RUN curl -s -L https://nvidia.github.io/libnvidia-container/experimental/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

#RUN sudo systemctl restart docker


## Download OS pin
#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
#RUN mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600

# Download and install OS for CUDA
#RUN wget "https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb"
#RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add
#RUN dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb

#RUN apt-get update && apt-get install -y --no-install-recommends \
#    cuda-11-3 && \
#    ln -s cuda-11.3 /usr/local/cuda && \
#    rm -rf /var/lib/apt/lists/* cuda-11.3

#RUN apt-get update && apt-get install -y --no-install-recommends && \
#    rm -rf /var/lib/apt/lists/*

# Install cuDNN packages
#RUN wget "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb"
#RUN dpkg -i libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb

#RUN wget "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/libcudnn8-dev_8.2.1.32-1+cuda11.3_amd64.deb"
#RUN dpkg -i libcudnn8-dev_8.2.1.32-1+cuda11.3_amd64.deb

## Install Conda
#RUN wget \
#    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#    && mkdir /root/.conda \
#    && bash Miniconda3-latest-Linux-x86_64.sh -b \
#    && rm -f Miniconda3-latest-Linux-x86_64.sh 

#RUN export PATH="/home/$NB_USER/opt/miniconda3/bin":$PATH

#RUN conda --version

#RUN conda update conda

#RUN conda install -c conda-forge scikit-image \
    #voila \ 
    #elyra \
    #opencv \
    #nibabel \
    #libopencv \
    #nbclassic \
    #bioblend \
    #jupyterlab
    #bioconda \
    #kalign2=2.04 \
    #hhsuite=3.3.0

#RUN conda install -y -q -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0 nbclassic

# Python packages
#RUN /usr/bin/python3 -m pip install --upgrade pip

RUN pip install --no-cache-dir \
    "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" \
    tensorflow==2.7.0 \
    tensorflow-probability==0.15.0 \
    onnx \
    onnx-tf \
    tf2onnx \
    skl2onnx \
    scikit-image \
    opencv-python \
    nibabel \
    onnxruntime \
    bioblend \
    galaxy-ie-helpers \
    nbclassic \
    jupyterlab-git \
    jupyter_server \
    jupyterlab \
    jupytext \
    lckr-jupyterlab-variableinspector \
    jupyterlab_execute_time \
    xeus-python \
    jupyterlab-kernelspy \
    jupyterlab-system-monitor \
    jupyterlab-fasta \
    jupyterlab-geojson \
    jupyterlab-topbar \
    #jupyterlab_nvdashboard \
    bqplot \
    aquirdturtle_collapsible_headings \
    "jax[cpu]"

RUN pip install --no-cache-dir elyra>=2.0.1 && jupyter lab build

#RUN jupyter lab build

RUN pip install --no-cache-dir voila

#RUN pip install --upgrade "jax[cuda11_cudnn82]" -f https://storage.googleapis.com/jax-releases/jax_releases.html

#RUN pip install "jax[cpu]"

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN conda --version

RUN conda install -y -q -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0

ADD ./startup.sh /startup.sh
ADD ./get_notebook.py /get_notebook.py

RUN mkdir -p /home/$NB_USER/.ipython/profile_default/startup/
RUN mkdir /import

COPY ./galaxy_script_job.py /home/$NB_USER/.ipython/profile_default/startup/00-load.py
COPY ./ipython-profile.py /home/$NB_USER/.ipython/profile_default/startup/01-load.py
COPY ./jupyter_notebook_config.py /home/$NB_USER/.jupyter/

ADD ./*.ipynb /home/$NB_USER/

RUN mkdir /home/$NB_USER/notebooks/
RUN mkdir /home/$NB_USER/elyra/

COPY ./notebooks/*.ipynb /home/$NB_USER/notebooks/
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
    DISABLE_AUTH=true \
    GALAXY_URL=none

RUN chown -R $NB_USER:users /home/$NB_USER /import 
#/usr/local/cuda-11.6

WORKDIR /import

CMD /startup.sh
