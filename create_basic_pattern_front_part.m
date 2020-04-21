function pattern = create_basic_pattern_front_part(human,pattern)
%% create_basic_pattern_front_part(human, pattern) - creates the basic pattern of the front part of a shirt
% (created by Christina M. Hein, 2019-April-24)
% (last changes by Christina M. Hein, 2019-August-02)
%
% This function creates a PL for the basic pattern of the front part of a
% shirt which is designed using the measurement data of the struct human.
% The PL is then added to the struct pattern into the field basic pattern.
% This function is intended to be used inside the function
% create_pattern_shirt.
%
% pattern = create_basic_pattern_front_part(human, pattern)
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
pattern.part_names = [pattern.part_names, "front_part"];

%% neckline
if pattern.construction_dimensions.neckline == 0 % round neckline 
    pattern.construction_points.neck = pattern.construction_points.a4;
    PL = pattern.construction_points.neck;    
    PL = [PL; pattern.construction_points.a4(1) pattern.construction_points.a2(2)];
    PL = [PL; pattern.construction_points.a2+[pattern.construction_dimensions.cm_nf 0]];
    PL = PLBezier3P(PL(1,:),PL(2,:),PL(3,:),30);
    pattern.basic_pattern = [pattern.basic_pattern; pattern.construction_points.F; PL];
    %parameters for cuffs neckline
    pattern.construction_dimensions.necklength_front = PLCurveLength(PL);
else % v neckline
    pattern.construction_points.neck = pattern.construction_points.a4+[-pattern.construction_dimensions.neckline(1) 0];
    PL = pattern.construction_points.neck;
    P1 = pattern.construction_points.a2+[pattern.construction_dimensions.cm_nf 0];
    P2 = pattern.construction_points.a3+[-pattern.construction_dimensions.cm_sf 0];
    P1P2 = P2-P1;
    NS = P1+pattern.construction_dimensions.neckline(2)*P1P2/norm(P1P2); % Point neckline-shoulder
    H = create_P_between_P1P2_with_d(PL(1,:),NS,pattern.construction_dimensions.neckline(3)); % help point for rounded curve
    PL = PLBezier3P(PL, H, NS,10);
    pattern.basic_pattern = [pattern.basic_pattern; pattern.construction_points.F; PL(:,1:2)];
    %parameters for cuffs neckline
    pattern.construction_points.necklength_front = PLCurveLength(PL);
    a = PL(3,:)-pattern.construction_points.neck;
    b = [-1 0];
    pattern.construction_points.alpha_neck = acosd((a(2)*b(1)+a(1)*b(2))/(norm(a)*norm(b)));
end
%% shoulder line
pattern.basic_pattern = [pattern.basic_pattern; pattern.construction_points.a3+[-pattern.construction_dimensions.cm_sf 0]];
%% armhole
PLa = [pattern.construction_points.y3];
temp1=abs(pattern.construction_points.a3(2)-pattern.construction_points.y3(2))*(abs(pattern.construction_points.x1(1))+pattern.construction_dimensions.cm_sf)/pattern.construction_points.y1(1);
PLa = [PLa; pattern.construction_points.x1(1), pattern.construction_points.a3(2)+temp1]; 
PLa = [PLa; pattern.construction_points.x3];
PLa = PLBezier3P(PLa(1,:),PLa(2,:),PLa(3,:),30);
pattern.construction_dimensions.fac = PLCurveLength([pattern.construction_points.a3+[-pattern.construction_dimensions.cm_sf 0]; PLa]); % front armhole circumference
%pattern.basic_pattern = [pattern.basic_pattern; PLa];
%% side seam 
if strcmp(human.type,'male') && pattern.construction_dimensions.fit_allowance > 0 %non-waisted basic cut for men with regular of wide fit
    PL = [PLa; pattern.construction_points.x3];
    PL = [PL; pattern.construction_points.D1];
    PL = [PL; pattern.construction_points.F(1),max(pattern.construction_points.f1(2),pattern.construction_points.F1(2))];
