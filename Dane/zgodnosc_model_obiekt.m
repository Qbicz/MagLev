load('pomiary_ostatnie_z_5_grudnia.mat')

MAX_PLOT_INDEX = 30000;

t = ident.time(1:MAX_PLOT_INDEX);
polozenie = ident.signals(1).values(1:MAX_PLOT_INDEX, :);
predkosc = ident.signals(2).values(1:MAX_PLOT_INDEX, :);
prad = ident.signals(3).values(1:MAX_PLOT_INDEX, :);

figure

subplot(3,1,1)
plot(t, polozenie)
title('Położenie sfery');
legend('Obiekt','Model');
xlabel('t [s]');
ylabel('x_1 [m]');

subplot(3,1,2)
plot(t, predkosc)
title('Prędkość sfery');
legend('Obiekt','Model');
xlabel('t [s]');
ylabel('x_2 [m/s]');
axis([0 30 -.3 .3]);

subplot(3,1,3)
plot(t, prad)
title('Prąd cewki');
legend('Obiekt','Model');
xlabel('t [s]');
ylabel('x_3 [A]');


figure

subplot(3,1,1)
plot(t, polozenie)
title('Położenie sfery');
legend('Obiekt', 'Model');
xlabel('t [s]');
ylabel('x_1 [m]');
axis([0 1 0.01 0.02]);

subplot(3,1,2)
plot(t, predkosc)
title('Prędkość sfery');
legend('Obiekt','Model');
xlabel('t [s]');
ylabel('x_2 [m/s]');
axis([0 1 -.3 .3]);

subplot(3,1,3)
plot(t, prad)
title('Prąd cewki');
legend('Obiekt','Model');
xlabel('t [s]');
ylabel('x_3 [A]');
axis([0 1 0 3]);