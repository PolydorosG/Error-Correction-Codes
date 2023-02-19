function c = hamming_encode(x, n, k)
    % x - binary matrix to be encoded row-wise
    % n - length of Hamming codeword
    % k - # of non parity bits
    % c - encoded sequence
    
    c = zeros(size(x,1), n);
    [~, G] = make_H_G(n, k);

    for row = 1:size(x,1)
        c(row,:) = mod(x(row,:)*G,2);
    end

end

