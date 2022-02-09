function [u2N, c] = u2N_FIR_coefs(N)

u2N = zeros(1,N+2);
c = 2^(-N);

for k = (-(N+1)/2):((N+1)/2);
    u2N(k+(N+1)/2+1) = nchoosek((N+1),k+(N+1)/2);
end
    