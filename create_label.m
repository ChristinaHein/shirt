function create_label(human, directory)
%% create_label(human, directory) - creates the label for a shirt
% (created by Christina M. Hein, 2019-June-28)
% (last changes Christina M. Hein, 2019-July-18)
%
% Creates the label for marking a shirt with the customers name and date of
% production. It creates a svg-file in the named directory which can be
% used for laser cutting and encraving.
%
% create_label(human, directory)
%
% === INPUT ARGUMENTS ===
% human     = struct containing name, type (male, female, child) and
%             body dimensions
% directory = directory name for production files
%
% === OUTPUT ARGUMENTS ===
% %

text = fileread('Template_Label.svg');

text = strrep(text,'Name',human.name);
d = date;
text = strrep(text,'Date',d);

filename = fullfile(directory, 'Label.svg');
fileID = fopen(filename,'w');
fprintf(fileID,text);
fclose(fileID);

end