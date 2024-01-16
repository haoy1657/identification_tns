
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Int�gration num�rique de l'�quation d'�tat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[Xkplus]=IntegEtat(Xk,u,Param,Te)

options=odeset;
%下面是对 x_dot=f(x)求积分从而得到x的值
%@ode 这里是syntaxe
[Auxt,AuxXkplus]=ode45(@EqEtatContinue,[0,Te],Xk,options,Param,U);
Xkplus=AuxXkplus(end,:)';