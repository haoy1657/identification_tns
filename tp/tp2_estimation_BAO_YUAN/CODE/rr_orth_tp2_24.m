function out = rr_orth;
close all;
clear all;
disp([mfilename '  ' datestr(now)]), tic, fn0 = 600;

syms q1 q2 q1p q2p q1pp q2pp L1 L2 l1 l2 m1 m2 I1 I2 
syms a r d th g fv1 fv2 fc1 fc2 rr TT %J1w J2w
syms k1 k2 j1 j2

if 1, disp('Symbolic inference of system''s matrix')
A_i = [ 1,      0,       0;
        0, cos(a), -sin(a);
        0, sin(a),  cos(a)]*...
      [ cos(th), -sin(th), 0;
        sin(th),  cos(th), 0;   
              0,        0, 1];
r_i = [d; -sin(a)*r; cos(a)*r];
T_i = [A_i,r_i; 0 0 0 1];

T01 = subs(T_i,[a r d th], [0 0 0 q1]);
T12 = subs(T_i,[a r d th], [pi/2, 0, -L1, pi/2-q2]);%[0 0 L1 q2]);%
T02 = T01*T12;

xC1 =  [0;-l1;0;1]; xC10 = T01*xC1;
xB1 =  [0;-L1;0;1]; xB0  = T01*xB1;
rC1B01 = [xC1(1:3), xB0(1:3), xB1(1:3)];


xC2 =  [-l2;0;0;1]; xC21 = T12*xC2; xC0 = T02*xC2;
xB2 =  [0;0;0;1]; xB21 = T12*xB2; xB20 = T02*xB2;
rC2B012 = [xC2(1:3), xB0(1:3), xB1(1:3), xB2(1:3)];

xM2 = [-L2;0;0;1]; xM1 = T12*xM2; xM0 = T02*xM2;
rM012 = [xM0(1:3), xM1(1:3), xM2(1:3)];

A01 = T01(1:3,1:3);
A02 = T02(1:3,1:3);

%%

J1w = sym(zeros(3,2)); J1w(3,1) = sym(1);
J2w = J1w; J2w(:,2) = A02(:,3),;

%%

for ii = '12';
    cc = ['x' ii '=A0' ii '(:,1); y' ii '=A0' ii '(:,2); z' ii '=A0' ii '(:,3)'];
    disp(cc); eval(cc);
end;

%%

J1v = [-cross(z1,(-l1*-y1)), [0;0;0]];
J2v = [-cross(z1,(-L1*-y1+l2*x2)), -cross(z2,l2*x2)];

%%
J2v = simplify(J2v);

