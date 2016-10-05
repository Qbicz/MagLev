function [X,t] = rk4(X0,u,tau,h0)

%funkcje s³u¿¹ce do wyznaczania d³ugoœci kroku w przedzia³ach
%strukturalnych
tau=[0 tau];
dtau=diff(tau);
n=ceil(dtau/h0);
cn=cumsum([1,n]);

%alokacja du¿ych tablic
X=zeros(cn(end),3);
t=zeros(cn(end),1);

%przypisanie warunku pocz¹tkowych do pierwszych wierszów tablic
X(1,:)=X0;
t(1)=0;

%algorytm metody Rungego-Kutty 4 rzêdu
for j=1:length(u)
h=dtau(j)/n(j);
h2=h/2;
h3=h/3;
h6=h/6;
    for i=cn(j):cn(j+1)-1
        dx1=rhs(X(i,:),u(j));
        X1=X(i,:)+h2*dx1;
        dx2=rhs(X1,u(j));
        X2=X(i,:)+h2*dx2;
        dx3=rhs(X2,u(j));
        X3=X(i,:)+h*dx3;
        dx4=rhs(X3,u(j));

        X(i+1,:) = X(i,:)+h3*(dx2+dx3)+h6*(dx1+dx4);
        t(i+1)= t(i) + h;
    end
end
end