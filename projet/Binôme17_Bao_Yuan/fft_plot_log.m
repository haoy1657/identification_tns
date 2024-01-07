function fft_plot_log(data,fs,Title,Legend)
fftData = fft(data);
Fs=fs;
N = length(fftData);
frequencies = (0:N-1) * Fs / N;
n_half = ceil(N/2);
X_half = fftData(1:n_half);
f_half = frequencies(1:n_half);
figure;
loglog(f_half, abs(X_half));
xlabel('f (Hz)');
ylabel('Amplitude');
title(Title);
legend(Legend);

end