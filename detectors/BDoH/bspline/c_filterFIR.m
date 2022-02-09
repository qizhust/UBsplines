function cp = filterFIR( b, x )
% filterFIR - FIR filter with reflected initial conditions
%
%   The reflected input data is used as initial conditions:
%   x(-k+2) = x(k)
%
%   The filter operates along the first non-singleton dimension of x
%
%   This function requires the Signal Processing toolbox
%   See also filterAPrev1ord, filterAPsym2ord


dms = 1:ndims(x);
fnsdm = find(size(x)>1, 1); % first non-singleton dimension

% Construct multidimensional subscripts
oidx = cell(size(dms));

for dm = dms
    oidx{dm} = ':';
end

% Number of reflected data points used to pad the input
m = length(b)/2;

z = mirrorpad(x, m);

% Calculate the output samples using SPTOOLBOX filter function
oidx{fnsdm} = (2*m+1):(size(z, fnsdm));

cp = filter(b, 1, z);

cp = cp(oidx{:});

end

