# Jupyter container used for Galaxy IPython Notebook Integration

FROM jupyter/tensorflow-notebook:latest

MAINTAINER Anup Kumar, anup.rulez@gmail.com

ENV DEBIAN_FRONTEND noninteractive

# Install system libraries first as root
USER root

RUN apt-get -qq update && apt-get install --no-install-recommends -y libcurl4-openssl-dev libxml2-dev \
    apt-transport-https python-dev libc-dev pandoc pkg-config liblzma-dev libbz2-dev libpcre3-dev \
    build-essential libblas-dev liblapack-dev gfortran libzmq3-dev libyaml-dev libxrender1 fonts-dejavu \
    libfreetype6-dev libpng-dev net-tools procps libreadline-dev wget software-properties-common octave \
    # IHaskell dependencies
    zlib1g-dev libtinfo-dev libcairo2-dev libpango1.0-dev && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER jovyan

# Python packages
RUN pip install --no-cache-dir tensorflow bioblend galaxy-ie-helpers

ADD ./startup.sh /startup.sh
ADD ./monitor_traffic.sh /monitor_traffic.sh
ADD ./get_notebook.py /get_notebook.py

USER root

# /import will be the universal mount-point for Jupyter
# The Galaxy instance can copy in data that needs to be present to the Jupyter webserver
RUN mkdir /import


# We can get away with just creating this single file and Jupyter will create the rest of the
# profile for us.
RUN mkdir -p /home/kumara/.ipython/profile_default/startup/
RUN mkdir -p /home/kumara/.jupyter/custom/

COPY ./ipython-profile.py /home/kumara/.ipython/profile_default/startup/00-load.py
COPY ./jupyter_server_config.py /home/kumara/.jupyter/

ADD ./custom.js /home/kumara/.jupyter/custom/custom.js
ADD ./custom.css /home/kumara/.jupyter/custom/custom.css
ADD ./default_notebook.ipynb /home/kumara/notebook.ipynb

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

#RUN mkdir /export/ && chown -R kumara:users /home/kumara/ /import /export/

##USER jovyan

WORKDIR /import

# Jupyter will run on port 8888, export this port to the host system

# Start Jupyter Notebook
CMD /startup.sh
