function J = funkcjaCeluOdX(T, x, xPracy)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ro = 100;
[N,M] = size(x);

%% tu musi byæ rozwiazywanie x w zaleznosci od tau




%%
for i=1:M
    x(:,i) = x(:,i) - xPracy;
end

x1 = x(1,:);
suma = sum(x1);
kwadratSumy = suma.^2;

J = T + ro*(kwadratSumy);

end

