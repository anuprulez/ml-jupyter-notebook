## Jupyter container used for Data Science and Tensorflow
#FROM jupyter/tensorflow-notebook:tensorflow-2.6.0
#FROM tensorflow/tensorflow:nightly-gpu-jupyter
#FROM tensorflow/tensorflow:latest-gpu-jupyter
#FROM jupyter/minimal-notebook:python-3.9.12
#FROM jupyter/minimal-notebook:lab-3.5.0
#FROM jupyter/tensorflow-notebook:python-3.9.6
#FROM jupyter/minimal-notebook:python-3.9.12

#FROM tensorflow/tensorflow:2.7.4-gpu

#MAINTAINER Anup Kumar, anup.rulez@gmail.com

#ENV DEBIAN_FRONTEND noninteractive

#USER root 

#RUN apt-get -qq update && apt-get upgrade -y && apt-get install --no-install-recommends -y libcurl4-openssl-dev libxml2-dev \
#    apt-transport-https python3-dev python3-pip libc-dev pandoc pkg-config liblzma-dev libbz2-dev libpcre3-dev \
#    build-essential libblas-dev liblapack-dev libzmq3-dev libyaml-dev libxrender1 fonts-dejavu \
#    libfreetype6-dev libpng-dev net-tools procps libreadline-dev wget software-properties-common gnupg2 curl ca-certificates && \
#    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN apt-get -qq update && apt-get upgrade -y && apt-get install --no-install-recommends -y libfreetype6-dev apt-transport-https software-properties-common && \     
#    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
#RUN mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600

#RUN wget "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb" && dpkg -i cuda-keyring_1.0-1_all.deb && rm cuda-keyring_1.0-1_all.deb
#RUN add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
#RUN apt-get update
#RUN apt-get -y install cuda
#RUN apt-get -y install libcudnn8


#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
#RUN curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
#RUN curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
#RUN apt-get update && apt-get install -y nvidia-container-toolkit

#ENV PATH=/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#ENV CONDA_DIR /opt/conda

#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/lib
#RUN export LD_LIBRARY_PATH
#ENV LD_LIBRARY_PATH=/usr/lib64/nvidia/
#ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64

#RUN echo $PATH
#RUN echo $LD_LIBRARY_PATH

#ENV NVIDIA_VISIBLE_DEVICES=all
#ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

#ENV NVIDIA_REQUIRE_CUDA=cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411
#ENV LIBRARY_PATH=/usr/local/cuda/lib64/
#RUN echo $LIBRARY_PATH

#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
#RUN curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
#RUN curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
#      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
#      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
#            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
#            tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

#RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
#      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
#      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
#            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
#            tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

#RUN apt-get update && apt-get install -y nvidia-docker2

#ENV NVIDIA_VISIBLE_DEVICES=all
#ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

#RUN wget \
#    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#    && mkdir /root/.conda \
#    && bash Miniconda3-latest-Linux-x86_64.sh -b \
#    && rm -f Miniconda3-latest-Linux-x86_64.sh 

#RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
#     /bin/bash ~/miniconda.sh -b -p /opt/conda

#ENV PATH=$CONDA_DIR/bin:$PATH

#RUN conda --version

# Python packages
#RUN pip install --no-cache-dir \
#    "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" \
#    onnx \
#    onnx-tf \
#    tf2onnx \
#    skl2onnx \
#    scikit-image \
#    opencv-python \
#    nibabel \
#    onnxruntime \
#    bioblend \
#    numba \
#    aquirdturtle_collapsible_headings

#RUN pip install --no-cache-dir \
#    bioblend \
#    galaxy-ie-helpers \
#    tensorflow-gpu==2.7.0 \
#    tensorflow_probability==0.15.0

#RUN mamba install -y -q -c conda-forge -c bioconda \
#    jupyterlab-nvdashboard \
#    jupyter_server \
#    jupyterlab \
#    jupyter_bokeh \
    #nbclassic \
    #jupyterlab-git \
    #jupytext \
#    jupyterlab_execute_time \
    #xeus-python \
    #jupyterlab-kernelspy \
    #jupyterlab-system-monitor \
#    jupyterlab-topbar \
#    matplotlib \
#    seaborn \
    #"elyra[all]" \
#    voila \
#    bqplot

#RUN mamba install -y -q -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0

#RUN pip install --upgrade jax==0.3.10 jaxlib==0.3.10 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html


FROM nvidia/cuda:11.2.0-cudnn8-runtime-ubuntu20.04

USER root

ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive

# libcurl4-openssl-dev libxml2-dev \
#    apt-transport-https python3-dev python3-pip libc-dev pandoc pkg-config liblzma-dev libbz2-dev libpcre3-dev \
#    build-essential libblas-dev liblapack-dev libzmq3-dev libyaml-dev libxrender1 fonts-dejavu \
#    libfreetype6-dev libpng-dev net-tools procps libreadline-dev wget software-properties-common gnupg2 curl ca-certificates

# Instal basic utilities
RUN apt-get update && apt-get -yq dist-upgrade \
  && apt-get -y install  apt-utils \
  && apt-get install -yq --no-install-recommends \
        wget \
        curl \
        bzip2 \
        ca-certificates \
        sudo \
        locales \
        fonts-liberation \
        build-essential \
        #emacs \
        fonts-dejavu \
        git \
        gnupg2 \
        #inkscape \
        jed \
        libsm6 \
        libxext-dev \
        libfreetype6-dev \
        libpng-dev \
        libxrender1 \
        lmodern \
        netcat \
        pandoc \
        pkg-config \
        python3-dev \
        software-properties-common \
        #texlive-fonts-extra \
        #texlive-fonts-recommended \
        #texlive-generic-recommended \
        #texlive-latex-base \
        #texlive-latex-extra \
        #texlive-xetex \
        #unzip \
        #nano \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER


ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER="${NB_USER}" \
    NB_UID=${NB_UID} \
    NB_GID=${NB_GID} \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ENV PATH="${CONDA_DIR}/bin:${PATH}" \
    HOME="/home/${NB_USER}"

COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions

ADD fix-permissions /usr/local/bin/fix-permissions
RUN chmod 777 /usr/local/bin
RUN chmod 777 /usr/local/bin/fix-permissions

RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc && \
   # Add call to conda init script see https://stackoverflow.com/a/58081608/4413446
   echo 'eval "$(command conda shell.bash hook 2> /dev/null)"' >> /etc/skel/.bashrc

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -l -m -s /bin/bash -N -u "${NB_UID}" "${NB_USER}" && \
    mkdir -p "${CONDA_DIR}" && \
    chown "${NB_USER}:${NB_GID}" "${CONDA_DIR}" && \
    chmod g+w /etc/passwd && \
    fix-permissions "${HOME}" && \
    fix-permissions "${CONDA_DIR}"

#USER ${NB_UID}

# Pin python version here, or set it to "default"
ARG PYTHON_VERSION=3.9

RUN mkdir "/home/${NB_USER}/work" && \
    fix-permissions "/home/${NB_USER}"

# Create jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
#RUN groupadd wheel -g 11 && \
#    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
#    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
#    mkdir -p $CONDA_DIR && \
#    chown $NB_USER:$NB_GID $CONDA_DIR && \
#    chmod g+w /etc/passwd && \
#    chmod 777 $HOME && \
#    chmod 777 $CONDA_DIR

#USER $NB_UID

# Setup work directory for backward-compatibility
#UN mkdir /home/$NB_USER/work && \
RUN chmod 777 /home/$NB_USER && \
    chmod 777 /home/$NB_USER/work


# Install conda as jovyan and check the md5 sum provided on the download site
ENV MINICONDA_VERSION 4.12.0

#RUN cd /tmp && \
#    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
#    echo "a946ea1d0c4a642ddf0c3a26a18bb16d *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
#    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
#    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
#    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
#    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
#    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
#    $CONDA_DIR/bin/conda install --quiet --yes conda="${MINICONDA_VERSION%.*}.*" && \
#    $CONDA_DIR/bin/conda update --all --quiet --yes && \
#    conda clean -tipsy && \
#    rm -rf /home/$NB_USER/.cache/yarn && \
#    fix-permissions $CONDA_DIR && \
#    fix-permissions /home/$NB_USER

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -f -b -p $CONDA_DIR \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda install --quiet --yes conda && \
    $CONDA_DIR/bin/conda update --all --quiet --yes
    #conda clean -tipsy && \
    #rm -rf /home/$NB_USER/.cache/yarn \
    #&& fix-permissions $CONDA_DIR \
    #3& fix-permissions /home/$NB_USER


ENV CONDA_DIR /opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH


RUN conda --version

# Install Tini
#RUN conda install --quiet --yes 'tini=0.18.0' && \
#    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    #conda clean -tipsy && \
#    && fix-permissions $CONDA_DIR && \
#    && fix-permissions /home/$NB_USER

# Install Jupyter Notebook, Lab, and Hub
# Generate a notebook server config
# Cleanup temporary files
# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
# Python packages

RUN pip install --no-cache-dir \
    "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" \
    onnx \
    onnx-tf \
    tf2onnx \
    skl2onnx \
    scikit-image \
    opencv-python \
    nibabel \
    onnxruntime \
    bioblend \
    numba \
    aquirdturtle_collapsible_headings


RUN pip install --no-cache-dir \
    bioblend \
    galaxy-ie-helpers \
    tensorflow-gpu==2.7.0 \
    tensorflow_probability==0.15.0

RUN conda install -c conda-forge mamba

RUN mamba install -y -q -c conda-forge -c bioconda \
    jupyterlab-nvdashboard \
    jupyter_server \
    jupyterlab \
    jupyter_bokeh \
    nbclassic \
    jupyterlab-git \
    jupytext \
    jupyterlab_execute_time \
    xeus-python \
    jupyterlab-kernelspy \
    jupyterlab-system-monitor \
    jupyterlab-topbar \
    matplotlib \
    seaborn \
    "elyra[all]" \
    voila \
    bqplot


RUN mamba install -y -q -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0

RUN pip install --upgrade jax==0.3.10 jaxlib==0.3.10 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html


#RUN conda install -y -q -c conda-forge -c bioconda \
#    jupyter_server \
#    jupyterlab


#RUN pip install tensorflow-gpu


#RUN pip install jupytext


#RUN conda install -c conda-forge \
    #'notebook=5' \
    #'jupyterhub=0.9.*' \
    #jupyterlab \
    #tensorflow-gpu
    #conda clean -tipsy && \
    #jupyter labextension install @jupyterlab/hub-extension@^0.11.0 && \
    #npm cache clean --force && \
    #jupyter notebook --generate-config && \
    #rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    #rm -rf /home/$NB_USER/.cache/yarn && \
    #fix-permissions $CONDA_DIR && \
    #fix-permissions /home/$NB_USER


#RUN conda install -y h5py scikit-learn matplotlib seaborn scikit-image  scipy   \
#  pandas mkl-service cython && \
#  conda clean -tipsy


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


#EXPOSE 8888

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

USER $NB_UID

CMD /startup.sh
