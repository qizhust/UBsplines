function [bkps_new,blss] = bk_2(img, directions, non_max_threshold, line_threshold)
% Extract keypoints from bspline scale space.
% Arguments:
%             img    - input image
%             thresh - threshold
% Returns:
%             bkps - bspline keypoints 
%             bss  - bspline hessian scale space
% Author :: Qi Zheng
% Date   :: 06/11/2019

[rows,cols] = size(img);
% Initialize parameters
S = 2;
O = 8; % O=10 for B-Lap-4;
sigma0 = 1.6*2^(1/S); % initial scale
sigman = 0.5; % nominal blur
verb = 0; % describe what is going on

if verb>0
    fprintf('BK: computing scale space...\n'); 
    tic; 
end

% bspline LoB scale space
[blss, bd_th] = blap_ss_2(img,sigman,O,directions,sigma0);

if verb>0
    fprintf('(%.3f s bhss);\n',toc);
end

DoB = zeros(rows, cols, O-1);
for i = 1:O-1
    DoB(:,:,i) = abs(blss.octave(:,:,i+1) - blss.octave(:,:,i));
end

bkps = [];
vs = [];

idx = siftlocalmax(DoB,0.8*non_max_threshold);

[i,j,s] = ind2sub(size(DoB),idx);
x = j - 1;
y = i - 1;
bkps = [x(:)';y(:)';sigma0*2.^((s(:)-2)/2)']';

% line suppression
x_new = [];
y_new = [];
sigma_new = [];
for idx_s = min(s) : max(s)
%     sigma = sigma0 * 2^((idx_s-0)/2);
    sigma = blss.sigmas(idx_s+1);
    win_size = round(6 * sigma + 1);
    non_zero_mask = suppress_lines(ones(size(img)), img, sigma, line_threshold, win_size);
    curr_mask = zeros(size(img));
    idx_tar = find(s==idx_s);
    curr_mask(sub2ind(size(img), y(idx_tar), x(idx_tar))) = 1;
    filtered_mask = non_zero_mask .* curr_mask;
    [x_keep, y_keep] = find(filtered_mask);
    non_bd_idx = (x_keep>bd_th & x_keep<rows-bd_th & y_keep>bd_th & y_keep<cols-bd_th);
    
    x_new = [x_new; x_keep(non_bd_idx)];
    y_new = [y_new; y_keep(non_bd_idx)];
    sigma_new = [sigma_new; sigma*ones(size(x_keep(non_bd_idx)))];
    
end
bkps_new = [y_new(:), x_new(:), sigma_new(:)];

end

function mask_out = minimum_filter(input, win_sizes)
% win_sizes should all be odd.

[row, col, num] = size(input);
mask_out = zeros(row, col, num);

w1 = (win_sizes(1)-1)/2;
w2 = (win_sizes(2)-1)/2;
w3 = (win_sizes(3)-1)/2;

for k = w3+1 : num-w3
    for i = w1+1 : row-w1 
        for j = w2+1 : col-w2
            block = input(i-w1:i+w1,j-w2:j+w2,k-w3:k+w3);
            if input(i,j,k) == min(block(:))
                mask_out(i,j,k) = 1;
            end
        end
    end
end
end

function mask_out = maximum_filter(input, win_sizes)
% win_sizes should all be odd.

[row, col, num] = size(input);
mask_out = zeros(row, col, num);

w1 = (win_sizes(1)-1)/2;
w2 = (win_sizes(2)-1)/2;
w3 = (win_sizes(3)-1)/2;

for k = w3+1 : num-w3
    for i = w1+1 : row-w1
        for j = w2+1 : col-w2
            block = input(i-w1:i+w1,j-w2:j+w2,k-w3:k+w3);
            if input(i,j,k) == max(block(:))
                mask_out(i,j,k) = 1;
            end
        end
    end
end
end

function mask_out = suppress_lines(feature_mask, img, sigma, line_threshold, win_size)
[imx, imy] = imgradientxy(img);
h = fspecial('gaussian', win_size, sigma);
Axx = imfilter(imx.*imx, h);
Axy = imfilter(imx.*imy, h);
Ayy = imfilter(imy.*imy, h);
feature_mask((Axx + Ayy).^2 > line_threshold * (Axx .* Ayy - Axy.^2)) = false;

mask_out = feature_mask;
end
