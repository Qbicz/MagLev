function [ output_args ] = funkcja_celu( input_args )
%FUNKCJA_CELU Summary of this function goes here
%   Detailed explanation goes here

%funkcje s³u¿¹ce do wyznaczania d³ugoœci kroku w przedzia³ach
%strukturalnych
dtau=diff(tau);
n=ceil(dtau/h0);
cn=cumsum([1,n]);

%alokacja du¿ych tablic
X=zeros(cn(end),3);
Psi=zeros(cn(end),3);

%przypisanie warunku pocz¹tkowych do pierwszych wierszów tablic
X(1,:)=x0;
u=u0;

%algorytm metody Rungego-Kutty 4 rzêdu
for j=1:(length(tau)-1)
h=dtau(j)/n(j);
h2=h/2;
h3=h/3;
h6=h/6;
U(j)=u;
    for i=cn(j):cn(j+1)-1
        dx1=rhsa(X(i,:),u);
        X1=X(i,:)+h2*dx1;
        dx2=rhsa(X1,u);
        X2=X(i,:)+h2*dx2;
        dx3=rhsa(X2,u);
        X3=X(i,:)+h*dx3;
        dx4=rhsa(X3,u);

        X(i+1,:) = X(i,:)+h3*(dx2+dx3)+h6*(dx1+dx4);
    end
    %X_tau(j,:)=X(i+1,:);
    u=vmax+vmin-u;   
end

%% do poprawy
J = X(end);

end

