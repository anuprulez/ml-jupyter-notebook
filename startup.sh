#!/bin/bash

# The IPython image starts as privileged user.
# The parent Galaxy server is mounting data into /import with the same 
# permissions as the Galaxy server is running on.
# In case of 1450 as UID and GID we are fine, because our preconfigured ipython
# user owns this UID/GID. 
# (1450 is the user id the Galaxy-Docker Image is using)
# If /import is not owned by 1450 we need to create a new user with the same
# UID/GID as /import and make everything accessible to this new user.
#
# In the end the IPython Server is started as non-privileged user. Either
# with the UID 1450 (preconfigured jupyter user) or a newly created 'galaxy' user
# with the same UID/GID as /import.

export PATH=/home/$NB_USER/.local/bin:$PATH

python /get_notebook.py

if [ ! -f /import/home_page.ipynb ]; then
    cp /home/$NB_USER/*.ipynb /import/
    chown $NB_USER /import/*.ipynb
fi

mkdir /import/elyra/
cp /home/$NB_USER/elyra/*.* /import/elyra/

mkdir /import/data/
cp /home/$NB_USER/data/*.tsv /import/data/

mkdir /import/notebooks/
cp /home/$NB_USER/notebooks/*.ipynb /import/notebooks/

mkdir /import/usecases/
cp /home/$NB_USER/usecases/*.ipynb /import/usecases/

chown $NB_USER /import/elyra/*.*
chown $NB_USER /import/data/*.tsv

jupyter trust /import/*.ipynb
jupyter trust /import/elyra/*.ipynb
jupyter trust /import/notebooks/*.ipynb
jupyter trust /import/usecases/*.ipynb

jupyter lab --no-browser
