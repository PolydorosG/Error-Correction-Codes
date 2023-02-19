function H = tanner_graph2(L,P)

    n = int16(sum(P));
    m = int16(sum(L));
    H = zeros(n, m);

    p_d = [(2:length(P)+1)', P];
    check_degs = repelem(p_d(:,1).', int16(p_d(:,2).'))'; % List of check degrees 
    check_degs = check_degs(randperm(length(check_degs)));
    
    l_d = [(2:length(L)+1)', L];
    var_degs = repelem(l_d(:,1).', int16(l_d(:,2).'))'; % List of variable degrees 
   
    var_pool = 1:length(var_degs); % variable nodes 
    
    % For each check node
    for cn = 1:length(check_degs) 
        local_pool = var_pool;
        
        % For each of its vertices
        for vert = 1:check_degs(cn)
            
            if isempty(local_pool)
                break
            end
            
            % Find a random variable node to connect it to
            index = randi(length(local_pool));
            vn = local_pool(index);
            
            while var_degs(vn) == 0 ||  H(cn,vn) == 1
                
                if H(cn,vn) == 1
                   local_pool(index) = []; 
                   if isempty(local_pool)
                       break
                   end
                end
                 
                index = randi(length(local_pool));
                vn = local_pool(index);
            end

            % Once found make the connection and reduce their degrees
            H(cn,vn) = 1;
            check_degs(cn) = check_degs(cn) - 1;
            var_degs(vn) = var_degs(vn) - 1;
            
            if var_degs(vn) == 0 
                var_pool(var_pool == vn) = []; % remove from variable pool
                if isempty(var_pool)
                       return
                end
            end
            
        end
    end

    
end