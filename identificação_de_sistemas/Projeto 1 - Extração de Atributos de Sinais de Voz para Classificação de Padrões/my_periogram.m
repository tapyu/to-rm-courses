function [p, all_f] = my_periogram(x,Fs)
% This function immitates the built-in function
% periogram()


N = numel(x);
delta_t = 1/Fs;
% Nyquist theorem
W = Fs/2;
all_f = 0:Fs/N:W;

% two-sided periogram -> see doc periodogram
p =  delta_t/N * abs(fft(x)).^2;
% transforming into one-sided
p = p(1:N/2+1);
p(2:end-1) = 2*p(2:end-1);
end