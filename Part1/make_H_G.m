function [H, G] = make_H_G(n, k)
    % n - length of Hamming codeword
    % k - # of non parity bits
    % H - parity check matrix
    % G - generatr matrix
    
    I_k = eye(n-k);
    bins = de2bi(1:2^(n-k)-1);

    rem = sum(bins,2) == 1;
    bins(rem,:) = [];

    H = [bins', I_k]; 

    G = [eye(k), bins];
end

