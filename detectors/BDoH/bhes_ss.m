function SS = bhes_ss(img,sigman,O,S,omin,smin,smax,sigma0,doh_type,nx,ny,m)
% Bspline hessian scale space

if(nargin<8)
	error( 'Eight arguments are required.');
end

if(~isreal(img)||ndims(img) > 2)
	error('image must be a real two dimensional matrix');
end

% Scale space structure
SS.O          = O;
SS.S          = S;
SS.sigma0     = sigma0;
SS.omin       = omin;
SS.smin       = smin;
SS.smax       = smax;

[rows,cols] = size(img);

% Pre-computed integral coefficients
img = padarray(img,[300 300]);

if strcmp(doh_type, 'doh_s')
    d2x = integral_c(img,1,1);
    d2y = integral_c(img,1,1);
    dxy = integral_c(img,1,1);
else
    d2x = integral_c(img,nx-1,ny+1);
    d2y = integral_c(img,nx+1,ny-1);
    dxy = integral_c(img,nx,ny);
end

% Build bspline hessian scale space
SS.octave{1} = zeros(rows,cols,smax-smin+1);
for i=1:smax-smin+1
    sigma = sqrt((sigma0*(2^(1/S))^(i-2)).^2-sigman.^2);
    SS.octave{1}(:,:,i) = bhesC(d2x,d2y,dxy,rows,cols,m,sigma,nx,ny,1,doh_type);
end

for i=2:O
    SS.octave{i} = zeros(ceil(rows/(2^(i-1))),ceil(cols/(2^(i-1))),smax-smin+1);
    SS.octave{i}(:,:,1) = halveSize(SS.octave{i-1}(:,:,smax-smin),2);
    SS.octave{i}(:,:,2) = halveSize(SS.octave{i-1}(:,:,smax-smin+1),2);
    for j=3:smax-smin+1
        sigma = sqrt((2^(i-1)*sigma0*(2^(1/S))^(j-2)).^2-sigman.^2);
        SS.octave{i}(:,:,j) = bhesC(d2x,d2y,dxy,rows,cols,m,sigma,nx,ny,2^(i-1),doh_type);
    end
end
end

function J = halveSize(I,step)
J = I(1:step:end,1:step:end);
end