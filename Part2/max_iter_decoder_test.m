%% HYPERPARAMETERS

error_step = 0.05;
ber_iter = 10;
max_error = 0.5;

%% irregular ldpc code
e = 0.3;  
n1= 1000;
max_degree_v = 20; 
max_degree_c = 20; 
discr_step = 100; 
max_iter = 1000;
[p_variable, p_check] = optimize_connectivity_nodes(e, max_degree_v, max_degree_c, discr_step, max_iter);

[L, P] = ldpc_set_n(n1, p_variable, p_check);

H_irr = tanner_graph2(L,P);

[m1,n1] = size(H_irr);


%% compute ber
ber_irr1 = [];
ber_irr2 = [];
ber_irr3 = [];
i = 1;
max_iter1 = 4;
max_iter2 = 5;
max_iter3 = 10;

for e = 0:error_step:max_error
    
    counter_irr1 = 0;
    counter_irr2 = 0;
    counter_irr3 = 0;
    for j = 1:ber_iter
        word = zeros(1,n1);
        
       
        encoded_channel = erasure_channel(word, e);
        decoded = ldpc_decoder(H_irr, encoded_channel, max_iter1);
        counter_irr1 = counter_irr1 + sum(decoded ~= word(1:(n1-m1)))/(n1-m1);

       
        decoded = ldpc_decoder(H_irr, encoded_channel, max_iter2);
        counter_irr2 = counter_irr2 + sum(decoded ~= word(1:(n1-m1)))/(n1-m1);

        decoded = ldpc_decoder(H_irr, encoded_channel, max_iter3);
        counter_irr3 = counter_irr3 + sum(decoded ~= word(1:(n1-m1)))/(n1-m1);
    end

    ber_irr1(i) = counter_irr1/ber_iter;
    ber_irr2(i) = counter_irr2/ber_iter;
    ber_irr3(i) = counter_irr3/ber_iter;
    i = i+1;
end


%% plot
plot(0:error_step:max_error, ber_irr1)
hold on
plot(0:error_step:max_error, ber_irr2)
hold on 
plot(0:error_step:max_error, ber_irr3)
legend({'max iterations = 4', 'max iterations = 5', 'max iterations = 10'})
