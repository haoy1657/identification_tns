clear all;
close all;
load('donnees_estimation_full_robot.mat');
load('donnees_initial_full_robot.mat');
% methode directe,methode sans contrainte, 
% linear least square, pseudo inverse directe
q1=q1_fil_fil;
q1_dot=q1_dot_fil;
q1_dotdot=q1_dotdot_fil;

q2=q2_fil_fil;
q2_dot=q2_dot;
q2_dotdot=q2_dotdot;

tau1=tau1_fil;
tau2=tau2_fil;




for i=1:5500
    Y(2*i-1:2*i,1:9)=[q1_dotdot(i)     sin(q2(i))^2*q1_dotdot(i)+q1_dot(i)*q2_dot(i)*sin(2*q2(i))   cos(q2(i))*q2_dotdot(i)-q2_dot(i)^2*sin(q2(i))   0   0   q1_dot(i)   0   tanh(1000*q1_dot(i))   0
                        0                               -0.5*q1_dot(i)^2*sin(q2(i))                                      cos(q2(i))*q1_dotdot(i)                   q2_dotdot(i)  -sin(q2(i))  0  q2_dot(i) 0 tanh(1000*q2_dot(i)) ];
    b(2*i-1:2*i,1)=[tau1(i);tau2(i)];
end 

% theta=inv(Y'*Y)*Y'*b;
theta=pinv(Y)*b;
disp('resultat lms sans contrainte')
disp(theta);

% theta estime -0.1741
% 0.0113 0.0002 -0.0016 -0.7580 1.1377 0.0459 -1.7127 -1.4580

% tester parametre dans le modele


for i=1:5500
    Y_estime=[q1_dotdot(i)     sin(q2(i))^2*q1_dotdot(i)+q1_dot(i)*q2_dot(i)*sin(2*q2(i))   cos(q2(i))*q2_dotdot(i)-q2_dot(i)^2*sin(q2(i))   0   0   q1_dot(i)   0   tanh(1000*q1_dot(i))   0
                         0                               -0.5*q1_dot(i)^2*sin(q2(i))                                      cos(q2(i))*q1_dotdot(i)                   q2_dotdot(i)  -sin(q2(i))  0  q2_dot(i) 0 tanh(1000*q2_dot(i)) ];
    
    tau_estime(1:2,i)=Y_estime*theta;
    tau_filtre(1:2,i)=[tau1(i);tau2(i)];
end

figure
hold on;
plot(tau_estime(1,:))
plot(tau_filtre(1,:))
xlabel('n');
ylabel('Amplitude');
title('axe1');
legend('tau1 estime', 'tau1 filtre');


figure
hold on;
plot(tau_estime(2,:))
plot(tau_filtre(2,:))
xlabel('n');
ylabel('Amplitude');
title('axe 2');
legend('tau2 estime', 'tau2 filtre');


