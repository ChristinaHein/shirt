function pattern = create_pattern_shirt(human, varargin)
%% create_pattern_shirt(human, [fit, sleeve_length, neckline, hemtype, fabric_elasticity]) - creates a pattern of a shirt
% (created by Christina M. Hein, 2019-April-24)
% (last changes by Christina M. Hein, 2020-February-18)
%
% This function creates a struct of type pattern that contains the PL of a
% shirt and other necessary information (e.g. material, part names). This
% pattern can be used to create all necessary production files.
%
% pattern = create_pattern_shirt(human, [fit, sleeve_length, neckline, hemtype])
%
% === INPUT ARGUMENTS ===
% human             = struct of type human (name, type, body dimensions)
% fit               = 'extra_slim', 'slim', 'regular', 'wide', default is regular
% sleeve length     = 'sleeveless', 'short', '3/4sleeves', 'long' , default
%                      is long
% neckline          = 'round' or 'v', default is 'round'
% hemtype           = 'plain_hem' (folded), 'simple_cuff' or 'rolled_hem'
% fabric_elasticity = elasticity of the fabric at which the initial dimension is reached again (in %) 

% === OUTPUT ARGUMENTS ===
% pattern     = struct containing PL of construction points, CPLs of basic 
%               pattern and production pattern, part names, material and
%               label information.
%
% see create_human_from_measurement, create_human_from_size

%% set default values
% only want 5 optional inputs at most
numvarargs = length(varargin);
if numvarargs > 5
    error('create_pattern_shirt: Too many inputs, requieres at most 5 optional inputs')
end

% set defaults for optional inputs
optargs = {'regular' 'long' 'round' 'plain_hem', 25};
optargs(1:numvarargs) = varargin;
[fit, sleeve_length, neckline, hemtype, fabric_elasticity] =  optargs{:};

%% write pattern properties
pattern.property.type = human.type;
pattern.property.fit = fit;
pattern.property.sleeve_length = sleeve_length;
pattern.property.neckline = neckline;
pattern.property.hemtype = hemtype;
    
%% Ininialization and parameters
pattern.part_names=[];
pattern.basic_pattern=[];
pattern.production_pattern=[];
seam = 1; 
pattern.construction_dimensions.seam = seam;

if strcmp(hemtype,'plain_hem')
    hem = 2;
elseif strcmp(hemtype,'rolled_hem')
    hem = 0.5;
elseif strcmp(hemtype,'simple_cuff')
    hem = 4+3*seam; % 4 cm width cuff
else
    error('create_pattern_shirt: Invalid input for hemtype. Valid input is plain_hem, simple_cuff or rolled_hem ');
end
pattern.construction_dimensions.hem = hem;

if strcmp(fit,'extra_slim')
    pattern.construction_dimensions.fit_allowance = -0.4*fabric_elasticity/100;
elseif strcmp(fit,'slim')
    pattern.construction_dimensions.fit_allowance = -0.1*fabric_elasticity/100;
elseif strcmp(fit,'regular')
    pattern.construction_dimensions.fit_allowance = 0.05*fabric_elasticity/100;
elseif strcmp(fit,'wide')
    pattern.construction_dimensions.fit_allowance = 0.15*fabric_elasticity/100;  
else
    error('create_pattern_shirt: Invalid input for variable fit')
end 

if strcmp(sleeve_length, 'long')
    pattern.construction_dimensions.sl = 1;
elseif strcmp(sleeve_length, '3/4sleeves')
    pattern.construction_dimensions.sl = 0.7;
elseif strcmp(sleeve_length, 'short')
    if strcmp(human.type,'female')
        pattern.construction_dimensions.sl = 0.3;
    elseif strcmp(human.type,'male')
        pattern.construction_dimensions.sl = 0.4;
    else
        error('Invalid Input for human type')
    end
elseif strcmp(sleeve_length, 'sleeveless')
    pattern.construction_dimensions.sl = 0;
