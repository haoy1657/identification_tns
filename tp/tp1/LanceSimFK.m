%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulations et Filtre de Kalman
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mise � z�zo du workspace

close all %ferme toutes les figures
clear all %efface le "workspace"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PARAMETRES DU SYSTEME REEL

eval('ParametresR'); %execute le fichier ParametresReels.m
ParamReels=ParamR;
%temps de fin de simulation (en secondes)
ParamReels.tfin=10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETRES DU FILTRE

ParamFilt=ParamReels; %recopie des param�tres r�els这里要在simlink里面设置来更新

%Estim� initial
ParamFilt.X00=ParamR.X0;

%Covariance de l'erreur d'estimation initiale
ParamFilt.P00=diag([1e-3,1e-3]);

%Covariance des bruits de dynamique
ParamFilt.Q=diag([1e-5,1e-5]);
%--------------------------------------------------------
%Pour Discr�tiser

%D�finition de la repr�sentation d'�tat lin�aire � temps continu
SystCont=ss(ParamFilt.A,ParamFilt.B,ParamFilt.C,0);



%discrétisation这里要离散化，因为我们有ABCD矩阵但是我们有fg
%有两个工具来离散化，1---ss（A,B,C,D，Te）如果我们添加第五个 te matlab会自己离散化
%2---如果我们不添加第五个变量，可以这样定义，t=c2d（ss（A,B,C,D），te）
%他会输出 {F,G,C,XI}--->t.a,t.b......
SystDiscr=c2d(SystCont,ParamFilt.Te);

%Mise en forme pour utilisation plus pratique
ParamFilt.F=SystDiscr.a;
ParamFilt.G=SystDiscr.b;
%--------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATION
%execution du fichier Simulink Lin�aire : SimLin
sim('SimLin',ParamReels.tfin);

%execution du fichier Simulink Non linaire: SimNL
%sim('SimNL',ParamReels.tfin);

NbMes=length(YReel); %Nombre de points de mesure
%--------------------------------------------------------
%Bruitage des mesures
% 对于添加干扰，我们倾向于在matlab里面添加干扰----randn
%racinne de variance
%G�n�ration d'un vecteur, de meme taille que YReel, 
%compos� de de bruits gaussiens d'esp�rance nulle
% de covariance 1
BruitsCov1=randn(NbMes,1);

%G�n�ration d'un vecteur, de meme taille que YReel, 
%compos� de de bruits gaussiens d'esp�rance nulle
% de covariance ParamReels.R
Bruits=sqrt(ParamReels.R)*BruitsCov1;

%addition des bruits � YReel -> Y mesur�
Ymes = YReel + Bruits;
%--------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FILTRAGE

%-----------------------------------------------------------
% initialisation

%mise en forme
Xkk=ParamFilt.X00-[0;ParamFilt.Equilibre.X2e];

Pkk=ParamFilt.P00;

U=UReal-ParamFilt.Equilibre.Ue*ones(NbMes,1);

%Stockage
Resultat.HatX(1,:)=Xkk'; %Estim�
Resultat.DiagPkk(1,:)=diag(Pkk)'; %Composantes diag de Pkk
%-----------------------------------------------------------


%-----------------------------------------------------------
%R�currence

for k=1:NbMes-1    
    % ****** De-commentez les lignes et   compléter *******
   ........................................................... 
  
   % Prediction 
    Xkplus = ParamFilt.F * Xkk + ParamFilt.G * U(k);
    Pkplus = ParamFilt.F * Pkk * ParamFilt.F' + ParamFilt.Q;
    
    % Correction
    K = Pkplus * ParamFilt.C' / (ParamFilt.C * Pkplus * ParamFilt.C' + ParamR.R);
    Xkk = Xkplus + K * (Ymes(k+1, 1) - ParamFilt.C * Xkplus); % attention k+1 
    Pkk = (eye(2) - K * ParamFilt.C) * Pkplus;
    
    % Stockage
    Resultat.HatX(k+1,:) = Xkk'; 
    Resultat.DiagPkk(k+1,:) = diag(Pkk)';
    Resultat.K(k+1,:) = K';
   ...........................................................  

    % ****** De-commentez les lignes et   compl�ter *******
   %........................................................... 
  
   %Prediction 
        % Xkplus=   %A COMPLETER ...
         % Pkplus=   %A COMPLETER 
   %........................................................... 
   
   %........................................................... 
   %Correction
         %   K=   %A COMPLETER ...
       %   Xkk=  %A COMPLETER
       %   Pkk=  %A COMPLETER
   %........................................................... 
  
   %........................................................... 
   
   %Stockage
   %De-commentez les lignes ci-dessous lorsque vous aurez
    % cod� le Filtre de Kalman :
   %...........................................................  
end;
%-----------------------------------------------------------


%-----------------------------------------------------------
%Prise en compte de la lin�arisation : x2 = X2lin + X2e
% et construction de l'erreur d'estimation
% De-commentez les lignes ci-dessous lorsque vous aurez
% cod� le Filtre de Kalman :

 Resultat.HatX(:,2)=Resultat.HatX(:,2)+...
    ParamFilt.Equilibre.X2e*ones(NbMes,1);

   ErrEstim = XReel-Resultat.HatX;
%-----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRACES
numfig=0;
Texte={'X1','X2'};

%estim� et valeur r�elle
for i=1:2,
    numfig=numfig+1;
    figure(numfig)
    xlabel('t')
    hold on
    a=plot(Tps,XReel(:,i),'b-');
    b=plot(Tps,Resultat.HatX(:,i),'r-');
    legend([a,b],'Reel','Estime')
    title(['Estimation de ',Texte{i}])
    grid on
end;

%erreur d'estimation
for i=1:2,
    numfig=numfig+1;
    figure(numfig)
    xlabel('t')
    hold on
    %plot(Tps,XReel(:,i)-Resultat.HatX(:,i),'m-');
    plot(Tps,ErrEstim (:,i),'m-');
    title(['Erreur d estimation de ',Texte{i}])
    grid on
end;

%composantes diagonales de Pkk
for i=1:2,
    numfig=numfig+1;
    figure(numfig)
    xlabel('t')
    hold on
    plot(Tps,Resultat.DiagPkk(:,i),'g-');
    title(['Composante diagonale de Pkk, numero ',num2str(i)])
    grid on
end;

%composantes de K
for i=1:2,
    numfig=numfig+1;
    figure(numfig)
    xlabel('t')
    hold on
    plot(Tps,Resultat.K(:,i),'k-');
    title(['Composante K, numero ',num2str(i)])
    grid on
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%