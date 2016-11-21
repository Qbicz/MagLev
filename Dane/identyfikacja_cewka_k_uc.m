%Autorzy: Filip Kubicz, Piotr Palucki
%Opis: 
%Skrypt do identyfikacji parametrow cewki: wzmocnienia k i stalego napiecia
%sterowania u_c


%Based on: https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
%Linear regression for y = ax + b -> Y = AB
Y = I_od_U(:,2);
U = 12*I_od_U(:,1);
A = [U ones(length(U), 1)];
% will be B = [a b];
B = A\Y;
k = B(1) 
u_c = B(2)


%Check results - plot data on one figure
x = linspace(U(1), U(end));
y = k*x+u_c;
% 
figure
hold on;
plot(U, Y, '*', x, y);
title('Zależność prądu cewki od sterowania');
xlabel('U');
ylabel('I [A]');
legend('Dane pomiarowe','Dopasowanie metodą najmniejszych kwadratów');