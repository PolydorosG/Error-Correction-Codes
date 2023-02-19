clc
clear  

S = 100000; % number of sequences to check 
n = [3 7 15 31 63]; % length of transmitted words
k = [1 4 11 26 57];
e = 0.2; % error % chance
t_enc = [];
t_dec = [];

for i = 1:length(n)
    sequences = (rand(S,k(i))>0.5)*1; % random 1 and 0 
    
    tstart = tic;
    % Define codeded sequences
    encoded = hamming_encode(sequences, n(i), k(i));
    t_enc(i) = toc(tstart);
    
    % Pass random sequences through channel
    channel_out = nan(size(encoded));

    for l = 1:S
        channel_out(l,:) = bs_channel(encoded(l,:), e)*1;
    end


    %% Decode 
    tstart = tic;
    decoded = hamming_decode(channel_out, n(i), k(i));
    t_dec(i) = toc(tstart);
    
    ber = sequences - decoded;
    sum(sum(abs(ber)))/length(ber(:));
end

%% Plots
figure
plot(n.*k, t_enc)
title('Hamming encoder time with respect to n*k')
xlabel('n*k') 
ylabel('seconds')

figure
plot(n.*k, t_dec)
title('Hamming decoder time with respect to n*k')
xlabel('n*k') 
ylabel('seconds')





