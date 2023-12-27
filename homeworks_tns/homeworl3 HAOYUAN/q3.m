% Define parameters for signal generation
N = 1000; % Number of samples
mean = 0; % Mean of the White Gaussian Noise
std = 1; % Standard deviation of the White Gaussian Noise
delay_samples = 50; % Delay in samples

% Generate the White Gaussian Noise signal
original_signal = mean + std .* randn(N, 1);

% Generate the delayed signal
delayed_signal = [zeros(delay_samples, 1); original_signal(1:end-delay_samples)];

% Compute discrete-time correlation and estimate the delay in samples
[correlation, lags] = xcorr(delayed_signal, original_signal, 'biased');
[~, I] = max(correlation);
estimated_delay = lags(I);

% Compensate the delay between the signals
compensated_signal = circshift(delayed_signal, -estimated_delay);

% Plot the signals
figure;
subplot(2,1,1);
plot(original_signal);
hold on;
plot(delayed_signal);
title('Original and Delayed Signals');
legend('Original Signal', 'Delayed Signal');
hold off;

subplot(2,1,2);
plot(compensated_signal);
title('Compensated Signal');
legend('Compensated Signal');

% Output the correlation and estimated delay for further use
correlation;
estimated_delay;
