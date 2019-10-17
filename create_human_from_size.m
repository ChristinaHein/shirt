function human = create_human_from_size(type,size,name)
%% create_human_from_size(type,size,name) - creates struct human from clothing size
% (created by Christina M. Hein, 2019-April-24)
% (last changes Christina M. Hein, 2019-August-08)
%
% This function creates a struct of type human that contains all body 
% measurements belonging to one dress size which are necessary to design 
% the dressmaking pattern of a shirt.
%
% human = create_human_from_size(type,size,name)
%
% === INPUT ARGUMENTS ===
% type      = 'female', 'male' or 'child'
% size      = clothing size (female: 32-60, male: 42-60)
% name      = name of human
%
% === OUTPUT ARGUMENTS ===
% human     = struct containing name, type (male, female, child) and
%             body dimensions
%
% see create_human_from_measurement, create_pattern_shirt

%% set type
% check type input
if ischar(type)
    if strcmp(type, {'female','male','child'}) == [0 0 0]
     error('Unvalid type input. Set type to: male, female or child.')
    end
else error('Unvalid type input. Type has to be a character vector');
end

human.type = type;

%% set name
% check name
if ischar(name)
    human.name = name;
else 
    error('Unvalid name input. Name has to be a character vector');
end

%% set measures

%values: Hofenbitzer p.12
if strcmp(type,'female')
    if size == 32
        human.back_length               = 41.4;
        human.seat_length               = 20;
        human.rear_shoulder_width       = 34.2/pi+2*11.6; %neck circumferense/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 11.6;
        human.chest_circumference       = 76;
        human.waist_circumference       = 62;
        human.hip_circumference         = 86;
        human.arm_length                = 59;
        human.circumference_upper_arm   = 25.6;
        human.wrist_circumference       = 14.6;
        human.armhole_depth             = 18.9;
        
    elseif size == 34
        human.back_length               = 41.4;
        human.seat_length               = 20.2;
        human.rear_shoulder_width       = 34.8/pi+2*11.8; %neck circumferense/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 11.8;
        human.chest_circumference       = 80;
        human.waist_circumference       = 65;
        human.hip_circumference         = 90;
        human.arm_length                = 59.3;
        human.circumference_upper_arm   = 26.2;
        human.wrist_circumference       = 15;
        human.armhole_depth             = 19.3; 
        
    elseif size == 36
        human.back_length               = 41.4;
        human.seat_length               = 20.4;
        human.rear_shoulder_width       = 35.4/pi+2*12; %neck circumferense/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 12;
        human.chest_circumference       = 84;
        human.waist_circumference       = 68;
        human.hip_circumference         = 94;
        human.arm_length                = 59.6;
        human.circumference_upper_arm   = 27;
        human.wrist_circumference       = 15.4;
        human.armhole_depth             = 19.7;
        
    elseif size == 38
        human.back_length               = 41.6;
        human.seat_length               = 20.6;
        human.rear_shoulder_width       = 36/pi+2*12.2; %neck circumferense/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 12.2;
        human.chest_circumference       = 88;
        human.waist_circumference       = 72;
        human.hip_circumference         = 97;
        human.arm_length                = 59.9;
        human.circumference_upper_arm   = 28;
        human.wrist_circumference       = 15.8;
        human.armhole_depth             = 20.1;
        
   elseif size == 40
        human.back_length               = 41.8;
        human.seat_length               = 20.8;
        human.rear_shoulder_width       = 36.6/pi+2*12.4; %neck circumferense/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 12.4;
        human.chest_circumference       = 92;
        human.waist_circumference       = 76;
        human.hip_circumference         = 100;
        human.arm_length                = 60.2;
        human.circumference_upper_arm   = 29.2;
        human.wrist_circumference       = 16.2;
        human.armhole_depth             = 20.5;

   elseif size == 42
        human.back_length               = 42;
        human.seat_length               = 21;
        human.rear_shoulder_width       = 37.2/pi+2*12.6; %neck circumferense/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 12.6;
        human.chest_circumference       = 96;
        human.waist_circumference       = 80;
        human.hip_circumference         = 103;
        human.arm_length                = 60.5;
        human.circumference_upper_arm   = 30.4;
        human.wrist_circumference       = 16.6;
        human.armhole_depth             = 20.9;
 
   elseif size == 44
        human.back_length               = 42.2;
        human.seat_length               = 21.2;
        human.rear_shoulder_width       = 37.8/pi+2*12.8; %neck circumferense/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 12.8;
        human.chest_circumference       = 100;
        human.waist_circumference       = 84;
        human.hip_circumference         = 106;
        human.arm_length                = 60.8;
        human.circumference_upper_arm   = 31.6;
        human.wrist_circumference       = 17;
        human.armhole_depth             = 21.3;
        
   elseif size == 46
        human.back_length               = 42.4;
        human.seat_length               = 21.4;
        human.rear_shoulder_width       = 38.4/pi+2*13; %neck circumference/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 12.3; %sind das nicht 13
        human.chest_circumference       = 104;
        human.waist_circumference       = 88;
        human.hip_circumference         = 109;
        human.arm_length                = 61.1;
        human.circumference_upper_arm   = 32.8;
        human.wrist_circumference       = 17.4;
        human.armhole_depth             = 21.7;
        
   elseif size == 48
        human.back_length               = 42.7;
        human.seat_length               = 21.6;
        human.rear_shoulder_width       = 39.6/pi+2*13.2; %neck circumference/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 13.2;
        human.chest_circumference       = 110;
        human.waist_circumference       = 94.5;
        human.hip_circumference         = 114;
        human.arm_length                = 61.4;
        human.circumference_upper_arm   = 34.6;
        human.wrist_circumference       = 18;
        human.armhole_depth             = 22.1;
        
   elseif size == 50
        human.back_length               = 43;
        human.seat_length               = 21.8;
        human.rear_shoulder_width       = 40.8/pi+2*13.4; %neck circumference/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 13.4;
        human.chest_circumference       = 116;
        human.waist_circumference       = 101;
        human.hip_circumference         = 119;
        human.arm_length                = 61.7;
        human.circumference_upper_arm   = 36.4;
        human.wrist_circumference       = 18.6;
        human.armhole_depth             = 22.5;
        
   elseif size == 52
        human.back_length               = 43.3;
        human.seat_length               = 22;
        human.rear_shoulder_width       = 42/pi+2*13.6; %neck circumference/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 13.6;
        human.chest_circumference       = 122;
        human.waist_circumference       = 107.5;
        human.hip_circumference         = 124;
        human.arm_length                = 62;
        human.circumference_upper_arm   = 38.2;
        human.wrist_circumference       = 19.2;
        human.armhole_depth             = 22.9;
         
    elseif size == 54
        human.back_length               = 43.6;
        human.seat_length               = 22.2;
        human.rear_shoulder_width       = 43.2/pi+2*13.8; %neck circumference/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 13.8;
        human.chest_circumference       = 128;
        human.waist_circumference       = 114;
        human.hip_circumference         = 129;
        human.arm_length                = 62.3;
        human.circumference_upper_arm   = 40;
        human.wrist_circumference       = 19.8;
        human.armhole_depth             = 23.3;
        
    elseif size == 56
        human.back_length               = 43.6;
        human.seat_length               = 22.4;
        human.rear_shoulder_width       = 44.4/pi+2*14; %neck circumference/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 14;
        human.chest_circumference       = 134;
        human.waist_circumference       = 120.5;
        human.hip_circumference         = 134;
        human.arm_length                = 62.3;
        human.circumference_upper_arm   = 41.8;
        human.wrist_circumference       = 20.4;
        human.armhole_depth             = 23.7;
        
    elseif size == 58
        human.back_length               = 43.6;
        human.seat_length               = 22.6;
        human.rear_shoulder_width       = 45.6/pi+2*14.2; %neck circumference/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 14.2;
        human.chest_circumference       = 140;
        human.waist_circumference       = 127;
        human.hip_circumference         = 139;
        human.arm_length                = 62.3;
        human.circumference_upper_arm   = 43.6;
        human.wrist_circumference       = 21;
        human.armhole_depth             = 24.1;
        
    elseif size == 60
        human.back_length               = 43.6;
        human.seat_length               = 22.8;
        human.rear_shoulder_width       = 46.8/pi+2*14.4; %neck circumference/pi (= diameter) + 2*shoulder deep
        human.shoulder_deep             = 14.4;
        human.chest_circumference       = 146;
        human.waist_circumference       = 133.5;
        human.hip_circumference         = 144;
        human.arm_length                = 62.3;
        human.circumference_upper_arm   = 45.4;
        human.wrist_circumference       = 21.6;
        human.armhole_depth             = 24.5;
        %% todo: add size 48-60, then change max values in create_human_from_measurement, plot_all_sizes and error message
    
    else
        error('Invalid size input for women. Valid input is size 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58 and 60.')
    end
        
    %values: Gilewska P.17
elseif strcmp(type, 'male')
    % check input size
    if size < 42 || size > 60 || mod(size,2) ~= 0
        warning('Invalid size input for men. Valid input is 42, 44, 46, 48, 50, 52, 54, 56, 58 and 60')
    end
         
    % calculate number of sizes between size 42 an input
    n = (size - 42)/2;
    
    % add measurement according to size input
    human.back_length               = 44.3 +n*0.3;
    human.seat_length               = 21   +n*0.2;
    human.rear_shoulder_width       = 43.8 +n*0.5;
    human.shoulder_deep             = (human.rear_shoulder_width - 41.6/pi)/2; % (shoulder width - neck circmumference/pi)/2
    human.chest_circumference       = 84   +n*4;
    human.waist_circumference       = 72   +n*4;
    human.hip_circumference         = 81   +n*4;
    human.arm_length                = 62   +n*0.3;
    human.circumference_upper_arm   = 28.8 +n*0.8;
    human.wrist_circumference       = 17   +n*0.2;
    human.armhole_depth             = human.back_length/2+1; % Gileska p.18: constuction armhole level

end

      