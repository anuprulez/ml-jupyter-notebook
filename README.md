# GPU-enabled docker container with Jupyterlab for artificial intelligence

[![bio.tools entry](https://img.shields.io/badge/bio.tools-gpu-enabled_docker_container_with_jupyterlab_for_ai.svg)](https://bio.tools/gpu-enabled_docker_container_with_jupyterlab_for_ai) [![RRID entry](https://img.shields.io/badge/RRID-SCR_022695-blue.svg)](https://scicrunch.org/scicrunch/Resources/source/nlx_144509-1/search?q=SCR_018491&l=SCR_022695)
## Steps to run:

1. `docker pull anupkumar/docker-ml-jupyterlab:galaxy-integration`

2. `docker run -it -p 8888:8888 -v <<local folder>>:/import anupkumar/docker-ml-jupyterlab:galaxy-integration`

3. (If running on NVIDIA GPUs) `docker run -it --gpus all -p 8888:8888 -v <<local folder>>:/import anupkumar/docker-ml-jupyterlab:galaxy-integration`
