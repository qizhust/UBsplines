function [g,gc] = bfilter_table(n1,n2,a,sh,doh_type)
% Generate bspline filter coeffcients.
%
% Arguments:
%               n1 - order of difference operator
%               n2 - order of reconstruction bspline
%               a  - scale factor, which could be any real positive value
%               sh - shift of the bspline filter
%
% Return:
%               g  - filter coefficients
%               gc - coordinate of filters
% 
% Author :: Mingming Gong
% Date   :: 13/12/2010
addpath('bspline');
switch(n1)
    case 0
        ds = [1,-1];
    case 1
        ds = [1,-2,1];
    case 2
        ds = [1,-3,3,-1];
    case 3
        ds = [1,-4,6,-4,1];
    case 4
        ds = [1,-5,10,-10,5,-1];
    otherwise
        error('The order is not supported yet, please use lower orders\n');
end
gc = cell(n1+2,1);
g  = cell(n1+2,1);
if strcmp(doh_type, 'abl_interp')
    for i=1:n1+2
%         gc{i} = fix(sh)-fix(a)*(i-1);
        gc{i} = floor(sh-a*(i-1));
        g{i} = 1/a^(n1+1)*ds(i);
    end
else
    for i=1:n1+2
        gc{i} = floor(sh-a*(i-1)-(n2+1)/2)+1:ceil(sh-a*(i-1)+(n2+1)/2)-1;
        g{i} = 1/a^(n1+1)*ds(i)*bsplineN(gc{i}-sh+a*(i-1),n2);
    end
end
rmpath('bspline');
end
