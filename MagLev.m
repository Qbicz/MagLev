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

u(1) = umin;
u(2) = umax;

i=1;
step = 0.01;
% iloœæ kroków
m = (tau(i+1) - tau(i))/step;

% Nominalny punkt pracy ^x1 = 14mm
% skalowanie ^x1 = alpha * x1
alpha = 0.00773746;
% u = 6.4;
% punkt pracy
y = [1.8094; 0.0; 2.4712];

% rozwiazywanie równañ przy prze³¹czanym sterowaniu
max_przelaczen = 3;
Tall = []; Yall = [];
for przelaczenie = 2:max_przelaczen
    % TODO: ustawienie aktualnego warunku poczatkowego w rk4.m
    [T,Y] = rk4(@rhs,tau(przelaczenie-1),tau(przelaczenie),y, u(przelaczenie-1), m);
    Tall = [Tall T];
    Yall = [Yall Y]; % TODO: preallocate
end

plot(Tall,Yall(1,:)*alpha*1000);
title('Odleg³oœæ œrodka sfery od cewki elektromagnesu [mm]');

% teraz do realizacji rozwi¹zywanie równañ miêdzy kolejnymi chwilami
% prze³¹czenia
