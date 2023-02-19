%% Hyperparameters

error_step = 0.05;
ber_iter = 10;
max_error = 0.5;

%% irregular ldpc code
e = 0.35;  
n1= 1000;
max_degree_v = 20; 
max_degree_c = 20; 
discr_step = 100; 
max_iter = 1000;
[p_variable, p_check] = optimize_connectivity_nodes(e, max_degree_v, max_degree_c, discr_step, max_iter);

[L, P] = ldpc_set_n(n1, p_variable, p_check);

H_irr = tanner_graph2(L,P);

[m1,n1] = size(H_irr);

%% regular ldpc code
n2 = 1000;
degree_v = 4;
degree_c = 10;

H_re = regular_tanner_graph(n2, degree_v, degree_c);

[m2,~] = size(H_re);


%% measure ber
ber_irr = [];
ber_re = [];
i = 1;

for e = 0:error_step:max_error
    
    counter_irr = 0;
    counter_re = 0;
    for j = 1:ber_iter
        word = zeros(1,n1);
        
       
        encoded_channel = erasure_channel(word, e);
        decoded = ldpc_decoder(H_irr, encoded_channel, max_iter);
        counter_irr = counter_irr + sum(decoded ~= word(1:(n1-m1)))/(n1-m1);

        encoded_channel = erasure_channel(word, e);
        decoded = ldpc_decoder(H_re, encoded_channel, max_iter);
        counter_re = counter_re + sum(decoded ~= word(1:(n2-m2)))/(n2-m2);
    end

    ber_irr(i) = counter_irr/ber_iter;
    ber_re(i) = counter_re/ber_iter;
    i = i+1;
end

%% plot


plot(0:error_step:max_error, ber_irr)
hold on
plot(0:error_step:max_error, ber_re)
