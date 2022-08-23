# Contributing to 

Following steps can be followed to start contributing to this project:

1. Fork this repository ([Galaxy Jupyterlab](https://github.com/anuprulez/ml-jupyter-notebook)).
2. Create a new branch.
3. Install Docker (version: 20.10.13) on the host machine
4. New packages can be added or existing packages can be updated in the Dockerfile
5. Container can be built, run and updated in docker hub:
    - `docker build -t new_container:latest .`
    - `docker tag new_container:latest <<docker username>>/<<new tag name>>`
    - `docker push <<docker username>>/<<new tag name>>`

## Contributors
1. [Anup Kumar](https://github.com/anuprulez) (Main contributor: developed the project).
2. [Gianmauro Cuccuru](https://github.com/gmauro) (Deployed the project on Galaxy Europe (https://usegalaxy.eu/)).
3. [Björn Grüning](https://github.com/bgruening) (Devised the idea of the project).
4. ...
