function g = preIntegral1( f, b, directions )
% f: input signal, 2-D, rows*cols
% g: output signal, rows*cols*4, including 4 running sum components 
% as g[:,:,1], g[:,:,2], g[:,:,3], g[:,:,4] 

[rows,cols] = size(f);
g = zeros(rows,cols,4);

%% preintegration
% horizontal running sum
for j = 1:cols
    rs = 0;
    for i = 1:rows
        rs = rs + b(1)*f(i,j);
        g(i,j,1) = rs;
    end
end
% first diagonal running sum
g(1,:,2) = b(2)*g(1,:,1);
g(:,1,2) = b(2)*g(:,1,1);
for i = 2:rows
    for j = 2:cols
        rs = g(i-1,j-1,2) + b(2)*g(i,j,1);
        g(i,j,2) = rs;
    end
end
% vertical running sum
for i = 1:rows
    rs = 0;
    for j = 1:cols
        rs = rs + b(3)*g(i,j,2);
        g(i,j,3) = rs;
    end
end
% second diagonal running sum
g(1,:,4) = b(4)*g(1,:,3);
g(:,cols,4) = b(4)*g(:,cols,3);
for i = 2:rows
    for j = 1:cols-1
        rs = g(i-1,j+1,4) + b(4)*g(i,j,3);
        g(i,j,4) = rs;
    end
end

end

