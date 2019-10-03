function create_production_files(human, pattern)
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
directory = strcat('Production_Files_',human.name);
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

position = find(pattern.part_names == 'cuffs_neckline_fine');
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
    filename = fullfile(directory, 'Cuffs_neckline_fine');
    PLwriteSVG2(PL, 'fName', filename);
end

%% create label
text = fileread('Template_Label.svg');
text = strrep(text,'Name',human.name);
d = date;
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