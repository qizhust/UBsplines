% thresholds in the hpatches dataset are automatically set to obtain around 1800 kpts

clc;clear;
addpath('siftlocalmax');

imgs_folder = '../../datasets/hpatches-sequences-release/';
save_folder = '../../results/hpatches-sequences-release/';
test_types = dir(imgs_folder);
img_suffix = '.ppm';

im_num = 6;
line_threshold = 10.0;
directions = 4;
tgt_num = 1000;

for i = 3:length(test_types)
    fprintf('detecting the %d/116 image...\n', i);
    test_type = test_types(i).name;
    
    img_dir = [imgs_folder, test_type, '/'];
    kpt_dir = [save_folder, test_type, '/keypoints_', num2str(tgt_num), '/'];
    
    if not(exist(kpt_dir, 'dir'))
        mkdir(kpt_dir)
    end
    
    for j = 1:6
        thr0 = 0; thr1=1;
        imname = [sprintf('%d',j), img_suffix];
        im = rgb2gray(im2double(imread([img_dir, imname])));
        old_size = -1;
        while true
            switch directions
                case 4
                    [pts,bhss] = bk_4(im, directions, (thr0+thr1)/2.0, line_threshold);
                case 2
                    [pts,bhss] = bk_2(im, directions, (thr0+thr1)/2.0, line_threshold);
            end
            features = lowe2aff(pts);
            fprintf('thr1=%d, size of features=%d\n', thr1, size(features, 1));
            if (size(features,1) >= tgt_num-50 && size(features,1) < tgt_num+50) || (old_size>0 && size(features, 1)==old_size)
                break
            elseif size(features, 1) < tgt_num-50
                thr1 = (thr0+thr1)/2.0;
                old_size = size(features, 1);
            else
                thr0 = (thr0+thr1)/2.0;
            end
        end
        fname = sprintf('img%d.blog%d', j, directions);
        fprintf('saving to %s\n', fname);
        exportFeatures([kpt_dir, fname], 0, features');
%         figure,display_features([kpt_dir, fname],[img_dir,imname],0,0);
    end
end