I1_ = diag([0,0,I1]);
I2_ = diag([0,0,I2]);
M1 = (m1*J1v.'*J1v + J1w.'*A01*I1_*A01.'*J1w);
M2 = (m2*J2v.'*J2v + J2w.'*A02*I2_*A02.'*J2w);

M = simplify(M1+M2); %pretty(M)

%%
n = 2; q = [q1; q2]; qp = [q1p; q2p]; %T = 1/2*qp.'*M*qp;
cc = sym(0)*zeros(2,2,2); C = sym(0)*zeros(2,2);

for kk = 1:n
    for jj = 1:n
        C(kk,jj) = sym(0);
        for ii = 1:n
            cc(ii,jj,kk) = 1/2 * (diff(M(kk,jj),q(ii)) + diff(M(kk,ii),q(jj)) - diff(M(ii,jj),q(kk)));
            C(kk,jj) = C(kk,jj) + cc(ii,jj,kk)*qp(ii);
        end
    end
end
C = simplify(C); %pretty(C)

%%
B = diag([fv1 fv2]);
FC = [fc1*tanh(rr*q1p);fc2*tanh(rr*q2p)];

G = [0; -m2*l2*g*sin(q2)];

end

%%
Q1 = m1*l1^2+I1+m2*L1^2;
Q2 = m2*l2^2;
Q3 = m2*L1*l2;
Q4 = m2*l2^2+I2;
Q5 = m2*l2*g;
Q6 = fv1; 
Q7 = fv2;
Q8 = fc1;
Q9 = fc2;

gg = [0; -Q5*sin(q2)]; 
Fv = [Q6 0; 0 Q7]; fv = Fv*qp;
fc = [Q8*tanh(rr*q1p);Q9*tanh(rr*q2p)];
%%

qpp = [q1pp; q2pp];
EE = M*qpp + (C + B)*qp + G + FC + TT;

%%
if 1
    disp('rigid')
tau = M*qpp + (C+B)*qp + G + FC;
ggg = matlabFunction(tau,'file','taulagr');
save
end


if 0
    disp('check with Moreno')
%%Moreno+ expr
MQ=[Q1+Q2*sin(q2)^2, Q3*cos(q2); Q3*cos(q2), Q4];
CQ=[Q2*q2p*sin(2*q2)/2, -Q3*q2p*sin(q2)+Q2*q1p*sin(2*q2)/2; -Q2*q1p*sin(2*q2)/2,0];

dm = simplify(M-MQ)
dc = simplify(C-CQ)

end


% % % % % % % % % % % % % % % % % % % % % /
% jusqu a ici modelisation de la modele 
%%
disp('numerical application')

% Set robot parameters
ID.nj = 2; % nb of joints
ID.g =  9.81;  % gravity constant (N/kg)
ID.l1 = 0.2; % CoM distance of the first arm (m)
ID.l2 = 0.2; % CoM distance of the second arm (m)
ID.L1 = 0.4; % length of the third arm (m)
ID.m1 = 1;   % weight of the first arm (kg)
ID.m2 = 0.5;   % weight of the second arm (kg) 

ID.I1 = 0.04; % intertia of the first arm (kg.m2)
ID.I2 = 0.02; % intertia of the second arm (kg.m2)

ID.fv1 = 1e-4; % viscous coefficient in 1st joint (N.m.s)
ID.fv2 = 1e-4; % viscous coefficient in 2nd joint (N.m.s)

ID.fc1 = 1e-2; % Coulomb coefficient in 1st joint (N.m)
ID.fc2 = 1e-2; % Coulomb coefficient in 2nd joint (N.m)
ID.rr  = 1e-5; % Coulomb law smoothing factor

ID.j1 = 2e-4; % axis inertia (kg.m2)
ID.j2 = 1e-4; % axis inertia (kg.m2)
ID.k1 = 1000; % axis stiffness (N.m)
ID.k2 = 1000; % axis stiffness (N.m)

% Define a trajectory
TR.Ts = 1e-4; % Sampling period (s)
TR.T = -1; %s !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
TR.N = 1;%.1;%3; % nb periods

TR.Q = [pi/2; 0];
TR.C = [0 1 0 0; 1 0 0 0];
TR.S = [0 0 0 0; 0 1 0 2]; 
TR.type = 'Fourier';%'Pulse';%   % if flexible

dt = 1e-3;
t = 0:TR.Ts:(TR.T*TR.N);


% generation de signal 
if 1
    disp('rigid trajectory')
    [q, tau] = DT2thetatau(ID,TR);
end

if 1, sstr='ODErigid'; disp(sstr)
    K = diag([k1 k2])*0; B = diag([fv1 fv2]); 
    ZZ = zeros(ID.nj); II = eye(ID.nj); Z = ZZ(:,1);
    A = [ZZ, II; -[K, C+B]]; 
    Ai = [II, ZZ; ZZ, M];
    Fc = [fc1*tanh(rr*q1p); fc2*tanh(rr*q2p) ];
    b = -[Z; G + Fc];
    
    SC = {'A','Ai','b'}; ff = fields(ID); % to be substituted
    for is = 1:length(SC),  for id = 1:length(ff)
        eval([SC{is} ' = subs(' SC{is} ', ''' ff{id} ''', ID.' ff{id} ');']);
    end, end
    
    %data store in DD
    DD.ID = ID; DD.TR = TR; DD.TR.q = q; DD.TR.tau = tau; 
    DD.TR.t = 0:TR.Ts:(TR.N*TR.T);
    DD.whos = whos('','variables'); DD.symnames = {}; DD.syms = {}; 
    for iw = 1:length(DD.whos)
        if strfind(DD.whos(iw).class,'sym')
            eval(['DD.syms{end+1} = ' DD.whos(iw).name ';']);
            DD.symnames{end+1} = DD.whos(iw).name;
        end
    end
    
    if TR.T>0, y0 = [TR.Q + sum(TR.C,2);
          2*pi/TR.T*sum(TR.S*(1:size(TR.S,2)).',2)]; %[0;0;0;0];
    else y0 = [0; 0; 1.e-3; 0];
    end

    [t,y] = ode45(@odefun, [0, TR.T*TR.N], y0, [], DD);
    
    plotfigs(fn0,t,y,tau,sstr);
end

if 1, sstr = 'ODEflex'; disp(sstr);%'ode45 flex data & matrix')
    ZZ = zeros(ID.nj); II = eye(ID.nj); 
    ZZZ = zeros(2*ID.nj); III = eye(2*ID.nj); 
    K = kron([1,-1;-1,1],diag([k1 k2])); 
    B = kron([1,-1;-1,1],diag([fv1 fv2])); 
    M = [M, ZZ; ZZ, diag([j1, j2])];
    C = [C, ZZ; ZZ, ZZ];
    A = [ZZZ, III; -[K, C+B]]; 
    Ai = [III, ZZZ; ZZZ, M];
    Fc = [fc1*tanh(rr*q1p); fc2*tanh(rr*q2p) ];
    b = -[ZZ(:,1);ZZ(:,1); G + Fc; ZZ(:,1)];
    
	fff = matlabFunction(M,C,K,B,G,Fc,'File','mckbgf',...
    	'Outputs',{'M','C','K','B','G','Fc'});

    %data store in DD
    DD.ID = ID; DD.TR = TR; DD.TR.q = q; DD.TR.tau = tau; 
    DD.TR.t = 0:TR.Ts:(TR.N*TR.T);
    DD.whos = whos('','variables'); DD.symnames = {}; DD.syms = {}; 
    for iw = 1:length(DD.whos)
        if strfind(DD.whos(iw).class,'sym')
            eval(['DD.syms{end+1} = ' DD.whos(iw).name ';']);
            DD.symnames{end+1} = DD.whos(iw).name;
        end
    end
end


if 1, sstr1 = 'ode45flex'; disp(sstr)
    if TR.T>0, sstr2 = 'harmonic';  y0 = [TR.Q + sum(TR.C,2);
          2*pi/TR.T*sum(TR.S*(1:size(TR.S,2)).',2)]; %[0;0;0;0];
          y0 = [y0(1:2);y0(1:2);y0(3:4);y0(3:4)];
    else sstr2 = 'pulse'; y0 = [0; 0; 0; 0;8.5771 ; 0; 0; 0];
    end; disp(sstr2);
    
    t = [0:TR.Ts:abs(TR.T*TR.N)];
    [t,y] = ode45(@odephi, t, y0, [], DD); 
    
    nt = length(t); tau = zeros(nt,2);
    if TR.T>0, for it = 1:nt, 
            tau(it,1:2) = interp1(DD.TR.t, DD.TR.tau, t(it))';
    end; end
    
    plotfigs(fn0,t,y,tau,[sstr1 ' ' sstr2]);
    
    if 1, sstr = 'flexeig'; disp(sstr);
        pnc = {'I1','I2','L1','g','j1','j2','fc1','fc2','fv1','fv2','k1','k2','l1','l2','m1','m2','rr'};
        
        for ip = 1:length(pnc), eval([pnc{ip} ' = DD.ID.' pnc{ip} ';']); end
        [M,C,K,B,G,Fc] = mckbgf(I1,I2,L1,g,fc1,fc2,fv1,fv2,j1,j2,k1,k2,l1,l2,m1,m2,y0(2),0,0,rr);
        Km = K(3:4,3:4); K(3:4,3:4) = K(3:4,3:4) + Km; 
        A = [ZZZ,III;-M\K,-M\C];
        [v,d] = eig(A); freq = imag(diag(d))/2/pi
        
    end;
        
end

%%
toc, disp(datestr(now)), disp(mfilename)
keyboard






function [theta, tau] = DT2thetatau(ID,TR)
% generates joint trajectory (theta and tau) from a robot inertia dataset ID for
% trajectory fourier series definition TR.(T,C,S,Q,N,Ts) over N periods,
% sampled at Ts<<T, with qi(t) = Qi + sum C(i,j) cos(2pi j t/T) + S(i,j) sin(2pi j t/T))

tt = 0:TR.Ts:(TR.N*TR.T); nt = length(tt);
nh = size(TR.C,2);
theta = zeros(ID.nj,nt);
tau   = zeros(ID.nj,nt); 
q0 = zeros(ID.nj,1); 
for it = 1:nt 
    q = q0; qp = q; qpp = q;
    t = tt(it); q = TR.Q;
    for ih = 1:nh
    q = q + ( TR.C(:,ih)*cos(2*pi*t*ih/TR.T)+TR.S(:,ih)*sin(2*pi*t*ih/TR.T));
    qp = qp +  2*pi*ih/TR.T*(-TR.C(:,ih)*sin(2*pi*t*ih/TR.T)+TR.S(:,ih)*cos(2*pi*t*ih/TR.T));
    qpp = qpp -(2*pi*ih/TR.T)^2*( TR.C(:,ih)*cos(2*pi*t*ih/TR.T)+TR.S(:,ih)*sin(2*pi*t*ih/TR.T));
    tau(:,it) = theta2tau(q,qp,qpp,ID);
    end
    theta(:,it) = q;
end
theta = theta' ;
tau = tau' ;


function tau = theta2tau(q,qp,qpp,ID)
% generates joint torques tau from a trajectory theta (q,qp,qpp) and dataset ID

ff = fields(ID);
for id = 1:length(ff), eval([ff{id} ' = ID.' ff{id} ';']); end;
for iq = 1:nj, eval(num2str(iq*[1 1 1 1 1 1],'q%g=q(%g);q%gp=qp(%g);q%gpp=qpp(%g);'));end;

%if 1, %~exist('jk1','var') % rigid, no flexibilities
tau = taulagr(I1,I2,L1,fc1,fc2,fv1,fv2,g,l1,l2,m1,m2,q2,q1p,q2p,q1pp,q2pp,rr);
%else % flexibilities preseent
%tau = taulagr_flex(I1,I2,L1,fc1,fc2,fv1,fv2,g,l1,l2,m1,m2,k1,k2,j1,j2,q2,q1p,q2p,q1pp,q2pp); %p1, p2, p1p, p2p, p1pp, p2pp
%end


function out = odefun(t,y,DD)

for is = 1:length(DD.syms), eval([DD.symnames{is} ' = DD.syms{is};']); end

if DD.TR.T>0, tau = interp1(DD.TR.t, DD.TR.tau, t)';
else tau = [0; 0]; end
b(end+[-1,-0]) = b(end+[-1,-0])+tau; 

SMc = {'A','Ai','b'}; 
if 1, %disp('rigid') %2dof
SNc = {'q1','q2','q1p','q2p'};%'q1','q2','p1','p2','q1p','q2p','p1p','p2p'}
SVc = {'y(1)','y(2)','y(3)','y(4)'};%'y(5)','y(6)','y(7)','y(8)'}
end;
for is = 1:length(SMc),
    for iv = 1:length(SNc),
        eval([SMc{is} ' = subs(' SMc{is} ', ''' SNc{iv} ''', ' SVc{iv} ');']);
    end,
    eval([SMc{is} ' = double(' SMc{is} ');']),
end
out = Ai\(A*y+b);


function out = odephi(t,y,DD)

q1  = y(1); q2  = y(2); p1  = y(3); p2  = y(4);
q1p = y(5); q2p = y(6); p1p = y(7); p2p = y(8); 

ZZ = zeros(DD.ID.nj); II = eye(DD.ID.nj); 
ZZZ = zeros(2*DD.ID.nj); III = eye(2*DD.ID.nj); 

pnc = {'I1','I2','L1','g','j1','j2','fc1','fc2','fv1','fv2','k1','k2','l1','l2','m1','m2','rr'};

for ip = 1:length(pnc), eval([pnc{ip} ' = DD.ID.' pnc{ip} ';']); end
[M,C,K,B,G,Fc] = mckbgf(I1,I2,L1,g,fc1,fc2,fv1,fv2,j1,j2,k1,k2,l1,l2,m1,m2,q2,q1p,q2p,rr);

if DD.TR.T>0, tau = interp1(DD.TR.t, DD.TR.tau, t)';
else tau = [0; 0]; Km = K(3:4,3:4); K(3:4,3:4) = K(3:4,3:4) + Km; end

    A = [ZZZ, III; -[K, C+B]]; 
    Ai = [III, ZZZ; ZZZ, M];
    Fc = [fc1*tanh(rr*q1p); fc2*tanh(rr*q2p) ];

b = -[ZZ(:,1);ZZ(:,1); G + Fc ; -tau];


out = Ai\(A*y+b);



function out = plotfigs(fn0,t,y,tau,tstr)
        
if size(y,2)==4,
	figure(fn0+12)
    subplot(211); plot(t,y(:,1:2)); xlabel('t'); ylabel('q'); axis tight 
    title(datestr(now))
    subplot(212); plot(t,y(:,3:4)); xlabel('t'); ylabel('q'''); axis tight 
    figure(fn0+11)
    subplot(211); hold on; plot(t,y(:,1:2),':');hold off; 
    legend('q_1','q_2','y_1','y_2'), title([tstr ' ' datestr(now)])
elseif size(y,2)==8,
    figure(fn0+12 +1000)
    subplot(211); plot(t,y(:,1:2)); xlabel('t'); ylabel('q'); axis tight
	title([tstr ' ' datestr(now)])
    subplot(212); plot(t,tau); xlabel('t'); ylabel('\tau'); axis tight
    fname = ['fl2_' datestr(now,30)]; mysavefig(gcf,fname,{'fig', 'png'});
    
    figure(fn0+11 +1000)
    subplot(211); plot(t,y(:,1:4)); legend('q_1','q_2','p_1','p_2')
	title([tstr ' ' datestr(now)])
    subplot(212); plot(t,y(:,5:8)); legend('q''_1','q''_2','p''_1','p''_2')
    fname = ['fl1_' datestr(now,30)]; mysavefig(gcf,fname,{'fig', 'png'});
end

function out = mysavefig(h,n,f)
for ii = 1:length(f); saveas(h,n,f{ii}); end



           
