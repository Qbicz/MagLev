clear all;
close all;

load('ident.mat')

% tutaj przeskalowanie pradu

figure;
subplot(2,1,1);
plot(ident.time, ident.signals(3).values);
title('Pr�d cewki [A]')

subplot(2,1,2);
plot(ident.time, ident.signals(4).values);
title('Napi�cie steruj�ce na cewce [U/U_{max}]')
xlabel('Czas [s]')
