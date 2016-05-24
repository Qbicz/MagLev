%% MagLev
clear all; close all;
stale;

% chwile prze³¹czenia
czasy_przel = [0, 0.01, 0.048, 0.051 ]; % , 0.1, 0.15, 0.2];
lb_przel = length(czasy_przel); %iloœæ prze³¹czeñ
ost_przel = czasy_przel(end); %ostatnie prze³¹cznie

step = 0.001; %przyjêty krok

% sporz¹dzenie wektora sterowañ
wektor_ster = []; %wektor sterowan
wektor_ster = wekt_ster(lb_przel, vmax, vmin);

x_zadane=18;
u=[vmax vmin vmax];
y0 = pkt_rownowagi(x_zadane);
h0=0.0001; %podstawowy krok dyskretyzacji

%wywo³anie metody RK4
[Y,T,u_wyj]=rk4a(y0,u,czasy_przel,h0);

%wykres po³o¿enia kulki
figure;
subplot(2,1,1)
plot(T,Y(:,1)*1000); %przeskalowanie po³o¿enia do [mm]
title('Odleg³oœæ œrodka sfery od cewki elektromagnesu [mm]');
grid on;

 %generowanie wektora prze³¹czeñ
 P=[];
 p=2;
 for i=1:length(T)
     if T(i)< czasy_przel(p)
         if p(mod(p,2)==0)
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
title('Wektor prze³¹czeñ');
xlabel('Czas');
ylabel('Wartoœæ');
grid on;

%% w ty³
nom_pkt = pkt_rownowagi(14); % Nominalny punkt pracy ^x1 = 14mm
ro=5;
PsiT=-ro*(Y(end,:)-nom_pkt);
Psi = rk4a_inv(Y,u,czasy_przel,h0,nom_pkt,ro);
figure(2)
plot(T, Psi(:,3));
legend('Psi3')
xlabel('T')
ylabel('Psi')
grid on
title('Rozwi¹zywanie równañ sprzê¿onych w ty³')

%% gradient

dQ = grad(y0,vmax,h0,czasy_przel,vmin,vmax,ro,nom_pkt);

%% fmincon




