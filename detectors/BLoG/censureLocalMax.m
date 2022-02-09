function [r,c,s] = censureLocalMax(octave_0,octave_1,octave_2,border,o,local_thres,extent,harris_thres)
% non-maxima suppression & line suppression
%   此处显示详细说明

[rs,cs] = size(octave_1);
r = []; c = []; s = [];

for i = border+2:rs-border-1
    for j = border+2:cs-border-1
        if octave_1(i,j) < local_thres; continue; end
        if octave_1(i,j) <= octave_0(i-1,j-1) || octave_1(i,j) <= octave_0(i-1,j) || octave_1(i,j) <= octave_0(i-1,j+1)...
        || octave_1(i,j) <= octave_0(i,j-1)   || octave_1(i,j) <= octave_0(i,j)   || octave_1(i,j) <= octave_0(i,j+1)...
        || octave_1(i,j) <= octave_0(i+1,j-1) || octave_1(i,j) <= octave_0(i+1,j) || octave_1(i,j) <= octave_0(i+1,j+1)...
        || octave_1(i,j) <= octave_1(i-1,j-1) || octave_1(i,j) <= octave_1(i-1,j) || octave_1(i,j) <= octave_1(i-1,j+1)...
        || octave_1(i,j) <= octave_1(i,j-1)   || octave_1(i,j) <= octave_1(i,j+1)...
        || octave_1(i,j) <= octave_1(i+1,j-1) || octave_1(i,j) <= octave_1(i+1,j) || octave_1(i,j) <= octave_1(i+1,j+1)...
        || octave_1(i,j) <= octave_2(i-1,j-1) || octave_1(i,j) <= octave_2(i-1,j) || octave_1(i,j) <= octave_2(i-1,j+1)...
        || octave_1(i,j) <= octave_2(i,j-1)   || octave_1(i,j) <= octave_2(i,j)   || octave_1(i,j) <= octave_2(i,j+1)...
        || octave_1(i,j) <= octave_2(i+1,j-1) || octave_1(i,j) <= octave_2(i+1,j) || octave_1(i,j) <= octave_2(i+1,j+1)
             continue;
        end
        if harris_cornerness(octave_1,i,j,extent) > harris_thres; continue; end
        r = [r,i]; c = [c,j]; s = [s,o];
    end
end
end

function harris_measure = harris_cornerness(img, x, y, extent)
    l11 = 0; l12 = 0; l22 = 0;
    for i = -extent:extent
        for j = -extent:extent
            dy = img(x+i,y+j) - img(x+i,y+j-1);
            dx = img(x+i,y+j) - img(x+i-1,y+j);
            l11 = l11 + dy*dy;
            l12 = l12 + dx*dy;
            l22 = l22 + dx*dx;
        end
    end
    harris_measure = (l11+l22)^2/(l11*l22-l12*2); % tr^2/det
end