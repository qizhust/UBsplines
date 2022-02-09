# A Unified B-Spline Framework for Scale-Invariant Keypoint Detection
## Updates
02/02/2022 The paper is pulished at [IJCV](https://link.springer.com/article/10.1007/s11263-021-01568-3)

## Data preparation
download [hpatches-sequence-release dataset](http://icvl.ee.ic.ac.uk/vbalnt/hpatches/hpatches-sequences-release.tar.gz) and [oxford dataset](https://www.robots.ox.ac.uk/~vgg/data/affine/)
- ./datasets/hpatches-sequences-release/i_fog (for example)
- ./datasets/oxford/boat (for example)

## Usage
1. use test_hpatch.m or test_oxford.m in ./detectors/BDoH/ or ./detectors/BLoG to detect keypoints

2. run compute_descriptors.sh to generate keypoint descriptors (for example, SIFT)

3. run repeatability_hpatch.m or repeatability_oxford.m to calculate repeatability and matching score

## Citations
```
@article{zheng2022unified,
  title={A Unified B-Spline Framework for Scale-Invariant Keypoint Detection},
  author={Zheng, Qi and Gong, Mingming and You, Xinge and Tao, Dacheng},
  journal={International Journal of Computer Vision},
  pages={1--23},
  year={2022},
  publisher={Springer}
}
```