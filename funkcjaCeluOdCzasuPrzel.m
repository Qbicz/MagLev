function J = funkcjaCeluOdCzasuPrzel(tau, params)
%funkcjaCeluOdCzasuPrzel - Ta funkcja przyjmuje wektor chwil prze³¹czeñ tau i na
%jego podstawie zwraca wskaznik jakosci. Struktura params agreguje
%parametry ukladu potrzebne przy optymalizacji.
%
%

%% -- Rozwiazanie rownan -- mozna zamknac w osobnej funkcji dla czytelnosci
max_przelaczen = length(tau);

% sporz¹dzenie wektora sterowañ
u=[];
for i=1:max_przelaczen-1
    if mod(i,2)==0
        u(i)=params.umax;
    else
        u(i)=params.umin;
    end
end

% rozwiazywanie równañ przy prze³¹czanym sterowaniu
Tall = [];  %wektor czasu
Yall = [];  %wszystkie wartoœci Y - [odleg³oœæ, prêdkoœæ, przyspieszenie]
Yprzel=[];  %ostatni Y w ka¿dym prze³¹czeniu
for przelaczenie = 2:max_przelaczen
    % ustawienie aktualnego warunku poczatkowego
    if przelaczenie > 2
       [yN,yM] = size(Y);
       y0 = Y(:,yM);
    end
    % iloœæ kroków
    m = (tau(przelaczenie) - tau(przelaczenie-1))/params.step;
    [T,Y] = rk4(@rhs,tau(przelaczenie-1),tau(przelaczenie), params.xOperating, u(przelaczenie-1), m);
    Tall = [Tall T];
    Yall = [Yall Y]; % TODO: preallocate
    Yprzel=[Yprzel Yall(:,end)];
end

%wykres po³o¿enia kulki
subplot(2,1,1)
hold on;
grid on
plot(Tall,Yall(:,:)*params.alpha*1000);
title('Odleg³oœæ œrodka sfery od cewki elektromagnesu [mm]');

% !!!
% Kazik to ponizej:
%

% wektor do wyplotowania prze³¹czeñ
P=[];
 p=2;
for i=1:length(Tall)
      if Tall(i)< tau(p)
          if p(mod(p,2)==0)
              P(i)= params.umin;
          else
              P(i)= params.umax;
          end
      else
          P(i)= P(i-1);
          p=p+1;
      end
 end
subplot(2,1,2)
hold on;
plot(Tall,P)
title('Funkcja prze³¹czaj¹ca')

%% Wyliczenie wartoœci funkcji celu
ro=100;
[N,M] = size(Yall);
for i=1:M
    x(:,i) = Yall(:,i) - params.xOperating;
end

x1 = x(1,:);
suma = sum(x1);
kwadratSumy = suma.^2;

J = params.Tfinish + ro*(kwadratSumy);

end

