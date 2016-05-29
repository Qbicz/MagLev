function [ gradientT ] = gradT(xT, uT, psiT)
%GRADT Summary of this function goes here
%   Detailed explanation goes here

stale;

gradientT = 1 - psiT(1) * xT(2) + psiT(2) * (b*xT(3)^2 * exp(a*xT(1)) + g) + psiT(3) * (c*xT(3) + uT);


end

