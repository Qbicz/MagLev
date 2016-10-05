% funkcja rozwi�zum�ca r�wnania sprz�one w ty�

function [T_sprz, Psi]=rozw_wtyl(psiT, Yprzel, params)

T_sprz=[];  %wektor czasu dla rozwi�zywania wstecz
Psi=[];     %warto�ci psi z r. sprz�onych

for i = 1:params.lb_przel-1
    numer_p = params.lb_przel-i;
    x0 = Yprzel(:,numer_p) ;   
    if i == 1
          psi0=psiT;
    else
          psi0=Psi(:,end);
    end
    m = (params.czasy_przel(numer_p+1) - params.czasy_przel(numer_p))/params.step;
    [T_i,Psi_i] = rk4(@rhs_sprz,params.czasy_przel(numer_p+1),params.czasy_przel(numer_p),psi0, x0, m);
    T_sprz = [T_sprz T_i];
    Psi = [Psi Psi_i]; 
end