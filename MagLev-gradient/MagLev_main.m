%% MagLev
clear all; close all;
stale;

% chwile prze��czenia
czasy_przel = [0.03, 0.048, 0.051 ]; % , 0.1, 0.15, 0.2];
lb_przel = length(czasy_przel); %ilo�� prze��cze�
ost_przel = czasy_przel(end); %ostatnie prze��cznie

step = 0.001; %przyj�ty krok

% sporz�dzenie wektora sterowa�
%wektor_ster = []; %wektor sterowan
%wektor_ster = wekt_ster(lb_przel, vmax, vmin);

x_zadane=18;
u=[vmax vmin vmax];
y0 = pkt_rownowagi(x_zadane);
h0=0.0001; %podstawowy krok dyskretyzacji

%wywo�anie metody RK4
[Y,T,u_wyj]=rk4a(y0,u,czasy_przel,h0);

%wykres po�o�enia kulki
figure;
subplot(2,1,1)
plot(T,Y(:,1)*1000); %przeskalowanie po�o�enia do [mm]
title('Odleg�o�� �rodka sfery od cewki elektromagnesu [mm]');
grid on;

 %generowanie wektora prze��cze�
 P=[];
 p=1;
 for i=1:length(T)
     if T(i)< czasy_przel(p)
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
plot(T,P);
%title('Wektor prze��cze�');
xlabel('Czas');
ylabel('Warto��');
grid on;

%% w ty�
nom_pkt = pkt_rownowagi(14); % Nominalny punkt pracy ^x1 = 14mm
ro=5;
PsiT=-ro*(Y(end,:)-nom_pkt);
Psi = rk4a_inv(Y,u,czasy_przel,h0,nom_pkt,ro);
%figure(2)
hold on;
plot(T, 10*Psi(:,3), 'r-'); % przeskalowanie na potrzeby wykresu
%legend('Psi3')
xlabel('T')
ylabel('Psi')
grid on
title('F. przelaczajaca na tle wektora przelaczen')

%% funkcja celu z gradientem
%J = funkcja_celu(y0,vmax,h0,czasy_przel,vmin,vmax,nom_pkt)
tic
[J, Jgrad] = funkcja_celu_z_gradientem(y0,vmax,h0,czasy_przel,vmin,vmax,ro,nom_pkt)
toc

%% fmincon
czasy_przel0 = czasy_przel;
% A=[-1, 0, 0;
%     1, -1, 0;
%     0, 1, -1];

% generacja macierzy ograniczen A i b dla dowolnej wielkosci
rozmiar = length(czasy_przel);
A = -eye(rozmiar) + ... % diagonalna
tril(ones(rozmiar),-1) - tril(ones(rozmiar),-2) % poddiagonalna

% b = [0; 0; 0];
b = zeros(1, rozmiar)
% uwzglednienie gradientu w fmincon
options = optimoptions('fmincon', 'MaxIter', 1);
options = optimoptions(options, 'GradObj', 'on');

%% szukanie minimum
czasy_przelOptim = fmincon(@(czasy_przelfmincon)funkcja_celu_z_gradientem(y0,vmax,h0,czasy_przelfmincon,vmin,vmax,ro,nom_pkt), czasy_przel0, A, b,[],[],[],[],[], options) % czasy_przelMin, czasy_przelMax);
% the gradient should have 3 elements.

% tutaj ROZW ROWNANIA i OCENIC optymalizacje

% wyrysowac f przelaczajaca

%% rown rownan w przod
x_zadane=18;
u=[vmax vmin vmax];
y0 = pkt_rownowagi(x_zadane);
h0=0.0001; %podstawowy krok dyskretyzacji

[Y,T,u_wyj]=rk4a(y0,u,czasy_przelOptim,h0);

%wykres po�o�enia kulki
figure;
subplot(2,1,1)
plot(T,Y(:,1)*1000); %przeskalowanie po�o�enia do [mm]
title('Odleg�o�� �rodka sfery od cewki elektromagnesu [mm]');
grid on;

 %generowanie wektora prze��cze�
 P=[];
 p=1;
 for i=1:length(T)
     if T(i)< czasy_przel(p)
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
plot(T,P);
title('Wektor prze��cze�');
xlabel('Czas');
ylabel('Warto��');
grid on;

