clc
clear 

es = 0:0.05:0.5;
r = 3:4:20;
lgd = cell(length(r),1);
id2 = 1;

for repeat = r
    ber = [];
    index = 1;
    for e=es

        S = 10000; % number of sequences to check 
        k = 10; % length of transmitted words
        sequences = (rand(S,k)>0.5)*1; % random 1 and 0 

        % Define codeded sequences
        encoded1 = repet_encode(sequences, repeat);

        % Pass random sequences through channel
        channel_out1 = nan(size(encoded1));

        for i = 1:S
            channel_out1(i,:) = bs_channel(encoded1(i,:), e)*1;
        end
        % Decode 
        decoded1 = repet_decode(channel_out1, k, repeat);

        ber1 = sequences - decoded1;
        ber(index) = sum(sum(abs(ber1)))/length(ber1(:));
        index = index + 1;
    end
    
    plot(es, ber)
    lgd{id2} = "r = " + int2str(repeat);
    id2 = id2+1;
    hold on 
end

title('Repetition code BER')
xlabel('error probability') 
ylabel('bit error rate')
legend(lgd)



