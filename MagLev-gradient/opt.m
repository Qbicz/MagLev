function [J]= opt(czasy_przel,x_zadane,u)
stale;
lb_przel = length(czasy_przel); %iloœæ prze³¹czeñ
ost_przel = czasy_przel(end); %ostatnie prze³¹cznie

step = 0.001; %przyjêty krok

% sporz¹dzenie wektora sterowañ
wektor_ster = []; %wektor sterowan
wektor_ster = wekt_ster(lb_przel, vmax, vmin);

y0 = pkt_rownowagi(x_zadane);
h0=0.0001; %podstawowy krok dyskretyzacji

%wywo³anie metody RK4
[Y,T,u_wyj]=rk4a(y0,u,czasy_przel,h0);

% w ty³
nom_pkt = pkt_rownowagi(14); % Nominalny punkt pracy ^x1 = 14mm
ro=5;
PsiT=-ro*(Y(end,:)-nom_pkt);
Psi = rk4a_inv(Y,u,czasy_przel,h0,nom_pkt,ro);

% gradient

dQ = grad(y0,vmax,h0,czasy_przel,vmin,vmax,ro,nom_pkt);

%% wskaŸnik jakoœci
J=wsk_jako(Tk, ro, nom_pkt, xk)

