clear all;
close all;

% load('identtfikacja_skok_pradu_z_pwm_tuy.mat');
% t = t(:, 1) - t(1,1); %przesuniecie wykresu do czasu 0
% y = y(:, 1) - y(1,1); %przesuniecie do 0
% 
% %Transmitancja modelu - np. obiekt 1 rzedu
% K = y(end, 1);      %dobrane doświadczalnie, nie ma znaczenia w tym przypadku
% T = 0.048;          %w pracy[1] wyszło 6.3 ms
% 
% NUM = K;
% DEN = [T 1];
% 
% model = tf(NUM, DEN);
% skok = step(model, t);
% 
% u = K*u; %Dla lepszego zobrazowania
% 
% %Kryterium jakości aproksymacji
% e = y - skok;
% error = sum(e.^2)
% 
% figure
% hold on;
% plot(t, u, t, y, t, skok);

load identyfikacja_indukcyjnosc


%Based on: https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
%Linear regression for y = ax + b -> Y = AB
Y = prad_A;
A = [x_mm ones(length(x_mm), 1)];
%B = [a b];
B = A\Y;
a = B(1) 
b = B(2)


%Check results - plot data on one figure
x = linspace(x_mm(1), x_mm(end));
y = a*x+b;

figure
hold on;
plot(x_mm, prad_A, '*', x, y);
title('Zaleznosc prądu cewki od położenia sfery');
xlabel('x [mm]');
ylabel('I [A]');
legend('Dane pomiarowe','Dopasowanie metodą najmniejszych kwadratów');



%Try to find L'(x) = -2*mg*10^-3 / (ax+b)^2
m = 55; %g
g = 9.81; %m/s^2s

Lprim = -(2*m*g*(10^-3))./((a*x+b).^2);
Lprim_dosw = -(2*m*g*(10^-3))./((a*x_mm+b).^2);

figure
hold on;
plot(x_mm, -Lprim_dosw, '*', x, -Lprim);
title('Pochodna indukcyjności w funkcji położenia sfery');
xlabel('x [mm]');
ylabel('L''(x) [H/m] ');
legend('Dane pomiarowe','Dopasowanie');


