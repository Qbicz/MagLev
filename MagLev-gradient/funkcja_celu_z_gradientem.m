function [J, gradient] = funkcja_celu_z_gradientem(tau, params)
%funkcjaCeluOdCzasuPrzel - Ta funkcja przyjmuje wektor chwil prze³¹czeñ tau i na
%jego podstawie zwraca wskaznik jakosci i jego [roznicowo przyblizony gradient?]. Struktura params agreguje
%parametry ukladu potrzebne przy optymalizacji.
%
% Uzycie fmincon z gradientem funkcji celu:
% http://www.mathworks.com/help/optim/ug/fmincon.html#busxd7j-1

%% -- Rozwiazanie rownan -- mozna zamknac w osobnej funkcji dla czytelnosci

% TODO: rozwiazac podobnie jak w grad() - uzyc tych samych argumentow

%% Gradient - rozw w dwoch miejscach i odjac od siebie

gradient = grad()

%% Wyliczenie wartoœci funkcji celu
% Tfinish = ;
ro = 100;

J = Tfinish + ro/2 * (sum( X(T) - X0 ))^2 ;

end

