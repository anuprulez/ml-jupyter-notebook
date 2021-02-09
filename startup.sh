#!/bin/bash

export PATH=/home/$NB_USER/.local/bin:$PATH

chown $NB_USER /home/$NB_USER/tensorflow_notebook.ipynb
jupyter trust /home/$NB_USER/tensorflow_notebook.ipynb

jupyter notebook --ip=0.0.0.0 --port=8888 --notebook-dir=/home/$NB_USER --allow-root --no-browser
