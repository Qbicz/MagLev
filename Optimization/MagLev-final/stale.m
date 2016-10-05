% sta³e z ksi¹¿ki:

m=0.06;
g=9.81;
s=0.00773746617019;
st_tau = 0.0107;
is=1.50595851172854;
k=0.29703779960998;
T=0.01069365993381;
umin=5.56;
umax=9.56;
L0=0.10912926393443;

% przedzia³ zmiennoœci po³o¿enia kulki x nale¿y [0 0.023] [m]
alpha = s;
beta = sqrt(g*s);
gamma = sqrt((2*m*s*g)/(L0));
ni = g*sqrt(2*m/L0);
epsilon = sqrt(s/g);
c = 1/st_tau*sqrt(s/g);

vmin=(k*umin-is)/(st_tau*ni);
vmax=(k*umax-is)/(st_tau*ni);
