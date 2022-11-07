## Jupyter container used for Data Science and Tensorflow
#FROM jupyter/tensorflow-notebook:tensorflow-2.6.0
#FROM tensorflow/tensorflow:nightly-gpu-jupyter
#FROM tensorflow/tensorflow:latest-gpu-jupyter
FROM jupyter/minimal-notebook:python-3.9.12
#FROM jupyter/minimal-notebook:lab-3.5.0
#FROM jupyter/tensorflow-notebook:python-3.9.6
#FROM jupyter/minimal-notebook:python-3.9.12

MAINTAINER Anup Kumar, anup.rulez@gmail.com

ENV DEBIAN_FRONTEND noninteractive

USER root 

#RUN apt-get -qq update && apt-get upgrade -y && apt-get install --no-install-recommends -y libcurl4-openssl-dev libxml2-dev \
#    apt-transport-https python3-dev python3-pip libc-dev pandoc pkg-config liblzma-dev libbz2-dev libpcre3-dev \
#    build-essential libblas-dev liblapack-dev libzmq3-dev libyaml-dev libxrender1 fonts-dejavu \
#    libfreetype6-dev libpng-dev net-tools procps libreadline-dev wget software-properties-common gnupg2 curl ca-certificates && \
#    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN apt-get -qq update && apt-get upgrade -y && apt-get install --no-install-recommends -y apt-transport-https software-properties-common && \     
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
#RUN curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
#RUN curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
#      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
#      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
#            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
#            tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

#RUN apt-get update && apt-get install -y nvidia-container-toolkit 

#RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64

#RUN export PATH=$PATH:/lib/lib64


#nvidia-docker2 libnvidia-container1 libnvidia-container-tools

#RUN apt-get -y install libcudnn8

#RUN systemctl restart docker

# Install CUDA Toolkit and CuDNN
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
RUN mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600

RUN wget "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb" && dpkg -i cuda-keyring_1.0-1_all.deb && rm cuda-keyring_1.0-1_all.deb
RUN add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
RUN apt-get update
RUN apt-get -y install cuda
RUN apt-get -y install libcudnn8


RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN conda --version

#RUN mamba install -y -q -c conda-forge -c bioconda \
#    tensorflow-gpu \
#    tensorflow-probability \
#    jupyterlab-nvdashboard \
#    jupyter_server \
#    jupyterlab \
#    jupyter_bokeh \
    #nbclassic \
#    jupyterlab-git \
    #jupytext \
    #jupyterlab_execute_time \
    #xeus-python \
    #jupyterlab-kernelspy \
#    jupyterlab-system-monitor \
#    jupyterlab-topbar \
#    matplotlib \
#    seaborn
    #bqplot \
    #"elyra[all]" \
    #voila \
    #kalign2=2.04 \
    #hhsuite=3.3.0 \
    #onnx \
    #tf2onnx \
    #skl2onnx \
    #scikit-image \
    #nibabel \
    #onnxruntime

#RUN jupyter labextension install @voila-dashboards/jupyterlab-preview
#RUN mamba install -y -q -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0

# Python packages
RUN pip install --no-cache-dir \
    #"colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" \
    tensorflow-gpu==2.7.0 \
    tensorflow_probability==0.15.0 \
    jupyterlab \
    jupyterlab-nvdashboard \
    jupyter_server \
    #onnx \
    #onnx-tf \
    #tf2onnx \
    #skl2onnx \
    #scikit-image \
    #opencv-python \
    #nibabel \
    #onnxruntime \
    bioblend \
    galaxy-ie-helpers \
    #nbclassic \
    jupyterlab-git \
    #jupytext \ 
    #lckr-jupyterlab-variableinspector \
    jupyterlab_execute_time
    #xeus-python \
    #jupyterlab-kernelspy \
    #jupyterlab-system-monitor \
    #jupyterlab-fasta \
    #jupyterlab-geojson \
    #jupyterlab-topbar \
    #bqplot \
    #aquirdturtle_collapsible_headings

#RUN pip install --no-cache-dir 'elyra>=2.0.1' && jupyter lab build

#RUN pip install --no-cache-dir voila

#RUN pip install --upgrade jax==0.3.10 jaxlib==0.3.10 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

#RUN pip install numpy==1.20.3

#RUN wget \
#    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#    && mkdir /root/.conda \
#    && bash Miniconda3-latest-Linux-x86_64.sh -b \
#    && rm -f Miniconda3-latest-Linux-x86_64.sh 

#RUN conda --version

#RUN conda install -y -q cudatoolkit cudnn tensorflow-gpu 

#RUN conda install -y -q -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0

ADD ./startup.sh /startup.sh
ADD ./get_notebook.py /get_notebook.py

RUN mkdir -p /home/$NB_USER/.ipython/profile_default/startup/
RUN mkdir /import

COPY ./galaxy_script_job.py /home/$NB_USER/.ipython/profile_default/startup/00-load.py
COPY ./ipython-profile.py /home/$NB_USER/.ipython/profile_default/startup/01-load.py
COPY ./jupyter_notebook_config.py /home/$NB_USER/.jupyter/

ADD ./*.ipynb /home/$NB_USER/

RUN mkdir /home/$NB_USER/notebooks/
RUN mkdir /home/$NB_USER/usecases/
RUN mkdir /home/$NB_USER/elyra/

COPY ./notebooks/*.ipynb /home/$NB_USER/notebooks/
COPY ./usecases/*.ipynb /home/$NB_USER/usecases/
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

WORKDIR /import

CMD /startup.sh
