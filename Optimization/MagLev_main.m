%% MagLev
clear all; close all;
stale;

% chwile prze³¹czenia
czasy_przel = [0.03, 0.045, 0.055]; %[0.015, 0.035, 0.055]; % , [0.03, 0.045, 0.055];

u=[vmax vmin vmax]; %wektor sterowañ

x_poczatkowe = 18; %[mm]
prad_cewki_pocz = 0.92; % 0.92 dla 18mm

x_docelowe = 14;
prad_cewki_docelowy = 0.7138; %0.7138 dla 14mm

h0=0.0001; %podstawowy krok dyskretyzacji


czasy_przel = czasy_przel/epsilon; %przeskalowanie
lb_przel = length(czasy_przel); %iloœæ prze³¹czeñ
ost_przel = czasy_przel(end); %ostatnie prze³¹cznie

nom_pkt = [(x_docelowe/1000)/alpha, 0/beta, prad_cewki_docelowy/gamma]; % Nominalny punkt pracy z doktoratu ^x1 = 14mm
x0 = [(x_poczatkowe/1000)/alpha, 0/beta, prad_cewki_pocz/gamma] ; %punkt poczatkowy

%wywo³anie metody RK4
[X_rk4,T_rk4]=rk4(x0,u,czasy_przel,h0);

%wykres po³o¿enia kulki
figure(1);
subplot(2,2,1)
plot(T_rk4*epsilon,X_rk4(:,1)*alpha*1000); %przeskalowanie zmiennych
title('Stan pocz¹tkowy - Po³o¿enie [mm]');
xlabel('czas [s]')
ylabel('x_1 [mm]')
grid on;

subplot(2,2,2)
plot(T_rk4*epsilon,X_rk4(:,2)*beta); %przeskalowanie zmiennych
title('Stan pocz¹tkowy - prêdkoœæ [m/s]');
xlabel('czas [s]')
ylabel('x_2 [m/s]')
grid on;

subplot(2,2,4)
plot(T_rk4*epsilon,X_rk4(:,3)*gamma); %przeskalowanie zmiennych
title('Stan pocz¹tkowy - pr¹d [A]');
xlabel('czas [s]')
ylabel('x_3 [A]')
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

subplot(2,2,3);
plot(T_rk4*epsilon,P);
xlabel('czas [s]');
ylabel('sterowanie [V], Psi3');
grid on;

%% w ty³
ro=100;
PsiT=-ro*(X_rk4(end,:)-nom_pkt);
Psi = rk4_inv(X_rk4,u,czasy_przel,h0,nom_pkt,ro);

hold on;
plot(T_rk4*epsilon, Psi(:,3)/15, 'r-'); % przeskalowanie na potrzeby wykresu
title('Stan pocz¹tkowy - F. prze³¹cz¹jaca na tle wektora prze³¹czeñ')

%% funkcja celu z gradientem

[J, Jgrad] = funkcja_celu_z_gradientem(x0,h0,czasy_przel,ro,nom_pkt,u)

%% fmincon
czasy_przel0 = czasy_przel;

% generacja macierzy ograniczen A i b dla dowolnej wielkosci
rozmiar = length(czasy_przel);
A = -eye(rozmiar) + ... % diagonalna
tril(ones(rozmiar),-1) - tril(ones(rozmiar),-2); % poddiagonalna

b = zeros(1, rozmiar);

deltaT = [0.02 0.02 0.01]/epsilon;
czasy_przelMin = czasy_przel - deltaT;
czasy_przelMax = czasy_przel + deltaT;

% uwzglednienie gradientu w fmincon
options = optimoptions(@fmincon,'Algorithm', 'active-set'); % mozna probowac: 'sqp' 'active-set'
options = optimoptions(options,  'GradObj', 'on' , 'MaxIter', 20, 'maxFunEvals', 50);

%% szukanie minimum
tic
czasy_przelOptim = fmincon(@(czasy_przelfmincon)funkcja_celu_z_gradientem(x0,h0,czasy_przelfmincon,ro,nom_pkt,u), czasy_przel0, A, b,[],[], czasy_przelMin, czasy_przelMax,[],options);
toc
czasy_przelOpt = czasy_przelOptim*epsilon

%% tutaj ROZW ROWNANIA i OCENIC optymalizacje
nom_pkt = [x_docelowe/alpha 0/beta prad_cewki_docelowy/gamma]; % Nominalny punkt pracy z doktoratu ^x1 = 14mm
x0 = [(x_poczatkowe/1000)/alpha 0/beta prad_cewki_pocz/gamma] ; %punkt poczatkowy

[X_optim,T_rozw_w_przod_optim]=rk4(x0,u,czasy_przelOptim,h0);

PsiT_optim=-ro*(X_optim(end,:)-nom_pkt);
Psi_optim = rk4_inv(X_optim,u,czasy_przelOptim,h0,nom_pkt,ro);
T_Psi_optim = 0:0.0001:(h0*(length(Psi_optim)-1));

[J_optim,J_grad_optim] = funkcja_celu_z_gradientem(x0,h0,czasy_przelOptim,ro,nom_pkt,u)

%wykres po³o¿enia kulki
figure(2);
subplot(2,2,1)
plot(T_rozw_w_przod_optim*epsilon,X_optim(:,1)*alpha*1000); %przeskalowanie zmiennych
title('Po optymalizacji - Po³o¿enie [mm]');
xlabel('czas [s]')
ylabel('x_1_o_p_t_i_m [mm]')
grid on;

subplot(2,2,2)
plot(T_rozw_w_przod_optim*epsilon,X_optim(:,2)*beta); %przeskalowanie zmiennych
title('Po optymalizacji - prêdkoœæ [m/s]');
xlabel('czas [s]')
ylabel('x_2_o_p_t_i_m [m/s]')
grid on;

subplot(2,2,4)
plot(T_rozw_w_przod_optim*epsilon,X_optim(:,3)*gamma); %przeskalowanie zmiennych
title('Po optymalizacji - pr¹d [A]');
xlabel('czas [s]')
ylabel('x_3_o_p_t_i_m [A]')
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

subplot(2,2,3);
plot(T_rozw_w_przod_optim*epsilon,P);
xlabel('czas [s]');
ylabel('sterowanie_o_p_t_i_m [V], Psi3_(optim)');
grid on;

%f przelaczajaca
hold on;
plot(T_Psi_optim*epsilon, Psi_optim(:,3)/10000, 'r-'); % przeskalowanie na potrzeby wykresu
grid on
title('Po optymalizacji - F. prze³¹czaj¹ca na tle wektora prze³¹czeñ')