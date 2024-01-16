%% Filtre Particulaire ppt 77页的题
% Exemple simple (monovariable) : estimation non linaire par Filtrage particulaire
% 
%
% R�dacteur Mechbal  

%% Mise a zero de la m�moire
clear all
close all
clc

%% Intialisation des param�tres
Np = 20;                        % Nombre de particules
k=80;                           % Nombre de d"�chantillons 
T = 0:k;                          % Vecteur temps

%% G�n�ration des donn�es
% Syst�me d'�tat avec les bruits

Q = 0.5;                                 % variance du bruit de processus omega
R = 0.05;                                % variance du bruit de mesure nu
x0 = 0.1;                                % �tat initial
x= x0;

for i=2:k+1                             % G�n�ration du vecteur d'�tat
    x(i) = 0.4*x(i-1) + (0.001*T(i)/(1+x(i-1)^2))+0.1*exp(T(i)/30) + sqrt(Q)*randn;
end
%multiplier vectoriel .*
y = x + sqrt(R).*randn(size(x));        % G�n�ration du vecteur sortie

%% Initialisation de l'�tat et du poids 根据高斯分布初始化噪声点云点分布的权重，越靠近高斯中心，权重取得越大

Xk = x0+randn(1,Np)*sqrt(Q);                                    % Initialisation de la population de particules
Wk = .....                                   % Initialisation des poids
Wk = ....                                                        % normalisation des poids
Xest = ....                                                                % Intialisation de l'�tat estim�
Xestk = ....;       
%% Filtre particulaire

for t=2:k+1
    % Propagation des particules selon l'�quation d"�tat : probabilit� a priori
    %下面这一步是最重要的一步
    Xk =                                                        ;  % dim = Np

    % Mise � jour des poids et normalisation:
    % utilisation de la Vraisemblance
    %y=x+w,p(w=y-x)
      lik=                          ;         % Probl�me num�rique.
     Wk =                    	;          % proposal = prior
     Wk =                                 % Normalisation 

    % Calcul de l'estim� avant l'�chantillonnage ! 
    % on peut aussi le faire � la fin
     Xest(t) = ;

    %R�-�chantillonnage
    n_thr = 0.25*Np;                                      % seuil
    n_eff = 1/(sum(Wk.^2));                          % Nuage effective
    n_effs(t)=n_eff;                                        % utile pour le plot
    if n_eff<n_thr
        cs = cumsum(Wk) ;                                     % Somme cumulative (cs) sur les poids
        Xk2=Xk;                                                       % 
        for i=1:Np
             indx = min(find(cs > rand))                      % trouver le cs sup�rieur � la nombre al�atoire uniforme
            Xk(i) = Xk2(indx)                                       % dupliquer la particule corepandante dans la nouvelle population
        end
        Wk = ones(size(Wk))/Np;                              % assigner un poids uniforme aux particules r�- �chantillonn�es
                                                                                  % Le poids des particules apr�s l"�tape de r�-�chantillonnage est |1/Np|.
    end
    
    % calcul apr�s le r�-�chantillonnage
    Xestk(t)=....... ;
    
end

%% Trac� des r�sultats

% trac� de l'estim� et de la mesure
figure(1)
title(strcat(['Exemple Filtre Particulaire avec Np = ' num2str(Np)]));
xlabel('kT');
ylabel('Etat');
hold on;
plot(T,x,'b.-','LineWidth',3,'MarkerSize',10);
plot(T,y,'rx','LineWidth',2,'MarkerSize',10);
plot(T,Xest,'g','LineWidth',3,'MarkerSize',10);
plot(T,Xestk,'m','LineWidth',3,'MarkerSize',10);
legend('Etat','mesures','Etat estim� avant','Etat estim� apr�s');

% Trac� de l'erreur d'estimation
figure(2)
errX=y-Xest;
plot(T,errX,'k','LineWidth',2,'MarkerSize',10)
title(strcat(['Erreur d"estimation avec Np = ' num2str(Np)]));
xlabel('kT');

figure(3)
hold on
plot(T,n_effs,'+r')
xlabel('Time (t)','fontsize',20), grid
title ('Nb effective des particules','fontsize',15')


