# GPU-enabled docker container with Jupyterlab for artificial intelligence

[![bio.tools entry](https://img.shields.io/badge/bio.tools-gpu-enabled_docker_container_with_jupyterlab_for_ai.svg)](https://bio.tools/gpu-enabled_docker_container_with_jupyterlab_for_ai) [![RRID entry](https://img.shields.io/badge/RRID-SCR_022695-blue.svg)](https://scicrunch.org/resources/about/registry/SCR_022695)


## General information

Project name: An accessible infrastructure for artificial intelligence using a docker-based Jupyterlab in Galaxy

Project home page: https://github.com/anuprulez/ml-jupyter-notebook, 

Docker file: https://github.com/anuprulez/ml-jupyter-notebook/blob/master/Dockerfile

Container at Docker hub: https://hub.docker.com/r/anupkumar/docker-ml-jupyterlab (tag: galaxy-integration-0.1)

Galaxy tool (that runs this container): https://github.com/usegalaxy-eu/galaxy/blob/release_22.01_europe/tools/interactive/interactivetool_ml_jupyter_notebook.xml

Data: https://zenodo.org/record/6091361 (to run sample notebooks at https://github.com/anuprulez/gpu_jupyterlab_ct_image_segmentation)

Operating system(s): Linux

Programming language(s): Python, Docker, XML

iPython sample notebooks: https://github.com/anuprulez/gpu_jupyterlab_ct_image_segmentation

Other requirements: Docker 20.10.13, (Optional) CUDA 11.6, CUDA DNN 8


## Running steps:

1. Download container: `docker pull anupkumar/docker-ml-jupyterlab:galaxy-integration-0.1`

2. Run container (on host without Nvidia GPU): `docker run -it -p 8888:8888 -v <<path to local folder>>:/import anupkumar/docker-ml-jupyterlab:galaxy-integration-0.1`

3. Run container (on host with Nvidia GPU): `docker run -it --gpus all -p 8888:8888 -v <<path to local folder>>:/import anupkumar/docker-ml-jupyterlab:galaxy-integration-0.1`

4. Open the link to the Jupyterlab (e.g. `http://<<host>>:8888/ipython/lab`)

License: MIT License

RRID: SCR_022695

bioToolsID: gpu-enabled_docker_container_with_jupyterlab_for_ai


## List of packages for Machine learning and deep learning

- Python (version: 3.9.7)
- Jupyterlab (version: 3.3.2)
- Jupyterlab-git (version: 0.36.0)
- Scikit learn (version: 1.0.1)
- Scikit image (version: 0.18.3)
- Tensorflow-GPU (version: 2.7.0)
- ONNX (version: 1.11.0)
- Nibabel (3.2.2)
- OpenCV (version: 4.5.5)
- CUDA (version: 11.7)
- CUDA DNN (version: 8)
- Bqplot (version: 0.12.33)
- Bokeh (version: 2.3.3)
- Matplotlib (version: 3.1.3)
- Seaborn (version: 0.11.2)
- Voila (version: 0.3.5)
- Jupyterlab-nvdashboard (version: 0.6.0)
- Py3Dmol (version: 1.8.0)
- Elyra AI (version: 3.7.0)
- Colabfold (version: 1.2.0)
- Bioblend (version: 0.16.0)
- Biopython (version: 1.79)
- many more ...
