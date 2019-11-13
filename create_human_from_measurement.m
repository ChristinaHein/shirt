function human = create_human_from_measurement(varargin)
%% create_human_from_measurement([name, type, nw, wh, rsw, cc, wac, hc, al, cua, wrc]) - creates struct human from measurement data
% (created by Christina M. Hein, 2019-April-24)
% (last changes by Christina M. Hein, 2019-September-11)
%
% This function helps to read the measured body dimensions  and creates 
% a struct (human) containing this data. This struct can be used to create
% a made-to-measure dressmaking pattern.
%
% human = create_human_from_measurement() - input help
% human = create_human_from_measurement(nw, wh, rsw, cc, hc, wac, al, cua, wrc); 
%
% === OPTIONAL INPUT ARGUMENTS - all or none === 
% name  = string with human's name
% type  = 'male', 'female' or 'child'
% nw    = neck to waist
% wh    = waist to hip
% rsw   = rear shoulder width
% cc    = chest circumference
% wac   = waist circumference
% hc    = hip circumference
% al    = arm length
% cua   = circumference upper arm
% wrc   = wrist circumference 
%
% === OUTPUT ARGUMENTS ===
% human     = struct containing name, type (male, female, child) and
%             body dimensions
%
% see also create_human_from_size


%% set names and variables
names = ["neck to waist"; "waist to hip"; "rear shoulder width";...
    %"shoulder deep"; "armhole depth"; 
    "chest circumference";...
    "waist circumference"; "hip circumference";...
    "arm length"; "upper arm circumference"; "wrist circumference"];
variables = ["back_length"; "seat_length"; "rear_shoulder_width";...
    %"shoulder_deep"; "armhole_depth"; 
    "chest_circumference";...
    "waist_circumference"; "hip_circumference";...
    "arm_length"; "circumference_upper_arm"; "wrist_circumference"];
%% input help
%%%%%%%%%%%%%%%%%%
if nargin == 0
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

%% read input data
%%%%%%%%%%%%%%%%%%%
elseif nargin == 11
    human.name = varargin{1};
    temp = isstrprop(human.name,'alpha');% check if only letters
    if any(~temp)
        human.name(~temp)=[];
        warning('Input of name: Letters are allowed, any other character was deleted.')
    end

    human.type = varargin{2};
    while sum(strcmp(varargin{2}, {'female','male','child'})) == 0
        error('Invalid type input. Set type to: male, female or child.')
    end
        
    for i = 3:length(variables)+2
        human.(variables(i-2)) = varargin{i};
    end

%% error if wrong number of inputs
else
    error('create_human_from_measurement: Please enter name, type and exactly 8 body dimensions or nothing to get input help');
end

