function [X,t,u_wyj] = rk4a(X0,u,tau,h0)

%funkcje s³u¿¹ce do wyznaczania d³ugoœci kroku w przedzia³ach
%strukturalnych
dtau=diff(tau);
n=ceil(dtau/h0);
cn=cumsum([1,n]);

%alokacja du¿ych tablic
X=zeros(cn(end),3);
t=zeros(cn(end),1);
u_wyj=zeros(cn(end),1);

%przypisanie warunku pocz¹tkowych do pierwszych wierszów tablic
X(1,:)=X0;
t(1)=0;
u_wyj(1)=u(1);

%algorytm metody Rungego-Kutty 4 rzêdu
for j=1:length(u)
h=dtau(j)/n(j);
h2=h/2;
h3=h/3;
h6=h/6;
    for i=cn(j):cn(j+1)-1
        dx1=rhsa(X(i,:),u(j));
        X1=X(i,:)+h2*dx1;
        dx2=rhsa(X1,u(j));
        X2=X(i,:)+h2*dx2;
        dx3=rhsa(X2,u(j));
        X3=X(i,:)+h*dx3;
        dx4=rhsa(X3,u(j));

        X(i+1,:) = X(i,:)+h3*(dx2+dx3)+h6*(dx1+dx4);
        t(i+1)= t(i) + h;
        u_wyj(i+1)=u(j);
    end
end
end