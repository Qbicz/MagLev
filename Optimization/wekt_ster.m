%funkcja wyznaczaj�ca wektor prze��cze�
%parametry:
% lb_przel -> liczba sterowa�
% u1 -> sterowanie od kt�rego zaczyna si� wektor = umin lub umax
% u2 -> drugie graniczne sterowanie odpowiednio = umax lub umin


function [u]=wekt_ster(lb_przel, u1, u2)
u=[];
for i=1:lb_przel-1
    if mod(i,2)==0
        u(i)=u1;
    else
        u(i)=u2;
    end
end