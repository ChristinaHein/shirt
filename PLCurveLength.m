function l = PLCurveLength(PL)

l=0;

if length(PL)==1
    l = 0;
else
    for i=1:length(PL)-1
        l= l+sqrt((PL(i,1)-PL(i+1,1))^2+(PL(i,2)-PL(i+1,2))^2);
    end
end