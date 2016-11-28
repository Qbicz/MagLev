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
%a = a+b;
%b = a-b
%a = a-b

% Warunki pocz�tkowe
x10 = 0.010; % m, pozycja sfery
x20 = -1e-10;  %m/s, predkosc sfery
x30 = 1e-10;  %A, prad cewki

% wartosc zadana
x1zad = 0.012 % [m]

% Ziegler dla Kp = 5: T0 = 4,5 sek
% Kp = 3, Ki = 2.2, Kd = 0.5

% regulator LQR dla zlinearyzowanego modelu
x1stab = 0.014  % [m]
x3stab = 0.023; % [A]
A21 = 0.002*a*g*x3stab^2/(a*x1stab+b)^3
A23 = -0.002*g*x3stab/(a*x1stab+b)^2

Q = diag([10 1 1])
R = 1
L = 2.46 % wzmocnienie wartosci zadanej
% L = 2.6 dla 14 mm
% L = 2.73 dla 16mm
% L = 2.46 dla 12 mm - wszystko dla linearyzacji w [0.014 0 0.023]
%u0 = 0.014 * L % sterowanie ustalone LQR
A = [ 0   1  0;
      A21 0  A23;
      0   0  -1/T]
B = [ 0;  0; k/T]

OB = obsv(A, [1 0 0])
ST = ctrb(A, B)

[K,S,E] = lqr(A,B,Q,R)

sim('nieliniowy')
