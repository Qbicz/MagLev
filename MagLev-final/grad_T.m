function [ gradientT ] = grad_T(xT, uT, psiT)
stale;

gradientT = 1 - (psiT(1) * xT(2) + psiT(2) * (-xT(3)^2 * exp(-xT(1)) + 1) + psiT(3) * (-c*xT(3) + uT));

end

