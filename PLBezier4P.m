function PL = PLBezier4P(P1, P2, P3, P4, n)


PLx= zeros(n,1);
PLy=zeros(n,1);
t=1;

for i=0:1/n:1
    PLx(t) = P1(1)*(1-i)^3 + 3*P2(1)*(1-i)^2*i + 3*P3(1)*(1-i)*i^2 + P4(1)*i^3;
    PLy(t) = P1(2)*(1-i)^3 + 3*P2(2)*(1-i)^2*i + 3*P3(2)*(1-i)*i^2 + P4(2)*i^3;
    t= t+1;
end

PL = [PLx, PLy];