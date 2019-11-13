function pattern = shirt_intern_production (human, fit, sleeves)
%% pattern = shirt_intern_production(human, fit, sleeves) - creates the pattern and all files for extern production
% (created by Christina M. Hein, 2019-November-13)
% (last changes by Christina M. Hein, ---)
%
% This function creates the pattern and all necessary files for intern
% fabrication of the shirt. It needs the customers 
% properties (human) and the shirt properties (fit, sleeves). The
% function creates a folder containing:
% - svg-files of pattern
% - variable human (for documentation)
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
% shirt_intern_cutting_extern_sewing

%% Pattern

pattern = create_pattern_shirt(human, fit, sleeves, 'round','plain_hem');

if nargout == 0
    plot_basic_pattern(pattern);
    plot_production_pattern(pattern)
end

directory = create_production_files_lc(human, pattern);
fprintf('A folder with the name %s was created with all files for your chosen fabrication type. \n', directory);
% Tutorial cutting and sewing
%disp('You can use them to directly cut the fabric with a laser cutter. A tutorial can be found in the same folder');
end