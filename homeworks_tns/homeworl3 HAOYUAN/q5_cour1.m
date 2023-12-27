% Example usage:
% Load a recorded segment of speech (replace with the path to your file)
[speech, Fs] = audioread('b.wav');

% Quantize the speech signal
num_bits = 8; % Number of bits for quantization
scale = 1; % Scale for the quantizer
quantized_speech = quantize_signal(speech, num_bits, scale);

% Plot the original and quantized signal
figure(1);
subplot(2,1,1);
plot(speech);
title('Original Speech Signal');
subplot(2,1,2);
plot(quantized_speech);
title(['Quantized Speech Signal with ', num2str(num_bits), ' bits']);

% Default MATLAB/OCTAVE uses double-precision floating-point numbers
% which are 64-bit. Here we simulate a 32-bit floating point signal.

% Generate a random noise signal with 32-bit precision
noise_signal = single(randn(1000, 1)); % Using 'single' for 32-bit precision

% Simulate quantization and calculate SNR
num_bits = 8:2:32; % Range of quantization bits
snr_values = zeros(length(num_bits), 1); % To store SNR values

for i = 1:length(num_bits)
    quantized_noise = quantize_signal(noise_signal, num_bits(i), scale);
    snr_values(i) = snr(noise_signal, noise_signal - quantized_noise);
end

% Plot the SNR values
figure(2);
plot(num_bits, snr_values);
xlabel('Number of Bits');
ylabel('SNR (dB)');
title('SNR vs. Quantization Bits');

% Load an audio signal
[audio_signal, Fs] = audioread('b.wav');

% Get the associated number of bits
audio_info = audioinfo('b.wav');
num_bits_audio = audio_info.BitsPerSample;

% Determine the quantum value graphically
quantum_values = 2^(-num_bits_audio);

% Plot the differences between consecutive samples
sample_differences = diff(audio_signal);
figure(3);
stem(sample_differences(1:100)); % Plotting first 100 differences for clarity
title('Sample Differences of Audio Signal');
xlabel('Sample Number');
ylabel('Difference Value');

% Method reliability analysis:
% The method is not entirely reliable because it assumes that the smallest
% difference between samples is due to quantization, which might not always be the case.

% A more reliable method would involve statistical analysis of the differences to
% determine the most frequent small difference, which would likely correspond to the
% quantum value. Another approach could be to use a histogram to identify the most
% common difference, which should correspond to the quantization step size.

% Histogram to find the most common difference
figure(4);
histogram(sample_differences, 'Normalization', 'probability');
title('Histogram of Sample Differences');
xlabel('Difference Value');
ylabel('Probability');
