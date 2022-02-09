function y = bsplineNidtrans( x, N )
% bsplineNidtrans - polynomial B-spline indirect transform
%   y = bsplineNidtrans(x, N) calculates N-order interpolating spline coefficients for
%   input vector x

[b, c] = idtrans_FIR_coefs(N);

x = filterFIR( b, x );

% Apply scaling
y = x*(1/c);

end

