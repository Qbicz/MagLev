function rysujPolozenieIPrzelaczenia(T, Y, alpha, czasy_przel, umin, umax)

%wykres po³o¿enia kulki
figure;
subplot(2,1,1)
plot(T,Y(1,:)*alpha*1000); %przeskalowanie po³o¿enia do [mm]
title('Odleg³oœæ œrodka sfery od cewki elektromagnesu [mm]');
grid on;

 %generowanie wektora prze³¹czeñ
 P=[];
 p=2;
 for i=1:length(T)
     if T(i)< czasy_przel(p)
         if p(mod(p,2)==0)
             P(i)= umin;
         else
             P(i)= umax;
         end
     else
         P(i)= P(i-1);
         p=p+1;
     end
 end

subplot(2,1,2);
plot(T,P);
title('Wektor prze³¹czeñ');
xlabel('Czas');
ylabel('Wartoœæ');
grid on;
