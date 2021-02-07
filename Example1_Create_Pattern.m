%% Exampel 1: How to use functions to create patten of made-to-measure shirt
% written by Christina Hein, 09/2019

%% inital state
close all; clc; clear all;
warning('off','all');

%% create struct of type 'human' 

% a) for a standard size
% human_example = create_human_from_size('female',36, 'Sam Sample');

% b) for individual measurements
% option 1: direct function input
human_example = create_human_from_measurement('Sam Sample','female', 33, 23, 40, 87, 63.5, 90.5, 58, 24.4, 15);
% 
% option 2: input help
% warning('on','all');
% human_example = create_human_from_measurement;
% save('human_example2', 'human_example');

% c) load existing struct
% load('human_example.mat');

%% create pattern
pattern = create_pattern_shirt(human_example, 'tight', 'long', 'round', 'plain_hem');

plot_basic_pattern(pattern);
plot_production_pattern(pattern)

%% optional: visual check of pattern
% plot_construction_points(pattern); hold on;
% plot_construction_points_sleeve(pattern);

% plot_all_sizes(pattern);

%% create production files 
 create_production_files_lc(human_example, pattern); % laser cutter
% create_production_files_ep(human_example, pattern); % external production

