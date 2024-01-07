clear all;
close all;

% 
% % % % QUESTION 4
% Load initial data and data from Questions 2 and 3
load('donnees_initial_full_robot.mat');
load('donnees_obtenues_Q23.mat');

% % q1 q1dot q1dotdot

% Design a Butterworth filter for q1_fil_fil
[N, Wn] = buttord(2/(500), 120/(500), 1, 60); 
[b, a] = butter(N, Wn); 
q1_fil_fil = filtfilt(b, a, q1_fil);

% Plot FFTs of q1_fil and q1_fil_fil
fft_plot_log(q1_fil, 1000, 'q1 fil', 'q1 fil');
fft_plot_log(q1_fil_fil, 1000, 'q1 fil fil', 'q1 fil fil');

% Calculate q1_dot and filter it
q1_dot = diff(q1_fil_fil) / 1e-3;
fft_plot_log(q1_dot, 1000, 'q1 dot', 'q1 dot');
[N, Wn] = buttord(5/(500), 120/(500), 1, 60); 
[b, a] = butter(N, Wn); 
q1_dot_fil = filtfilt(b, a, q1_dot);
fft_plot_log(q1_dot_fil, 1000, 'q1 dot fil', 'q1 dot fil');

% Calculate q1_dotdot and filter it
q1_dotdot = diff(q1_dot_fil) / 1e-3;
fft_plot_log(q1_dotdot, 1000, 'q1 dot dot', 'q1 dot dot');
[N, Wn] = buttord(3/(500), 120/(500), 1, 120); 
[b, a] = butter(N, Wn);
q1_dotdot_fil = filtfilt(b, a, q1_dotdot);
fft_plot_log(q1_dotdot_fil, 1000, 'q1 dot dot fil', 'q1 dot dot fil');

% q2 q2dot q2dotddot

% Design a Butterworth filter for q2_fil_fil
[N, Wn] = buttord(2/(500), 120/(500), 1, 60); 
[b, a] = butter(N, Wn); 
q2_fil_fil = filtfilt(b, a, q2_fil);

% Plot FFTs of q2_fil and q2_fil_fil
fft_plot_log(q2_fil, 1000, 'q2 fil', 'q2 fil');
fft_plot_log(q2_fil_fil, 1000, 'q2 fil fil', 'q2 fil fil');

% Calculate q2_dot and q2_dotdot
q2_dot = diff(q2_fil_fil) / 1e-3;
fft_plot_log(q2_dot, 1000, 'q2 dot', 'q2 dot');
q2_dotdot = diff(q2_dot) / 1e-3;
fft_plot_log(q2_dotdot, 1000, 'q2 dot dot', 'q2 dot dot');

% Remove Gaussian noise from the signal tau
[N, Wn] = buttord(10/(500), 120/(500), 1, 60); 
[b, a] = butter(N, Wn); 
tau1_fil = filtfilt(b, a, tau1_resample);
fft_plot_log(tau1_resample, 1000, 'tau1 resample', 'tau1 resample');
fft_plot_log(tau1_fil, 1000, 'tau1 resample fil', 'tau1 resample fil');

tau2_fil = filtfilt(b, a, tau2_resample);
fft_plot_log(tau2_resample, 1000, 'tau2 resample', 'tau2 resample');
fft_plot_log(tau2_fil, 1000, 'tau2 resample fil', 'tau2 resample fil');

% Plot comparisons between initial and filtered signals
figure
subplot(411);
hold on;
plot(q1_initial)
plot(q1_fil_fil)
xlabel('n');
ylabel('Amplitude');
title('q1 initial and q1 final');
legend('q1 initial', 'q1 final');
hold off;

subplot(412);
hold on;
plot(q2_initial)
plot(q2_fil_fil)
xlabel('n');
ylabel('Amplitude');
title('q2 initial and q2 final');
legend('q2 initial', 'q2 final');
hold off;

subplot(413);
hold on;
plot(tau1_initial)
plot(tau1_fil)
xlabel('n');
ylabel('Amplitude');
title('tau1 initial and tau1 final');
legend('tau1 initial', 'tau1 final');
hold off;

subplot(414);
hold on;
plot(tau2_initial)
plot(tau2_fil)
xlabel('n');
ylabel('Amplitude');
title('tau2 initial and tau2 final');
legend('tau2 initial', 'tau2 final');
hold off;

% Plot q1, q1dot, and q1dotdot together
figure
subplot(211);
hold on;
plot(q1_fil_fil)
plot(q1_dot_fil)
plot(q1_dotdot_fil)
xlabel('n');
ylabel('Amplitude');
title('q1, q1dot, and q1dotdot');
legend('q1', 'q1dot', 'q1dotdot');
hold off;

% Plot q2, q2dot, and q2dotdot together
subplot(212);
hold on;
plot(q2_fil_fil)
plot(q2_dot)
plot(q2_dotdot)
xlabel('n');
ylabel('Amplitude');
title('q2, q2dot, and q2dotdot');
legend('q2', 'q2dot', 'q2dotdot');
hold off;









