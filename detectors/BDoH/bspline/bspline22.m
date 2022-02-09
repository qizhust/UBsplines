function y = bspline22(x)
y = zeros(size(x));
x0range = abs(x) < 1/2;
x1range = abs(x)>=1/2 & abs(x)<3/2;
x0 = x(x0range);
x1 = x(x1range);
y(x0range) = -2;
y(x1range) = 1;
