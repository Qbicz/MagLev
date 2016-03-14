%% RK4 dla systemu MagLev
clear all; close all;

tau = [];

% chwile prze��czenia
tau = [0, 0.2, 0.4, 1, 2]
max_przelaczen = 5;

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

u = [umin, umax, umin, umax];

i=1;
step = 0.01;
% ilo�� krok�w
m = (tau(i+1) - tau(i))/step;

% Nominalny punkt pracy ^x1 = 14mm
% skalowanie ^x1 = alpha * x1
alpha = 0.00773746;
% u = 6.4;
% punkt pracy
y0 = [1.8094; 0.0; 2.4712];

% rozwiazywanie r�wna� przy prze��czanym sterowaniu
Tall = []; Yall = [];
for przelaczenie = 2:max_przelaczen
    % ustawienie aktualnego warunku poczatkowego
    if przelaczenie > 2
       y0 = Y(:,length(Y)) ;
    end
    [T,Y] = rk4(@rhs,tau(przelaczenie-1),tau(przelaczenie),y0, u(przelaczenie-1), m);
    Tall = [Tall T];
    Yall = [Yall Y]; % TODO: preallocate
end
hold on;
plot(Tall,Yall(1,:)*alpha*1000);
title('Odleg�o�� �rodka sfery od cewki elektromagnesu [mm]');

%u_plot = 
%plot();

for i = 1:max_przelaczen
    plot([tau(i) tau(i)],get(gca,'ylim'));
end

% teraz do realizacji rozwi�zywanie r�wna� mi�dzy kolejnymi chwilami
% prze��czenia