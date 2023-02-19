function decoded = repet_decode(x, L, repeat)
	% x - binary matrix to be encoded row-wise
    % L - length of transmitted words
    % repeat - # number of repetitions per bit
    % decoded - decoded sequences
    
    S = size(x, 1);
    decoded = nan(S,L);

    % for each column do a majority vote 
    for i= 0:L-1 
        majority_vote = mode(x(:,i*repeat+1:(i+1)*repeat)')';
        decoded(:,i+1) = majority_vote;
    end 

end

