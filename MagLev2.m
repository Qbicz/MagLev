%% MagLev
clear all; close all;

% chwile prze³¹czenia
czasy_przel = [0, 0.01, 0.05, 0.055 ]; % , 0.1, 0.15, 0.2];
lb_przel = length(czasy_przel); %iloœæ prze³¹czeñ
ost_przel = czasy_przel(end); %ostatnie prze³¹cznie

% parametry do przeskalowania 
vmax = 9.56; %maksymalne napiêcie steruj¹ce
vmin = 5.56; %minimalne napiêcie steruj¹ce
is = 1.506; %sta³y pr¹d p³yn¹cy przez cewkê
k = 0.297; %wspó³czynnik wzmocnienia sterownika pr¹du
ni = 10.28701901522286; %wspó³czynnik skalowania
tau = 0.0107; %sta³a czasowa elektromagnesu
alpha = 0.00773746; % parametr elektromagnesu [m] -> skalowanie ^x1 = alpha * x1

% umin, umax na podstawie vmin, vmax
umax = (vmax*k - is)/(ni*tau); %maksymalne sterowanie
umin = (vmin*k - is)/(ni*tau); %minimalne sterowanie

step = 0.001; %przyjêty krok

% sporz¹dzenie wektora sterowañ
wektor_ster = []; %wektor sterowan
wektor_ster = wekt_ster(lb_przel, umax, umin);

nom_pkt = [1.8094; 0.0; 2.4712]; % Nominalny punkt pracy ^x1 = 14mm
%y0 = [x_zadane/(alpha*1000); 0.0; 2.4712];


% struktura parametrów wykorzystywana przy wywo³aniu funkcji celu
params = struct('umax', umax, 'umin', umin, ...
                'step', step, 'alpha', alpha, ...
                'xOperating', nom_pkt, ... % punkt pracy
                'Tfinish', ost_przel,...
                'lb_przel', lb_przel,...
                'czasy_przel', czasy_przel,...
                'wektor_ster', wektor_ster );

                        
            
% rozwiazywanie równañ przy prze³¹czanym sterowaniu
% T = [];  %wektor czasu w którym nastêpuj¹ prze³¹czenia
% Y = [];  %wszystkie wartoœci wyjœcia - [po³o¿enie, prêdkoœæ, przyspieszenie]
% Yprzel = [];  %ostatni Y w ka¿dym prze³¹czeniu

[T, Y, Yprzel]= rozw_rown(params);

%funkcja subplotuj¹ca polozenie kulki i wektor prze³¹czeñ
rysujPolozenieIPrzelaczenia(T, Y, alpha, czasy_przel, umin, umax); 


%% rozwi¹zywanie równañ sprzê¿onych wstecz
% T_sprz = [];  %wektor czasu dla rozwi¹zywania wstecz
% Psi = [];     %wartoœci psi z r. sprzê¿onych
% ro = 25;      %wspó³czynnik kary
% psiT = -ro*(Y(:,end)-nom_pkt); %psi w chwili koñcowej T - punkt startowy do rozwi¹zywania równañ w ty³
% 
% [T_sprz, Psi] = rozw_wtyl(psiT, Yprzel, params);
% 
% % wykres rozwi¹zanych r. sprzê¿onych wstecz
% figure;
% plot(T_sprz, Psi); title('wykres rozwi¹zanych r. sprzê¿onych wstecz')
% grid on

%% rozwi¹zywanie równañ stanu wstecz (sprawdzenie dzia³ania)
% T_spr = [];     %wektor czasu do rozw. r. stanu w ty³
% Y_spr = [];     %wektor wartoœci zm. stanu dla rozw. w ty³
% YT = Y(:,end); %ostatni punkt z wektora zmiennych stanu rozwi¹zywanych w przód
% 
% [T_spr, Y_spr] = rozw_wtyl_spr(YT, params);
% 
% %wykres równañ stanu rozwi¹zanych w ty³
% figure;
% plot(T_spr, Y_spr(1,:)*alpha*1000);
% title('wykres równañ stanu rozwi¹zanych w ty³');
% grid on

%% Funkcja celu
% J = funkcjaCeluOdX(ost_przel, Y, nom_pkt)

%% Minimalizacja wzd³u¿ wektora czasy_przel - prze³¹czeñ

%czasy_przelMin = [0, 0.03, 0.05, 0.09];
%czasy_przelMax = [0.01, 0.04, 0.07, 0.1];
J_czasy_przel = funkcjaCeluOdCzasuPrzel(czasy_przel, params)

% minimalizujemy funkcje celu w zaleznosci od czasy_przel
%A = ones(max_przelaczen, max_przelaczen);
%b = ones(max_przelaczen, 1);

%% Test
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
% trzeba podac tez gradient, opcja optimset Optimization
options = optimoptions('fmincon', 'MaxIter', 10000);

czasy_przelOptim = fmincon(@(czasy_przelfmincon)funkcjaCeluOdCzasuPrzel(czasy_przelfmincon, params), czasy_przel0, A, b,[],[],[],[],[], options); % czasy_przelMin, czasy_przelMax);
%czasy_przelOptim = fmincon(@funkcjaCeluOdczasy_przel, czasy_przel0, A, b); % czasy_przelMin, czasy_przelMax);

%% zoptymalizowane wartosci
params.czasy_przel = czasy_przelOptim;
[T, Y, Yprzel]= rozw_rown(params);

rysujPolozenieIPrzelaczenia(T, Y, alpha, czasy_przelOptim, umin, umax);
J_optim = funkcjaCeluOdCzasuPrzel(czasy_przelOptim, params)
