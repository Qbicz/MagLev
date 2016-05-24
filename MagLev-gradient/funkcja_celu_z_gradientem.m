function [J, gradient] = funkcja_celu_z_gradientem(x0,u0,h0,tau,vmin,vmax,ro,nom_pkt)
%funkcjaCeluOdCzasuPrzel - Ta funkcja przyjmuje wektor chwil prze³¹czeñ tau i na
%jego podstawie zwraca wskaznik jakosci i jego gradient. Wynik to
%zagregowany wskaznik jakosci i gradient, tak jak wymaga tego fmincon().
%
% Uzycie fmincon z gradientem funkcji celu:
% http://www.mathworks.com/help/optim/ug/fmincon.html#busxd7j-1

%% Rozwiazanie rownan i obliczenie wskaznika jakosci
J = funkcja_celu(x0,u0,h0,tau,vmin,vmax,nom_pkt)

%% Gradient - na podstawie wzoru psi*costam
gradient = grad(x0,u0,h0,tau,vmin,vmax,ro,nom_pkt) % 2 elem

%gradient = [gradient; gradientT]

end

