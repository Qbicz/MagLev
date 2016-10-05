% sta³e z ksi¹¿ki:

m=0.08;
g=9.81;
k=0.29703779960998;
T=0.01069365993381;
is=1.50595851172854;
L=0.10912926393443;
s=0.00773746617019;
umin=5.56;
umax=9.56;

% przedzia³ zmiennoœci po³o¿enia kulki x nale¿y [0 0.023] [m]
a=-1/s;
b=-L/(2*m*s);
c=-1/T;
vmin=(k*umin-is)/T;
vmax=(k*umax-is)/T;
