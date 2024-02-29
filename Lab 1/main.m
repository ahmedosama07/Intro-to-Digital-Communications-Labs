% Simulation parameters
NBITS = 1e6;                                % Number of bits/SNR
SNRRANGE = -20 : 2 : 20;                    % Signal to noise ratio range in dB

itterations = 100;                          % Number of itterations for Monte-Carlo simulation
berAvg = 0;                                 % BER average for Monte-Carlo simulation
berVect = zeros(size(SNRRANGE));            % BER results for each SNR

for i = 1 : length(SNRRANGE)
    snrdb  = SNRRANGE(i);
    % Generate random binary data vector
    signal = randi([0 1], 1, NBITS);
    for j = 1 : itterations
        % Apply noise to bits (Hint: you must calculate the signal power in
        % this case because it is not unity)
        signalPWR = mean(signal .^ 2);       % Signal power
        snr = 10 ^ (snrdb / 10);             % SNR
        noisePWR = sqrt(signalPWR / snr);    % Noise power
        noise = noisePWR * randn(1, NBITS);  % Noise vector
        rx_sequence = signal + noise;        % Apply noise to signal
        
        % Decide whether the Rx_sequence is '1' or '0' by comparing the
        % samples (Hint: try to use relational operators and indexing to
        % make the code more efficient)
        signalimg = (rx_sequence > 0.5);
        
        % Compare the original bits with the detected bits and calculate
        % number of errors
        nerrors = sum(signal ~= signalimg);
        ber = nerrors / NBITS;              % BER
        berAvg = berAvg + ber;              % BER accumulator for Monte-Carlo simulation
    end
    berAvg = berAvg / itterations;          % BER average due to Monte-Carlo simulation
    berVect(i) = berAvg;
    berAvg = 0;
end

% Plot the BER curve against SNR (use semilogy)
figure();
title('BER against SNR');
semilogy(SNRRANGE, berVect, '-o');
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
grid on;
fprintf('SNR (dB)	|   BER\n');
fprintf('%6.2f      |   %.8f\n', [SNRRANGE; berVect]);