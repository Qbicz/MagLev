function J = funkcjaCeluOdTau(Tfinish, tau, xPracy)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% -- Rozwiazanie rownan -- mozna zamknac w osobnej funkcji dla czytelnosci
max_przelaczen = length(tau);

% !!!
% struktura params z argumentami wejsciowymi
%

% parametry
vmax = 9.56;
vmin = 5.56;
is = 1.506;
k = 0.297;
eta = 10.287;
Tau = 0.0107;

% umin, umax na podstawie vmin, vmax
umax = (vmax*k - is)/(eta*Tau);
umin = (vmin*k - is)/(eta*Tau);

% sporz¹dzenie wektora sterowañ
u=[];
for i=1:max_przelaczen-1
    if mod(i,2)==0
        u(i)=umax;
    else
        u(i)=umin;
    end
end

%przyjêty krok
step = 0.0001;

% Nominalny punkt pracy ^x1 = 14mm
% skalowanie ^x1 = alpha * x1
alpha = 0.00773746;
% u = 6.4;

% punkt pracy
y0 = [1.8094; 0.0; 2.4712];
%x_zadane = 18;
%y0 = [x_zadane/(alpha*1000); 0.0; 2.4712];

% rozwiazywanie równañ przy prze³¹czanym sterowaniu
Tall = [];  %wektor czasu
Yall = [];  %wszystkie wartoœci Y - [odleg³oœæ, prêdkoœæ, przyspieszenie]
Yprzel=[];  %ostatni Y w ka¿dym prze³¹czeniu
for przelaczenie = 2:max_przelaczen
    % ustawienie aktualnego warunku poczatkowego
    if przelaczenie > 2
       [yN,yM] = size(Y);
       y0 = Y(:,yM);
    end
    % iloœæ kroków
    m = (tau(przelaczenie) - tau(przelaczenie-1))/step;
    [T,Y] = rk4(@rhs,tau(przelaczenie-1),tau(przelaczenie),y0, u(przelaczenie-1), m);
    Tall = [Tall T];
    Yall = [Yall Y]; % TODO: preallocate
    Yprzel=[Yprzel Yall(:,end)];
end

%wykres po³o¿enia kulki
subplot(2,1,1)
hold on;
grid on
plot(Tall,Yall(:,:)*alpha*1000);
title('Odleg³oœæ œrodka sfery od cewki elektromagnesu [mm]');

% !!!
% Kazik to ponizej:
%

wektor do wyplotowania prze³¹czeñ
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
hold on;
plot(Tall,P)
title('Funkcja prze³¹czaj¹ca')

%% Wyliczenie wartoœci funkcji celu
ro=100;
[N,M] = size(Yall);
for i=1:M
    x(:,i) = Yall(:,i) - xPracy;
end

x1 = x(1,:);
suma = sum(x1);
kwadratSumy = suma.^2;

J = Tfinish + ro*(kwadratSumy);

end

