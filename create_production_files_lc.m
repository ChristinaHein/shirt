function directory = create_production_files_lc(human, pattern, varargin)
%% directory = create_production_files_lc(human, pattern, [directory]) - creates production files for laser cutting
% (created by Christina M. Hein, 2019-May-15)
% (last changes by Christina M. Hein, 2019-October-28)
%
% This function creates all files necessary for the production using a
% laser cutter. The following files are created in a folder with the name 
% of the object human 'Production_Files_name' in the working directory:
% - svg-files of back part, front part, label
% - object human with measurement data (for documentation)
% - optional (depending on pattern type): svg files of sleeves and cuffs,
% - variable containing dart-length (necessary for sewing)
% 
%
% create_production_files_lc(human, pattern)
%
% === INPUT ARGUMENTS ===
% human             = struct of type human (name, type, body dimensions)
% pattern           = struct for pattern, yet filled with construction
%                     points and optionally with other part's basic pattern
%                     created by create_pattern_shirt
% directory         = directory name (string)
%
% === OUTPUT ARGUMENTS ===
% directory         = directory name (string)
%
%% check name
% replace ä,ö,ü,ß
human.name = strrep(human.name,'ä','ae');
human.name = strrep(human.name,'ö','oe');
human.name = strrep(human.name,'ü','ue');
human.name = strrep(human.name,'ß','ss');

% check if only letters
temp = isstrprop(human.name,'alpha');
if any(~temp)
    human.name(~temp)=[];
    warning('Input of name: Letters are allowed, any other character was deleted.')
end


%% make directory
d = date;
if length(varargin)==0 % create directory name if no directory as input argument
    directory = strcat(d,'_Production_Files_lc_',human.name);
else % or use directory input name
    directory = varargin{1};
end

mkdir(directory);

%% create svg-file of pattern
% front part
position = find(pattern.part_names == 'front_part');
separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];
PL = pattern.production_pattern(separator(position):separator(position+1),:);
if isequaln(PL(end,:),[NaN NaN])% delete NaN at end of CPL
    PL = PL(1:end-1,:);
end
if isequaln(PL(1,:),[NaN NaN]) % delete NaN at start of CPL
    PL = PL(2:end,:);
end
PL = PL.*10; % from cm to mm
PL = [1 0; 0 -1]*PL'; PL = PL'; % mirror on x-axis
filename = fullfile(directory, 'Front_Part');
PLwriteSVG2(PL, 'fName', filename);

% back part
position = find(pattern.part_names == 'back_part');
separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];
PL = pattern.production_pattern(separator(position):separator(position+1),:);
if isequaln(PL(end,:),[NaN NaN])% delete NaN at end of CPL
    PL = PL(1:end-1,:);
end
if isequaln(PL(1,:),[NaN NaN]) % delete NaN at start of CPL
    PL = PL(2:end,:);
end
PL = PL.*10; % from cm to mm
%PL = [-1 0; 0 1]*PL'; PL = PL'; % rotation 180 deg
filename = fullfile(directory, 'Back_Part');
PLwriteSVG2(PL, 'fName', filename);

% sleeve
position = find(pattern.part_names == 'sleeve');
if ~isempty(position) 
    separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];
    PL = pattern.production_pattern(separator(position):separator(position+1),:);
    if isequaln(PL(end,:),[NaN NaN])% delete NaN at end of CPL
        PL = PL(1:end-1,:);
    end
    if isequaln(PL(1,:),[NaN NaN]) % delete NaN at start of CPL
    PL = PL(2:end,:);
    end
    PL = PL.*10; % from cm to mm
    PL = [0 -1; 1 0]*PL'; PL = PL'; % rotation 90 deg
    filename = fullfile(directory, 'Sleeve');
    PLwriteSVG2(PL, 'fName', filename);
end

% cuffs neckline
position = find(pattern.part_names == 'cuffs_neckline_simple');
if ~isempty(position) 
    separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];
    PL = pattern.production_pattern(separator(position):separator(position+1),:);
    if isequaln(PL(end,:),[NaN NaN])% delete NaN at end of CPL
        PL = PL(1:end-1,:);
    end
    if isequaln(PL(1,:),[NaN NaN]) % delete NaN at start of CPL
    PL = PL(2:end,:);
    end
    PL = PL.*10; % from cm to mm
    filename = fullfile(directory, 'Cuffs_neckline_simple');
    PLwriteSVG2(PL, 'fName', filename);
end

position = find(pattern.part_names == 'cuffs_neckline');
if ~isempty(position) 
    separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];
    PL = pattern.production_pattern(separator(position):separator(position+1),:);
    if isequaln(PL(end,:),[NaN NaN])% delete NaN at end of CPL
        PL = PL(1:end-1,:);
    end
    if isequaln(PL(1,:),[NaN NaN]) % delete NaN at start of CPL
    PL = PL(2:end,:);
    end
    PL = PL.*10; % from cm to mm
    filename = fullfile(directory, 'Cuffs_neckline');
    PLwriteSVG2(PL, 'fName', filename);
end

%% create label
text = fileread('Template_Label.svg');
text = strrep(text,'Name',human.name);
text = strrep(text,'Date',d);

filename = fullfile(directory, 'Label.svg');
fileID = fopen(filename,'w');
fprintf(fileID,text);
fclose(fileID);

%% save human for documentation
fname = strcat(directory,'/',d,'_Measurement_Data',human.name);
save(fname,'human');

%% save dart length
if isfield(pattern.construction_points,'dart_right') % if dart exists
    fname = strcat(directory,'/',d,'_dart_length',human.name);
    dart_length = pattern.construction_dimensions.dart_length;
    save(fname,'dart_length');
end

end