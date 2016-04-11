function dp= rhs_sprz(psi,x)
d=2.62626497611548;
tmp=exp(-x(1))*(x(3));
dp=zeros(3,1);
dp(1)=-tmp*psi(2);
dp(2)= -psi(1);
dp(3)= 2*tmp*psi(2)+d*psi(3);