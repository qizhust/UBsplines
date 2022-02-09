function output = finiteDiff_m( a, gb )
%FINITEDIFF_M 此处显示有关此函数的摘要
%   此处显示详细说明

tau1 = (sqrt(2)*a(1)+a(2)-a(4)-sqrt(2))/(2*sqrt(2));
tau2 = (a(2)+sqrt(2)*a(3)+a(4)-3*sqrt(2))/(2*sqrt(2));
a2 = a(2)/sqrt(2);
a4 = a(4)/sqrt(2);
xi = [0,0; a(1),0; a2,a2; a(1)+a2,a2;...
    0,a(3); a(1),a(3); a2,a(3)+a2; a(1)+a2,a(3)+a2;...
    -a4,a4; a(1)-a4,a4; a2-a4,a2+a4; a(1)+a2-a4,a2+a4;...
    -a4,a(3)+a4; a(1)-a4,a(3)+a4; a2-a4,a(3)+a2+a4; a(1)+a2-a4,a(3)+a2+a4]; 
w = 1/(a(1)*a(2)*a(3)*a(4));
wi = [w, -w, -w, w, -w, w, w, -w,...
    -w, w, w, -w, w, -w, -w, w];

xall1 = [0,0; 1,0; 0,1; -1,1; -1,0; -1,-1; 0,-1];
xall2 = [0,0; 0,-1; 1,0; 1,1; 0,1; -1,1; -1,0];
xall3 = [0,0; 0,1; -1,0; -1,-1; 0,-1; 1,-1; 1,0];
xall4 = [0,0; -1,0; 0,-1; 1,-1; 1,0; 1,1; 0,1];

% tic
output = finiteDiff_c(gb, tau1, tau2, xi, wi, xall1, xall2, xall3, xall4);
% toc
end

