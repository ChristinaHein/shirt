%% Exampel: How to use functions to create a made-to-measure shirt
%
% written by Christina Hein, 09/2019

close all; clc; clear all;

%% create struct of type 'human' 

% a) for a standard size
% human_example = create_human_from_size('female',36, 'Sam Sample');

% b) for individual measurements
human_example = create_human_from_measurement;
save('human_example2', 'human_example');

% c) load existing struct
% % load('human_example.mat');

%% create pattern
pattern = create_pattern_shirt(human_example, 'slim', 'sleeveless', 'v','plain_hem');

plot_basic_pattern(pattern);
plot_production_pattern(pattern)

%% optional: visual check of pattern
% plot_construction_points(pattern); hold on;
% plot_construction_points_sleeve(pattern);

plot_all_sizes(pattern);

%% create production files 
% directly
%create_production_files_lc(human_example, pattern); % laser cutter
%create_production_files_ep(human_example, pattern); % external production

% or geht help (name of suppliers, tutorials, etc.)
help_on_fabrication(human_exampel, pattern)

