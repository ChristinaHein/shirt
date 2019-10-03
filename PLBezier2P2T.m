function PL = PLBezier2P2T(P1, P2, t1, t2, n)

% P1 starting point
% P2 endpoint
%t1, t2 tanget vectors at P1 and P2

% calculate inner Bezier points
H1 = P1+1/3*t1;
H2 = P2+1/3*t2;

% calculate Bezier curve
PL = PLBezier4P(P1, H1, H2, P2, n);
% 
% plot(H1(1), H1(2),'*k');
% hold on;
% plot(H2(1), H2(2),'*b');
% hold on;