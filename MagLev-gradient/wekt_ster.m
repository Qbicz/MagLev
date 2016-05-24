%funkcja wyznaczaj¹ca wektor prze³¹czeñ
%parametry:
% lb_przel -> liczba sterowañ
% u1 -> sterowanie od którego zaczyna siê wektor = umin lub umax
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