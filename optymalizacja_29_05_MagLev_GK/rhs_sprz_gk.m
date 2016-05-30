function w= rhs_sprz_gk(z, v)

g=9.81;
s=0.00773746617019;
st_tau = 0.0107;
c = 1/st_tau*sqrt(s/g);

x=z(1:3);
psi=z(4:6);
xdot=zeros(1,3);
xdot(1)=x(2);
xdot(2)= -x(3)^2*exp(-x(1))+1;
xdot(3)= -c*x(3)+ v;

dp=zeros(1,3);
dp(1)= -exp(-x(1))*x(3)^2*psi(2);
dp(2)= -psi(1);
dp(3)= 2*exp(-x(1))*x(3)*psi(2)+c*psi(3);

w=[xdot, dp];