function directory = create_production_files_ep(human, pattern, varargin)
%% directory = create_production_files_ep(human, pattern, [directory]) - creates production files for external production
% (created by Christina M. Hein, 2019-October-28)
% (last changes by Christina M. Hein, --)
%
% This function creates all files necessary for the external production. 
% The following files are created in a folder with the name 
% of the object human 'Production_Files_lc_name' in the working directory:
% - dxf-file containing the pattern
% - object human with measurement data (for documentation)
% 
%
% create_production_files_ep(human, pattern)
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
    directory = strcat(d,'_Production_Files_ep_',human.name);
else
    directory = varargin{1};
end
mkdir(directory);

%% create dxf-file for pattern
filename = fullfile(directory, 'Production_pattern_all_parts.dxf');
FID = dxf_open(filename);
separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];

%% create dxf-file with pattern
pattern.construction_dimensions.cm_d = 50; %distance between parts

% front part
position = find(pattern.part_names == 'front_part');
PL = pattern.production_pattern(separator(position):separator(position+1),:);
if isequaln(PL(end,:),[NaN NaN])% delete NaN at end of CPL
    PL = PL(1:end-1,:);
end
if isequaln(PL(1,:),[NaN NaN]) % delete NaN at start of CPL
    PL = PL(2:end,:);
end
PL = PL.*10; % from cm to mm
PLtemp = [1 0; 0 -1]*PL'; PLtemp = PLtemp'; % mirror on x-axis
PL = [PL; PLtemp(end:-1:1,:)]; % mirrored and original assembled
PL = PL + [-min(PL(:,1)) -min(PL(:,2))]; % move to origin
%PLplot(PL); hold on; daspect([1 1 1]);
edge_front = [min(PL(:,1)) max(PL(:,2))]; % save edge for other alignments
dxf_polyline(FID,PL(:,1),PL(:,2),zeros(length(PL),1));

% back part
position = find(pattern.part_names == 'back_part');
PL = pattern.production_pattern(separator(position):separator(position+1),:);
if isequaln(PL(end,:),[NaN NaN])% delete NaN at end of CPL
    PL = PL(1:end-1,:);
end
if isequaln(PL(1,:),[NaN NaN]) % delete NaN at start of CPL
    PL = PL(2:end,:);
end
PL = PL.*10; % from cm to mm
PL = PL - pattern.construction_points.B.*10; % move to x-axis
PLtemp = [1 0; 0 -1]*PL'; PLtemp = PLtemp'; % mirror on x-axis
PL = [PL; PLtemp(end:-1:1,:)]; % mirrored and original assembled
edge_back = [min(PL(:,1)), min(PL(:,2))];
PL = PL + (edge_front - edge_back +[0 pattern.construction_dimensions.cm_d]); % move above front part
%PLplot(PL,'b.-');
edge_back = [max(PL(:,1)), max(PL(:,2))];
dxf_polyline(FID,PL(:,1),PL(:,2),zeros(length(PL),1));

% sleeve
position = find(pattern.part_names == 'sleeve');
if isempty(position) 
    error('External production without sleeves is not possible. Please add sleeves.');
elseif ~isempty(position) 
    separator = [1; find(isnan(pattern.production_pattern(:,1)) & isnan(pattern.production_pattern(:,2)))];
    PL = pattern.production_pattern(separator(position):separator(position+1),:);
    if isequaln(PL(end,:),[NaN NaN])% delete NaN at end of CPL
        PL = PL(1:end-1,:);
    end
    if isequaln(PL(1,:),[NaN NaN]) % delete NaN at start of CPL
    PL = PL(2:end,:);
    end
    PL = PL.*10; % from cm to mm
    PL = [0 1; -1 0]*PL'; PL = PL'; % rotation -90 deg
    PL = PL + [0 -pattern.construction_dimensions.cm_d]; % create small distance to x-axis
    PLtemp = [1 0; 0 -1]*PL'; PLtemp = PLtemp'; % mirror on x-axis
    edge_sleeve = [min(PL(:,1)), min(PL(:,2))];
    PL = PL + [-edge_sleeve(1)+edge_back(1)+pattern.construction_dimensions.cm_d -edge_sleeve(2)]; % move left of front part
    PLtemp = PLtemp + [-edge_sleeve(1)+edge_back(1)+pattern.construction_dimensions.cm_d -edge_sleeve(2)];
    %PLplot(PL,'g.-'); PLplot(PLtemp,'g.-');
    edge_sleeve = [max(PLtemp(:,1)), max(PLtemp(:,2))];
    dxf_polyline(FID,PL(:,1),PL(:,2),zeros(length(PL),1));
    dxf_polyline(FID,PLtemp(:,1),PLtemp(:,2),zeros(length(PLtemp),1));
end

% cuffs neckline
position = find(pattern.part_names == 'cuffs_neckline_simple',1);
if ~isempty(position) 
    error('External production for v-neckline is not possible. Please change to round neckline');
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
    PL = PL + [0 -max(PL(:,2))]; % move to x-axis
    PLtemp = [1 0; 0 -1]*PL'; PLtemp = PLtemp'; % mirror on x-axis
    PL = [PL; PLtemp(end:-1:1,:)]; % mirrored and original assembled
    edge_cuff = [min(PL(:,1)), min(PL(:,2))];
    PL = PL + [edge_sleeve(1)-edge_cuff(1)+pattern.construction_dimensions.cm_d,  -edge_cuff(2)];
    %PLplot(PL,'y.-');
    dxf_polyline(FID,PL(:,1),PL(:,2),zeros(length(PL),1));
end


% mark reference length
PL = [edge_sleeve(1) edge_sleeve(2)+pattern.construction_dimensions.cm_d];
PL = [PL; PL+[-50 0]];
PL = [PL; PL(2,:)+[0 50]; PL(1,:)+[0 50]; PL(1,:)];
%PLplot(PL,'k');
dxf_polyline(FID,PL(:,1),PL(:,2),zeros(length(PL),1));
dxf_text(FID,PL(2,1),PL(2,2)-30,0,'5x5 cm', ...
  'TextHeight',20)

% mark thread running
PL= PL(1,:)+[0 200];
PL = [PL; PL+[-200 0]]; % arrow line
%PLplot(PL,'k');
dxf_polyline(FID,PL(:,1),PL(:,2),zeros(length(PL),1));
dxf_text(FID,PL(2,1),PL(2,2)+10,0,'Fadenlauf', ...
  'TextHeight',20)
PL = [PL(1,:); PL(1,:)+[-40 30]]; %upper arrowhead
%PLplot(PL,'k');
dxf_polyline(FID,PL(:,1),PL(:,2),zeros(length(PL),1));
PL = [PL(1,:); PL(1,:)+[-40 -30]]; %lower arrowhead
%PLplot(PL,'k')
dxf_polyline(FID,PL(:,1),PL(:,2),zeros(length(PL),1));

dxf_close(FID)
%% save human for documentation
fname = strcat(directory,'/',d,'_Measurement_Data_',human.name);
save(fname,'human');

%% save dart length
if isfield(pattern.construction_points,'dart_right') % if dart exists
    fname = strcat(directory,'/',d,'_dart_length',human.name);
    dart_length = pattern.construction_dimensions.dart_length;
    save(fname,'dart_length');
end

end