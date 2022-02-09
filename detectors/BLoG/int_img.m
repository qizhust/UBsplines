function [intim, intim_r, intim_l] = int_img( img, SLANT )
% calculate integral image
% Argument:
%           img - input image
% Returns:
%           int_res - output integral image
% Author :: Qi Zheng
% Date   :: 06/06/2019

if(~isreal(img)||ndims(img) > 2)
	error('image must be a real two dimensional matrix');
end

[rows,cols] = size(img);
intim = zeros(rows,cols);
intim_r = zeros(rows, cols);
intim_l = zeros(rows, cols);

% regular integral image, which can also be calculated by CUMSUM function
intim(1,1) = img(1,1);
for i = 2:cols
    intim(1,i) = intim(1,i-1) + img(1,i);
end
for i = 2:rows
    intim(i,1) = intim(i-1,1) + img(i,1);
end

for i = 2:rows
    for j = 2:cols
        intim(i,j) = img(i,j) + intim(i-1,j) + intim(i,j-1) - intim(i-1,j-1);
    end
end

% slanted integral image
if SLANT
    intim_h = cumsum(img, 2);
    
    % area that slants to the right
    intim_r(1,:) = intim_h(1,:);

    for i = 2:rows
        for j = 1:cols-1
            intim_r(i,j) = intim_r(i-1,j+1) + intim_h(i,j);
        end
        intim_r(i,cols) = intim(i,cols);
    end

    % area that slants to the left
    intim_l(1,:) = intim_h(1,:);

    for i = 2:rows
        intim_l(i,1) = intim(i,1);
        for j = 2:cols
            intim_l(i,j) = intim_l(i-1,j-1) + intim_h(i,j);
        end
    end
end

end

