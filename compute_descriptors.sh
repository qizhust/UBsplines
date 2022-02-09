#!/bin/bash

im_dir='bspline/datasets/hpatches-sequences-release'
in_dir='bspline/results/hpatches-sequences-release'

detector_type=$1

while IFS= read -r line
do
  mkdir -p "$in_dir"/"$line"/descriptors_1000
  for i in {1..6}
  do
    ./compute_descriptors.ln -sift -i "$im_dir"/"$line"/"$i".ppm -p1 "$in_dir"/"$line"/keypoints_1000/img"$i"."$detector_type" -o1 "$in_dir"/"$line"/descriptors_1000/img"$i"."$detector_type".sift
  done
done < 'names.txt'
