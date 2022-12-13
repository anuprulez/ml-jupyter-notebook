# Spatial transforms

Whenever we need to change the voxel size of images or move/rotate their content, we are applying spatial transforms. Most commonly these operations are applied when registering image data. Image registation is the process of determining the transform that is necessary so that two images fit well together if overlayed. After this transform has been determined, images can be fused. When image acquisition produces tiled datasets, multiple images of different positions in the same field of view, which partially overlap, image registation can be applied to put these images together in one scene. We call this process image stitching.

See also
* [Image registration (video)](https://youtu.be/3CGC-5vwraM)