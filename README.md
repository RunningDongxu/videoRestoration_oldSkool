# videoRestoration_oldSkool

## How to use

Simply run the `denoise_test.m` which should add the subfolders to Matlab paths (tested on Ubuntu 16.04, Matlab R2016a), and processes the input test frames from `testData`

## Structure of the pipeline

### Denoising

We are using the *de facto* denoising standard [BM4D {1}](http://www.cs.tut.fi/~foi/GCF-BM3D/) to denoise the images that is optimized for volumetric images whereas the video-optimized [VBM4D {2}](http://www.cs.tut.fi/~foi/GCF-BM3D/) could have been a better choice but it would have required a Wavelet Toolbox.

_{1} Maggioni, Matteo, et al. "Nonlocal transform-domain filter for volumetric data denoising and reconstruction." IEEE transactions on image processing 22.1 (2013): 119-133. [doi: 10.1109/TIP.2012.2210725](https://doi.org/10.1109/TIP.2012.2210725)_

_{2} Maggioni, Matteo, et al. "Video denoising, deblocking, and enhancement through separable 4-D nonlocal spatiotemporal transforms." IEEE Transactions on image processing 21.9 (2012): 3952-3966. [doi: 10.1109/TIP.2012.2199324](https://doi.org/10.1109/TIP.2012.2199324)_

For further improvement of this block you could consider some single-image based deep learning solutions {3,4} or some video-based deep learning approach such as "Deep RNNs for video denoising" {5}

_{3} Vemulapalli, Raviteja, Oncel Tuzel, and Ming-Yu Liu. "Deep gaussian conditional random field network: A model-based deep network for discriminative denoising." Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition. 2016. [arXiv: 1511.04067](https://arxiv.org/abs/1511.04067)_

_{4} Zhang, Jiawei, et al. "Learning Fully Convolutional Networks for Iterative Non-blind Deconvolution." arXiv preprint arXiv:1611.06495 (2016). [arXiv: 1611.06495](https://arxiv.org/abs/1611.06495)_

_{5} Chen, Xinyuan, Li Song, and Xiaokang Yang. "Deep RNNs for video denoising." SPIE Optical Engineering+ Applications. International Society for Optics and Photonics, 2016. [doi: 10.1117/12.2239260](https://dx.doi.org/10.1117/12.2239260)_

### Edge-Aware Smoothing


### Edge Detection



### Contrast Equalization
