clear all; close all;

%load('skok_pradu_bezfiltra.mat')
load('skok_pradu_zfiltrem.mat')

plot(ident.time, ident.signals(4).values, 'r', ident.time, ident.signals(3).values, 'b')
title('Skok pr¹du bez filtracji')
legend('Napiêcie steruj¹ce', 'Pr¹d cewki')
