function xdot= rhsa(x,v)
stale;
xdot=zeros(1,3);
xdot(1)=x(2);
xdot(2)= b*x(3)^2*exp(a*x(1))+g;
xdot(3)= c*x(3)+ v;