% thresholds in the Oxford dataset are manually set to obtain around 1800 kpts

clc;clear;

test_type = 'boat';
im_num = 6;
doh_type = 'doh_s';
% doh_type = 'doh_c';
% doh_type = 'abl_interp';

img_dir = ['../../datasets/oxford/', test_type, '/'];
% img_dir = ['../../repeatability/', test_type, '/'];
% kpt_dir = ['../results/oxford/', test_type, '/keypoints/'];
kpt_dir = ['./res/', test_type];

if not(exist(kpt_dir, 'dir'))
    mkdir(['./res/', test_type])
end

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

switch test_type
    case 'bark'
        if strcmp(doh_type, 'abl_interp')
            thres = 0.038;
        else
            thres = 0.017;
        end
    case 'bikes'
        if strcmp(doh_type, 'abl_interp')
            thres = 0.055;
        else
            thres = 0.023;
        end
    case 'boat'
        if strcmp(doh_type, 'abl_interp')
%             thres = 0.175;
%             thres = 0.24;
%             thres = 0.052; % doh_c_no_interp
            thres = 0.082;
        elseif strcmp(doh_type, 'doh_c')
%             thres = 0.065; % doh_c_m0
            thres = 0.07; % doh_c_m1_n2
%             thres = 0.07; % doh_c_m2
%             thres = 0.067; % doh_c_m3
%            thres = 0.036; % doh_c_m1_n3
%             thres = 0.0013; % doh_c_m1_n4
        else
            thres = 0.23;
        end
    case 'graffi'
        if strcmp(doh_type, 'abl_interp')
            thres = 0.045;
        else
            thres = 0.000;
        end
    case 'leuven'
        if strcmp(doh_type, 'abl_interp')
            thres = 0.064;
        else
            thres = 0.000;
        end
    case 'rotate'
        im_num = 19;
        if strcmp(doh_type, 'abl_interp')
            thres = 0.124;
        else
            thres = 0.035;
        end
    case 'scale'
        im_num = 9;
        if strcmp(doh_type, 'abl_interp')
            thres = 0.124;
        else
            thres = 0.035;
        end
    case 'trees'
        if strcmp(doh_type, 'abl_interp')
            thres = 0.093;
        else
            thres = 0.08;
        end
    case 'ubc'
        if strcmp(doh_type, 'abl_interp')
            thres = 0.082;
        else
            thres = 0.08;
        end
    case 'wall'
        if strcmp(doh_type, 'abl_interp')
            thres = 0.076;
        else
            thres = 0.052;
        end
end

for i=1:im_num
    if strcmp(test_type, 'rotate') && i < 10
        imname = sprintf('img0%d.pgm',i);
        fname = sprintf('img0%d.%s_m%d_n%d',i,doh_type,m,nx); 
    else
        imname = sprintf('img%d.pgm',i);
        fname = sprintf('img%d.%s_m%d_n%d',i,doh_type,m,nx);
    end
    im = im2double(imread([img_dir,imname]));
    tic;
    [pts,bhss] = bk(im,thres,doh_type,nx,ny,m);
    toc;
    features = lowe2aff(pts);
    size(features, 1)
    exportFeatures([kpt_dir, fname],0,features');
%     figure,display_features(['./res/', test_type, '/', fname],[imdir,imname],0,0);
end
