function pattern = shirt_intern_cutting_extern_sewing(human, fit, sleeves)
%% pattern = shirt_intern_cutting_extern_sewing(human, fit, sleeves) - creates the pattern and all files for extern production
% (created by Christina M. Hein, 2019-November-13)
% (last changes by Christina M. Hein, ---)
%
% This function creates the pattern and all necessary files for intern
% cutting and extern sewing of the shirt. It needs the customers 
% properties (human) and the shirt properties (fit, sleeves). The
% function creates a folder containing:
% - svg-files of pattern
% - variable human (for documentation)
% - label adress of tailor
% - order mail for tailor
% 
% EXAMPEL:
% pattern = shirt_intern_production_(create_human_from_size('female',36, 'Sam Sample'), 'slim', 'long')
%
% === INPUT ARGUMENTS === 
% human     = struct containing name, type (male, female, child) and
%             body dimensions
% fit       = 'slim', 'regular' or 'wide'
% sleeves   = 'sleeveless', 'short', '3/4sleeves', 'long'
%
% === OUTPUT ARGUMENTS ===
% pattern     = struct containing PL of construction points, CPLs of basic 
%               pattern and production pattern, part names, material and
%               label information.
%
% see also 
% shirt_extern_production_one
% shirt_extern_production_two
% shirt_intern_production

%% Pattern
pattern = create_pattern_shirt(human, fit, sleeves, 'round','plain_hem');

if nargout == 0
    plot_basic_pattern(pattern);
    plot_production_pattern(pattern)
end

d = date;
directory = strcat(d,'_Production_Files_ices_',human.name);

create_production_files_lc(human, pattern,directory);

%% copy only tutorials for cutting
tutorialfolder = strcat(directory,'/Tutorials');
rmdir(tutorialfolder, 's');
mkdir(tutorialfolder);
% Important information
destination = strcat(tutorialfolder,'/1_Important_information.pdf');
if strcmp(pattern.property.hemtype, 'simple_cuff')
    copyfile('Tutorials_templates/01a_Important_information_cuff.pdf', destination);
elseif strcmp(pattern.property.hemtype, 'plain_hem')
    copyfile('Tutorials_templates/01b_Important_information_hem.pdf', destination);
elseif strcmp(pattern.property.hemtype, 'rolled_hem')
    copyfile('Tutorials_templates/01c_Important_information_rolled_hem.pdf', destination);
end

% cutting
copyfile('Tutorials_templates/02_Cut.pdf', strcat(tutorialfolder,'/2_Cut.pdf'));
copyfile('Tutorials_templates/Help-Terminology_fabric_cutting.pdf', strcat(tutorialfolder,'/Help-Terminology_fabric_cutting.pdf'));

fprintf('A folder with the name %s was created with all files for your chosen fabrication type. \n', directory);

%% Label adress
filename = fullfile(directory, 'Adress_tailor.txt');
fid = fopen(filename,'w');
fprintf(fid,'Altenburger Anja \nMass u. Aenderungsschneiderei \nGruenwalder Str. 24 \n81547 Muenchen');
fclose(fid);

%% order letter
filename = fullfile(directory, 'Order_tailor.txt');
fid = fopen(filename,'w');
fprintf(fid,'Altenburger Anja \nMass u. Aenderungsschneiderei \nGruenwalder Str. 24 \n81547 Muenchen \n\n\n');
fprintf(fid,'Sehr geehrte Frau Altenburger,\n\nbitte naehen Sie aus den angefuegten Schnittmusterteilen ein Shirt.\n');
fprintf(fid,'Die Nahtzugabe beträgt %d cm und die Saumzugabe %d cm.\n', pattern.construction_dimensions.seam,pattern.construction_dimensions.hem);
fprintf(fid,'Das fertige Shirt senden Sie bitte an: \n ADRESSE\n\n');
fprintf(fid,'Mit freundlichen Gruessen\n NAME');
fclose(fid);

%% Print instructions
disp('-----------------------------------------------------------------')
fprintf('Please send the cut parts to the tailor (including return postage) or hand them in personally.\n');
fprintf('A label with the adress and a order letter was created. The opening hours are Thu-Fri 9:00am - 17:00pm.\n');
disp('-----------------------------------------------------------------')
disp('-----------------------------------------------------------------')

end