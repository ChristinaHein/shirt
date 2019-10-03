function pattern = create_production_pattern_back_part(pattern, seam, hem)

%% separate basic pattern
position = find(pattern.part_names == 'back_part');
if isempty(position)
    error('Creation of production pattern of back part failed: It is not possible to create a production pattern without basic pattern. Please use create_basic_pattern_back_part first.')
end
separator = [1; find(isnan(pattern.basic_pattern(:,1)) & isnan(pattern.basic_pattern(:,2)))];
CPLb = pattern.basic_pattern(separator(position):separator(position+1),:);

%% grow basic pattern with seam allowance
pgon1 = polyshape(CPLb);
pgon2 = polybuffer(pgon1, seam, 'JointType','miter');
CPL = pgon2.Vertices;
CPL = [CPL; CPL(1,:)];

%% front middle: delete seam from all points over construction point A
f=find(CPL(:,2) > pattern.construction_points.B(2));
CPL(f,:) = CPL(f,:)+ [0 -seam];
%% hem: add delta between hem and seam to all points left of construction
% point F
f=find(CPL(:,1) < pattern.construction_points.F(1));
CPL(f,:) = CPL(f,:)- [hem-seam 0];
%% for laser cutting: delete front middle line
E = pattern.construction_points.E+[-hem 0];
B = pattern.construction_points.B+[seam 0];
CPL=[CPL, zeros(length(CPL),1)];
ptCloud = pointCloud(CPL);
[i_E,~] = findNearestNeighbors(ptCloud, [E 0], 1); %index to nearest point to F, distance to F
[i_B,~] = findNearestNeighbors(ptCloud, [B 0], 1);

CPL = ptCloud.Location(:,1:2);
CPL = [CPL(i_B:end,:); CPL(1:i_E,:)];

%% Clip mark: 6 cm back (pattern.construction_dimensions.cm_cm)
% find x2 in basic pattern
CPLb=[CPLb, zeros(length(CPLb),1)];
ptCloud = pointCloud(CPLb);
[i_x2,~] = findNearestNeighbors(ptCloud, [pattern.construction_points.x2 0], 1);
CPLb = ptCloud.Location(:,1:2);
% find point who meets shoulder seam
n=1;
if CPLb(i_x2,2) > CPLb(i_x2+2,2) %clockwise definition
    index = create_index(CPLb,i_x2:i_x2+n);
    while PLCurveLength(CPLb(index,:)) < pattern.construction_dimensions.cm_cm
        n = n+1;
        index = create_index(CPLb,i_x2:i_x2+n);
    end 
    temp_Pb = CPLb(index(end),:);
else % anticklockwise defintion
    
    index = create_index(CPLb,i_x2-n:i_x2);
   while PLCurveLength(CPLb(index,:)) < pattern.construction_dimensions.cm_cm
        n = n+1;
        index = create_index(CPLb,i_x2-n:i_x2);
   end 
    temp_Pb = CPLb(index(1),:);
end
%plot(temp_Pb(1), temp_Pb(2),'ro'); hold on;
% find closest point on production pattern
CPL=[CPL, zeros(length(CPL),1)];
ptCloud = pointCloud(CPL);
[i_P,~] = findNearestNeighbors(ptCloud, [temp_Pb 0], 1);
CPL = ptCloud.Location(:,1:2);
temp_P = CPL(i_P,:);
%plot(temp_P(1), temp_P(2),'bo'); hold on;
% cut line for clip mark
n = temp_Pb-temp_P / norm(temp_Pb-temp_P);
CPL = [CPL(1:i_P,:); CPL(i_P,:)+pattern.construction_dimensions.cm_cc*n; CPL(i_P:end,:)];

pattern.production_pattern = [pattern.production_pattern; CPL; NaN NaN];
