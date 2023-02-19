function output = erasure_channel(input, e)
    % input - 2D array input, each row is a codeword
    % e - probability of erasure
    % output - output sequence with errors
    % Given input sequence and erasure probability
    % return output sequence with erasures as Nan
    
    s = size(input);
    r = (rand(s) > e)*1;
    r(r==0) = NaN;
    output = input.*r;
    
end

