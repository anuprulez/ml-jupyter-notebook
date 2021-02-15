#!/bin/bash

cp /home/$NB_USER/tensorflow_notebook.ipynb /home/$NB_USER/work/tensorflow_notebook.ipynb

chown $NB_USER /home/$NB_USER/work/tensorflow_notebook.ipynb

jupyter trust /home/$NB_USER/work/tensorflow_notebook.ipynb

jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --no-browser
