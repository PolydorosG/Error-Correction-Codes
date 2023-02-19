% Demo designing, encoding and decoding for irregular LDPC code
% make sure to uncomment line 6 of ldpc_decoder
clc
clear 


e = 0.2;  
n= 20;
max_degree_v = 3; 
max_degree_c = 5; 
discr_step = 100; 
max_iter = 1000;
[p_variable, p_check] = optimize_connectivity_nodes(e, max_degree_v, max_degree_c, discr_step, max_iter);

%% get variable degrees
[L, P] = ldpc_set_n(n, p_variable, p_check);


%% generate parity check matrix
H = tanner_graph2(L,P);
[m,n] = size(H);

%% encode
word = (rand(1,n-m)>0.5)*1;
encoded = ldpc_encoder(H, word, 1000000);


%% decode
encoded_channel = erasure_channel(encoded, 0.1);
decoded = ldpc_decoder(H, encoded_channel, 100);
if(decoded == word(1:(n-m)))
    disp('Decoded succesfully!')
else
    disp('Unsucceful decoding!')
end



