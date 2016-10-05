% funkcja rozwiazuj�ca r�wnania dla zadanych prze��cze�

function [T, Y, Yprzel]= rozw_rown(params)
% deklaracja
T = [];  %wektor czasu w kt�rym nast�puj� prze��czenia
Y = [];  %wszystkie warto�ci wyj�cia - [po�o�enie, pr�dko��, przyspieszenie]
Yprzel=[];  %ostatni Y w ka�dym prze��czeniu

lb_przel = length(params.czasy_przel); %ilo�� prze��cze�

for nr_przel = 2:lb_przel
    if nr_przel == 2 % ustawienie aktualnego warunku poczatkowego
       y0 = params.xOperating;
    else 
       y0 = Y(:,length(Y));
    end
    m = (params.czasy_przel(nr_przel) - params.czasy_przel(nr_przel-1))/params.step; % ilo�� krok�w
    [Ti,Yi] = rk4(@rhs,params.czasy_przel(nr_przel-1),params.czasy_przel(nr_przel),y0, params.wektor_ster(nr_przel-1), floor(m));
    T = [T Ti];
    Y = [Y Yi];
    Yprzel=[Yprzel Y(:,end)]; 
end