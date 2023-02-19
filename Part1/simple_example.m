%%% Simple example of repetition and Hamming encoding %%%

clc
clear  

S = 10000; % number of sequences to check 
n = 7; % length of transmitted words
k = 4;
e = 1/8; % error % chance
sequences = (rand(S,k)>0.5)*1; % random 1 and 0 

%% Define codeded sequences
repeat = 4;
encoded1 = repet_encode(sequences, repeat); % Make sure same bandwidth
encoded2 = hamming_encode(sequences, n, k);

%% Pass random sequences through channel

channel_out1 = nan(size(encoded1));
channel_out2 = nan(size(encoded2));

for i = 1:S
    channel_out1(i,:) = bs_channel(encoded1(i,:), e)*1;
    channel_out2(i,:) = bs_channel(encoded2(i,:), e)*1;
end

channel_out1;
channel_out2;

%% Decode 
decoded1 = repet_decode(channel_out1, k, repeat);
decoded2 = hamming_decode(channel_out2, n, k);

ber1 = sequences - decoded1;
ber2 = sequences - decoded2;
sum(sum(abs(ber1)))/length(ber1(:))
sum(sum(abs(ber2)))/length(ber2(:))
% BER/rate(k/ham) διάγραμμα
