function pattern = shirt_extern_production_two(human, fit, sleeves)
%% pattern = shirt_extern_production_two(human, fit, sleeves) - creates the pattern and all files for extern production
% (created by Christina M. Hein, 2019-November-13)
% (last changes by Christina M. Hein, ---)
%
% This function creates the pattern and all necessary files for external 
% fabrication of the shirt at two suppliers. It needs the customers 
% properties (human) and the shirt properties (fit, sleeves). The
% function creates a folder containing:
% - dxf-file of pattern
% - variable human (for documentation)
% - label adress for cutting and sewing
% - order Mail for cutting and sewing
% 
% EXAMPEL:
% pattern = shirt_extern_production_two(create_human_from_size('female',36, 'Sam Sample'), 'slim', 'long')
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
% shirt_intern_production
% shirt_intern_cutting_extern_sewing

%% Pattern
pattern = create_pattern_shirt(human, fit, sleeves, 'round','plain_hem');

if nargout == 0
    plot_basic_pattern(pattern);
    plot_production_pattern(pattern)
end

directory = create_production_files_ep(human, pattern);
fprintf('A folder with the name %s was created with all files for your chosen fabrication type. \n', directory);

%% Label adress and Mail cutting
% Label adress
filename = fullfile(directory, 'Adress_cutting.txt');
fid = fopen(filename,'w');
fprintf(fid,'waldmann-textech \nHerr Andreas Waldmann \nDurchaer Strasse 29-31 \n87471 Durach');
fclose(fid);

% order E-Mail cutting
filename = fullfile(directory, 'Order_mail_cutting.txt');
fid = fopen(filename,'w');
fprintf(fid,'waldmann-textech \nHerr Andreas Waldmann \nDurchaer Strasse 29-31 \n87471 Durach \n\n\n');
fprintf(fid,'Sehr geehrter Herr Waldmann,\n\nbitte schneiden Sie angefügtem Schnittmusterplan die Teile aus Jersey (separat gesendet) zu.\n');
fprintf(fid,'Das zugeschnittenen Teile senden Sie bitte an: ADRESSE\n\n');
fprintf(fid,'Mit freundlichen Gruessen\n NAME');
fprintf(fid,'\n\n Anlage: Zuschneideplan als dxf-Datei');
fclose(fid);

%% Label adress and mail sewing
% Label adress
filename = fullfile(directory, 'Adress_tailor.txt');
fid = fopen(filename,'w');
fprintf(fid,'Altenburger Anja \nMass u. Aenderungsschneiderei \nGruenwalder Str. 24 \n81547 Muenchen');
fclose(fid);

% order letter
filename = fullfile(directory, 'Order_tailor.txt');
fid = fopen(filename,'w');
fprintf(fid,'Altenburger Anja \nMass u. Aenderungsschneiderei \nGruenwalder Str. 24 \n81547 Muenchen \n\n\n');
fprintf(fid,'Sehr geehrte Frau Altenburger,\n\nbitte naehen Sie aus den angefuegten Schnittmusterteilen ein Shirt.\n');
fprintf(fid,'Das fertige Shirt senden Sie bitte an: ADRESSE\n\n');
fprintf(fid,'Mit freundlichen Gruessen\n NAME');
fclose(fid);

%% Print instructions
disp('-----------------------------------------------------------------')
fprintf('Step 1: Please send the dxf-files to info@waldmann-textech.de.\n');
fprintf('The pattern as dxf-file, an order E-Mail and a label with the adress (if you need to send fabric) were created. \n');
fprintf('Step 2: As soon as you receive the cutted parts please send the cut parts to the tailor (including return postage) or hand them in personally.\n');
fprintf('A label with the adress and a order letter was created. The opening hours are Thu-Fri 9:00am - 17:00pm.\n');
end