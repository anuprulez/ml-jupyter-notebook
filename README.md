# Docker container for Tensorflow in Jupyter Notebook

## Steps to run:

1. `docker pull anupkumar/docker-ml-jupyterlab:galaxy-integration`

2. `docker run -it -p 8888:8888 -v <<local folder>>:/import anupkumar/docker-ml-jupyterlab:galaxy-integration`

3. (If running on NVIDIA GPUs) `docker run -it --gpus all -p 8888:8888 -v <<local folder>>:/import anupkumar/docker-ml-jupyterlab:galaxy-integration`
