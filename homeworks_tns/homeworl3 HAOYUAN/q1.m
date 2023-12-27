% Define the signal x[n]
N = 1024;
n = 0:N-1;
x = randn(1, N); % Example random signal

% Compute power in time domain
Pt = sum(abs(x).^2)/N;

% Compute power in frequency domain using FFT
Xf = fft(x);
Pf = sum(abs(Xf).^2)/N;

% Check if both powers are approximately equal
parseval_check = isequal(Pt, Pf);
disp(['Parseval''s theorem check: ', num2str(parseval_check)]);
% Parameters for the sine sweep
f0 = 0; % Start frequency
f1 = 100; % End frequency
t = linspace(0, 1, N);
A = 5; % Amplitude

% Generate the sine sweep
y = chirp(t, f0, t(end), f1) * A;

% Compute its power 
Py = bandpower(y);

% Plot its spectrogram
figure(1)
spectrogram(y, 'yaxis');
title('Spectrogram of exponential sine sweep');
% Generate Gaussian white noise of power equal to half the power of the sine sweep
noise_power = Py / 2;
noise_std = sqrt(noise_power);
noise = noise_std * randn(1, N);

% Plot histogram to verify Gaussian distribution
figure(2)
histogram(noise, 100, 'Normalization', 'pdf');
hold on;
x_values = linspace(min(noise), max(noise), 1000);
plot(x_values, normpdf(x_values, 0, noise_std), 'LineWidth', 2);
title('Histogram of Gaussian white noise');
hold off;

% Generate composite signal
composite_signal = y + noise;

% Compute the SNR
signal_power = bandpower(composite_signal);
noise_power = bandpower(noise);
SNR = 10 * log10(signal_power / noise_power);
disp(['SNR of composite signal: ', num2str(SNR), ' dB']);

% Plot the spectrogram of the composite signal
figure(3)
spectrogram(composite_signal, 'yaxis');
title('Spectrogram of composite signal');

desired_snr = 20; % SNR in dB
composite_signal_with_snr = generate_composite_signal(desired_snr, y);

% Plot the spectrogram of this signal
figure(4)
spectrogram(composite_signal_with_snr, 'yaxis');
title(['Spectrogram of composite signal with ', num2str(desired_snr), ' dB SNR']);





