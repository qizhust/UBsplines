function y = bspline21(x)
y = zeros(size(x));
x0range = abs(x) < 1/2;
x1range = x>=1/2 & x<3/2;
x2range = x>=-3/2 & x<=-1/2;
x0 = x(x0range);
x1 = x(x1range);
x2 = x(x2range);
y(x0range) = -2*x0;
y(x1range) = x1-1.5;
y(x2range) = x2+1.5;