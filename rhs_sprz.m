function dp= rhs_sprz(x,psi)
c=2.62627844778518;
xdot=zeros(3,1);
xdot(1)=x(2);
xdot(2)= -exp(-x(1))*(x(3))^2 +1;
xdot(3)= -c*x(3)+ u;

d=2.62626497611548;
tmp=exp(-x(1))*(x(3));
dp=zeros(3,1);
dp(1)=-tmp*psi(1);
dp(2)= -psi(0);
dp(3)= 2*tmp*psi(1)+d*psi(2);