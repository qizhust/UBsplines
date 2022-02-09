function ico = img_bfilter(ic,rows,cols,nx,ny,m,dx,dy,a,step,doh_type)
% Fast bspline filtering with any real positive scales
% 
% Arguments:
%             ic    - integral coefficients
%             nx     - bspline filter order in x direction
%             ny     - bspline filter order in y direction
%             m      - interpolation bspline order
%             a      - scale of bspline filter, which could be any positive number
% Returns:
%             img_o - filtered image 
% 
% Author :: Mingming Gong
% Date   :: 03/02/2010

if(nargin<5)
    error('At least 5 parameters should be assigned.');
end
if(nx<dx||ny<dy)
    error('n cannot be smaller than d.');
end

% Calculate filter coeffcients
if strcmp(doh_type, 'doh_s')
    shx = ((a(1)-1)*(nx+1)+dx)/2;
    shy = ((a(2)-1)*(ny+1)+dy)/2;
    [gx,gxc] = bfilter_table(nx,m+1+nx-dx,a(1),shx,doh_type);
    [gy,gyc] = bfilter_table(ny,m+1+ny-dy,a(2),shy,doh_type);
else
    shx = ((a-1)*(nx+1)+dx)/2;
    shy = ((a-1)*(ny+1)+dy)/2;
    if strcmp(doh_type, 'abl_interp')
        [gx,gxc] = bfilter_table(nx,nx-dx,a,shx,doh_type);
        [gy,gyc] = bfilter_table(ny,ny-dy,a,shy,doh_type);
    else
        [gx,gxc] = bfilter_table(nx,m+1+nx-dx,a,shx,doh_type);
        [gy,gyc] = bfilter_table(ny,m+1+ny-dy,a,shy,doh_type);
    end
end
% filtering
gyc = [gyc{:}];
gy  = [gy{:}];
gxc = [gxc{:}];
gx  = [gx{:}];
g = gy'*gx;
[gcx,gcy] = meshgrid(gxc,gyc);
ico = bconv(ic,gcx,gcy,g,rows,cols,step);
