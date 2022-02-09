function SS = bhes_ss_surf(img,sigman,O,S,omin,smin,smax,sigma0)
% Bspline hessian scale space

if(nargin<8)
	error( 'Eight arguments are required.');
end

if(~isreal(img)||ndims(img) > 2)
	error('image must be a real two dimensional matrix');
end

nx = 2; % Bspline filter order
ny = 2;
m = 1; % Interpolation Bspline order
% Scale space structure
SS.O          = O;
SS.S          = S;
SS.sigma0     = sigma0;
SS.omin       = omin;
SS.smin       = smin;
SS.smax       = smax;

[rows,cols] = size(img);

% Pre-computed integral coefficients
img = padarray(img,[200 200]);
d2x = integral(img,nx-1,ny+1);
d2y = integral(img,nx+1,ny-1);
dxy = integral(img,nx,ny);

sb2 = [3 5 7 9 11; 7 11 15 19 23; 15 23 31 39 47; 31 47 63 79 95];
sigmas = sb2/2;
% Build bspline hessian scale space
SS.octave{1} = zeros(rows,cols,smax-smin+1);
for i=1:smax-smin+1
%     sigma = sqrt((sigma0*(2^(1/S))^(i-2)).^2-sigman.^2);
    SS.octave{1}(:,:,i) = bhes(d2x,d2y,dxy,rows,cols,m,sigmas(1,i),nx,ny,1);
end

for i=2:O
    SS.octave{i} = zeros(ceil(rows/(2^(i-1))),ceil(cols/(2^(i-1))),smax-smin+1);
    SS.octave{i}(:,:,1) = halveSize(SS.octave{i-1}(:,:,smax-smin-1),2);
    SS.octave{i}(:,:,2) = halveSize(SS.octave{i-1}(:,:,smax-smin+1),2);
    for j=3:smax-smin+1
%         sigma = sqrt((2^(i-1)*sigma0*(2^(1/S))^(j-2)).^2-sigman.^2);
        SS.octave{i}(:,:,j) = bhes(d2x,d2y,dxy,rows,cols,m,sigmas(i,j),nx,ny,2^(i-1));
    end
end
end

function J = halveSize(I,step)
J = I(1:step:end,1:step:end);
end