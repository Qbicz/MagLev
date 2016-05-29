%% MagLev
clear all; close all;
stale;

% TODO: wskaznik jakosci (predkosc), punkty startowe i koncowe

% chwile prze³¹czenia
czasy_przel = [0.02, 0.045, 0.051 ]; % , 0.1, 0.15, 0.2];
lb_przel = length(czasy_przel); %iloœæ prze³¹czeñ
ost_przel = czasy_przel(end); %ostatnie prze³¹cznie

% sporz¹dzenie wektora sterowañ
%wektor_ster = []; %wektor sterowan
%wektor_ster = wekt_ster(lb_przel, vmax, vmin);

x_zadane=18;
u=[vmax vmin vmax];
y0 = pkt_rownowagi(x_zadane);
h0=0.0001; %podstawowy krok dyskretyzacji

%wywo³anie metody RK4
[Y,T_rozw_w_przod,u_wyj]=rk4a(y0,u,czasy_przel,h0);

%wykres po³o¿enia kulki
figure;
subplot(2,1,1)
plot(T_rozw_w_przod,Y(:,1)*1000); %przeskalowanie po³o¿enia do [mm]
title('Odleg³oœæ œrodka sfery od cewki elektromagnesu [mm] dla pocz¹tkowego sterowania');
grid on;

 %generowanie wektora prze³¹czeñ
 P=[];
 p=1;
 for i=1:length(T_rozw_w_przod)
     if T_rozw_w_przod(i)< czasy_przel(p)
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
plot(T_rozw_w_przod,P);
%title('Wektor prze³¹czeñ');
xlabel('Czas');
ylabel('Wartoœæ');
grid on;

%% w ty³
nom_pkt = pkt_rownowagi(14); % Nominalny punkt pracy ^x1 = 14mm
ro=1;
PsiT=-ro*(Y(end,:)-nom_pkt);
Psi = rk4a_inv(Y,u,czasy_przel,h0,nom_pkt,ro);
%figure(2)
hold on;
plot(T_rozw_w_przod, 10*Psi(:,3), 'r-'); % przeskalowanie na potrzeby wykresu
%legend('Psi3')
xlabel('T')
ylabel('Psi')
grid on
title('F. przelaczajaca na tle wektora przelaczen')

%% funkcja celu z gradientem
%J = funkcja_celu(y0,vmax,h0,czasy_przel,vmin,vmax,nom_pkt)

[J, Jgrad] = funkcja_celu_z_gradientem(y0,vmax,h0,czasy_przel,vmin,vmax,ro,nom_pkt)

%% fmincon params
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

czasy_przelMin = czasy_przel - [0.02 0.02 0.01];%[0; 0; czasy_przel(end)];
czasy_przelMax = czasy_przel + [0.02 0.02 0.01];%[czasy_przel(end); czasy_przel(end); czasy_przel(end)];

options = optimoptions(@fmincon,'Algorithm', 'sqp'); % mozna probowac: 'sqp' 'active-set'
options = optimoptions(options,  'GradObj', 'on');% , 'MaxIter', 10, 'maxFunEvals', 10);


% options

%% szukanie minimum
tic
czasy_przelOptim = fmincon(@(czasy_przelfmincon)funkcja_celu_z_gradientem(y0,vmax,h0,czasy_przelfmincon,vmin,vmax,ro,nom_pkt), czasy_przel0, A, b,[],[], czasy_przelMin, czasy_przelMax,[],options)
% the gradient should have 3 elements.
toc
%% tutaj ROZW ROWNANIA i OCENIC optymalizacje
% rown rownan w przod
u=[vmax vmin vmax];
y0 = pkt_rownowagi(x_zadane);
h0=0.0001; %podstawowy krok dyskretyzacji

[Y_optim,T_rozw_w_przod_optim,u_wyj]=rk4a(y0,u,czasy_przelOptim,h0);

ro=1;
PsiT_optim=-ro*(Y_optim(end,:)-nom_pkt);
Psi_optim = rk4a_inv(Y_optim,u,czasy_przelOptim,h0,nom_pkt,ro);

[J_optim, Jgrad_optim] = funkcja_celu_z_gradientem(y0,vmax,h0,czasy_przelOptim,vmin,vmax,ro,nom_pkt)

%wykres po³o¿enia kulki
figure;
subplot(2,1,1)
plot(T_rozw_w_przod_optim,Y_optim(:,1)*1000); %przeskalowanie po³o¿enia do [mm]
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
         % tylko zabezpieczenie, moze byc zle
         if i>1
            P(i)= P(i-1);
         else
             %P(i) = umin;
         end
         p=p+1;
     end
 end

subplot(2,1,2);
plot(T_rozw_w_przod_optim,P);
title('Wektor prze³¹czeñ');
xlabel('Czas');
ylabel('Wartoœæ');
grid on;



% wyrysowac f przelaczajaca

hold on;
plot(T_rozw_w_przod_optim, 10*Psi_optim(:,3), 'r-'); % przeskalowanie na potrzeby wykresu
%legend('Psi3')
xlabel('T')
ylabel('Psi')
grid on
title('F. przelaczajaca na tle wektora przelaczen')
