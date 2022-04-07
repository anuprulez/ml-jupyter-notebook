## Jupyter container used for Tensorflow
FROM jupyter/tensorflow-notebook:tensorflow-2.6.0

MAINTAINER Anup Kumar, anup.rulez@gmail.com

ENV DEBIAN_FRONTEND noninteractive

USER root 

RUN apt-get -qq update && apt-get install --no-install-recommends -y libcurl4-openssl-dev libxml2-dev \
    apt-transport-https python3-dev python3-pip libc-dev pandoc pkg-config liblzma-dev libbz2-dev libpcre3-dev \
    build-essential libblas-dev liblapack-dev libzmq3-dev libyaml-dev libxrender1 fonts-dejavu \
    libfreetype6-dev libpng-dev net-tools procps libreadline-dev wget software-properties-common gnupg2 curl ca-certificates && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Python packages
RUN /usr/bin/python3 -m pip install --upgrade pip

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

RUN pip install --no-cache-dir voila

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
