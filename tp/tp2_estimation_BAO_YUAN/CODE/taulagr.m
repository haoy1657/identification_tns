function tau = taulagr(I1,I2,L1,fc1,fc2,fv1,fv2,g,l1,l2,m1,m2,q2,q1p,q2p,q1pp,q2pp,rr)
%TAULAGR
%    TAU = TAULAGR(I1,I2,L1,FC1,FC2,FV1,FV2,G,l1,L2,M1,M2,Q2,Q1P,Q2P,Q1PP,Q2PP,RR)

%    This function was generated by the Symbolic Math Toolbox version 23.2.
%    16-Jan-2024 12:49:32

t2 = cos(q2);
t3 = sin(q2);
t4 = l2.^2;
t5 = q2.*2.0;
t6 = sin(t5);
tau = [fc1.*tanh(q1p.*rr)+q1p.*(fv1+(m2.*q2p.*t4.*t6)./2.0)+q1pp.*(I1+(m2.*t4)./2.0+L1.^2.*m2+l1.^2.*m1-(m2.*t4.*cos(t5))./2.0)-(l2.*m2.*q2p.*(L1.*q2p.*t3.*2.0-l2.*q1p.*t6))./2.0+L1.*l2.*m2.*q2pp.*t2;fv2.*q2p+fc2.*tanh(q2p.*rr)+q2pp.*(I2+m2.*t4)-g.*l2.*m2.*t3-(m2.*q1p.^2.*t4.*t6)./2.0+L1.*l2.*m2.*q1pp.*t2];
end
