clear all;
close all;
% methode 1: fonction du cout definit sans changement de varriable,
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

x0 =[0.37 0.04 0.1 0.06 1.962 0.0001 0.0001 0.01 0.01] ;



lb=0.1*[0.16 0.02 0.05 0.03 0.8 0.00005 0.00005 0.005 0.005];
ub =0.8*[0.74 0.08 0.2 0.12 3.8 0.0002 0.0002 0.02 0.02];


%lsqnonlin 
% fonction du cout definit sans changement de varriable
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt', 'Display', 'iter','TolFun', 1e-9,'TolX', 1e-6,'MaxIterations', 10000);
[x,resnorm,residual,exitflag,output] = lsqnonlin(@function_cout_optimization_methode1, x0, lb, ub, options);

theta=x';
disp('theta estime')
disp(x)


% theta estime 
% 0.0160    0.0020    0.0050    0.0030    0.2725    0.0002    0.0000  0.0160    0.0005

% theta=[0.0160    0.0020    0.0050    0.0030    0.2725    0.0002    0.0000  0.0160    0.0005]';
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



