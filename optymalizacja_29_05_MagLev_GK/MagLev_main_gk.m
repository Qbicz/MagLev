%% MagLev
clear all; close all;
stale_gk;

% chwile prze³¹czenia
czasy_przel = [0.02, 0.035, 0.055]; % , 0.1, 0.15, 0.2];
czasy_przel = czasy_przel/epsilon; %przeskalowanie
lb_przel = length(czasy_przel); %iloœæ prze³¹czeñ
ost_przel = czasy_przel(end); %ostatnie prze³¹cznie

% sporz¹dzenie wektora sterowañ
%wektor_ster = []; %wektor sterowan
%wektor_ster = wekt_ster(lb_przel, vmax, vmin);

x_zadane=18; %[mm]
prad_cewki_pocz = 0.92;
u=[vmax vmin vmax];

nom_pkt = [0.014/alpha 0/beta 0.7138/gamma]; % Nominalny punkt pracy z doktoratu ^x1 = 14mm
x0 = [(x_zadane/1000)/alpha 0/beta prad_cewki_pocz/gamma] ; %punkt poczatkowy
h0=0.0001; %podstawowy krok dyskretyzacji

%wywo³anie metody RK4
[X_rk4,T_rk4]=rk4_gk(x0,u,czasy_przel,h0);

%wykres po³o¿enia kulki
figure;
subplot(2,1,1)
plot(T_rk4*epsilon,X_rk4(:,1)*alpha*1000); %przeskalowanie zmiennych
title('Odleg³oœæ œrodka sfery od cewki elektromagnesu [mm] dla pocz¹tkowego sterowania');
grid on;

 %generowanie wektora prze³¹czeñ
 P=[];
 p=1;
 for i=1:length(T_rk4)
     if T_rk4(i)< czasy_przel(p)
         if p(mod(p,2)~=0)
             P(i)= umax;
         else
             P(i)= umin;
         end
     else
         P(i)= P(i-1);
         p=p+1;
     end
 end

subplot(2,1,2);
plot(T_rk4*epsilon,P);
%title('Wektor prze³¹czeñ');
xlabel('Czas');
ylabel('Wartoœæ');
grid on;

%% w ty³
ro=100;
PsiT=-ro*(X_rk4(end,:)-nom_pkt);
Psi = rk4_inv_gk(X_rk4,u,czasy_przel,h0,nom_pkt,ro);

hold on;
plot(T_rk4*epsilon, Psi(:,3)/10, 'r-'); % przeskalowanie na potrzeby wykresu
xlabel('T')
ylabel('Psi')
grid on
title('F. przelaczajaca na tle wektora przelaczen')

%% funkcja celu z gradientem
%J = funkcja_celu(y0,vmax,h0,czasy_przel,vmin,vmax,nom_pkt)

[J, Jgrad] = funkcja_celu_z_gradientem_gk(x0,h0,czasy_przel,ro,nom_pkt,u)

%% fmincon
czasy_przel0 = czasy_przel;
% A=[-1, 0, 0;
%     1, -1, 0;
%     0, 1, -1];

% generacja macierzy ograniczen A i b dla dowolnej wielkosci
rozmiar = length(czasy_przel);
A = -eye(rozmiar) + ... % diagonalna
tril(ones(rozmiar),-1) - tril(ones(rozmiar),-2); % poddiagonalna

% b = [0; 0; 0];
b = zeros(1, rozmiar);
% uwzglednienie gradientu w fmincon

% czasy_przelMin = [0; 0; czasy_przel(end)];
% czasy_przelMax = [czasy_przel(end); czasy_przel(end); czasy_przel(end)];
% czasy_przelMin = [0; 0.01; 0.04];
% czasy_przelMax = [0.05; 0.08; 0.09];

deltaT = [0.02 0.02 0.01]/epsilon;
czasy_przelMin = czasy_przel - deltaT;
czasy_przelMax = czasy_przel + deltaT;

options = optimoptions(@fmincon,'Algorithm', 'active-set'); % mozna probowac: 'sqp' 'active-set'
options = optimoptions(options,  'GradObj', 'on' , 'MaxIter', 10, 'maxFunEvals', 50);


% options

%% szukanie minimum
tic
czasy_przelOptim = fmincon(@(czasy_przelfmincon)funkcja_celu_z_gradientem_gk(x0,h0,czasy_przelfmincon,ro,nom_pkt,u), czasy_przel0, A, b,[],[], czasy_przelMin, czasy_przelMax,[],options)
% the gradient should have 3 elements.
toc
%% tutaj ROZW ROWNANIA i OCENIC optymalizacje
x_zadane=18; %[mm]
prad_cewki_pocz = 0.92;
u=[vmax vmin vmax];

nom_pkt = [0.014/alpha 0/beta 0.7138/gamma]; % Nominalny punkt pracy z doktoratu ^x1 = 14mm
x0 = [(x_zadane/1000)/alpha 0/beta prad_cewki_pocz/gamma] ; %punkt poczatkowy
h0=0.0001; %podstawowy krok dyskretyzacji

[X_optim,T_rozw_w_przod_optim]=rk4_gk(x0,u,czasy_przelOptim,h0);

ro=100;
PsiT_optim=-ro*(X_optim(end,:)-nom_pkt);
Psi_optim = rk4_inv_gk(X_optim,u,czasy_przelOptim,h0,nom_pkt,ro);
T_Psi_optim = 0:0.0001:(h0*(length(Psi_optim)-1));

[J_optim,J_grad_optim] = funkcja_celu_z_gradientem_gk(x0,h0,czasy_przelOptim,ro,nom_pkt,u)

%wykres po³o¿enia kulki
figure;
subplot(2,1,1)
plot(T_rozw_w_przod_optim*epsilon,X_optim(:,1)*1000*alpha); %przeskalowanie po³o¿enia do [mm]
title('Odleg³oœæ œrodka sfery od cewki elektromagnesu [mm] dla optymalnych prze³¹czeñ');
grid on;

 %generowanie wektora prze³¹czeñ
 P=[];
 p=1;
 for i=1:length(T_rozw_w_przod_optim)
     if T_rozw_w_przod_optim(i)< czasy_przelOptim(p)
         if p(mod(p,2)~=0)
             P(i)= umax;
         else
             P(i)= umin;
         end
     else
         P(i)= P(i-1);
         p=p+1;
     end
 end

subplot(2,1,2);
plot(T_rozw_w_przod_optim*epsilon,P);
title('Wektor prze³¹czeñ');
xlabel('Czas');
ylabel('Wartoœæ');
grid on;



% wyrysowac f przelaczajaca

hold on;
plot(T_Psi_optim*epsilon, Psi_optim(:,3)*10, 'r-'); % przeskalowanie na potrzeby wykresu
%legend('Psi3')
xlabel('T')
ylabel('Psi')
grid on
title('F. przelaczajaca na tle wektora przelaczen')
