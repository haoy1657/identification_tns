clear all;
close all;
% methode 2:function du cout defini avec les changement des varriable ---exp(x)--on
% estime x puis calculer theta =exp(x)
load('donnees_estimation_full_robot.mat');
load('donnees_initial_full_robot.mat');
q1=q1_fil_fil;
q1_dot=q1_dot_fil;
q1_dotdot=q1_dotdot_fil;

q2=q2_fil_fil;
q2_dot=q2_dot;
q2_dotdot=q2_dotdot;

tau1=tau1_fil;
tau2=tau2_fil;


x0=[-0.9943   -3.2189   -2.3026   -2.8134    0.6740   -9.2103   -9.2103  -4.6052   -4.6052 ];

lb=[-2 -5 -4 -4   0    -15 -15 -8 -8];
ub =[0  0  0  0   1.5   0  0   0   0];




%lsqnonlin 
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt', 'Display', 'iter','TolFun', 1e-9,'TolX', 1e-6,'MaxIterations', 10000);
[x,resnorm,residual,exitflag,output] = lsqnonlin(@function_cout_optimization_methode2, x0, lb, ub, options);

theta=exp(x);
theta=theta';
disp('theta estime')
disp(theta)

% theta estime
% 0.1353    0.0067    0.0183    0.0183    3.3324    0.8420    0.0001  0.0257    0.0012 
% theta=[0.1353    0.0067    0.0183    0.0183    3.3324    0.8420    0.0001  0.0257    0.0012 ]';


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



