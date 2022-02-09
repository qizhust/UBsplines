function y = bspline11( x,a )
% B-spline function of 1st order

y = zeros(size(x));

x0range = x>=0 & x<1*a;
x1range = x>-1*a & x<=0;

y(x0range) = 1;
y(x1range) = -1;

end

