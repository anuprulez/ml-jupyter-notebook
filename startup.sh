#!/bin/bash

#cp /home/$NB_USER/tensorflow_notebook.ipynb /home/$NB_USER/tensorflow_notebook.ipynb
#chown $NB_USER /home/$NB_USER/tensorflow_notebook.ipynb
#jupyter trust /home/$NB_USER/tensorflow_notebook.ipynb

cp /home/$NB_USER/tensorflow_notebook.ipynb /import/tensorflow_notebook.ipynb

chown $NB_USER /import/tensorflow_notebook.ipynb

jupyter trust /import/tensorflow_notebook.ipynb

jupyter notebook --port=8888 --allow-root --no-browser
