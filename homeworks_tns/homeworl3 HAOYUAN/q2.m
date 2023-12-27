% Parameters
f0 = 100; % frequency of the sinusoid in Hz
fs = 1000; % sampling frequency in Hz
t = 0:1/fs:0.3-1/fs; % time vector for 0.3 seconds

% Generate the signal
signal = sin(2*pi*f0*t);
% FFT computation
N = length(signal); % number of points in the FFT
f = fs*(0:(N/2))/N; % frequency vector
Y = fft(signal);
P = abs(Y/N);

% Plotting the spectrum
figure(1);
plot(f, P(1:N/2+1))
title('Discrete Spectrum of the Signal')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

% Maximum frequency and maximal downsampling factor
f_max = max(f(P(1:N/2+1) > max(P)/100)); % Threshold to account for numerical issues
max_downsampling_factor = floor(fs/(2*f_max)); % Nyquist theorem

% Downsampling factors
downsampling_factors = [2, max_downsampling_factor, max_downsampling_factor+1];

% Downsampling and plotting to illustrate aliasing
for k = 1:length(downsampling_factors)
    downsampled_signal = downsample(signal, downsampling_factors(k));
    t_downsampled = downsample(t, downsampling_factors(k));
    
    % Plotting downsampled signal
    figure(2);
    plot(t_downsampled, downsampled_signal);
    title(['Downsampled Signal with Factor ', num2str(downsampling_factors(k))]);
    xlabel('Time (s)');
    ylabel('Amplitude');
end
% Downsampling with the maximal factor
downsampled_signal = downsample(signal, max_downsampling_factor);
t_downsampled = t(1:max_downsampling_factor:end); % correct the time vector for downsampled signal

% New sampling frequency
new_fs = 1.2 * fs;

% Generating a new time vector for the upsampled signal
upsample_time = 0:1/new_fs:((length(t_downsampled)-1)/fs);

% Upsampling
upsampled_signal = interp1(t_downsampled, downsampled_signal, upsample_time, 'linear', 'extrap');

% Plotting both signals
figure(3);
subplot(2,1,1);
plot(t, signal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(upsample_time, upsampled_signal);
title('Upsampled Signal');
xlabel('Time (s)');
ylabel('Amplitude');
