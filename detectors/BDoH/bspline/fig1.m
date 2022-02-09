clc
clear
x = -2:0.02:2;
% y = bspline0(x);
% hold on;
% plot(x,y,'r','LineWidth',1.5);
% % y = bspline1(x);
% plot(x,y,'g','LineWidth',1.5);
% y = bspline2(x/2);
% plot(2*x,y,'b','LineWidth',1.5);
% y = bspline3(x);
% plot(x,y,'m','LineWidth',1.5);
% grid on;
% legend('Degree 0','Degree 1','Degree 2','Degree 3');

y1 = bsplineNkernel(x,0,sqrt(3));
y2 = bspline11(x,sqrt(6)/2);
g = y2'*y2;
g = (g-min(g(:)))/(max(g(:))-min(g(:)));
imshow(g,'border','tight','initialmagnification','fit');