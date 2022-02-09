function im_out = boxFiltering( im, a )
%BOXFILTERING 此处显示有关此函数的摘要
%   此处显示详细说明

[rows, cols] = size(im);
[intim, ~, ~] = int_img(im, false);
im_out = zeros(rows, cols);

border = ceil(a/2);
for i = border+1 : rows-border
    for j = border+1 : cols-border
        im_out(i,j) = intim(i+border,j+border) - intim(i-border,j+border) - intim(i+border,j-border) + intim(i-border,j-border);
    end
end

end

