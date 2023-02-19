function c = repet_encode(x, repeat)
    % x - binary matrix to be encoded row-wise
    % repeat - # of times to repeat each bit
    % c - encoded sequence
    
    S = size(x,1);
    L = size(x,2);
    c = nan(S, L*repeat);

    for i = 0:L-1   
        c(:, i*repeat+1:(i+1)*repeat) = repmat(x(:, i+1), 1, repeat);
    end

end

