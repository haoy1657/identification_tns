
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Definition of the "Actual or Real" parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Model parameters
ParamR.beta=1;
ParamR.alpha=4;


% equilibrum State
ParamR.Equilibre.X2e=sqrt(ParamR.beta/ParamR.alpha);
ParamR.Equilibre.Ue=ParamR.beta/ParamR.Equilibre.X2e;

% A and B linearization
[ParamR.A,ParamR.B]=Linearise(ParamR.Equilibre.X2e,...
    ParamR.Equilibre.Ue,ParamR);
ParamR.C=[1,0];

disp("Matrice A:")
disp(ParamR.A)
disp("Matrice B:")
disp(ParamR.B)

% Initial state
ParamR.X0=[4;ParamR.Equilibre.X2e];
disp(ParamR.X0)

% Intial linear state 
ParamR.X0lin=ParamR.X0-[0;ParamR.Equilibre.X2e];
disp(ParamR.X0lin)

% Sampling time
ParamR.Te=0.1;

% Measurment noise covariance
ParamR.R=1e-2;