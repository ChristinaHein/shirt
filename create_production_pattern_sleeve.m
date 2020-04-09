function pattern = create_production_pattern_sleeve(pattern, seam, hem)

%% separate basic pattern
position = find(pattern.part_names == 'sleeve');
if isempty(position)
    error('Creation of production pattern of sleeve failed: It is not possible to create a production pattern without basic pattern. Please use create_basic_pattern_sleeve first.')
end
separator = [1; find(isnan(pattern.basic_pattern(:,1)) & isnan(pattern.basic_pattern(:,2)))];
PLb = pattern.basic_pattern(separator(position):separator(position+1),:);

%% grow basic pattern with seam allowance
pgon1 = polyshape(PLb);
pgon2 = polybuffer(pgon1, seam, 'JointType','miter');
PL = pgon2.Vertices;
PL = [PL; PL(1,:)];

%% front middle: delete seam from all points lower than construction point
% sE
position_sE=find(PL(:,2) < pattern.construction_points.sE(2));
PL(position_sE,:) = PL(position_sE,:)+ [0 seam];

%% hem allowance with 'folding'
alpha = atan((pattern.construction_points.sb(1)-pattern.construction_points.sB(1))/(pattern.construction_points.sC(2)-pattern.construction_points.sB(2)));


if strcmp(pattern.property.hemtype, 'simple_cuff')
    x = hem/2*tan(alpha);
    
    PL=[PL, zeros(length(PL),1)];
    ptCloud = pointCloud(PL);
    sb = pattern.construction_points.sb-[seam 0];
    [i_sb,~] = findNearestNeighbors(ptCloud, [sb 0], 1);
    PL = ptCloud.Location(:,1:2);
    if i_sb > 1 && i_sb < length(PL)
        PL = [PL(1:i_sb-1,:); PL(i_sb,:)+[0 -hem];PL(i_sb,:)+[-x -hem/2]; PL(i_sb:end,:)];
    elseif i_sb == 1
        PL = [PL(i_sb,:)+[0 -hem]; PL(i_sb,:)+[-x -hem/2]; PL(i_sb:end-1,:);PL(i_sb,:)+[0 -hem]];
    else % i_sb == length(PL)
        PL = [PL(i_sb,:)+[0 -hem]; PL(1:i_sb-1,:);PL(i_sb,:)+[-x -hem/2]; PL(i_sb,:)];
    end

    PL=[PL, zeros(length(PL),1)];
    ptCloud = pointCloud(PL);
    sh = pattern.construction_points.sh+[seam 0];
    [i_sh,~] = findNearestNeighbors(ptCloud, [sh 0], 1);
    PL = ptCloud.Location(:,1:2);
    if i_sh > 1 && i_sh < length(PL)
        PL = [PL(1:i_sh,:); PL(i_sh,:)+[x -hem/2]; PL(i_sh,:)+[0 -hem]; PL(i_sh+1:end,:)];
    elseif i_sh == 1
        PL = [PL(i_sh,:)+[0 -hem];  PL(i_sh+1:end,:); PL(i_sh,:)+[x -hem/2]; PL(i_sh,:)+[0 -hem]];
    else % i_sh == length(PL)
        PL = [PL(1:i_sh-1,:);PL(i_sh,:)+[0 -hem]; PL(i_sh,:)+[x -hem/2]; PL(i_sh,:)];
    end 
    
else
    x = hem*tan(alpha);
    
    PL=[PL, zeros(length(PL),1)];
    ptCloud = pointCloud(PL);
    sb = pattern.construction_points.sb-[seam 0];
    [i_sb,~] = findNearestNeighbors(ptCloud, [sb 0], 1);
    PL = ptCloud.Location(:,1:2);
    if i_sb > 1 && i_sb < length(PL)
        PL = [PL(1:i_sb-1,:);PL(i_sb,:)+[-x -hem]; PL(i_sb:end,:)];
    elseif i_sb == 1
        PL = [PL(i_sb,:)+[-x -hem]; PL(i_sb:end-1,:);PL(i_sb,:)+[-x -hem]];
    else % i_sb == length(PL)
        PL = [PL(1:i_sb-1,:);PL(i_sb,:)+[-x -hem]; PL(i_sb,:)];
    end

    PL=[PL, zeros(length(PL),1)];
    ptCloud = pointCloud(PL);
    sh = pattern.construction_points.sh+[seam 0];
    [i_sh,~] = findNearestNeighbors(ptCloud, [sh 0], 1);
    PL = ptCloud.Location(:,1:2);
    if i_sh > 1 && i_sh < length(PL)
        PL = [PL(1:i_sh,:);PL(i_sh,:)+[x -hem]; PL(i_sh+1:end,:)];
    elseif i_sh == 1
        PL = [PL(i_sh,:)+[x -hem]; PL(i_sh+1:end,:); PL(i_sh,:)+[x -hem]];
    else % i_sh == length(PL)
        PL = [PL(1:i_sh-1,:);PL(i_sh,:)+[x -hem]; PL(i_sh,:)];
    end
