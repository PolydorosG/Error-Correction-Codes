function output = bs_channel(input, e)
    % input - 2D array input, each row is a codeword
    % e - probability of error
    % output - output sequences with errors

    s = size(input);
    r = rand(s) < e;
    output = xor(input,r);

end

