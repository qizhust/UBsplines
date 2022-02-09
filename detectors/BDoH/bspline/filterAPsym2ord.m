function c = filterAPsym2ord( x, zi )
% filterAPsym2ord - symmetrical 2. order allpole filter
%   c = filterAPsym2ord( x, zi) filters signal x according to
%   the transfer function 
%   H(z) = - zi / (1 - zi * z)*(1 - zi * z^-1) 
%
%   The reflected input data is used as boundary conditions
%   x(k) = x(2N-k)) for k > N
%   x(k) = x(-k) for k <= N
%
%   The filter operates along the first non-singleton dimension of x
%
%   This function requires the Signal Processing toolbox
%
%   See also filterAPfwd1ord, filterAPrev1ord

cp = filterAPfwd1ord(x,zi);

c = filterAPrev1ord(cp, zi);

end

