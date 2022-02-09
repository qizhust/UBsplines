% thresholds in the hpatches dataset are automatically set to obtain around 1800 kpts

clc;clear;

imgs_folder = '../../datasets/hpatches-sequences-release/';
save_folder = '../../results/hpatches-sequences-release/';
test_types = dir(imgs_folder);
img_suffix = '.ppm';

im_num = 6;
% doh_type = 'doh_s';
doh_type = 'doh_c';
% doh_type = 'abl_interp';
tgt_num = 1000;

switch doh_type
	case 'doh_c'
		nx = 2; % Bspline filter order
		ny = 2;
		m = 1; % Interpolation Bspline order
	case 'doh_s'
		nx = 1; % just temporary value
		ny = 1; % just temporary value
		m = 1;
	case 'abl_interp'
		nx = 2;
		ny = 2;
		m = 1;
end

for i = 2:length(test_types)
    fprintf('detecting the %d/116 image, %s...\n', i, test_types(i).name);
    test_type = test_types(i).name;

    img_dir = [imgs_folder, test_type, '/'];
    kpt_dir = [save_folder, test_type, '/keypoints_', num2str(tgt_num), '/'];

    if not(exist(kpt_dir, 'dir'))
        mkdir(kpt_dir)
    end

    for j = 1:6
        thr0 = 0; thr1=1;
        imname = [sprintf('%d',j), img_suffix];
        im = rgb2gray(im2double(imread([img_dir,imname])));
        old_size = -1;
        while true
            [pts,bhss] = bk(im, (thr0+thr1)/2.0, doh_type, nx, ny, m);
            features = lowe2aff(pts);
            fprintf('thr1=%d, size of features=%d\n', thr1, size(features, 1));
            if (size(features,1) >= tgt_num-50 && size(features,1) < tgt_num+50) || (old_size>10 && size(features, 1)==old_size)
                break
            elseif size(features, 1) < tgt_num-50
                thr1 = (thr0+thr1)/2.0;
                old_size = size(features, 1);
            else
                thr0 = (thr0+thr1)/2.0;
                old_size = size(features, 1);
            end
        end
        fname = sprintf('img%d.%s_m%d_n%d', j, doh_type, m, nx);
        fprintf('saving to %s\n', fname);
        exportFeatures([kpt_dir, fname], 0, features');
    end
end

