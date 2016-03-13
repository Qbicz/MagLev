%% RK4 dla systemu MagLev
clear all; close all;

tau = [];

% chwile prze³¹czenia
tau(1) = 0;
tau(2) = 0.9;
tau(3) = 1.4;


% parametry
vmax = 9.56;
vmin = 5.56;
is = 1.506;
k = 0.297;
eta = 10.287;
Tau = 0.0107;

% umin, umax na podstawie vmin, vmax
umax = (vmax*k - is)/(eta*Tau)
umin = (vmin*k - is)/(eta*Tau)

i=1;
step = 0.01;
% iloœæ kroków
m = (tau(i+1) - tau(i))/step;

u = 6.4;
%y = [;]
y = [1.8;0;2.5];
[T,Y] = rk4(@rhs,tau(1),tau(2),y, u, m);

plot(T,Y(1,:)*0.0077); % alpha
