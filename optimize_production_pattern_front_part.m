function pattern = optimize_production_pattern_front_part(pattern, seam, hem)
%% optimize_production_pattern_front_part(pattern, seam, hem) - optimizes the production pattern of the front part relative to the back part
% (created by Christina M. Hein, 2019-April-24)
% (last changes by Christina M. Hein, 2020-February-18)
%
% This function optimizes the production pattern of the front part relative
% to the back part. It cuts out an edge on the neckline, so that the two
% parts map together exactly for sewing.
%
% pattern = optimize_production_pattern_front_part(pattern, seam, hem)
%
% === INPUT ARGUMENTS ===
% pattern     = struct containing PL of construction points, CPLs of basic 
%               pattern and production pattern, part names, material and
%               label information.
% seam        = seam allowance measurement [cm]
% hem         = hem allowance measurement [cm]

% === OUTPUT ARGUMENTS ===
% pattern     = struct containing PL of construction points, CPLs of basic 
%               pattern and production pattern, part names, material and
%               label information.
%
% see create_production_pattern_back, create_production_pattern_front

%% separate basic and production pattern
% separate back part from pattern
position = find(pattern.part_names == 'back_part');
if isempty(position)
    error('Optimization of production pattern of front part failed: It is not possible to optimize the production pattern without back pattern. Please use create_production_pattern_back_part first.')
end

separator = [1; find(isnan(pattern.basic_pattern(:,1)) & isnan(pattern.basic_pattern(:,2)))];
bp_back = pattern.basic_pattern(separator(position):separator(position+1),:);
bp_back(~any(~isnan(bp_back), 2),:)=[]; % delete NaN 


separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];
pp_back = pattern.production_pattern(separator(position):separator(position+1),:);
pp_back(~any(~isnan(pp_back), 2),:)=[]; % delete NaN 

% separate front part from production pattern
position = find(pattern.part_names == 'front_part');
if isempty(position)
    error('Optimization of production pattern of front part failed: It is not possible to optimize the production pattern without back pattern. Please use create_production_pattern_back_part first.')
end

separator = [1; find(isnan(pattern.basic_pattern(:,1)) & isnan(pattern.basic_pattern(:,2)))];
bp_front = pattern.basic_pattern(separator(position):separator(position+1),:);
bp_front(~any(~isnan(bp_front), 2),:)=[]; % delete NaN 

separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];
pp_front = pattern.production_pattern(separator(position):separator(position+1),:);
pp_front(~any(~isnan(pp_front), 2),:)=[];% delete NaN 

%% create polyshape objects
po_bp_back = polyshape(bp_back); % polyshape object basic pattern back
po_pp_back = polyshape(pp_back); % polyshape object production pattern back
%plot(po_bp_back); hold on;

po_bp_front = polyshape(bp_front); % polyshape object basic pattern front
po_pp_front = polyshape(pp_front); % polyshape object production pattern front

%% move back part: back middle line on front middle line
po_bp_back = translate(po_bp_back, -pattern.construction_points.B);
po_pp_back = translate(po_pp_back, -pattern.construction_points.B);
%plot(po_bp_back);

%% mirror back part
po_bp_back.Vertices(:,2)=po_bp_back.Vertices(:,2)*(-1);
po_pp_back.Vertices(:,2)=po_pp_back.Vertices(:,2)*(-1);
%plot(po_bp_back); 

%% find shoulder seam in basic pattern
i_sn_f = find(po_bp_front.Vertices(:,1) == max(po_bp_front.Vertices(:,1))); % index shoulder-neck: max x-value
i_sa_f = find(po_bp_front.Vertices(:,2) == max([po_bp_front.Vertices(i_sn_f-1,2),po_bp_front.Vertices(i_sn_f+1,2)])); % index shoulder-arm: neighbor of shoulder-neck with higher y-value

i_sn_b = find(po_bp_back.Vertices(:,1) == max(po_bp_back.Vertices(:,1))); % index shoulder-neck: max x-value
i_sa_b = find(po_bp_back.Vertices(:,2) == max([po_bp_back.Vertices(i_sn_b-1,2),po_bp_back.Vertices(i_sn_b+1,2)])); % index shoulder-arm: neighbor of shoulder-neck with higher y-value

%plot(po_bp_back.Vertices([i_sn_b,i_sa_b],1),po_bp_back.Vertices([i_sn_b,i_sa_b],2),'ro');
%plot(po_bp_front.Vertices([i_sn_f,i_sa_f],1),po_bp_front.Vertices([i_sn_f,i_sa_f],2),'b*');

%% angle between shoulder seams
v_ss_f = po_bp_front.Vertices(i_sn_f,:)- po_bp_front.Vertices(i_sa_f,:);  %vector shoulder seam front
v_ss_b = po_bp_back.Vertices(i_sn_b,:)- po_bp_back.Vertices(i_sa_b,:); %vector shoulder seam front

alpha = acosd((v_ss_f(1)*v_ss_b(1)+v_ss_f(2)*v_ss_b(2))/(norm(v_ss_f)*norm(v_ss_b)));

%% move back part: shoulder seams congruent
t = po_bp_front.Vertices(i_sa_f,:)-po_bp_back.Vertices(i_sa_b,:);
po_bp_back = translate(po_bp_back,t);
po_bp_back = rotate(po_bp_back,alpha,po_bp_front.Vertices(i_sa_f,:));

po_pp_back = translate(po_pp_back,t);
po_pp_back = rotate(po_pp_back,alpha,po_bp_front.Vertices(i_sa_f,:));

%plot(po_bp_back);
%plot(po_pp_back)

%% seperate parts x>0
x = po_bp_front.Vertices(i_sn_f,1)+2*seam;
box = [0 0; pattern.construction_points.a3; x pattern.construction_points.a3(2); x 0];
po_box = polyshape(box);

po_pp_front_part1 = intersect(po_pp_front, po_box);
po_pp_front_part2 = subtract(po_pp_front, po_box);
%plot(po_pp_front_part1);

%% boolean: interserct
po_pp_front_part1 = intersect(po_pp_front_part1, po_pp_back);
%plot(po_pp_front_part1);

%% join front part together
po_pp_front = union(po_pp_front_part1, po_pp_front_part2);
%plot(po_pp_front);

%% delete front middle line
F = pattern.construction_points.F+[-hem 0];
if pattern.construction_dimensions.neckline == 0 % case round neckline
    a4 = pattern.construction_points.a4+[seam 0];
else % case v-neckline
    a4 = pattern.construction_points.a4+[-pattern.construction_dimensions.neckline(1) 0];
end
PL = po_pp_front.Vertices;
PL=[PL, zeros(length(PL),1)];
ptCloud = pointCloud(PL);
[i_F,~] = findNearestNeighbors(ptCloud, [F 0], 1); %index to nearest point to F, distance to F
[i_a4,~] = findNearestNeighbors(ptCloud, [a4 0], 1);
% todo: add warning if d ist too big
PL = ptCloud.Location(:,1:2);
PL = [PL(i_F:end,:); PL(1:i_a4,:)];

%% write into pattern
position = find(pattern.part_names == 'front_part');
separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];

production_pattern = pattern.production_pattern;
pattern.production_pattern = production_pattern(1:separator(position),:);
pattern.production_pattern = [pattern.production_pattern; PL];
pattern.production_pattern = [pattern.production_pattern; production_pattern(separator(position+1):end,:)];



