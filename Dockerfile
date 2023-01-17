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
    #add-apt-repository ppa:deadsnakes/ppa && apt-get update && apt-get install -y python3.9 python3.9-dev python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen


RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt install -y python3.8 python3.8-dev python3-pip python3.8-distutils gfortran libopenblas-dev liblapack-dev

#RUN echo python --version

# set python 3 as the default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
    
#RUN update-alternatives --set python /usr/bin/python3.9
 
RUN alias python=/usr/bin/python3.8
   
RUN python3.8 -m pip install --upgrade pip requests setuptools pipenv

# make requests library use the Debian CA bundle (includes Zalando CA)
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

ENV PATH=/usr/bin/python3.8:$PATH

#RUN ln -sfn /usr/bin/python3.9 /usr/bin/python3 && ln -sfn /usr/bin/python3 /usr/bin/python && ln -sfn /usr/bin/pip3 /usr/bin/pip

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

RUN python3.8 -m pip install --upgrade pip

# Python packages
RUN python3.8 -m pip install \
    "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" \
    #colabfold==1.2.0 \
    #alphafold-colabfold==2.1.16 \
    #onnx==1.12.0 \
    #onnx-tf==1.10.0 \
    #tf2onnx==1.13.0 \
    #skl2onnx==1.13 \
    #scikit-image==0.19.3 \
    #opencv-python==4.6.0.66 \
    #nibabel==4.0.2 \
    #onnxruntime==1.13.1 \
    bioblend==1.0.0 \
    galaxy-ie-helpers==0.2.5 \
    numba==0.56.4 \
    #aquirdturtle_collapsible_headings==3.1.0 \
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
    jupyterlab-topbar==0.6.1
    #seaborn==0.12.1 \
    #elyra==3.8.0 \
    #voila==0.3.5 \
    #bqplot==0.12.36
    #pytz==2022.7 \
    #pyrsistent==0.19.2 \
    #pyparsing==3.0.9 \
    #pylint==2.15.6 \
    #Pygments==2.13.0 \
    #pydocstyle==6.1.1 \
    #PyNaCl==1.5.0 \
    #python-dateutil==2.8.2 \
    #python-lsp-jsonrpc==1.0.0 \
    #PyJWT==2.3.0 \
    #ujson==5.2.0 \
    #urllib3==1.26.7 \
    #watchdog==2.1.7 \
    #tqdm==4.62.3 \
    #traitlets==5.1.1 \
    #traittypes==0.2.1 \
    #tomlkit==0.10.1 \
    #tifffile==2021.11.2 \
    #terminado==0.12.1 \
    #protobuf==3.16.0 \
    #prompt-toolkit==3.0.22 \
    #mpmath==1.2.1 \
    #mistune==0.8.4 \
    #pathspec==0.9.0

#COPY requirements.txt requirements.txt
#RUN python3.9 -m pip install -r requirements.txt

#RUN python3.9 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"

#RUN python3.9 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"

RUN conda install -c conda-forge mamba python==3.8

#RUN mamba install -y -q -c conda-forge -c bioconda \
    #onnx \
    #onnx-tf \
    #tf2onnx \
    #skl2onnx \
    #scikit-image \
    #opencv \
    #nibabel \
    #onnxruntime \
    #bioblend==1.0.0 \
    #galaxy-ie-helpers====0.2.5 \
    #numba====0.56.4 \
    #jupyterlab-nvdashboard==0.7.0 \
    #bokeh==2.4.0 \
    #jupyter_server==1.15.0 \
    #jupyterlab==3.3.4 \
    #nbclassic==0.4.8 \
    #jupyterlab-git==0.39.3 \
    #jupytext==1.14.1
    #jupyterlab-execute-time==2.3.0 \
    #jupyterlab-kernelspy==3.1.0 \
    #jupyterlab-system-monitor==0.8.0 \
    #jupyterlab-topbar==0.6.1 \
    #seaborn==0.12.1 \
    #elyra==3.8.0 \
    #voila==0.3.5 \
    #bqplot==0.12.36

#RUN mamba install -y -q -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0

#RUN python3.9 -m pip install jax==0.3.24 jaxlib==0.3.24 "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"

#RUN mamba install -y -q -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0

#RUN python3.9 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
#RUN python3.9 -m pip install -q "jax[cuda]>=0.3.8,<0.4" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
# For template-based predictions also install kalign and hhsuite

RUN mamba install -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0

RUN python3.8 -m pip install \
    jax==0.3.24 \
    jaxlib==0.3.24 \
    dm-haiku==0.0.7 \
    tensorflow-gpu==2.7.0 \
    tensorflow_probability==0.15.0
    #colabfold[alphafold]
    #tensorflow-cpu==2.7.0
    #"colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"

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
