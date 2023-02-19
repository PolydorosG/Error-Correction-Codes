%% Time complexity encoder m
clc
clear

S = 1000; % number of sequences to check 
e = 0.2; % error % chance
repeat = 3;
times = [];
id = 1;
log = int64(logspace(1,3,500));

for m=log
    sequences = (rand(S,m)>0.5)*1; % random 1 and 0 
    encoded1 = repet_encode(sequences, repeat);     
    
    channel_out1 = nan(size(encoded1));
    for l = 1:S
        channel_out1(l,:) = bs_channel(encoded1(l,:), e)*1;
    end

    % Decode 
    tstart = tic;
    decoded1 = repet_decode(channel_out1, m, repeat);
    times(id) = toc(tstart);
    
    id = id+1;
end

plot(log, times)
title('Repetition Decoding time with respect to m')
xlabel('message length') 
ylabel('seconds')


%% Time complexity encoder r
clc
clear

S = 1000; % number of sequences to check 
e = 0.2; % error % chance
m = 10;
times = [];
id = 1;
r = int64(round(logspace(1,3,500)));

for i=r
    sequences = (rand(S,m)>0.5)*1; % random 1 and 0 
    encoded1 = repet_encode(sequences, i); 
    
    channel_out1 = nan(size(encoded1));
    for l = 1:S
        channel_out1(l,:) = bs_channel(encoded1(l,:), e)*1;
    end

    % Decode 
    tstart = tic;
    decoded1 = repet_decode(channel_out1, m, i);
    times(id) = toc(tstart);
    id = id+1;
end

plot(r, times)
title('Repetition decoding time with respect to r')
xlabel('repetitions per bit') 
ylabel('seconds')


