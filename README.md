# GPU-enabled docker container with Jupyterlab for artificial intelligence

[![bio.tools entry](https://img.shields.io/badge/bio.tools-gpu-enabled_docker_container_with_jupyterlab_for_ai.svg)](https://bio.tools/gpu-enabled_docker_container_with_jupyterlab_for_ai) [![RRID entry](https://img.shields.io/badge/RRID-SCR_022695-blue.svg)](https://scicrunch.org/resources/about/registry/SCR_022695)

# Published article: https://doi.org/10.1093/gigascience/giad028


## General information

Project name: An accessible infrastructure for artificial intelligence using a docker-based Jupyterlab in Galaxy

Project home page: https://github.com/anuprulez/ml-jupyter-notebook, 

Docker file: https://github.com/anuprulez/ml-jupyter-notebook/blob/master/Dockerfile

Container at Docker hub: https://hub.docker.com/r/anupkumar/docker-ml-jupyterlab (tag: galaxy-integration-0.2)

Galaxy tool (that runs this container): https://github.com/usegalaxy-eu/galaxy/blob/release_22.01_europe/tools/interactive/interactivetool_ml_jupyter_notebook.xml

Data: https://zenodo.org/record/6091361 (to run sample notebooks at https://github.com/anuprulez/gpu_jupyterlab_ct_image_segmentation)

How to use: Galaxy training network [tutorial](https://training.galaxyproject.org/training-material/topics/statistics/tutorials/gpu_jupyter_lab/tutorial.html)

Operating system(s): Linux

Programming language(s): Python, Docker, XML

iPython sample notebooks: https://github.com/anuprulez/gpu_jupyterlab_ct_image_segmentation

Other requirements: Docker 20.10.13, (Optional) CUDA 11.8, CUDA DNN 8

License: MIT License

RRID: [SCR_022695](https://scicrunch.org/resources/about/registry/SCR_022695)

bioToolsID: [gpu-enabled_docker_container_with_jupyterlab_for_ai](https://bio.tools/gpu-enabled_docker_container_with_jupyterlab_for_ai)


## Running steps:

1. Download container: `docker pull anupkumar/docker-ml-jupyterlab:galaxy-integration-0.2`

2. Run container (on host without Nvidia GPU): `docker run -it -p 8888:8888 -v <<path to local folder>>:/import anupkumar/docker-ml-jupyterlab:galaxy-integration-0.2`

3. Run container (on host with Nvidia GPU): `docker run -it --gpus all -p 8888:8888 -v <<path to local folder>>:/import anupkumar/docker-ml-jupyterlab:galaxy-integration-0.2`

4. Open the link to the Jupyterlab (e.g. `http://<<host>>:8888/ipython/lab`)

## List of packages for Machine learning and deep learning

- Python (version: 3.8.0)
- Jupyterlab (version: 3.3.4)
- Jupyterlab-git (version: 0.39.3)
- Scikit learn (version: 1.1.1)
- Scikit image (version: 0.19.3)
- Tensorflow-GPU (version: 2.7.0)
- ONNX (version: 1.12.0)
- Nibabel (4.0.2)
- OpenCV (version: 4.6.0.66)
- CUDA (version: 11.8)
- CUDA DNN (version: 8.6)
- Bqplot (version: 0.12.36)
- Bokeh (version: 2.4.0)
- Matplotlib (version: 3.1.3)
- Seaborn (version: 0.12.1)
- Voila (version: 0.3.5)
- Jupyterlab-nvdashboard (version: 0.7.0)
- Py3Dmol (version: 2.0.0.post2)
- Elyra AI (version: 3.14.1)
- Colabfold (version: 1.3.0)
- Bioblend (version: 1.0.0)
- Biopython (version: 1.79)
- many more ...