else 
    error('create_pattern_shirt: Invalid input for variable sleeve_length')
end

if strcmp(neckline, 'round')
    pattern.construction_dimensions.neckline = 0;
elseif strcmp(neckline, 'v')
    if strcmp(human.type,'female')
        pattern.construction_dimensions.neckline = [12,2,3]; % measurement breast and shoulder and rounded curve parameter
    elseif strcmp(human.type, 'male')
        pattern.construction_dimensions.neckline = [4,1,1.5];
    else
        error('Invalid input for human type');
    end
else 
    error('create_pattern_shirt: Invalid input for variable neckline')
end

%% constant measurements
pattern.construction_dimensions.cm_dp = 10;% distance between parts
pattern.construction_dimensions.cm_nf = 2; % neck front
pattern.construction_dimensions.cm_sf = 3; % shoulder front
%pattern.construction_dimensions.cm_w  = 2; % waist (2-3, todo: variabel)
pattern.construction_dimensions.cm_nb = 2; % neck back
pattern.construction_dimensions.cm_sb = 2; % shoulder back
pattern.construction_dimensions.cm_am = human.chest_circumference/24+1; % armhole measurement
pattern.construction_dimensions.f = 1.16;
% corrections on armhole measurment according to Hofenbitzer (S. 11): 1/3
if human.chest_circumference <= 89
    pattern.construction_dimensions.cm_am = pattern.construction_dimensions.cm_am -0.5;
elseif human.chest_circumference <= 99
    pattern.construction_dimensions.cm_am = pattern.construction_dimensions.cm_am -0.3;
elseif human.chest_circumference <= 109
    pattern.construction_dimensions.cm_am = pattern.construction_dimensions.cm_am -0.17;
elseif human.chest_circumference >=120
     pattern.construction_dimensions.cm_am = pattern.construction_dimensions.cm_am +0.17;
end
pattern.construction_dimensions.cm_cm = 6; % clip mark sleeve-back part
pattern.construction_dimensions.cm_cc = 0.2; % clip cut length
pattern.construction_dimensions.cm_cuff = 4; % cuffs pattern width for v-neck
pattern.construction_dimensions.cm_cuff_width = (pattern.construction_dimensions.cm_cuff-2*seam)/2; % width of final cuff

%% create construction points (struct) for torso
pattern.construction_points.A  = [0 0];
pattern.construction_points.a1 = [0,(human.chest_circumference*(1+pattern.construction_dimensions.fit_allowance))/4];
pattern.construction_points.a2 = [0,human.rear_shoulder_width/5+pattern.construction_dimensions.cm_cuff_width];
pattern.construction_points.a3 = [0,human.rear_shoulder_width/2];
pattern.construction_points.a4 = [-human.rear_shoulder_width/5-pattern.construction_dimensions.cm_cuff_width,0];

pattern.construction_points.b3 = pattern.construction_points.a1 + [0 pattern.construction_dimensions.cm_dp];
pattern.construction_points.B  = pattern.construction_points.b3 + [0 (human.chest_circumference*(1+pattern.construction_dimensions.fit_allowance))/4];
pattern.construction_points.b1 = pattern.construction_points.B - [0,human.rear_shoulder_width/5+pattern.construction_dimensions.cm_cuff_width];
pattern.construction_points.b2 = pattern.construction_points.B - [0,human.rear_shoulder_width/2];

pattern.construction_points.C = [-human.back_length pattern.construction_points.B(2)];
pattern.construction_points.D = [-human.back_length 0];

pattern.construction_points.C1 = [pattern.construction_points.C(1) pattern.construction_points.b3(2)];
pattern.construction_points.D1 = [pattern.construction_points.D(1) pattern.construction_points.a1(2)];

pattern.construction_points.E = pattern.construction_points.C-[human.seat_length*pattern.construction_dimensions.f 0];
pattern.construction_points.F = pattern.construction_points.D-[human.seat_length*pattern.construction_dimensions.f 0];

