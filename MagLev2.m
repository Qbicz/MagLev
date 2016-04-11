%% RK4 dla systemu MagLev
clear all; close all;

tau = [];

% chwile prze³¹czenia
%tau = [0, 0.2, 0.4, 1, 1.3 ,1.7,1.8,2.3,2.6, 3,3.1,3.3,3.8];
tau = [0, 0.02, 0.05]
max_przelaczen = length(tau);

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
%y0 = [1.8094; 0.0; 2.4712];

x_zadane = 18;
y0 = [x_zadane/(alpha*1000); 0.0; 2.4712];

% rozwiazywanie równañ przy prze³¹czanym sterowaniu
Tall = [];  %wektor czasu
Yall = [];  %wszystkie wartoœci Y - [odleg³oœæ, prêdkoœæ, przyspieszenie]
Yprzel=[];  %ostatni Y w ka¿dym prze³¹czeniu
for przelaczenie = 2:max_przelaczen
    % ustawienie aktualnego warunku poczatkowego
    if przelaczenie > 2
       y0 = Y(:,length(Y)) ;
    end
    % iloœæ kroków
    m = (tau(przelaczenie) - tau(przelaczenie-1))/step;
    [T,Y] = rk4(@rhs,tau(przelaczenie-1),tau(przelaczenie),y0, u(przelaczenie-1), floor(m));
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

%wektor do wyplotowania prze³¹czeñ
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



%rozwi¹zywanie równañ sprzê¿onych wstecz
Tt=[]; %wektor czasu dla rozwi¹zywania wstecz
Psit=[];    %wartoœci psi z r. sprzê¿onych
ro=25;  %wspó³czynnik kary
psiT=-ro*(Yall(:,end)-x_zadane); %psi w chwili koñcowej T
for i = 1:max_przelaczen-1
    numer_p= max_przelaczen-i;
       x0 = Yprzel(:,numer_p) ;   
      if i>1
          psiT=Psit(:,end);
      end
    m = (tau(numer_p+1) - tau(numer_p))/step;
    [T,Psi] = rk4(@rhs_sprz,tau(numer_p+1),tau(numer_p),psiT, x0, m);
    Tt = [Tt T];
    Psit = [Psit Psi]; 
end

% wykres rozwi¹zanych r. sprzê¿onych wstecz
figure(2)
plot(Tt, Psit)
grid on


% for i = 1:max_przelaczen
%     plot([tau(i) tau(i)],get(gca,'ylim'));
% end


%rozwi¹zywanie równañ stanu wstecz (sprawdzenie dzia³ania)
Tty=[]; %wektor czasu do rozw. r. stanu w ty³
Ytyl=[];    %wektor wartoœci zm. stanu dla rozw. w ty³
YT=Yall(:,end); %ostatni punkt z wektora zmiennych stanu rozwi¹zywanych w przód
for i = 1:max_przelaczen-1
    numer_p= max_przelaczen-i;
       x0 = Yprzel(:,numer_p) ;   
      if i>1
          YT=Ytyl(:,end);
      end
    m = (tau(numer_p+1) - tau(numer_p))/step;
    [T,Yt] = rk4(@rhs1,tau(numer_p+1),tau(numer_p), YT, u(numer_p), m);
    Tty = [Tty T];
    Ytyl = [Ytyl Yt]; 
end

%wykres równañ stanu rozwi¹zanych w ty³
figure(3)
plot(Tty, Ytyl*alpha*1000)
grid on

%% Funkcja celu
Tfinish = tau(length(tau));
J = funkcjaCeluJ(Tfinish, Yall, y0)

%% Minimalizacja wzd³u¿ wektora tau - prze³¹czeñ

%tauMin = [0, 0.03, 0.05, 0.09];
%tauMax = [0.01, 0.04, 0.07, 0.1];
J_tau = funkcjaCeluOdTau(Tfinish, tau, y0)

% minimalizujemy funkcje celu w zaleznosci od tau
%A = ones(max_przelaczen, max_przelaczen);
%b = ones(max_przelaczen, 1);

tau0 = tau;
A=[-1, 0, 0;
    1, -1, 0;
    0, 1, -1];
b = [0; 0; 0];
% trzeba podac tez gradient, opcja optimset Optimization
tauOptim = fmincon(@(taufmincon)funkcjaCeluOdTau(Tfinish, taufmincon, y0), tau0, A, b); % tauMin, tauMax);
