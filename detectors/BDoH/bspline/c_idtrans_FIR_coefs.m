function [b, c0] = c_idtrans_FIR_coefs(N)

% Use a precalculated table for low-order splines
idtrans_table = { {2,[1, 1]}, {2,[1, 1]}, {2, [1, 1]}, {48, [1, 23, 23, 1]}, ...
                {24, [1, 11, 11, 1]}, {3840, [1 237 1682 1682 237 1]},...
                {46080, [1, 722, 10543, 23548, 10543, 722, 1]},...
                {5040, [1, 120, 1191, 2416, 1191, 120, 1]} };

idtrans = idtrans_table{N +1};

b = idtrans{2};
c0 = idtrans{1};