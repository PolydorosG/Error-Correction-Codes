function [L, P] = ldpc_set_n(n, p_variable, p_check)
    

    max_degree_v = length(p_variable)+1;
    max_degree_c = length(p_check)+1;
    degs_v = (2:max_degree_v);
    degs_c = (2:max_degree_c);
    
    sum_lj = sum(p_variable ./ degs_v');
    
    % Make initial estimation of L and P
    L_cap = floor(n/sum_lj * p_variable./degs_v');
    P_cap = floor(n/sum_lj * p_check./degs_c');
    
    % Calculate A
    sum_Pi = max_degree_v*sum(p_check./degs_c')/sum(p_variable ./ degs_v');
    A = sum_Pi - sum(P_cap);
    
    % Optimize minimization 
    f = [zeros(1,max_degree_v-1), ones(1,max_degree_c-1)]' ;
    
    C4A = -f';
    C4b = -ceil(A);
    
    lam = [ones(1,max_degree_v-1), zeros(1,max_degree_c-1)]';
    tot_degs = [degs_v, degs_c];
    
    C12Aeq = zeros(2, size(f,1));
    C12Aeq(1,:) = lam;
    C12Aeq(2,:) = lam.*tot_degs' - f.*tot_degs'; 

    C12beq = [n - sum(L_cap); 
              sum(P_cap'.*(2:max_degree_c)) - sum(L_cap'.*(2:max_degree_v))];
    
    
    lb = zeros(1,max_degree_c-1+max_degree_v-1);
    ub = 1+lb;
          
    [x_cap_min, obj_min] = intlinprog(f, ...
                                    1:length(f), ...
                                    C4A, ...
                                    C4b, ...
                                    C12Aeq, ...
                                    C12beq, ...
                                    lb,...
                                    ub);
                   
    % Optimize maximization
    
    f = -[zeros(1,max_degree_v-1), ones(1,max_degree_c-1)]' ;
    
    C4A = -f';
    C4b = floor(A);
    
    C12Aeq = zeros(2, size(f,1));
    C12Aeq(1,:) = lam;
    C12Aeq(2,:) = lam.*tot_degs' + f.*tot_degs';

    C12beq = [n - sum(L_cap); 
              sum(P_cap'.*degs_c) - sum(L_cap'.*degs_v)];
          
    [x_cap_max, obj_max] = intlinprog(f, ...
                                      1:length(f), ...
                                      C4A, ...
                                      C4b, ...
                                      C12Aeq, ...
                                      C12beq, ...
                                      lb,...
                                      ub); 
   
   % Pick the best solution of the two
   id = -obj_max-A > obj_min-A;

   if isempty(obj_max)
       "error max"
       id = 1;
   end
   
   if isempty(obj_min)
       "error min"
       id = 0; 
   end 
   
   if id == 0
       x_cap = x_cap_max;
   else
       x_cap = x_cap_min;
   end

   L = L_cap + x_cap(1:length(L_cap));
   P = P_cap + x_cap(length(L)+1:end);
end

