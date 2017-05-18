# videoRestoration_oldSkool

## How to use

Simply run the `denoise_test.m` which should add the subfolders to Matlab paths (tested on Ubuntu 16.04, Matlab R2016a), and processes the input test frames from `testData`

[![Output of processing](https://github.com/petteriTeikari/videoRestoration_oldSkool/blob/master/imgs/youtube.png)](https://www.youtube.com/watch?v=4FyJeGdhpZk)

### Tweaks

**BM4D** automatically estimates the noise level, and if you think that it constantly overestimates your noise, you could multiply with some factor less than one inside of `/BM4D/bm4d.m`

**L0 gradient smoothing** uses a "dumb" *lambda* parameter that depends heavily on your input data, so if you would replace the input retinal video with natural image, the same *lambda* would result in oversmoothed image.

### Video - Frame - Video - conversion

extract frames
https://ubuntuforums.org/showthread.php?t=1141293:
```bash
ffmpeg -i retinal_video.avi -y -f image2  filename%03d.png
```

do something for frames, e.g. crop
https://linuxacademy.com/blog/linux/cropping-multiple-images-the-same-way-short-tutorial/
```bash
mogrify -crop 114x113-18-17! *.png
```

and convert back:
https://askubuntu.com/questions/610903/how-can-i-create-a-video-file-from-a-set-of-jpg-images
```bash
ffmpeg -framerate 15 -i filename%03d.png -c:v libx264 -profile:v high -crf 10 -pix_fmt yuv420p output.mp4
```

### Output frame manipulation

Matlab .png outputs were resized and padded with Imagemagick

```bash
mogrify -resize 1868x1080 *.png
mogrify -extent 1920x1080 -gravity Center *.png
```

And then converted to a video using `ffmpeg`:

```bash
ffmpeg -framerate 10 -i denoised_video_frame_%07d.png -c:v libx264 -profile:v high -crf 10 -pix_fmt yuv420p output.mp4
```

## Structure of the pipeline

### Denoising

We are using the *de facto* denoising standard [BM4D {1}](http://www.cs.tut.fi/~foi/GCF-BM3D/) to denoise the images that is optimized for volumetric images whereas the video-optimized [VBM4D {2}](http://www.cs.tut.fi/~foi/GCF-BM3D/) could have been a better choice but it would have required a Wavelet Toolbox.

_{1} Maggioni, Matteo, et al. "Nonlocal transform-domain filter for volumetric data denoising and reconstruction." IEEE transactions on image processing 22.1 (2013): 119-133. [doi: 10.1109/TIP.2012.2210725](https://doi.org/10.1109/TIP.2012.2210725)_

_{2} Maggioni, Matteo, et al. "Video denoising, deblocking, and enhancement through separable 4-D nonlocal spatiotemporal transforms." IEEE Transactions on image processing 21.9 (2012): 3952-3966. [doi: 10.1109/TIP.2012.2199324](https://doi.org/10.1109/TIP.2012.2199324)_

#### Deep Learning

For further improvement of this block you could consider some single-image based deep learning solutions {3,4} or some video-based deep learning approach such as "Deep RNNs for video denoising" {5}

_{3} Vemulapalli, Raviteja, Oncel Tuzel, and Ming-Yu Liu. "Deep gaussian conditional random field network: A model-based deep network for discriminative denoising." Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition. 2016. [arXiv: 1511.04067](https://arxiv.org/abs/1511.04067)_

_{4} Zhang, Jiawei, et al. "Learning Fully Convolutional Networks for Iterative Non-blind Deconvolution." arXiv preprint arXiv:1611.06495 (2016). [arXiv: 1611.06495](https://arxiv.org/abs/1611.06495)_

_{5} Chen, Xinyuan, Li Song, and Xiaokang Yang. "Deep RNNs for video denoising." SPIE Optical Engineering+ Applications. International Society for Optics and Photonics, 2016. [doi: 10.1117/12.2239260](https://dx.doi.org/10.1117/12.2239260)_

![Denoising](https://github.com/petteriTeikari/videoRestoration_oldSkool/blob/master/imgs/chen2016_videoDenoising.png)


### Edge-Aware Smoothing

Some remaining ripple could be removed with some edge-aware smoothing techniques such as anisotropic diffusion, bi/trilateral filtering, etc. We use now the ["Image Smoothing via L0 Gradient Minimization"](http://www.cse.cuhk.edu.hk/~leojia/projects/L0smoothing/) published by Xu *et al.* (2011) which was later improved slightly by the L1 Fidelity term by [Pang et al. (2015)](https://doi.org/10.1371/journal.pone.0138682)

![L0 Gradient Smoothing](https://github.com/petteriTeikari/videoRestoration_oldSkool/blob/master/imgs/edgeAwareIdea.jpg)

_Idea of edge-aware smoothing as in L0 gradient minimization_

![Bilateral vs. Trilateral](https://github.com/petteriTeikari/videoRestoration_oldSkool/blob/master/imgs/bi-trilateral_filtering.png)

_Conceptual difference between bilateral and trilateral filter [Pal et al. (2015)](https://arxiv.org/abs/1503.07297)_

![Bilateral vs. Trilateral with MRI smoothing](https://github.com/petteriTeikari/videoRestoration_oldSkool/blob/master/imgs/MRI_biAndTrilateral.png)

_Difference between bilateral and trilater filter for smoothing MRI images [Pal et al. (2015)](https://arxiv.org/abs/1503.07297)_

#### Deep Learning

Xu *et al* (2015) published a "copycat network" [Deep Edge-Aware Filters](http://lxu.me/projects/deepeaf/) + [Github](https://github.com/jimmy-ren/vcnn_double-bladed/tree/master/applications/deep_edge_aware_filters) that was able to learn bilateral and L0 gradient minimization edge-aware smoothing from data.

![Smoothing](https://github.com/petteriTeikari/videoRestoration_oldSkool/blob/master/imgs/Xu2015_edgeAware.png)

### Edge Detection

The effect of denoising and smoothing to edge detection was quantified using the standard Canny filter that is commonly used and fast to compute.

#### Deep Learning

Of course if you are interested in having a very good edge detection performance, you should try the contemporary deep learning approaches that offer more robust and accurate edge detection for example published by [Xie and Tu (2015): Holistically-Nested Edge Detection](http://www.cv-foundation.org/openaccess/content_iccv_2015/html/Xie_Holistically-Nested_Edge_Detection_ICCV_2015_paper.html) or [Li et al. (2016): Unsupervised Learning of Edges](http://www.cv-foundation.org/openaccess/content_cvpr_2016/html/Li_Unsupervised_Learning_of_CVPR_2016_paper.html)

![Edges](https://github.com/petteriTeikari/videoRestoration_oldSkool/blob/master/imgs/xie2015_hed_performance.png)

### Contrast Equalization

[Contrast-limited adaptive histogram equalization (CLAHE)](http://www.cs.utah.edu/~sujin/courses/reports/cs6640/project2/clahe.html) is a commonly used technique to enhance the contrast of the image as our test iamge suffered from low contrast.

Alternative for contrast equalization would be to use [detail magnification](http://www.cse.cuhk.edu.hk/~leojia/projects/L0smoothing/ToneMapping.htm) that are based on separating the "base" and "detail" layers like in HDR tone mapping to boost the details without accentuating the noise. 

![Detail magnification](https://github.com/petteriTeikari/videoRestoration_oldSkool/blob/master/imgs/xu_detailMagnification.png)

The quality of the detail magnification depend on the base-detail decomposition which again can be improved by **deep learning** and better edge-aware smoothing or [intrinsic image decomposition](https://arxiv.org/abs/1612.07899) techniques

![Image decomposition](https://github.com/petteriTeikari/videoRestoration_oldSkool/blob/master/imgs/lettry2016_decomposition.png)
