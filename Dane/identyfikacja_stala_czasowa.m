clear all;
close all;

load('identtfikacja_skok_pradu_z_pwm_tuy.mat');
t = t(:, 1) - t(1,1); %przesuniecie wykresu do czasu 0
y = y(:, 1) - y(1,1); %przesuniecie do 0

%Transmitancja modelu - np. obiekt 1 rzedu
K = y(end, 1);      %dobrane doświadczalnie, nie ma znaczenia w tym przypadku
T = 0.048;          %w pracy[1] wyszło 6.3 ms

NUM = K;
DEN = [T 1];

model = tf(NUM, DEN);
skok = step(model, t);

u = K*u; %Dla lepszego zobrazowania

%Kryterium jakości aproksymacji
e = y - skok;
error = sum(e.^2)

figure
hold on;
plot(t, u, t, y, t, skok);