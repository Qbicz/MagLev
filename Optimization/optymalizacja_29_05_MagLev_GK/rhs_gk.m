function xdot= rhs_gk(x,v)

g=9.81;
s=0.00773746617019;
st_tau = 0.0107;
c = 1/st_tau*sqrt(s/g);

xdot=zeros(1,3);
xdot(1)=x(2);
xdot(2)= -x(3)^2*exp(-x(1))+1;
xdot(3)= -c*x(3)+ v;