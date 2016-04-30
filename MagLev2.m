%% MagLev
clear all; close all;

% chwile prze��czenia
czasy_przel = [0, 0.02, 0.05];
lb_przel = length(czasy_przel); %ilo�� prze��cze�
ost_przel = czasy_przel(end); %ostatnie prze��cznie

% parametry do przeskalowania 
vmax = 9.56; %maksymalne napi�cie steruj�ce
vmin = 5.56; %minimalne napi�cie steruj�ce
is = 1.506; %sta�y pr�d p�yn�cy przez cewk�
k = 0.297; %wsp�czynnik wzmocnienia sterownika pr�du
ni = 10.28701901522286; %wsp�czynnik skalowania
tau = 0.0107; %sta�a czasowa elektromagnesu
alpha = 0.00773746; % parametr elektromagnesu [m] -> skalowanie ^x1 = alpha * x1

% umin, umax na podstawie vmin, vmax
umax = (vmax*k - is)/(ni*tau); %maksymalne sterowanie
umin = (vmin*k - is)/(ni*tau); %minimalne sterowanie

step = 0.001; %przyj�ty krok

% sporz�dzenie wektora sterowa�
wektor_ster = []; %wektor sterowa�
wektor_ster = wekt_ster(lb_przel, umax, umin);

nom_pkt = [1.8094; 0.0; 2.4712]; % Nominalny punkt pracy ^x1 = 14mm
%y0 = [x_zadane/(alpha*1000); 0.0; 2.4712];




% struktura parametr�w wykorzystywana przy wywo�aniu funkcji celu
params = struct('umax', umax, 'umin', umin, ...
                'step', step, 'alpha', alpha, ...
                'xOperating', nom_pkt, ... punkt pracy
                'Tfinish', ost_przel,...
                'lb_przel', lb_przel,...
                'czasy_przel', czasy_przel,...
                'wektor_ster', wektor_ster );

            
            
            
% rozwiazywanie r�wna� przy prze��czanym sterowaniu
T = [];  %wektor czasu w kt�rym nast�puj� prze��czenia
Y = [];  %wszystkie warto�ci wyj�cia - [po�o�enie, pr�dko��, przyspieszenie]
Yprzel = [];  %ostatni Y w ka�dym prze��czeniu

[T, Y, Yprzel]= rozw_rown(params);

%wykres po�o�enia kulki
subplot(2,1,1)
hold on;
grid on
plot(T,Y(1,:)*alpha*1000); %przeskalowanie po�o�enia do [mm]
title('Odleg�o�� �rodka sfery od cewki elektromagnesu [mm]');

% WYWO�ANIE FUNKCJI OD KAZIKA-----------------------------------
% %wektor do wyplotowania prze��cze�
% P=[];
%  p=2;
% for i=1:length(T)
%       if T(i)< czasy_przel(p)
%           if p(mod(p,2)==0)
%               P(i)= umin;
%           else
%               P(i)= umax;
%           end
%       else
%           P(i)= P(i-1);
%           p=p+1;
%       end
% end
% subplot(2,1,2)
% plot(T,P)
% title('Funkcja prze��czaj�ca')
% KONIEC WYWO�ANIA FUNKCJI OD KAZIKA-------------------




%rozwi�zywanie r�wna� sprz�onych wstecz
T_sprz = [];  %wektor czasu dla rozwi�zywania wstecz
Psi = [];     %warto�ci psi z r. sprz�onych
ro = 25;      %wsp�czynnik kary
psiT = -ro*(Y(:,end)-nom_pkt); %psi w chwili ko�cowej T - punkt startowy do rozwi�zywania r�wna� w ty�

[T_sprz, Psi] = rozw_wtyl(psiT, Yprzel, params);

% wykres rozwi�zanych r. sprz�onych wstecz
figure(2)
plot(T_sprz, Psi)
grid on

%rozwi�zywanie r�wna� stanu wstecz (sprawdzenie dzia�ania)
T_spr = [];     %wektor czasu do rozw. r. stanu w ty�
Y_spr = [];     %wektor warto�ci zm. stanu dla rozw. w ty�
YT = Y(:,end); %ostatni punkt z wektora zmiennych stanu rozwi�zywanych w prz�d

[T_spr, Y_spr] = rozw_wtyl_spr(YT, params);

%wykres r�wna� stanu rozwi�zanych w ty�
figure(3)
plot(T_spr, Y_spr(1,:)*alpha*1000)
grid on

%% Funkcja celu
J = funkcjaCeluOdX(ost_przel, Y, y0)

%% Minimalizacja wzd�u� wektora czasy_przel - prze��cze�

%czasy_przelMin = [0, 0.03, 0.05, 0.09];
%czasy_przelMax = [0.01, 0.04, 0.07, 0.1];
J_czasy_przel = funkcjaCeluOdczasy_przel(czasy_przel, params)

% minimalizujemy funkcje celu w zaleznosci od czasy_przel
%A = ones(max_przelaczen, max_przelaczen);
%b = ones(max_przelaczen, 1);

%% Test
czasy_przel0 = czasy_przel;
A=[-1, 0, 0;
    1, -1, 0;
    0, 1, -1];
b = [0; 0; 0];
% trzeba podac tez gradient, opcja optimset Optimization
options = optimoptions('fmincon', 'MaxIter', 10000);

czasy_przelOptim = fmincon(@(czasy_przelfmincon)funkcjaCeluOdczasy_przel(czasy_przelfmincon, params), czasy_przel0, A, b,[],[],[],[],[], options); % czasy_przelMin, czasy_przelMax);
%czasy_przelOptim = fmincon(@funkcjaCeluOdczasy_przel, czasy_przel0, A, b); % czasy_przelMin, czasy_przelMax);