else % waisted basic cut for women and slim fit for men
    PL = [pattern.construction_points.x3];
    PL = [PL; pattern.construction_points.D+[0 (human.waist_circumference*(1+pattern.construction_dimensions.fit_allowance))/4]];
    PL = [PL; pattern.construction_points.f1+[6,0]];
    PL = [PL; pattern.construction_points.f1];
    PL = PLaddauxpoints(PL,human.seat_length*0.1);
    PL = VLBezierC(PL);
    PL = PL(:,1:2);

    % include side dart in side seam
    if human.chest_circumference-human.waist_circumference > 15 && strcmp(human.type,'female')% condition for side dart
        % chest point
        pattern.construction_points.chest_point = [pattern.construction_points.z(1) human.chest_circumference/12];
        %plot (pattern.construction_points.chest_point(1),pattern.construction_points.chest_point(2),'bo'); hold on;

        % left point of dart in side seam
        PL=[PL, zeros(length(PL),1)];
        ptCloud = pointCloud(PL);
        [i_z3,~] = findNearestNeighbors(ptCloud, [pattern.construction_points.z3 0], 1);
        PL = ptCloud.Location(:,1:2);
        n=1;
        index = create_index(PL,i_z3:i_z3+n);
        while PLCurveLength(PL(index,:)) < 0.03*human.chest_circumference/2
            n = n+1;
            index = create_index(PL,i_z3:i_z3+n);
        end 
        temp1 = PL(index(end),:);
        pattern.construction_points.dart_left = temp1;
        %plot (temp1(1),temp1(2),'ro'); hold on;
        % right point of dart in side seam
        temp2 = pattern.construction_points.z3 + [0.03*human.chest_circumference/2 0];
        %plot (temp2(1),temp2(2),'ro'); hold on;
        % angle of dart
        temp3 = pattern.construction_points.chest_point-temp1;
        temp4 = pattern.construction_points.chest_point-temp2;
        alpha = -acos(dot(temp3,temp4)/(norm(temp3)*norm(temp4)));
        % rotate constructions points right to dart into armhole
        index = create_index(PL,1:i_z3+n);
        %plot(PL(index,1), PL(index,2), 'r.-');
        tempPL = PL(index,:)-pattern.construction_points.chest_point; %move, so that origin in center of rotation
        %plot(tempPL(index,1), tempPL(index,2), 'r*');
        R = [cos(alpha) -sin(alpha); sin(alpha) cos(alpha)]; %rotate
        tempPL = R*tempPL'; tempPL=tempPL';
        %plot(tempPL(index,1), tempPL(index,2), 'b*');
        tempPL = tempPL+pattern.construction_points.chest_point; %move back
        %plot(tempPL(index,1), tempPL(index,2), 'b.-');
        pattern.construction_points.dart_right = tempPL(end,:); % for production pattern
        %plot(pattern.construction_points.dart_left(1),pattern.construction_points.dart_left(2),'bo'); hold on;
        % redo armhole
        pattern.construction_points.y3 =pattern.construction_points.y3-pattern.construction_dimensions.cm_am/2;
        PLa = [pattern.construction_points.y3];
        % plot(tempPL(1,1),tempPL(1,2),'og')
        temp1=abs(pattern.construction_points.a3(2)-pattern.construction_points.y3(2))*(abs(tempPL(1,1))+pattern.construction_dimensions.cm_sf)/pattern.construction_points.y1(1);
        PLa = [PLa; pattern.construction_points.x1(1), pattern.construction_points.a3(2)+temp1]; 
        PLa = [PLa; tempPL(1,:)];
        PLa = PLBezier3P(PLa(1,:),PLa(2,:),PLa(3,:),30);
        pattern.construction_dimensions.fac = PLCurveLength([pattern.construction_points.a3+[-pattern.construction_dimensions.cm_sf 0]; PLa]); % front armhole circumference
        % write PL
        PL = [PLa; tempPL; pattern.construction_points.chest_point; PL(i_z3+n:end,:)];
    else
         PL = [PLa; PL];
    end
end
pattern.basic_pattern = [pattern.basic_pattern; PL(:,1:2)];

%% hem
pattern.basic_pattern = [pattern.basic_pattern; pattern.construction_points.F];
pattern.basic_pattern = [pattern.basic_pattern; NaN NaN];

end