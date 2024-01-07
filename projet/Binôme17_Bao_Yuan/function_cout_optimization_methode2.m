function F = function_cout_optimization_methode2(x)
x=double(x);
load('donnees_estimation_full_robot.mat');

q1=q1_fil_fil;
q1_dot=q1_dot_fil;
q1_dotdot=q1_dotdot_fil;

q2=q2_fil_fil;
q2_dot=q2_dot;
q2_dotdot=q2_dotdot;

tau1=tau1_fil;
tau2=tau2_fil;

Y=[];
b=[];
for i=1:2000
    Y(2*i-1:2*i,1:9)=[q1_dotdot(i)     sin(q2(i))^2*q1_dotdot(i)+q1_dot(i)*q2_dot(i)*sin(2*q2(i))   cos(q2(i))*q2_dotdot(i)-q2_dot(i)^2*sin(q2(i))   0   0   q1_dot(i)   0   tanh(1000*q1_dot(i))   0
        0                               -0.5*q1_dot(i)^2*sin(q2(i))                                      cos(q2(i))*q1_dotdot(i)                   q2_dotdot(i)  -sin(q2(i))  0  q2_dot(i) 0 tanh(1000*q2_dot(i)) ];
    b(2*i-1:2*i,1)=[tau1(i);tau2(i)];
end 
F=Y*[exp(x(1));exp(x(2));exp(x(3));exp(x(4));exp(x(5));exp(x(6));exp(x(7));exp(x(8));exp(x(9))]-b;
% F=Y*[x(1);x(2);x(3);x(4);x(5);x(6);x(7);x(8);x(9)]-b;

F=norm(F);
F=double(F);

end


