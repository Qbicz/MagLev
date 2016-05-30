function [ gradientT ] = gradT_gk(xT, uT, psiT)
%GRADT Summary of this function goes here
%   Detailed explanation goes here

stale_gk;

gradientT = 1 - (psiT(1) * xT(2) + psiT(2) * (-xT(3)^2 * exp(-xT(1)) + 1) + psiT(3) * (-c*xT(3) + uT));


end

