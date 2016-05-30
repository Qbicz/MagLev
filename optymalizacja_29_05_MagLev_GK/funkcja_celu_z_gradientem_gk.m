function [J, dQ] = funkcja_celu_z_gradientem_gk(x0,h0,tau,ro,nom_pkt,u)
%funkcjaCeluOdCzasuPrzel - Ta funkcja przyjmuje wektor chwil prze³¹czeñ tau i na
%jego podstawie zwraca wskaznik jakosci i jego gradient. Wynik to
%zagregowany wskaznik jakosci i gradient, tak jak wymaga tego fmincon().
%
% Uzycie fmincon z gradientem funkcji celu:
% http://www.mathworks.com/help/optim/ug/fmincon.html#busxd7j-1

%funkcje s³u¿¹ce do wyznaczania d³ugoœci kroku w przedzia³ach
%strukturalnych
tau=[0 tau];
dtau=diff(tau);
n=ceil(dtau/h0);
cn=cumsum([1,n]);

%alokacja du¿ych tablic
X=zeros(cn(end),3);
Psi=zeros(cn(end),3);

%przypisanie warunku pocz¹tkowych do pierwszych wierszów tablic
X(1,:)=x0;

%% Rozwiazanie rownan i obliczenie wskaznika jakosci
%algorytm metody Rungego-Kutty 4 rzêdu
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
    end
end

% obliczenie wartosci funkcji celu
ro_f_celu = 1000;
Tfinish = tau(end);
J = Tfinish + ro_f_celu/2 * (10*((X(end,1) - nom_pkt(1))^2)+5*((X(end,2) - nom_pkt(2))^2)+((X(end,3) - nom_pkt(3))^2));

%% Rozw wstecz na potrzeby gradientu
%Zdefiniowanie warunku koñcowego dla równañ sprzê¿onych
Psi_T=-ro*(X(end,:)-nom_pkt);

%przypisanie warunku pocz¹tkowych i koñcowych do odpowiednich tablic
Psi(end,:)=Psi_T;

%algorytm metody Rungego-Kutty od ty³u
for j=length(dtau):-1:1
    h=dtau(j)/n(j);
    h2=h/2;h3=h/3;h6=h/6;
    for i=cn(j+1):-1:cn(j)+1
        z=[X(i,:) Psi(i,:)];
        k1=rhs_sprz_gk(z,u(j));
        z1=z-h2*k1;
        k2=rhs_sprz_gk(z1,u(j));
        z2=z-h2*k2;
        k3=rhs_sprz_gk(z2,u(j));
        z3=z-h*k3;
        k4=rhs_sprz_gk(z3,u(j));
        
        z=z-h3*(k2+k3)-h6*(k1+k4);
        Psi(i-1,:)=z(4:end);
    end
end

%% Gradient - na podstawie wzoru psi*costam
Fi=Psi(:,3);
dQ = zeros(2,1);
% gradienty po tau (2 elem)
for i=1:length(tau)-2
   dQ(i)=Fi(cn(i+1))*(u(i+1)-u(i));
end
%     dQ=dQ';
    % gradient po czasie koncowym
    gradientT = gradT_gk(X(end,:), u(end), Psi(end, :)); % 1 elem    %%B£¥D W gradT (by³ liczony H(T) a nie 1-H(T)
    
    dQ = [dQ; gradientT];

end % function

