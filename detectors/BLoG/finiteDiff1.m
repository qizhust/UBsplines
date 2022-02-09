function fout = finiteDiff1( a,  g )
% Finite difference
% Input: a --- scale vector, 1*4
%        g --- running sum matrix
% Output: fout --- filtered signal

[rows,cols] = size(g);
fout = zeros(rows,cols);
a_new = a/sqrt(2);

tao1 = (sqrt(2)*a(1)+a(2)-a(4)-sqrt(2))/(2*sqrt(2));
tao2 = (a(2)+sqrt(2)*a(3)+a(4)-3*sqrt(2))/(2*sqrt(2));
w0 = 1/(a(1)*a(2)*a(3)*a(4));
w = [w0,-w0,-w0, w0,-w0, w0, w0,-w0,...
    -w0, w0, w0,-w0, w0,-w0,-w0, w0];
x = [0,0;a(1),0;a_new(2),a_new(2);a(1)+a_new(2),a_new(2);...
    0,a(3);a(1),a(3);a_new(2),a(3)+a_new(2);a(1)+a_new(2),a(3)+a_new(2);...
    -a_new(4),a_new(4);a(1)-a_new(4),a_new(4);a_new(2)-a_new(4),a_new(2)+a_new(4);a(1)+a_new(2)-a_new(4),a_new(2)+a_new(4);...
    -a_new(4),a(3)+a_new(4);a(1)-a_new(4),a(3)+a_new(4);a_new(2)-a_new(4),a(3)+a_new(2)+a_new(4);a(1)+a_new(2)-a_new(4),a(3)+a_new(2)+a_new(4)];


for i = 1:rows
    for j = 1:cols
        for k = 1:16
            x_curr = [i+tao1-x(k,1), j+tao2-x(k,2)];
            
            % In order to make sure x0,...,x6 are within the support of spline function center at point x_curr
            if x_curr(1)>3/2 && x_curr(2)>3/2 && x_curr(1)<rows-3/2 && x_curr(2)<cols-3/2
                F_zp = fastZP(g,x_curr);
%                 fprintf('fastZP interpolated value: %d\n',F_zp);
                fout(i,j) = fout(i,j) + w(k)*F_zp;
            else
                fout(i,j) = 0;
                break
            end
        end
        
%         fprintf('fout = sum(F_zp) = %d\n',fout(i,j));
    end
end
end

