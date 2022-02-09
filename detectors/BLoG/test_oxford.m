% thresholds in the Oxford dataset are manually set to obtain around 1800 kpts

clc;clear;
addpath('siftlocalmax');

test_type = 'boat';
im_num = 6;
line_threshold = 10.0;
directions = 4;

switch test_type
    case 'bark'
        if directions == 2
            non_max_threshold = 0.038;
        elseif directions == 4
            non_max_threshold = 0.017;
        end
    case 'bikes'
        if directions == 2
            non_max_threshold = 0.055;
        elseif directions == 4
            non_max_threshold = 0.023;
        end
    case 'boat'
        if directions == 2
            non_max_threshold = 0.124;
        elseif directions == 4
            non_max_threshold = 0.035;
        end
    case 'graffi'
        if directions == 2
            non_max_threshold = 0.045;
        elseif directions == 4
            non_max_threshold = 0.000;
        end
    case 'leuven'
        if directions == 2
            non_max_threshold = 0.064;
        elseif directions == 4
            non_max_threshold = 0.000;
        end
    case 'rotate'
        im_num = 19;
        if directions == 2
            non_max_threshold = 0.124;
        elseif directions == 4
            non_max_threshold = 0.035;
        end
    case 'scale'
        im_num = 9;
        if directions == 2
            non_max_threshold = 0.124;
        elseif directions == 4
            non_max_threshold = 0.035;
        end
    case 'trees'
        if directions == 2
            non_max_threshold = 0.093;
        elseif directions == 4
            non_max_threshold = 0.08;
        end
    case 'ubc'
        if directions == 2
            non_max_threshold = 0.082;
        elseif directions == 4
            non_max_threshold = 0.08;
        end
    case 'wall'
        if directions == 2
            non_max_threshold = 0.076;
        elseif directions == 4
            non_max_threshold = 0.052;
        end
end

for i=1:im_num
    imdir = ['../../repeatability/', test_type, '/'];
    if strcmp(test_type, 'rotate') && i < 10
        imname = sprintf('img0%d.pgm',i);
        fname = sprintf('img0%d.blap%d',i,directions); 
    else
        imname = sprintf('img%d.pgm',i);
        fname = sprintf('img%d.blap%d',i,directions);
    end
    imname = [imdir,imname]; %#ok<AGROW>
    fname = ['./res/', test_type, '/', fname]; %#ok<AGROW>
    im = im2double(imread(imname));
    if directions == 4
        tic;
        [pts,bhss] = bk_4(im, directions, non_max_threshold, line_threshold);
        toc;
    elseif directions == 2
        tic;
        [pts,bhss] = bk_2(im, directions, non_max_threshold, line_threshold);
        toc;
    end
    features = lowe2aff(pts);
    exportFeatures(fname,0,features');
end
% figure,display_features(fname,imname,0,0);