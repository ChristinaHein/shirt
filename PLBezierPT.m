function PL = PLBezierPT(PLin, TL, n)

% check input
if length(PLin) ~= length(TL)
    error('Number of Points and Tangets have to be the same (PLin and TL have to be the same length).')
end

% write PL
PL=[];
for i = 1:length(PLin)-1
    PL = [PL; PLBezier2P2T(PLin(i,:), PLin(i+1,:), TL(i,:), -TL(i+1,:), n)];
end