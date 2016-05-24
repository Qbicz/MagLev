function w= rhsa_sprz(z, v)
stale;
x=z(1:3);
psi=z(4:6);
xdot=zeros(1,3);
xdot(1)=x(2);
xdot(2)= b*x(3)^2*exp(a*x(1))+g;
xdot(3)= c*x(3)+ v;

dp=zeros(1,3);
dp(1)=-a*b*exp(a*x(1))*x(3)^2*psi(2);
dp(2)= -psi(1);
dp(3)= -2*b*exp(a*x(1))*x(3)*psi(2)-c*psi(3);

w=[xdot, dp];