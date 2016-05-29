function [ gradientT ] = gradT(xT, uT, psiT)
%GRADT Summary of this function goes here
%   Detailed explanation goes here

stale;

% wzor 9.23 z "Sterowanie docelowe ukladami nieliniowymi", A.Turnau
gradientT = 1 - psiT(1) * xT(2) + psiT(2) * (b*xT(3)^2 * exp(a*xT(1)) + g) + psiT(3) * (c*xT(3) + uT);


end

