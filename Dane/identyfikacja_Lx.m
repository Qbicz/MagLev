%Autorzy: Filip Kubicz, Piotr Pałucki
%Skrypt do dopasowania metodą regresji liniowej parametrów pochodnej
%indukcyjności

clear all; close all;
load identyfikacja_indukcyjnosc


%Based on: https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
%Linear regression for y = ax + b -> Y = AB
Y = prad_A;
A = [ ones(length(x_mm), 1) x_mm];
% will be B = [a b];
B = A\Y
b = B(1) 
a = B(2)


%Check results - plot data on one figure
x = linspace(x_mm(1), x_mm(end));
y = a*x+b;

figure
hold on;
plot(x_mm, prad_A, '*', x, y);
title('Zależność prądu cewki od położenia sfery');
xlabel('x [mm]');
ylabel('I [A]');
legend('Dane pomiarowe','Dopasowanie metodą najmniejszych kwadratów');



%Try to find L'(x) = -2*mg*10^-3 / (ax+b)^2
m = 58; %g
g = 9.81; %m/s^2s

Lprim = -(2*m*g*(10^-3))./((a*x+b).^2);
Lprim_dosw = -(2*m*g*(10^-3))./((a*x_mm+b).^2);

figure
hold on;
plot(x_mm, -Lprim_dosw, '*', x, -Lprim);
title('Pochodna indukcyjności w funkcji położenia sfery');
xlabel('x [mm]');
ylabel('L''(x) [H/m] ');
legend('Dane pomiarowe','Dopasowanie metodą najmniejszych kwadratów');


