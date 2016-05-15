% funkcja rozwiazuj¹ca równania dla zadanych prze³¹czeñ

function [T, Y, Yprzel]= rozw_rown(params)
% deklaracja
T = [];  %wektor czasu w którym nastêpuj¹ prze³¹czenia
Y = [];  %wszystkie wartoœci wyjœcia - [po³o¿enie, prêdkoœæ, przyspieszenie]
Yprzel=[];  %ostatni Y w ka¿dym prze³¹czeniu

lb_przel = length(params.czasy_przel); %iloœæ prze³¹czeñ

for nr_przel = 2:lb_przel
    if nr_przel == 2 % ustawienie aktualnego warunku poczatkowego
       y0 = params.xOperating;
    else 
       y0 = Y(:,length(Y));
    end
    m = (params.czasy_przel(nr_przel) - params.czasy_przel(nr_przel-1))/params.step; % iloœæ kroków
    [Ti,Yi] = rk4(@rhs,params.czasy_przel(nr_przel-1),params.czasy_przel(nr_przel),y0, params.wektor_ster(nr_przel-1), floor(m));
    T = [T Ti];
    Y = [Y Yi];
    Yprzel=[Yprzel Y(:,end)]; 
end