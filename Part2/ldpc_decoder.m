function decoded = ldpc_decoder(H, encoded, max_iter)
    
    [n, m] = size(H);
    
    %for low n demo uncomment below
    %check = mod(sum(H,2),2)';
    check = zeros(1,n);

    for iter = 1:max_iter
        for i = 1:n
            inds = H(i,:) == 1;
            vals = encoded(inds);

            if(nnz(isnan(vals)) == 1)
                vals1 = vals(~isnan(vals));
                ind = all([inds ; isnan(encoded)]);
                encoded(ind) = mod(check(i) + sum(vals1),2);
            end
           
        end
        if(~isnan(encoded))
            "Converged in " + iter + " iterations";
            break;
        end
    end
    
    decoded = encoded(1:(m-n));
    