function human = create_human_from_measurement()
%% create_human_from_measurement() - creates struct human from measurement data
% (created by Christina M. Hein, 2019-April-24)
% (last changes by Christina M. Hein, 2019-August-08)
%
% This function helps to read the measured body dimensions  and creates 
% a struct (human) containing this data. This struct can be used to create
% a made-to-measure dressmaking pattern.
%
% human = create_human_from_measurement()
%
% === INPUT ARGUMENTS ===
% 
%
% === OUTPUT ARGUMENTS ===
% human     = struct containing name, type (male, female, child) and
%             body dimensions
%
% see also create_human_from_size

%% request user input for metadata
disp('Please enter the following data:')
in=true;

% name
in = input('Name:','s');
human.name = in;

temp = isstrprop(human.name,'alpha');% check if only letters
if any(~temp)
    human.name(~temp)=[];
    warning('Input of name: Letters are allowed, any other character was deleted.')
end

% type
in = input('Type (female, male, child):','s');
while sum(strcmp(in, {'female','male','child'})) == 0
    warning('Invalid type input. Set type to: male, female or child.')
    in = input('Type (female, male, child):','s');
end
human.type = in;


%%  set min and max limits for measures
if strcmp(human.type,'female')
    size_min = 32;
    size_max = 46;
elseif strcmp(human.type,'male')
    size_min = 42;
    size_max = 60;
end

human_min = create_human_from_size(human.type, size_min, 'min');
human_max = create_human_from_size(human.type, size_max, 'max');
f = 0.1; % factor for allowed deviation from smallest and biggest standard size

names = ["back length"; "seat length"; "rear shoulder width";...
    "shoulder deep"; "armhole depth"; "chest circumference";...
    "waist circumference"; "hip circumference";...
    "arm length"; "circumference upper arm"; "wrist circumference"];
variables = ["back_length"; "seat_length"; "rear_shoulder_width";...
    "shoulder_deep"; "armhole_depth"; "chest_circumference";...
    "waist_circumference"; "hip_circumference";...
    "arm_length"; "circumference_upper_arm"; "wrist_circumference"];

for i=1:length(variables)
    human_min.(variables(i)) = round((1-f)*human_min.(variables(i)),1);
    human_max.(variables(i)) = round((1+f)*human_max.(variables(i)),1);
end

%% request user input for measures 

for i=1:length(variables)
    human.(variables(i)) = input(strcat(names(i),': '));
    while human.(variables(i)) < human_min.(variables(i)) || human.(variables(i)) > human_max.(variables(i))
        warning('Invalid input for %s: value need to be between %0.1f and %0.1f',names(i), human_min.(variables(i)), human_max.(variables(i)));
        human.(variables(i)) = input(strcat(names(i),': '));
    end
end


