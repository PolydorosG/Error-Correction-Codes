clc
clear  

S = 10000; % number of sequences to check 
n = [3 7 15 31 63]; % length of transmitted words
k = [1 4 11 26 57];
es = 0:0.05:0.5; % error % chance
t_enc = [];
t_dec = [];
lgd = cell(length(n),1);
id2 = 1;

for i = 1:length(n)
    i
    ber = [];
    index = 1;
    
    for e=es
        sequences = (rand(S,k(i))>0.5)*1; % random 1 and 0 

        % Define codeded sequences
        encoded = hamming_encode(sequences, n(i), k(i));

        % Pass random sequences through channel
        channel_out = nan(size(encoded));

        for l = 1:S
            channel_out(l,:) = bs_channel(encoded(l,:), e)*1;
        end

        % Decode 
        decoded = hamming_decode(channel_out, n(i), k(i));
        
        % BER
        ber_t = sequences - decoded;
        ber(index) = sum(sum(abs(ber_t)))/length(ber_t(:));
        index = index+1;
    end
    plot(es, ber)
    lgd{id2} = "("+int2str(n(i))+","+int2str(k(i))+ ")" ;
    id2 = id2+1;
    hold on 
end

%% Plots
title('Hamming code BER')
xlabel('error probability') 
ylabel('bit error rate')
legend(lgd)



