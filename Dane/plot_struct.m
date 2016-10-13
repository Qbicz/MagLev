% Wykres z pomiaru zapisanego do struktury z czasem
close all;

figure;
% plot(ident.time, ident.signals(1).values)

% Charakterystyka statyczna
plot(SensorData.Sensor_V, SensorData.Distance_mm, '.')
title('Charakterystyka optycznego czujnika po³o¿enia')
xlabel('Napiêcie [V]')
ylabel('Odleg³oœæ sfery od cewki [mm]')
