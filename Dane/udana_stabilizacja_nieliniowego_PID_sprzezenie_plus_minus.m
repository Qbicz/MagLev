%% Wykresy stabilizacji MagLev z regulatorami PID i LQ

clear all;
close all;

%load('udana_stabilizacja_nieliniowego_PID_sprzezenie_plus_minus.mat')
load('model_LQR.mat');
N = 1000 %floor(length(ModelNieliniowy.time)/3); % variable-step, it doesnt work!

%% Przyciecie czasu
t = ModelNieliniowy.time(1:N);
x = ModelNieliniowy.signals(1).values(1:N);
v = ModelNieliniowy.signals(2).values(1:N);
i = ModelNieliniowy.signals(3).values(1:N);
u = ModelNieliniowy.signals(4).values(1:N);

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