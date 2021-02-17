#!/bin/bash

#export LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

if [ ! -f /import/tensorflow_notebook.ipynb ]; then
    cp /home/$NB_USER/tensorflow_notebook.ipynb /import/tensorflow_notebook.ipynb
    chown $NB_USER /import/tensorflow_notebook.ipynb
fi

jupyter trust /import/tensorflow_notebook.ipynb

jupyter notebook --port=8888 --allow-root --no-browser
