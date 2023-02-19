function decoded = hamming_decode(x, n, k)
    % x - binary matrix to be decoded row-wise
    % n - codeword length
    % k - non parity bits 
    % decoded - decoded sequences
    
    [H, ~] = make_H_G(n, k);
    S = size(x,1);
    decoded = zeros(S,k);
    
    for i= 1:S
        s = mod(x(i,:)*H', 2);
        
        [q, idx] = ismember(s, H', 'rows');
        if (~q)
            decoded(i,:) = x(i, 1:k);
        else
            x(i, idx) = xor(x(i, idx), 1);
            decoded(i,:) = x(i, 1:k);
        end
    end
    decoded = decoded(:, 1:k);
end
