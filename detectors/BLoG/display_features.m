function display_features(file1,imf1,dx,dy)
%
%Displays affine regions on the image
%
%disp_features(file1,imf1,dx,dy)
%
%file1 - 'filename' - ASCII file with affine regions
%imf1 - 'filename'- image
%dx - shifts all the regions in the image by dx  
%dy - shifts all the regions in the image by dy
%
%example:
%disp_features('img1.haraff','img1.ppm',0,0)

[feat1 nb dim]=importFeatures(file1);
clf;imshow(imf1);
for c1=1:nb,%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drawellipse([feat1(3,c1) feat1(4,c1); feat1(4,c1) feat1(5,c1) ], feat1(1,c1)+dx, feat1(2,c1)+dy,'c');
end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

function drawellipse(Mi,i,j,col)
hold on;
[v e]=eig(Mi);

l1=1/sqrt(e(1));

l2=1/sqrt(e(4));

alpha=atan2(v(4),v(3));
s = 1;
t = 0:pi/50:2*pi;
y=s*(l2*sin(t));
x=s*(l1*cos(t));

xbar=x*cos(alpha) + y*sin(alpha);
ybar=y*cos(alpha) - x*sin(alpha);
plot(ybar+i,xbar+j,col,'LineWidth',1);
set(gca,'Position',[0 0 1 1]);
hold off;
end

