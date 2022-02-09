function response = separableFiltering( img, a )
%SEPARABLEFILTERING 此处显示有关此函数的摘要
%   此处显示详细说明

[rows, cols] = size(img);

% horizontal running-sum
intim_h = cumsum(img, 2);

% finite-difference
fd1 = zeros(rows, cols);
border = round(a/2);
for j = border+1 : cols-border
    fd1(:,j) = (intim_h(:,j+border) - intim_h(:,j-border))/(2*border);
end

% vertical running-sum
intim_v = cumsum(fd1, 1);

% finite-difference
response = zeros(rows, cols);
for i = border+1 : rows-border
    response(i,:) = (intim_v(i+border,:) - intim_v(i-border,:))/(2*border);
end

end