pattern.construction_points.E1 = [pattern.construction_points.E(1) pattern.construction_points.b3(2)];
pattern.construction_points.F1 = [pattern.construction_points.F(1) pattern.construction_points.a1(2)];

pattern.construction_points.e1 = pattern.construction_points.E+[0,-(human.hip_circumference*(1+pattern.construction_dimensions.fit_allowance))/4];
pattern.construction_points.f1 = pattern.construction_points.F+[0,(human.hip_circumference*(1+pattern.construction_dimensions.fit_allowance))/4];

pattern.construction_points.x  = pattern.construction_points.B-[human.back_length/2 0];
pattern.construction_points.x1 = [pattern.construction_points.x(1) 0];

% for women and extra slim and slim fit
pattern.construction_points.x2 = [pattern.construction_points.x(1),pattern.construction_points.b3(2)];
pattern.construction_points.x3 = [pattern.construction_points.x1(1),pattern.construction_points.a1(2)];

% move x2 and x3 for regular and wide fit for men
if strcmp(human.type,'male') && pattern.construction_dimensions.fit_allowance > 0
    pattern.construction_points.x2 = pattern.construction_points.x2 +[0 -pattern.construction_dimensions.fit_allowance*human.chest_circumference];
    pattern.construction_points.x3 = pattern.construction_points.x3 +[0 pattern.construction_dimensions.fit_allowance*human.chest_circumference];
end

pattern.construction_points.y  = pattern.construction_points.B-[human.back_length/4 0];
pattern.construction_points.y1 = [-human.back_length/4 0];

pattern.construction_points.z = pattern.construction_points.x + [-human.back_length/5 0];
pattern.construction_points.z1 = [pattern.construction_points.z(1) pattern.construction_points.x1(2)];
pattern.construction_points.z2 = [pattern.construction_points.z(1) pattern.construction_points.x2(2)];
pattern.construction_points.z3 = [pattern.construction_points.z(1) pattern.construction_points.x3(2)];

temp1 = 2*pattern.construction_dimensions.cm_am-(pattern.construction_points.b2(2)-pattern.construction_points.b3(2));
temp2 = temp1/(human.back_length/2-pattern.construction_dimensions.cm_sb)*(human.back_length/4-pattern.construction_dimensions.cm_sb);
pattern.construction_points.y2 = [pattern.construction_points.y(1), pattern.construction_points.b2(2)+temp2];

temp1 = 1.5*pattern.construction_dimensions.cm_am-(pattern.construction_points.a1(2)-pattern.construction_points.a3(2));
temp2 = temp1/(human.back_length/2-pattern.construction_dimensions.cm_sf)*(human.back_length/4-pattern.construction_dimensions.cm_sf);
pattern.construction_points.y3 = [pattern.construction_points.y1(1),pattern.construction_points.a3(2)-temp2];
%% back part
    
% create basic pattern 
pattern = create_basic_pattern_back_part(human, pattern);

% create production pattern 
pattern = create_production_pattern_back_part(pattern, seam, hem);

%% front part

% create basic pattern
pattern = create_basic_pattern_front_part(human,pattern); 

% create production pattern 
pattern = create_production_pattern_front_part(pattern, seam, hem); 

%% optimize production pattern of front part relating to back part
pattern = optimize_production_pattern_front_part(pattern, seam, hem);


%% create sleeve
if pattern.construction_dimensions.sl > 0
    % create basic pattern
    pattern = create_basic_pattern_sleeve(human, pattern);

    % create production pattern
    pattern = create_production_pattern_sleeve(pattern, seam, hem);
end

%% create cuffs neckline for v-neck or simple cuffs
if pattern.construction_dimensions.neckline ~= 0
    pattern = create_production_pattern_cuffs_neckline_simple(pattern, seam);
    % pattern = create_production_pattern_cuffs_neckline(pattern, 10); %fine cuff
else
    pattern = create_production_pattern_cuffs_neckline(pattern, seam, 0.8); 
end

