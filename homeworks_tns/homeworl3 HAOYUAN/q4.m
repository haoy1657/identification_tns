% Filter specifications
Fs = 1; % Sampling frequency in Hz
Wp = 0.1/(Fs/2); % Normalized passband frequency
Ws = 0.15/(Fs/2); % Normalized stopband frequency
Rp = 1; % Passband ripple in dB
Rs = 15; % Stopband attenuation in dB

% Butterworth filter design
[nb, Wnb] = buttord(Wp, Ws, Rp, Rs); % Butterworth filter order
[bb, ab] = butter(nb, Wnb); % Butterworth filter coefficients

% Chebyshev filter design
[nc, Wnc] = cheb1ord(Wp, Ws, Rp, Rs); % Chebyshev filter order
[bc, ac] = cheby1(nc, Rp, Wnc); % Chebyshev filter coefficients


    
% Filter coefficients (example from a designed filter)
b = bb; % Replace with actual filter coefficients
a = ab; % Replace with actual filter coefficients

% Quantize coefficients to 5 bits
bq = round(b * 2^5) / 2^5;
aq = round(a * 2^5) / 2^5;

% Frequency response of the quantized filter
[hq, wq] = freqz(bq, aq, 1024, Fs);

% Plot the transfer function
figure(1);
freqz(bq, aq, 1024, Fs);
title('Quantized Filter Frequency Response');


% Signal parameters
f1 = 1000; % Frequency of the first sinusoid in Hz
f2 = 1560; % Frequency of the second sinusoid in Hz
Fs = 10000; % Sampling frequency in Hz

% Design a lowpass FIR filter (using an arbitrary order, adjust as needed)
lpFilt = designfilt('lowpassfir', 'PassbandFrequency', f1, ...
                 'StopbandFrequency', f2, 'SampleRate', Fs);

% Generate the signal (example, replace with actual signal)
t = 0:1/Fs:1;
x = sin(2*pi*f1*t) + sin(2*pi*f2*t);

% Filter the signal
y = filter(lpFilt, x);

% Plot the original and filtered signal
figure(2);
subplot(2,1,1);
plot(t, x);
title('Original Signal');
subplot(2,1,2);
plot(t, y);
title('Filtered Signal (Extracted Sinusoid)');

% Filter specifications
fc = 6000; % Cutoff frequency in Hz
Fs = 20000; % Sampling frequency in Hz
N = 120; % Filter order

% Frequency sampling method to design a highpass FIR filter
f = [0 (2*fc/Fs) (2*fc/Fs) 1];
m = [0 0 1 1];
b = fir2(N, f, m);

% Plot the filter transfer function
[h, w] = freqz(b, 1, 1024, Fs);
figure(3);
plot(w, 20*log10(abs(h)));
title('Highpass FIR Filter Frequency Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

