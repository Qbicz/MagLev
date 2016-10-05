function [X,t] = rk4_gk(X0,u,tau,h0)

%funkcje s�u��ce do wyznaczania d�ugo�ci kroku w przedzia�ach
%strukturalnych
tau=[0 tau];
dtau=diff(tau);
n=ceil(dtau/h0);
cn=cumsum([1,n]);

%alokacja du�ych tablic
X=zeros(cn(end),3);
t=zeros(cn(end),1);

%przypisanie warunku pocz�tkowych do pierwszych wiersz�w tablic
X(1,:)=X0;
t(1)=0;

%algorytm metody Rungego-Kutty 4 rz�du
for j=1:length(u)
h=dtau(j)/n(j);
h2=h/2;
h3=h/3;
h6=h/6;
    for i=cn(j):cn(j+1)-1
        dx1=rhs_gk(X(i,:),u(j));
        X1=X(i,:)+h2*dx1;
        dx2=rhs_gk(X1,u(j));
        X2=X(i,:)+h2*dx2;
        dx3=rhs_gk(X2,u(j));
        X3=X(i,:)+h*dx3;
        dx4=rhs_gk(X3,u(j));

        X(i+1,:) = X(i,:)+h3*(dx2+dx3)+h6*(dx1+dx4);
        t(i+1)= t(i) + h;
    end
end
end