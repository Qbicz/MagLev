%% RK4 dla systemu MagLev
clear all; close all;

tau = [];

% chwile prze³¹czenia
tau = [0, 0.2, 0.4, 1, 1.3 ,1.7,1.8,2.3,2.6, 3,3.1]
max_przelaczen = length(tau);

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

u=[];
for i=1:max_przelaczen-1
    if mod(i,2)==0
        u(i)=umax;
    else
        u(i)=umin;
    end
end

i=1;
step = 0.01;
% iloœæ kroków
m = (tau(i+1) - tau(i))/step;

% Nominalny punkt pracy ^x1 = 14mm
% skalowanie ^x1 = alpha * x1
alpha = 0.00773746;
% u = 6.4;
% punkt pracy
y0 = [1.8094; 0.0; 2.4712];

% rozwiazywanie równañ przy prze³¹czanym sterowaniu
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
subplot(2,1,1)
hold on;
grid on
plot(Tall,Yall(1,:)*alpha*1000);
title('Odleg³oœæ œrodka sfery od cewki elektromagnesu [mm]');

% for i = 1:max_przelaczen
%     plot([tau(i) tau(i)],get(gca,'ylim'));
% end

P=[];
 p=2;
for i=1:length(Tall)
      if Tall(i)< tau(p)
          if p(mod(p,2)==0)
              P(i)= umin;
          else
              P(i)= umax;
          end
      else
          P(i)= P(i-1);
          p=p+1;
      end
end
subplot(2,1,2)
plot(Tall,P)
title('Funkcja prze³¹czaj¹ca')

% teraz do realizacji rozwi¹zywanie równañ miêdzy kolejnymi chwilami
% prze³¹czenia