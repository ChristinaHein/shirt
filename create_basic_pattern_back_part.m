function pattern = create_basic_pattern_back_part(human, pattern)
%% create_basic_pattern_back_part(human, pattern) - creates the basic pattern of the back part of a shirt
% (created by Christina M. Hein, 2019-April-24)
% (last changes by Christina M. Hein, 2019-August-02)
%
% This function creates a PL for the basic pattern of the back part of a
% shirt which is designed using the measurement data of the struct human.
% The PL is then added to the struct pattern into the field basic pattern.
% This function is intended to be used inside the function
% create_pattern_shirt.
%
% pattern = create_basic_pattern_back_part(human, pattern)
%
% === INPUT ARGUMENTS ===
% human             = struct of type human (name, type, body dimensions)
% pattern           = struct for pattern, yet filled with construction
%                     points and optionally with other part's basic pattern
%                     created by create_pattern_shirt
%
% === OUTPUT ARGUMENTS ===
% pattern     = struct containing PL of construction points, CPLs of basic 
%               pattern and production pattern, part names, material and
%               label information.
%
% see create_human_from_measurement, create_human_from_size,
% create_pattern_shirt

%% write part name
pattern.part_names = [pattern.part_names, "back_part"];

%% neckline
if pattern.construction_dimensions.neckline == 0 % round neckline 
    PL = pattern.construction_points.B;
    PL = [PL; pattern.construction_points.b1];
    PL = [PL; pattern.construction_points.b1+[pattern.construction_dimensions.cm_nb 0]];   
else % v neckline
    P1 = pattern.construction_points.b1+[pattern.construction_dimensions.cm_nb 0];
    P2 = pattern.construction_points.b2+[-pattern.construction_dimensions.cm_sb 0];
    P1P2 = P2-P1;
    NS = P1+pattern.construction_dimensions.neckline(2)*P1P2/norm(P1P2); % Point neckline-shoulder
    PL = pattern.construction_points.B;
    PL = [PL; pattern.construction_points.b1; NS];
end
PL = PLBezier3P(PL(1,:),PL(2,:),PL(3,:),30);
pattern.basic_pattern = [pattern.basic_pattern; PL];
%parameters for cuffs neckline
pattern.construction_points.necklength_back = PLCurveLength(PL);
%% shoulder line
pattern.basic_pattern = [pattern.basic_pattern; pattern.construction_points.b2+[-pattern.construction_dimensions.cm_sb 0]];
%% armhole
PL= [pattern.construction_points.y2];
temp=abs(pattern.construction_points.b2(2)-pattern.construction_points.y2(2))*(abs(pattern.construction_points.x1(1))+pattern.construction_dimensions.cm_sb)/pattern.construction_points.y1(1);
PL = [PL; pattern.construction_points.x1(1), pattern.construction_points.b2(2)-temp]; 
PL = [PL; pattern.construction_points.x2];
PL = PLBezier3P(PL(1,:),PL(2,:),PL(3,:),30);
pattern.construction_dimensions.bac = PLCurveLength([pattern.construction_points.b2+[-pattern.construction_dimensions.cm_sb 0]; PL]); % back armhole circumference
pattern.basic_pattern = [pattern.basic_pattern; PL(:,1:2)];
%% side seam
if strcmp(human.type,'male') && pattern.construction_dimensions.fit_allowance > 0 %non-waisted basic cut for men with regular of wide fit
    PL = [pattern.construction_points.x2];
    PL = [PL; pattern.construction_points.C1];
    PL = [PL; pattern.construction_points.E(1),min(pattern.construction_points.e1(2),pattern.construction_points.E1(2))];
else % waisted basic cut for women and slim fit for men    
    PL = [pattern.construction_points.x2];
    PL = [PL; pattern.construction_points.C+[0 -(human.waist_circumference*(1+pattern.construction_dimensions.fit_allowance))/4]];
    PL = [PL; pattern.construction_points.e1+[6,0]];
    PL = [PL; pattern.construction_points.e1];
    PL = PLaddauxpoints(PL,human.seat_length*0.1);
    PL = VLBezierC(PL);
end
pattern.basic_pattern = [pattern.basic_pattern; PL(:,1:2)];
%% hem
pattern.basic_pattern = [pattern.basic_pattern; pattern.construction_points.E];
pattern.basic_pattern = [pattern.basic_pattern; pattern.construction_points.B];
pattern.basic_pattern = [pattern.basic_pattern; NaN NaN];

end
