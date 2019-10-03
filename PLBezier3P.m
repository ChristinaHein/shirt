function PL = PLBezier3P(P1, P2, P3, n)


PLx= zeros(n,1);
PLy=zeros(n,1);
t=1;

for i=0:1/n:1
    PLx(t) = (1-i)^2*P1(1)+2*(1-i)*i*P2(1)+i^2*P3(1);
    PLy(t) = (1-i)^2*P1(2)+2*(1-i)*i*P2(2)+i^2*P3(2);
    t= t+1;
end

PL = [PLx, PLy];