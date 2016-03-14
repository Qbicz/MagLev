function xdot= rhs(x,u)
c=2.62627844778518;
xdot=zeros(3,1);
xdot(1)=x(2);
xdot(2)= -exp(-x(1))*(x(3))^2 +1;
xdot(3)= -c*x(3)+ u;