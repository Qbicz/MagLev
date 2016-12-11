load('prad_od_sterowanie.mat')

u = I_od_U(:, 1);
i = I_od_U(:, 2);

stairs(u, i)
title('Zależność prądu od sterowania na cewce po uśrednieniu');
xlabel('U/U_{max}');
ylabel('I [A]');
