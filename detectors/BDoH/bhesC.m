function [bhes_map,a] = bhesC(d2x,d2y,dxy,rows,cols,m,sigma,nx,ny,step,doh_type)
% Hessian response map via bspline filtering

if strcmp(doh_type, 'doh_s')
    a1 = [sigma*sqrt(12/(2+1)), sigma*sqrt(12/(0+1))];
    a2 = [sigma*sqrt(12/(0+1)), sigma*sqrt(12/(2+1))];
    a3 = [sigma*sqrt(12/(1+1)), sigma*sqrt(12/(1+1))];
    Ixx = img_bfilter(d2x,rows,cols,2,0,m,2,0,a1,step,doh_type);
    Iyy = img_bfilter(d2y,rows,cols,0,2,m,0,2,a2,step,doh_type);
    Ixy = img_bfilter(dxy,rows,cols,1,1,m,1,1,a3,step,doh_type);
    bhes_map = abs(a1(1)*a1(2)*a2(1)*a2(2)*Ixx.*Iyy - (a3(1)*a3(2))^2*Ixy.^2);
else
    a = sigma*sqrt(12/(nx+1));
    if strcmp(doh_type, 'abl_interp')
        a = floor(a);
    end
    Ixx = img_bfilter(d2x,rows,cols,nx,ny,m,2,0,a,step,doh_type);
    Iyy = img_bfilter(d2y,rows,cols,nx,ny,m,0,2,a,step,doh_type);
    Ixy = img_bfilter(dxy,rows,cols,nx,ny,m,1,1,a,step,doh_type);
    bhes_map = a^4*abs(Ixx.*Iyy-Ixy.^2);
end

% [padr,padc] = size(d2x);
% if strcmp(doh_type, 'abl_interp')
%     d2x = d2x(301:padr-300,301:padc-300);
%     d2y = d2y(301:padr-300,301:padc-300);
%     dxy = dxy(301:padr-300,301:padc-300);
%     hx = bspline_fd(nx+1);
%     hy = bspline_fd(ny+1);
%     Ixx = imfilter(d2x, hx.*hx);
%     Iyy = imfilter(d2y, hy'.*hy');
%     Ixy = imfilter(dxy, hx'*hy);
%     bhes_map = abs(Ixx.*Iyy-Ixy.^2);
% else
%     Ixx = img_bfilter(d2x,rows,cols,nx,ny,m,2,0,a,step,doh_type);
%     Iyy = img_bfilter(d2y,rows,cols,nx,ny,m,0,2,a,step,doh_type);
%     Ixy = img_bfilter(dxy,rows,cols,nx,ny,m,1,1,a,step,doh_type);
%     bhes_map = a^4*abs(Ixx.*Iyy-Ixy.^2);
% end

end

function coefficients = bspline_fd(n)
addpath('bspline');

switch(n)
    case 0
        coefficients = [1,-1];
    case 1
        coefficients = [1,-2,1];
    case 2
        coefficients = [1,-3,3,-1];
    case 3
        coefficients = [1,-4,6,-4,1];
    case 4
        coefficients = [1,-5,10,-10,5,-1];
    otherwise
        error('The order is not supported yet, please use lower orders\n');
end
rmpath('bspline');
end
