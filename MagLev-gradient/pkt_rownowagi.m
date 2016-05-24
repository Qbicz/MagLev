function [xr]=pkt_rownowagi(polozenie)
stale;
polozenie=polozenie/1000;
v=sqrt(-g*c^2/exp(polozenie*a)/b);
xr(1)=polozenie;
xr(2)=0;
xr(3)=-v/c;
end