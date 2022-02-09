function [SS, bd_th] = blap_ss_2(img, sigman, O, directions, sigma0)
% Bspline hessian scale space

if(nargin<5)
	error( 'Five arguments are required.');
end

if(~isreal(img)||ndims(img) > 2)
	error('image must be a real two dimensional matrix');
end

% Scale space structure
SS.O          = O;
SS.directions = directions;
SS.sigma0     = sigma0;

[rows,cols] = size(img);

% Build DoB scale space
SS.octave = zeros(rows, cols, O);
SS.sigmas = zeros(1, O);
SS.as = zeros(1, O);
for i = 1:O
%     sigma = sqrt((sigma0*(2^(i-2))^2 - sigman^2))
%     sigma = sqrt((sigma0*(2^((i-2)/2)))^2 - sigman^2);
    sigma = sigma0*(2^((i-2)/2));
    sigma = ones(1,4)*sigma;
    a = sigma * sqrt(24/directions);
%     sigma = ones(1,4);
    if directions == 4
        b = [1, sqrt(2), 1, sqrt(2)];
%         g = preIntegral1(img, b, directions);
        g = preIntegral2(img, b, directions);
%         tmp1 = finiteDiff1(sigma, g(:,:,4));
%         tmp2 = finiteDiff2(sigma, g(:,:,4));
%         SS.octave(:,:,i) = finiteDiff2(a, g(:,:,4));
        SS.octave(:,:,i) = finiteDiff_m(a, g(:,:,4));
    elseif directions == 2
        SS.octave(:,:,i) = separableFiltering(img, a(1));
        b = [1, 1];
%         SS.octave(:,:,i) = boxFiltering(img, a(1));
        tmp = SS.octave(:,:,i);
%         SS.octave(:,:,i) = (tmp-min(tmp(:)))/(max(tmp(:))-min(tmp(:)));
    end
    SS.as(1, i) = a(1);
    SS.sigmas(1, i) = sigma(1);
end
bd_th = SS.sigmas(1,O) * sqrt(24/directions);

end
