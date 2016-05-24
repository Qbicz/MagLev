%% MagLev
clear all; close all;
stale;

% chwile prze��czenia
czasy_przel = [0, 0.01, 0.048, 0.051 ]; % , 0.1, 0.15, 0.2];
lb_przel = length(czasy_przel); %ilo�� prze��cze�
ost_przel = czasy_przel(end); %ostatnie prze��cznie

step = 0.001; %przyj�ty krok

% sporz�dzenie wektora sterowa�
wektor_ster = []; %wektor sterowan
wektor_ster = wekt_ster(lb_przel, vmax, vmin);

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
title('Wektor prze��cze�');
xlabel('Czas');
ylabel('Warto��');
grid on;

%% w ty�
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
title('Rozwi�zywanie r�wna� sprz�onych w ty�')

%% gradient

dQ = grad(y0,vmax,h0,czasy_przel,vmin,vmax,ro,nom_pkt);

%% fmincon




