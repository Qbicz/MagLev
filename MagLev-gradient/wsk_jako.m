function [J]=wsk_jako(Tk, ro, nom_pkt, xk)
J=Tk+0.5*ro*sum((xk-nom_pkt).^2);
end