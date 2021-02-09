#!/bin/bash

export PATH=/home/$NB_USER/.local/bin:$PATH

#python /get_notebook.py

#if [ ! -f /import/ipython_galaxy_notebook.ipynb ]; then
#    cp /home/$NB_USER/notebook.ipynb /import/ipython_galaxy_notebook.ipynb
#    chown $NB_USER /import/ipython_galaxy_notebook.ipynb
#fi

chown $NB_USER /home/$NB_USER/ipython_galaxy_notebook.ipynb
jupyter trust /home/$NB_USER/ipython_galaxy_notebook.ipynb

jupyter notebook --ip=0.0.0.0 --port=8888 --notebook-dir=/home/$NB_USER/ --allow-root --no-browser
#jupyter notebook --ip=0.0.0.0 --port=8888 --notebook-dir=/home/jovyan --allow-root --no-browser
