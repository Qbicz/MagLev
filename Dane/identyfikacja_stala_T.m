clear all;
close all;

load('stala_cewki_z_wlozeniem_preskaler4095.mat');

%parametry narastania prądu

t_min = 427;
t_max = 628;

t = ident.time(t_min : t_max);
current = ident.signals(3).values(t_min : t_max);

t = t(:, 1) - t(1,1);
y = current(:,1) - current(1,1); %y - obnizone do 0, tylko do obliczen, do ostatecznego wykresu bierzemy current

% %Transmitancja modelu - np. obiekt 1 rzedu
K = y(end, 1);      %dobrane doświadczalnie, nie ma znaczenia w tym przypadku
T_up = 0.0245          %w pracy[1] wyszło 6.3 ms

NUM = K;
DEN = [T_up 1];

model = tf(NUM, DEN);
step = step(model, t);

%Kryterium jakości aproksymacji
e = y - step;
error = sum(e.^2)

figure
title('Stala czasowa cewki przy narastaniu prądu.')
hold on;
plot(t, y, t, step);

%parametry opadania

clear all;
load('stala_cewki_z_wlozeniem_preskaler4095.mat');

t_min2 = 637;
t_max2 = 846;

t = ident.time(t_min2 : t_max2);
current = ident.signals(3).values(t_min2 : t_max2);

t = t(:, 1) - t(1,1);
y = current(:,1) - current(1,1); %y - obnizone do 0, tylko do obliczen, do ostatecznego wykresu bierzemy current

% %Transmitancja modelu - np. obiekt 1 rzedu
K = y(end, 1);      %dobrane doświadczalnie, nie ma znaczenia w tym przypadku
T_down = 0.023          %w pracy[1] wyszło 6.3 ms

NUM = K;
DEN = [T_down 1];

model = tf(NUM, DEN);
step = step(model, t);

%Kryterium jakości aproksymacji
e = y - step;
error = sum(e.^2)

figure
title('Stała czasowa cewki przy malejącym prądzie.')
hold on;
plot(t, y, t, step);