clear all; close all;

%load('skok_pradu_bezfiltra.mat')
load('skok_pradu_zfiltrem.mat')

plot(ident.time, ident.signals(4).values, 'r', ident.time, ident.signals(3).values, 'b')
title('Skok pr�du bez filtracji')
legend('Napi�cie steruj�ce', 'Pr�d cewki')
