function F_zp = fastZP(c, x)
% fast ZP interpolation

x0 = round(x);

% figure out the partition of x0, two binary decision-makings
x0_delta = x0 - x;
b0 = x0_delta(1)>x0_delta(2); % linear partition: x>y
b1 = x0_delta(1)>-x0_delta(2); % linear partition: x>-y

% x_all = [0,0; 1,0; 0,1; -1,1; -1,0; -1,-1; 0,-1];

if b0==1
    if b1==1
        flag = 0;
        x_all = [0,0; 1,0; 0,1; -1,1; -1,0; -1,-1; 0,-1];
    else
        flag = 3;
        x_all = [0,0; 0,-1; 1,0; 1,1; 0,1; -1,1; -1,0];
    end
else
    if b1==1
        flag = 1;
        x_all = [0,0; 0,1; -1,0; -1,-1; 0,-1; 1,-1; 1,0];
    else 
        flag = 2;
        x_all = [0,0; -1,0; 0,-1; 1,-1; 1,0; 1,1; 0,1];
    end
end

[rows, cols ] = size(c);
x_all = x_all + repmat(x0,7,1);
x_all(:,1) = filtminmax(x_all(:,1), 1, rows);
x_all(:,2) = filtminmax(x_all(:,2), 1, cols);

F_zp = 0;
for i = 1:7
    F = Ffun(x_all(i,1),x_all(i,2),x(1),x(2));
    F_zp = F_zp + c(x_all(i,1),x_all(i,2))*F;
end

end

function F = Ffun(x,y,j,k)
% patches functions
% reference: Philip B.Zwart. Multivariate splines with nondegenerate partitions
% point (x,y) is within the support of spline function center at point(j,k)

Fjk_0 = 1 - (x-j)^2 - (y-k)^2;

if x>=(j-3/2) && x<(j-1/2)
    Fjk_x = (x-j+1/2)^2;
elseif x>=(j-1/2) && x<=(j+1/2) 
    Fjk_x = 0;
elseif x>(j+1/2) && x<=(j+3/2)
    Fjk_x = (x-j-1/2)^2;
else
    Fjk_x = 0;
    fprintf('Fjk_x (%d, %d, %d, %d) error...\n',j,k,x,y);
end

if y>=(k-3/2) && y<(k-1/2)
    Fjk_y = (y-k+1/2)^2;
elseif y>=(k-1/2) && y<=(k+1/2)
    Fjk_y = 0;
elseif y>(k+1/2) && y<=(k+3/2)
    Fjk_y = (y-k-1/2)^2;
else
    Fjk_y = 0;
    fprintf('Fjk_y (%d, %d, %d, %d) error...\n',j,k,x,y);
end

if (y-x)>=(k-j-2) && (y-x)<(k-j-1)
    Fjk_yx = (y-x+j-k+1)^2/2;
elseif (y-x)>=(k-j-1) && (y-x)<=(k-j+1)
    Fjk_yx = 0;
elseif (y-x)>(k-j+1) && (y-x)<=(k-j+2)
    Fjk_yx = (y-x+j-k-1)^2/2;
else
    Fjk_yx = 0;
    fprintf('Fjk_yx (%d, %d, %d, %d) error...\n',j,k,x,y);
end

if (x+y)>=(j+k-2) && (x+y)<(j+k-1)
    Fjk_xy = (x+y-j-k+1)^2/2;
elseif (x+y)>=(j+k-1) && (x+y)<=(j+k+1)
    Fjk_xy = 0;
elseif (x+y)>(j+k+1) && (x+y)<=(j+k+2)
    Fjk_xy = (x+y-j-k-1)^2/2;
else
    Fjk_xy = 0;
    fprintf('Fjk_xy (%d, %d, %d, %d) error...\n',j,k,x,y);
end

F = Fjk_0 + Fjk_x + Fjk_y + Fjk_xy + Fjk_yx;

end

function x = filtminmax(x, min_value, max_value)
x = min(x, max_value);
x = max(min_value, x);
end