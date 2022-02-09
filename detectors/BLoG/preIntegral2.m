function gb = preIntegral2(img, b, directions)

[rows, cols] = size(img);
gb = zeros(rows, cols, directions);

num = 2^directions;

%------------- RS --------------
gb(1,1,1) = img(1,1);
gb(1,1,2) = sqrt(2) * gb(1,1,1);
gb(1,1,3) = gb(1,1,2);
gb(1,1,4) = sqrt(2) * gb(1,1,3);

% the first column
for i = 2:rows
    gb(i,1,1) = img(i,1) + gb(i-1,1,1);
    gb(i,1,2) = sqrt(2) * gb(i,1,1);
    gb(i,1,3) = gb(i,1,2);
    gb(i,1,4) = sqrt(2) * gb(i,1,3);
end

% the first row
for j = 2:cols
    gb(1,j,1) = img(1,j);
    gb(1,j,2) = sqrt(2) * gb(1,j,1);
    gb(1,j,3) = gb(1,j,2) + gb(1,j-1,3);
%     gb(1,j,4) = sqrt(2)*gb(1,j,3) + gb(2,j-1,4);
end

for j = 2:cols-1
    for i = 2:rows-1
        gb(i,j,1) = img(i,j) + gb(i-1,j,1);
        gb(i,j,2) = sqrt(2) * gb(i,j,1) + gb(i-1,j-1,2);
        gb(i,j,3) = gb(i,j,2) + gb(i,j-1,3);
        gb(i,j,4) = sqrt(2) * gb(i,j,3) + gb(i+1,j-1,4);
    end
    gb(1,j,4) = sqrt(2) * gb(1,j,3) + gb(2,j-1,4);
end

% the last row
for j = 2: cols-1
    gb(rows,j,1) = img(rows,j) + gb(rows-1,j,1);
    gb(rows,j,2) = sqrt(2) * gb(rows,j,1) + gb(rows-1,j-1,2);
    gb(rows,j,3) = gb(rows,j,2) + gb(rows,j-1,3);
    gb(rows,j,4) = sqrt(2) * gb(rows,j,3);
end

% the last column
for i = 2: rows-1
    gb(i,cols,1) = img(i,cols) + gb(i-1,cols,1);
    gb(i,cols,2) = sqrt(2) * gb(i,cols,1) + gb(i-1,cols-1,2);
    gb(i,cols,3) = gb(i,cols,2) + gb(i,cols-1,3);
    gb(i,cols,4) = sqrt(2) * gb(i,cols,3) + gb(i+1, cols-1, 4);
end

% the last vertical
gb(rows,cols,1) = img(rows,cols) + gb(rows-1,cols,1);
gb(rows,cols,2) = sqrt(2)*gb(rows,cols,1) + gb(rows-1,cols-1,2);
gb(rows,cols,3) = gb(rows,cols,2) + gb(rows,cols-1,3);
gb(rows,cols,4) = sqrt(2) * gb(rows,cols,3);

end