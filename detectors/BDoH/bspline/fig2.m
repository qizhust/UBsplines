
x = -3:0.00001:3;
n=2;
sigma = sqrt((n+1)/12);
yb = bsplineN(x,n);
yg = exp(-0.5 * x.*x/(sigma^2))/(sqrt(2*pi)*sigma);
axes('position',[.05  .05  .9  .9])
plot(x,yb,'LineWidth',2);hold on,
plot(x,yg,'r--','LineWidth',2);grid on;