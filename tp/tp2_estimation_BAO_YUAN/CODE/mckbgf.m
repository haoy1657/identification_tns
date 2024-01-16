function [M,C,K,B,G,Fc] = mckbgf(I1,I2,L1,fc1,fc2,fv1,fv2,g,j1,j2,k1,k2,l1,l2,m1,m2,q2,q1p,q2p,rr)
%MCKBGF
%    [M,C,K,B,G,Fc] = MCKBGF(I1,I2,L1,FC1,FC2,FV1,FV2,g,J1,J2,K1,K2,l1,L2,M1,M2,Q2,Q1P,Q2P,RR)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    16-Jan-2024 12:49:34

t2 = cos(q2);
t3 = sin(q2);
t4 = l2.^2;
t5 = q2.*2.0;
t7 = -fv1;
t8 = -fv2;
t9 = -k1;
t10 = -k2;
t6 = sin(t5);
t11 = L1.*l2.*m2.*t2;
M = reshape([I1+(m2.*t4)./2.0+L1.^2.*m2+l1.^2.*m1-(m2.*t4.*cos(t5))./2.0,t11,0.0,0.0,t11,I2+m2.*t4,0.0,0.0,0.0,0.0,j1,0.0,0.0,0.0,0.0,j2],[4,4]);
if nargout > 1
    C = reshape([(m2.*q2p.*t4.*t6)./2.0,m2.*q1p.*t4.*t6.*(-1.0./2.0),0.0,0.0,l2.*m2.*(L1.*q2p.*t3.*2.0-l2.*q1p.*t6).*(-1.0./2.0),0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],[4,4]);
end
if nargout > 2
    K = reshape([k1,0.0,t9,0.0,0.0,k2,0.0,t10,t9,0.0,k1,0.0,0.0,t10,0.0,k2],[4,4]);
end
if nargout > 3
    B = reshape([fv1,0.0,t7,0.0,0.0,fv2,0.0,t8,t7,0.0,fv1,0.0,0.0,t8,0.0,fv2],[4,4]);
end
if nargout > 4
    G = [0.0;-g.*l2.*m2.*t3];
end
if nargout > 5
    Fc = [fc1.*tanh(q1p.*rr);fc2.*tanh(q2p.*rr)];
end
end