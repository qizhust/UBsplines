function y = bsplineNdtrans( x, N )
% bsplineNdtrans - polynomial B-spline direct transform
%   y = bsplineNdtrans(x, N) calculates N-order interpolating spline coefficients for
%   input vector x

[b, c] = idtrans_FIR_coefs(N);

% Find the z-transform poles of the direct transform 
z = roots(b);

% The roots appear in conjugate pairs, keep upper part
if(z)
    z = z((length(z)/2 + 1): end);
end

for zn = z'
    x = filterAPsym2ord( x, zn);
end

% Apply scaling
y = x*c;

end

