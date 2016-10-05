%rozwi¹zywanie równañ stanu wstecz (sprawdzenie dzia³ania)

function [T_spr, Y_spr]=rozw_wtyl_spr(YT, params)

T_spr = [];     %wektor czasu do rozw. r. stanu w ty³
Y_spr = [];     %wektor wartoœci zm. stanu dla rozw. w ty³

for i = 1:params.lb_przel-1
    numer_p = params.lb_przel-i;
    if i == 1
        Y0 = YT;
    else
        Y0 = Y_spr(:,end);
    end
    m = (params.czasy_przel(numer_p+1) - params.czasy_przel(numer_p))/params.step;
    [T_i,Y_i] = rk4(@rhs,params.czasy_przel(numer_p+1),params.czasy_przel(numer_p), Y0, params.wektor_ster(numer_p), m);
    T_spr = [T_spr T_i];
    Y_spr = [Y_spr Y_i]; 
end