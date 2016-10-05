function [J, dQ] = funkcja_celu_z_gradientem(x0,u0,h0,tau,vmin,vmax,ro,nom_pkt)
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
u=u0;

%% Rozwiazanie rownan i obliczenie wskaznika jakosci
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

% obliczenie wartosci funkcji celu
ro_f_celu = 100;
Tfinish = tau(end);
norma = (X(end,1) - nom_pkt(1))^2 + 1*(X(end,2) - nom_pkt(2))^2 + (X(end,3) - nom_pkt(3))^2;
J = Tfinish + ro_f_celu/2 * norma;

%% Rozw wstecz na potrzeby gradientu
%Zdefiniowanie warunku koñcowego dla równañ sprzê¿onych
Psi_T=zeros(1,3);
Psi_T=-ro*(X(end,:)-nom_pkt);

%przypisanie warunku pocz¹tkowych i koñcowych do odpowiednich tablic
Psi(end,:)=Psi_T;

%algorytm metody Rungego-Kutty od ty³u
for j=(length(dtau)):-1:1                 %%BY£O ...LENGTH(TAU)... - czyli o jedena iteracje wiecej
    h=dtau(j)/n(j);
    h2=h/2;h3=h/3;h6=h/6;
    for i=cn(j+1):-1:cn(j)+1
        z=[X(i,:) Psi(i,:)];
        k1=rhsa_sprz(z,U(j));
        z1=z-h2*k1;
        k2=rhsa_sprz(z1,U(j));
        z2=z-h2*k2;
        k3=rhsa_sprz(z2,U(j));
        z3=z-h*k3;
        k4=rhsa_sprz(z3,U(j));
        
        z=z-h3*(k2+k3)-h6*(k1+k4);
        Psi(i-1,:)=z(4:end);
    end
end

%% Gradient - na podstawie wzoru psi*costam
H1=Psi(:,3);
qQ = zeros(2,1);
% gradienty po tau (2 elem)
for i=1:length(tau)-2
   dQ(i)=H1(cn(i+1))*(U(i+1)-U(i));
end
    dQ=dQ';
    % gradient po czasie koncowym
    gradientT = gradT(X(end,:), U(end), Psi(end, :)); % 1 elem    %%B£¥D W gradT (by³ liczony H(T) a nie 1-H(T)
    
    dQ = [dQ; gradientT];

end % function

