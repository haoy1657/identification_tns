clear all;
close all;


% Define a trajectory
TR.T = 2; %s
TR.N = 3; % nb periods
TR.Q = [pi/2; -pi];
TR.C = [0 1 0 0; 1 0 0 0];
TR.S = [0 0 0 0; 0 1 0 2]; 

% Run script
% option = 'only_acquisition_hardware' ;
option = 'full_robot' ;% 'full_robot' or  'only_acquisition_hardware'
[q, tau] = myrobot(TR,option);
q1=q(:,1);
q2=q(:,2);
tau1=tau(:,1);
tau2=tau(:,2);
fs1=1000;%Angles are acquired at a sampling frequency of 1 kHz
fs2=2500;%Torques are acquired at a sampling frequency of 2.5 kHz.
% 
% QUESTION  1


% Define the parameters of the band reject filter
f0 = 50;%Desired blocking frequency 50Hz
Q = 30; % Quality factor, which determines the width of the bandwidth
% Calculate the parameters of the band-stop filter
bw = f0/Q;
[f1, f2] = deal(f0-bw/2, f0+bw/2);% Calculation of the two cut-off frequencies of band resistance by bandwidth
% Conversion frequency is normalised
Wn_q = [f1 f2]/(fs1/2);
% Design filters
[b, a] = butter(2, Wn_q, 'stop'); % Use the 'Stop Tape' option
freqz(b, a);
% 
q1_fil = filter(b, a, q1);
fft_plot_log(q1,fs1,'q1initial','q1initail')
fft_plot_log(q1_fil,fs1,'q1fil','q1fil')

fft_plot_log(q2,fs1,'q2initial','q2initial')
q2_fil = filter(b, a, q2);
fft_plot_log(q2_fil,fs1,'q2fil','q2fil')

Wn_tau = [f1 f2]/(fs2/2);
[b, a] = butter(2, Wn_tau, 'stop');
fft_plot_log(tau1,fs2,'tau1initial','tau1initial')
tau1_fil = filter(b, a, tau1);
fft_plot_log(tau1_fil,fs2,'tau1fil','tau1fil')

fft_plot_log(tau2,fs2,'tau2initial','tau2initail')
tau2_fil = filter(b, a, tau2);
fft_plot_log(tau2_fil,fs2,'tau2fil','tau2fil')








