function P = create_P_between_P1P2_with_d(P1, P2, d, p)

%% create_P_between_P1P2_with_d(P1, P2, d, [p]) - creates struct human from measurement data
% (created by Christina M. Hein, 2019-April-26)
% (last changes by Christina M. Hein, 2019-June-07)
%
% This function creates a point between two points with the distance d
% rectancular to the connection line. 
%
% P = create_P_between_P1P2_with_d(P1, P2, d, p)
%
% === INPUT ARGUMENTS ===
% P1        = Point 1 [x y]
% P2        = Point 2 [x y]
% d         = distance of new point to line P1P2
% p         = partition: division factor, 0.5 is in the middle between
%             the two points
%
% === OUTPUT ARGUMENTS ===
% P         = point [x y]
%

if nargin == 3 % set default value for p
    p = 0.5;
end

P1P2 = P2-P1;
H = P1+p*P1P2;
n = [-P1P2(2) P1P2(1)]/norm(P1P2);
P = H + d*n;

