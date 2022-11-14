#https://hub.docker.com/r/ceshine/cuda-pytorch/~/dockerfile/
#https://tsaprailis.com/2017/10/10/Docker-for-data-science-part-1-building-jupyter-container/

#FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive

# Instal basic utilities
RUN apt-get update && apt-get -yq dist-upgrade \
  && apt-get -y install  apt-utils \
  && apt-get install -yq --no-install-recommends \
        wget \
        bzip2 \
        ca-certificates \
        sudo \
        locales \
        fonts-liberation \
        build-essential \
        emacs \
        git \
        inkscape \
        jed \
        libsm6 \
        libxext-dev \
        libxrender1 \
        lmodern \
        netcat \
        pandoc \
        python3-dev \
        texlive-fonts-extra \
        texlive-fonts-recommended \
        #texlive-generic-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        texlive-xetex \
        unzip \
        nano \
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



ADD fix-permissions /usr/local/bin/fix-permissions
RUN chmod 777 /usr/local/bin
RUN chmod 777 /usr/local/bin/fix-permissions


# Create jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN groupadd wheel -g 11 && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    chmod 777 $HOME && \
    chmod 777 $CONDA_DIR

USER $NB_UID

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work && \
    chmod 777 /home/$NB_USER && \
    chmod 777 /home/$NB_USER/work


# Install conda as jovyan and check the md5 sum provided on the download site
#ENV MINICONDA_VERSION py39_4.12.0
#RUN cd /tmp && \
    #wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    #echo "a946ea1d0c4a642ddf0c3a26a18bb16d *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    #/bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    #rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    #$CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    #$CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    #$CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    #$CONDA_DIR/bin/conda install --quiet --yes conda="${MINICONDA_VERSION%.*}.*" && \
    #$CONDA_DIR/bin/conda update --all --quiet --yes && \
    #conda clean -tipsy && \
    #rm -rf /home/$NB_USER/.cache/yarn && \
    #fix-permissions $CONDA_DIR && \
    #fix-permissions /home/$NB_USER

ENV CONDA_DIR /opt/conda

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -f -b -p /opt/conda

ENV PATH=$CONDA_DIR/bin:$PATH

# Install Tini
RUN conda install --quiet --yes 'tini=0.18.0' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    ##conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install Jupyter Notebook, Lab, and Hub
# Generate a notebook server config
# Cleanup temporary files
# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
RUN conda install --quiet --yes \
    jupyterlab && \
    #'notebook=5.6.*' \
    #'jupyterhub=0.9.*' \
    #'jupyterlab=0.34.*' && \
    #conda clean -tipsy && \
    #jupyter labextension install @jupyterlab/hub-extension@^0.11.0 && \
    #npm cache clean --force && \
    #jupyter notebook --generate-config && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


RUN conda install -y h5py scikit-learn matplotlib seaborn scikit-image  scipy pandas mkl-service cython 
  #conda clean -tipsy

RUN pip install tensorflow-gpu==2.7.0

USER root

#EXPOSE 8888
#WORKDIR /import

# Configure container startup
#ENTRYPOINT ["tini", "-g", "--"]

ADD ./startup.sh /startup.sh
ADD ./get_notebook.py /get_notebook.py

RUN mkdir -p /home/$NB_USER/.ipython/profile_default/startup/
RUN mkdir /import

COPY ./galaxy_script_job.py /home/$NB_USER/.ipython/profile_default/startup/00-load.py
COPY ./ipython-profile.py /home/$NB_USER/.ipython/profile_default/startup/01-load.py

COPY ./jupyter_notebook_config.py /home/$NB_USER/.jupyter/
#COPY /home/.jupyter/jupyter_notebook_config.py /home/$NB_USER/.jupyter/

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

#CMD ["start-notebook.sh"]



# Add local files as late as possible to avoid cache busting
#COPY jupyter/start.sh /usr/local/bin/
#COPY jupyter/start-notebook.sh /usr/local/bin/
#COPY jupyter/start-singleuser.sh /usr/local/bin/
#COPY jupyter/jupyter_notebook_config.py /etc/jupyter/
#RUN fix-permissions /etc/jupyter/

#RUN chmod +x /usr/local/bin/start-*
#RUN chmod 777 /home/$NB_USER/work

# Switch back to jovyan to avoid accidental container runs as root
#USER $NB_UID

