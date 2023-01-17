FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ENV NB_USER="gpuuser"
ENV UID=999

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    git \
    ca-certificates \
    software-properties-common \
    locales \
    gcc pkg-config libfreetype6-dev libpng-dev g++ \
    pandoc \
    sudo \
    curl \
    libffi-dev \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

#RUN echo "**** Installing Python ****" && \
#    add-apt-repository ppa:deadsnakes/ppa &&  \
#    apt-get install -y build-essential python3.9 python3.9-dev python3-pip python3.9-distutils && \
#    curl -O https://bootstrap.pypa.io/get-pip.py && \
#    python3.9 get-pip.py && \
#    rm -rf /var/lib/apt/lists/*

ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER="${NB_USER}" \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    PATH="${CONDA_DIR}/bin:${PATH}" \
    HOME="/home/${NB_USER}"

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -l -m -s /bin/bash -u $UID $NB_USER && \
    mkdir -p "${CONDA_DIR}" && \
    chown -R "${NB_USER}" "${CONDA_DIR}" && \
    chmod g+w /etc/passwd

USER ${NB_USER}

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -f -b -p /opt/conda && rm -rf ~/miniconda.sh

ENV PATH=$CONDA_DIR/bin:$PATH
ENV PATH=/home/$NB_USER/.local/bin:$PATH

RUN conda --version

# Python packages
RUN pip install \
    #"colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" \
    onnx==1.12.0 \
    onnx-tf==1.10.0 \
    tf2onnx==1.13.0 \
    skl2onnx==1.13 \
    scikit-image==0.19.3 \
    opencv-python==4.6.0.66 \
    nibabel==4.0.2 \
    onnxruntime==1.13.1 \
    bioblend==1.0.0 \
    galaxy-ie-helpers==0.2.5 \
    numba==0.56.4 \
    aquirdturtle_collapsible_headings==3.1.0 \
    jupyterlab-nvdashboard==0.7.0 \
    bokeh==2.4.0 \
    jupyter_server==1.15.0 \
    jupyterlab==3.3.4 \
    nbclassic==0.4.8 \
    jupyterlab-git==0.39.3 \
    jupytext==1.14.1 \
    jupyterlab-execute-time==2.3.0 \
    jupyterlab-kernelspy==3.1.0 \
    jupyterlab-system-monitor==0.8.0 \
    jupyterlab-topbar==0.6.1 \
    seaborn==0.12.1
    #elyra==3.8.0 \
    #voila==0.3.5 \
    #bqplot==0.12.36
    #pytz==2022.7 \
    #pyrsistent==0.19.2 \
    #pyparsing==3.0.9 \
    #pylint==2.15.6 \
    #Pygments==2.13.0

#RUN conda install -c conda-forge mamba
#RUN mamba install -y -q -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0

RUN pip install jax==0.3.24 jaxlib==0.3.24 dm-haiku==0.0.7 tensorflow-gpu==2.8.0 tensorflow_probability==0.15.0

USER root 

RUN mkdir -p /home/$NB_USER/.ipython/profile_default/startup/
RUN mkdir -p /import
RUN mkdir -p /home/$NB_USER/notebooks/
RUN mkdir -p /home/$NB_USER/usecases/
RUN mkdir -p /home/$NB_USER/elyra/
RUN mkdir -p /home/$NB_USER/data

COPY ./startup.sh /startup.sh
COPY ./get_notebook.py /get_notebook.py

COPY ./galaxy_script_job.py /home/$NB_USER/.ipython/profile_default/startup/00-load.py
COPY ./ipython-profile.py /home/$NB_USER/.ipython/profile_default/startup/01-load.py
COPY ./jupyter_notebook_config.py /home/$NB_USER/.jupyter/

COPY ./*.ipynb /home/$NB_USER/

COPY ./notebooks/*.ipynb /home/$NB_USER/notebooks/
COPY ./usecases/*.ipynb /home/$NB_USER/usecases/
COPY ./elyra/*.* /home/$NB_USER/elyra/

COPY ./data/*.tsv /home/$NB_USER/data/

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

RUN chown -R $NB_USER /home/$NB_USER /import

USER ${NB_USER}

WORKDIR /import

CMD /startup.sh
