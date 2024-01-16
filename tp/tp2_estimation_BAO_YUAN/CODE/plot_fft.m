clear all
close all

load("donne_y.mat");
q1=y(:,1);
q2=y(:,2);
p1=y(:,3);
p2=y(:,4);
q1_dot=y(:,5);
q2_dot=y(:,6);
p1_dot=y(:,7);
p2_dot=y(:,8);
sampling_period=1e-4;
Fs=1/sampling_period;

fft_q1=fft(q1);
fft_q2=fft(q2);
fft_p1=fft(p1);
fft_p2=fft(p2);
fft_shifted_q1 = fftshift(fft_q1);
fft_shifted_q2 = fftshift(fft_q2);
fft_shifted_p1 = fftshift(fft_p1);
fft_shifted_p2 = fftshift(fft_p2);




N = length(q1);  % nb de done
f = (-N/2:N/2-1)*(Fs/N);
f_range = (f >= -1000 & f <= 1000);
fft_cropped_q1 = fft_shifted_q1(f_range);
fft_cropped_q2 = fft_shifted_q2(f_range);
fft_cropped_p1 = fft_shifted_p1(f_range);
fft_cropped_p2 = fft_shifted_p2(f_range);

f_cropped = f(f_range);





figure;
hold on
plot(f_cropped ,abs(fft_cropped_q1));
plot(f_cropped ,abs(fft_cropped_q2));
plot(f_cropped ,abs(fft_cropped_p1)); 
plot(f_cropped ,abs(fft_cropped_p2));
legend('q1','q2','p1','p2')
hold off



figure;
loglog(f_cropped ,abs(fft_cropped_q1));
title ('q1')

figure
loglog(f_cropped ,abs(fft_cropped_q2));
title ('q2')

figure
loglog(f_cropped ,abs(fft_cropped_p1)); 
title ('p1')

figure
loglog(f_cropped ,abs(fft_cropped_p2)); 
title ('p2')