end


    

%% Clip mark: shoulder seam
% find sC in basic pattern
PLb=[PLb, zeros(length(PLb),1)];
ptCloud = pointCloud(PLb);
[i_sC,~] = findNearestNeighbors(ptCloud, [pattern.construction_points.sC 0], 1);
PLb = ptCloud.Location(:,1:2);
% find point who meets shoulder seam
n=1;
if PLb(i_sC,2) < PLb(i_sC+1,2) %clockwise definition
    index = create_index(PLb,i_sC:i_sC+n);
    while PLCurveLength(PLb(index,:)) < pattern.construction_dimensions.fac
        n = n+1;
        index = create_index(PLb,i_sC:i_sC+n);
    end 
    temp_Pb = PLb(index(end),:);
else % anticklockwise defintion
    index = create_index(PLb,i_sC-n:i_sC);
   while PLCurveLength(PLb(index,:)) < pattern.construction_dimensions.fac
        n = n+1;
        index = create_index(PLb,i_sC-n:i_sC);
    end 
    temp_Pb = PLb(index(1),:);
end
% plot(temp_Pb(1), temp_Pb(2),'ro'); hold on;
% find closest point on production pattern
PL=[PL, zeros(length(PL),1)];
ptCloud = pointCloud(PL);
temp_P = temp_Pb +[0 seam];
[i_P,~] = findNearestNeighbors(ptCloud, [temp_P 0], 1);
PL = ptCloud.Location(:,1:2);
temp_P = PL(i_P,:);
% plot(temp_P(1), temp_P(2),'bo'); hold on;
% cut line for clip mark
n = temp_Pb-temp_P / norm(temp_Pb-temp_P);
PL = [PL(1:i_P,:); PL(i_P,:)+pattern.construction_dimensions.cm_cc*n; PL(i_P:end,:)];

%% Clip mark: 6 cm back (pattern.construction_dimensions.cm_cm)
% find sE in basic pattern
PLb=[PLb, zeros(length(PLb),1)];
ptCloud = pointCloud(PLb);
[i_sE,~] = findNearestNeighbors(ptCloud, [pattern.construction_points.sE 0], 1);
PLb = ptCloud.Location(:,1:2);
% find point who meets shoulder seam
n=1;
if PLb(i_sE,2) < PLb(i_sE+2,2) %clockwise definition
    while PLCurveLength(PLb(index,:)) < pattern.construction_dimensions.cm_cm
        n = n+1;
        index = create_index(PLb,i_sE:i_sE+n);
    end 
    temp_Pb = PLb(index(end),:);
else % anticklockwise defintion
   index = create_index(PLb,i_sE-n:i_sE);
   while PLCurveLength(PLb(index,:)) < pattern.construction_dimensions.cm_cm
        n = n+1;
        index = create_index(PLb,i_sE-n:i_sE);
   end 
    temp_Pb = PLb(index(1),:);
end
% plot(temp_Pb(1), temp_Pb(2),'ro'); hold on;
% find closest point on production pattern
PL=[PL, zeros(length(PL),1)];
ptCloud = pointCloud(PL);
%temp_P = temp_Pb +[0 seam];
[i_P,~] = findNearestNeighbors(ptCloud, [temp_Pb 0], 1);
PL = ptCloud.Location(:,1:2);
temp_P = PL(i_P,:);
% plot(temp_P(1), temp_P(2),'bo'); hold on;
% cut line for clip mark
n = temp_Pb-temp_P / norm(temp_Pb-temp_P);
PL = [PL(1:i_P,:); PL(i_P,:)+pattern.construction_dimensions.cm_cc*n; PL(i_P:end,:)];
    
%% write PL into pattern.production_pattern
pattern.production_pattern = [pattern.production_pattern; PL(:,1) PL(:,2); NaN NaN];

