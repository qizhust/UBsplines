function output = finiteDiff2(a, gb)

[rows, cols] = size(gb);
output = zeros(rows, cols);

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

%--------------- FD -----------------

for i = 1:rows
    for j = 1:cols
% for i = 1:10
%     for j = 1:10
        x1_curr = i+tau1-xi(:,1);
%         x1_curr = filtminmax(x1_curr, 1, rows);
        x2_curr = j+tau2-xi(:,2);
%         x2_curr = filtminmax(x2_curr, 1, cols);
        
        for k = 1:16
            if x1_curr(k)>3/2 && x2_curr(k)>3/2 && x1_curr(k)<rows-3/2 && x2_curr(k)<cols-3/2
                F_zp = fastZP(gb, [x1_curr(k), x2_curr(k)]);
                output(i,j) = output(i,j) + wi(k)*F_zp;
            else
                output(i,j) = 0;
                break
            end
        end
        
    end
end

end

function x = filtminmax(x, min_value, max_value)
x = min(x, max_value);
x = max(min_value, x);
end