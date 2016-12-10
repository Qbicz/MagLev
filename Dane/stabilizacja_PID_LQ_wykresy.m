%% Wykresy stabilizacji MagLev z regulatorami PID i LQ

clear all;
close all;

load('udana_stabilizacja_nieliniowego_PID_sprzezenie_plus_minus.mat')
%% Przyciecie czasu
t = ModelNieliniowy.time(1:40000);
x = ModelNieliniowy.signals(1).values(1:40000);
v = ModelNieliniowy.signals(2).values(1:40000);
i = ModelNieliniowy.signals(3).values(1:40000);
u = ModelNieliniowy.signals(4).values(1:40000);

figure;

%% Polozenie
subplot(4,1,1);
plot(t, x);
title('Po³o¿enie sfery [m]')

%% Predkosc
subplot(4,1,2);
plot(t, v);
title('Prêdkoœæ [m/s]')

%% Prad cewki
subplot(4,1,3);
plot(t, i);
title('Pr¹d cewki [A]')

%% Sterowanie
subplot(4,1,4);
plot(t, u);
title('Napiêcie steruj¹ce na cewce [U/U_{max}]')
xlabel('Czas [s]')