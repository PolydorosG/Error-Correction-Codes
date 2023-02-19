function [p_v, p_c] = optimize_connectivity_nodes(e, max_degree_v, max_degree_c, discr_step, max_iter)
    % e is the erasure rate of the channel
    % max_degree_v is the maximum degree of a variable node
    % max_degree_c is the maximum degree of a check node
    % max_iter is the maximum number of iterations for the optimization algorithm
    % discr_step is the discretization step
    % p_v is the optimized connection probability of the variable nodes
    % p_c is the optimized connection probability of the check nodes
    
    options = optimoptions('linprog','Display','none');

    p_v = ones(max_degree_v-1, 1) / (max_degree_v-1);
    p_c = ones(max_degree_c-1, 1) / (max_degree_c-1);
    

    for iter = 1:max_iter
        % Optimize the connection probability of the variable nodes
        f = -ones(1,max_degree_v-1) ./ (2:max_degree_v);
        A = zeros(discr_step, max_degree_v-1);
        for dis = 1:discr_step
            x = dis/discr_step;
            A(dis,:) = e* calc_r(p_c, 1-x, max_degree_v)';
            b(dis,:) = (dis/discr_step);
        end
        Aeq = ones(1,max_degree_v-1);
        beq = [1];
        lb = zeros(1,max_degree_v-1);
        ub = ones(1,max_degree_v-1);
        ub(1) = 1/(e*sum(p_c' .* (1:max_degree_c-1)));
        p_v = linprog(f, A, b, Aeq, beq, lb, ub, options);
        % Optimize the connection probability of the check nodes

        f = ones(1,max_degree_c-1) ./ (2:max_degree_c);
        A = zeros(discr_step, max_degree_c-1);
        for dis = 1:discr_step
            A(dis,:) = calc_l(p_v, dis/discr_step, max_degree_c, e)';
            b(dis,:) = [dis/discr_step];
        end
        Aeq = ones(1,max_degree_c-1);
        beq = [1];
        lb = zeros(1,max_degree_c-1);
        ub = ones(1,max_degree_c-1);
        p_c = linprog(f, A, b, Aeq, beq, lb, ub, options);
        
    end
end


function res = calc_r(p_c, x, max_degree_v)
    res = zeros(max_degree_v-1,1);
    for j = 2:max_degree_v
        for i=2:size(p_c)+1
            res(j-1) = res(j-1) + p_c(i-1)*x^(i-1);
        end
        res(j-1) = (1-res(j-1))^(j-1);
    end
end


function res = calc_l(p_v, y, max_degree_c,e)
    res = zeros(max_degree_c-1,1);
    for j = 2:max_degree_c
        for i=2:size(p_v)+1
            res(j-1) = res(j-1) + p_v(i-1)*y^(i-1);
        end
        res(j-1) = (1-(1-e*res(j-1))^(j-1));
    end
end