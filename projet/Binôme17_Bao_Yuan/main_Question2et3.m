clear all;
close all;

% % % % % % 
% % % % QUESTION 2
% Load initial data and data from Question 1
load('donnees_initial_full_robot.mat');
load('donnees_obtenues_Q1.mat');
% % %

% Resample tau1_fil and plot its FFT with 2500Hz and 1000Hz
tau1_resample = resample(tau1_fil, 2 , 5);
fft_plot_log(tau1_fil, 2500, 'tau1fil 2500Hz', 'tau1fil 2500Hz')
fft_plot_log(tau1_resample, 1000, 'tau1fil 1000Hz', 'tau1fil 1000Hz')

% Resample tau2_fil and plot its FFT with 2500Hz and 1000Hz
tau2_resample = resample(tau2_fil, 2 , 5);
fft_plot_log(tau2_fil, 2500, 'tau2fil 2500Hz', 'tau2fil 2500Hz')
fft_plot_log(tau2_resample, 1000, 'tau2fil 1000Hz', 'tau2fil 1000Hz')

% % QUESTION 3
% Combine q1_fil and q2_fil
combined_q = [q1_fil; q2_fil];
combined_tau = [tau1_resample; tau2_resample];

% Calculate the cross-correlation and time delay
[correlation, lags] = xcorr(combined_q, combined_tau);
[~, I] = max(abs(correlation));
time_delay = lags(I);
time_delay_in_seconds = time_delay / 1000;
disp('Time delay before the signal moves');
disp(time_delay);

% Remove the first 400 samples from q1_fil and q2_fil
q1_fil = q1_fil(401:end);
q2_fil = q2_fil(401:end);

% Combine q1_fil and q2_fil again
combined_q = [q1_fil; q2_fil];

% Calculate the cross-correlation and time delay after the signal moves
[correlation, lags] = xcorr(combined_q, combined_tau);
[~, I] = max(abs(correlation));
time_delay = lags(I);
time_delay_in_seconds = time_delay / 1000;
disp('Time delay after the signal moves');
disp(time_delay);
