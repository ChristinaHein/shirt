function pattern = shirt_extern_production_one(human, fit, sleeves)
%% pattern = shirt_extern_production_one(human, fit, sleeves) - creates the pattern and all files for extern production
% (created by Christina M. Hein, 2019-November-13)
% (last changes by Christina M. Hein, ---)
%
% This function creates the pattern and all necessary files for external 
% fabrication of the shirt at one supplier. It needs the customers 
% properties (human) and the shirt properties (fit, sleeves). The
% function creates a folder containing:
% - dxf-file of pattern
% - variable human (for documentation)
% - label adress
% - order E-Mail
% 
% EXAMPEL:
% pattern = shirt_extern_production_one(create_human_from_size('female',36, 'Sam Sample'), 'tight', 'long')
%
% === INPUT ARGUMENTS === 
% human     = struct containing name, type (male, female, child) and
%             body dimensions
% fit       = 'tight', 'regular' or 'loose'
% sleeves   = 'short', '3/4sleeves', 'long'
%
% === OUTPUT ARGUMENTS ===
% pattern     = struct containing PL of construction points, CPLs of basic 
%               pattern and production pattern, part names, material and
%               label information.
%
% see also 
% shirt_extern_production_two
% shirt_intern_production
% shirt_intern_cutting_extern_sewing

%% Pattern
pattern = create_pattern_shirt(human, fit, sleeves, 'round','simple_cuff');

if nargout == 0
    figure
    plot_basic_pattern(pattern);
    plot_production_pattern(pattern)
end

d = date;
directory = strcat(d,'_Production_Files_ep_one_',human.name);
create_production_files_ep(human, pattern, directory);
fprintf('A folder with the name %s was created with all files for your chosen fabrication type. \n', directory);

%% Label adress
filename = fullfile(directory, 'Adress_cutting.txt');
fid = fopen(filename,'w');
fprintf(fid,'waldmann-textech \nHerr Andreas Waldmann \nDurchaer Strasse 29-31 \n87471 Durach');
fclose(fid);

%% order E-Mail
filename = fullfile(directory, 'Order_mail_cutting_sewing.txt');
fid = fopen(filename,'w');
fprintf(fid,'waldmann-textech \nHerr Andreas Waldmann \nDurchaer Strasse 29-31 \n87471 Durach \n\n\n');
fprintf(fid,'Sehr geehrter Herr Waldmann,\n\nbitte schneiden Sie angefuegtem Schnittmusterplan die Teile aus Jersey (separat gesendet) zu\n');
fprintf(fid, 'und naehen Sie daraus ein Shirt.\n');
fprintf(fid,'Das fertige Shirt senden Sie bitte an: ADRESSE\n\n');
fprintf(fid,'Mit freundlichen Gruessen\nNAME');
fprintf(fid,'\n\n Anlage: Zuschneideplan als dxf-Datei');
fclose(fid);

%% Print instructions
disp('-----------------------------------------------------------------')
fprintf('Please send the dxf-files to info@waldmann-textech.de.\n');
fprintf('The pattern as dxf-file, an order E-Mail and a label with the adress (if you need to send fabric) were created. \n');
disp('-----------------------------------------------------------------')
disp('-----------------------------------------------------------------')
end