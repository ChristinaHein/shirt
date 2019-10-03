function index = create_index(PL,index)

%% create_index(PL,index) - creates the index counting in the round of a PL
% (created by Christina M. Hein, 2019-June-28)
% (last changes ...)
%
% sets every index into the length of PL, if an index reaches the end of
% PL, it starts at the beginning 
%
% index = create_index(PL,index)
%
% === INPUT ARGUMENTS ===
% PL        = point list
% index     = index to a point in the point list or a list of indexes (>
%             length(PL) allowed)
%
% === OUTPUT ARGUMENTS ===
% index     = index to the point list which is between 1 and length(PL)
%
% EXAMPEL:
% PL = linspace(1,12,12);
% index = 13;
% index = create_index(PL,index) %index = 1

index = length(PL) - mod(length(PL)-index, length(PL));

end