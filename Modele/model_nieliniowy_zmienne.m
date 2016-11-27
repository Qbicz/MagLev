%Autorzy: Filip Kubicz, Piotr Pa�ucki
%Opis: 
%Skrypt inicjalizuj�cy zmienne wykorzystywane w modelu nieliniowym.
%Model nielniowy zbudowany w celu weryfikacji wynik�w identyfikacji

m = 58;         %g
g = 9.81;       %m/s^2
u_c = -0.0062;  %V - stale napicie na cewce     
T = 0.024;      %s - stala czasowa cewki
k = 0.2607;     %wspolczynnik wzmocnienia cewki
a = 0.0928;     %parametry cewki
b = 0.0214;     %parametry cewki
a = a+b;
b = a-b
a = a-b

% Warunki pocz�tkowe
x10 = 0.013; % m, pozycja sfery
x20 = 0.0;  %m/s, predkosc sfery
x30 = 0.0;  %A, prad cewki

% wartosc zadana
x1zad = 0.014

% Ziegler dla Kp = 5: T0 = 4,5 sek
