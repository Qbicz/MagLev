function [Psi] = rk4_inv(X,u,tau,h0,nom_pkt,ro)

%funkcje s³u¿¹ce do wyznaczania d³ugoœci kroku w przedzia³ach
%strukturalnych
tau=[0 tau];
dtau=diff(tau);
n=ceil(dtau/h0);
cn=cumsum([1,n]);

%alokacja du¿ych tablic
Psi=zeros(cn(end),3);

Psi_T=-ro*(X(end,:)-nom_pkt);

%przypisanie warunku pocz¹tkowych i koñcowych do odpowiednich tablic
Psi(end,:)=Psi_T;

%algorytm metody Rungego-Kutty od ty³u
for j=length(dtau):-1:1
    h=dtau(j)/n(j);
    h2=h/2;h3=h/3;h6=h/6;
    for i=cn(j+1):-1:cn(j)+1
        z=[X(i,:) Psi(i,:)];
        k1=rhs_inv(z,u(j));
        z1=z-h2*k1;
        k2=rhs_inv(z1,u(j));
        z2=z-h2*k2;
        k3=rhs_inv(z2,u(j));
        z3=z-h*k3;
        k4=rhs_inv(z3,u(j));
        
        z=z-h3*(k2+k3)-h6*(k1+k4);
        Psi(i-1,:)=z(4:end);
    end
end

end