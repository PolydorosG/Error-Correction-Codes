function encoded = ldpc_encoder(H, r, max_iter)
    
    [n, m] = size(H);

    check = mod(sum(H,2),2)';
    
    parity = (rand(1,n)>0.5)*1;
    
    counter = 0;

    for iter = 1:max_iter

        for i = 1:n
            inds = H(i,:) == 1;
            vals1 = r(inds(1:(m-n)));
            vals2 = parity(inds((m-n+1):m));
            if isempty(vals2)
                counter = counter + 1;
                continue;
            end
            if(mod(sum(vals1) + sum(vals2),2) ~= check(i))
                tmp = find(inds((m-n+1):m) == 1);
                rand_ind = randi([1 length(tmp)], 1, 1);
                parity(tmp(rand_ind)) = mod(parity(tmp(rand_ind)) + 1 , 2);
            else
                counter = counter + 1;
            end
           
        end
        if(counter == n)
            "Converged in " + iter + " iterations";
            break;
        else
            counter = 0;
        end
    end
    
    encoded = [r, parity];
    