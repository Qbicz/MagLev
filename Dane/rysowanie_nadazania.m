load('dane/nadazanie_za_sinusem.mat')

plot(ident.time, (ident.signals(1).values(:,1)-0.01)*10, 'r', ident.time, ident.signals(1).values(:,2)-0.011, 'b')
title('Nad¹¿anie za sinusem')
