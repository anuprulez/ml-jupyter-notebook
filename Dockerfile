FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

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
    net-tools \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV PYTHON_VERSION=3.9

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt install -y python$PYTHON_VERSION python$PYTHON_VERSION-dev python3-pip python$PYTHON_VERSION-distutils gfortran libopenblas-dev liblapack-dev

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
 
RUN alias python=/usr/bin/python$PYTHON_VERSION
   
RUN python$PYTHON_VERSION -m pip install --upgrade pip requests setuptools pipenv

ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

ENV PATH=/usr/bin/python$PYTHON_VERSION:$PATH

RUN if [ "${NB_USER}" = "root" ]; then ln -s /root /home/root; fi

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
    #useradd -l -m -s /bin/bash -u $UID $NB_USER && \
    mkdir -p "${CONDA_DIR}" && \
    chown -R "${NB_USER}" "${CONDA_DIR}" && \
    chmod g+w /etc/passwd

USER ${NB_USER}

ENV PATH=$CONDA_DIR/bin:$PATH
ENV PATH=/home/$NB_USER/.local/bin:$PATH

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -f -b -p /opt/conda && rm -rf ~/miniconda.sh

RUN conda install -c conda-forge mamba python=$PYTHON_VERSION
RUN conda install -y -q -c "nvidia/label/cuda-11.8.0" cuda-nvcc

RUN python$PYTHON_VERSION -m pip install \
    bioblend==1.0.0 \
    galaxy-ie-helpers==0.2.7 \
    numba \
    aquirdturtle_collapsible_headings \
    jupyterlab-nvdashboard \
    bokeh \
    jupyter_server==1.21.0 \
    jupyterlab==3.6.5 \
    nbclassic \
    jupyterlab-git \
    jupytext \
    jupyterlab-execute-time \
    jupyterlab-kernelspy \
    jupyterlab-system-monitor \
    jupyterlab-topbar \
    onnx==1.12.0 \
    onnx-tf==1.10.0 \
    tf2onnx==1.13.0 \
    skl2onnx==1.13 \
    wrapt==1.14.1 \
    scikit-image \
    opencv-python \
    nibabel \
    onnxruntime==1.13.1 \
    seaborn \
    voila \
    elyra \
    bqplot \
    biopython \
    jupyter_ai==1.0.0 \
    "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold@v1.2.0" \
    dm-haiku \
    ml-collections \
    "jax[cuda]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

RUN sed -i -e "s/jax.tree_flatten/jax.tree_util.tree_flatten/g" /opt/conda/lib/python$PYTHON_VERSION/site-packages/alphafold/model/mapping.py
RUN sed -i -e "s/jax.tree_unflatten/jax.tree_util.tree_unflatten/g" /opt/conda/lib/python$PYTHON_VERSION/site-packages/alphafold/model/mapping.py

RUN python$PYTHON_VERSION -m pip install \
    tensorflow-gpu==2.7.0 \
    tensorflow_probability==0.15.0

RUN conda install -y -q -c bioconda kalign3=3.2.2 hhsuite=3.3.0

RUN python$PYTHON_VERSION -m pip install numpy==1.20.0 pandas scipy

RUN python$PYTHON_VERSION -m pip install py3Dmol==2.0.0.post2

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
    GALAXY_URL=none

RUN chown -R $NB_USER /home/$NB_USER /import

USER ${NB_USER}

WORKDIR /import

CMD /startup.sh
