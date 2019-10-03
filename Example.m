%% Exampel: How to use functions to create a made-to-measure shirt
%
% written by Christina Hein, 09/2019

close all; clc; clear all;

%% create struct of type 'human' 

% a) for a standard size
% human_example = create_human_from_size('female',36, 'Sam Sample');

% b) for individual measurements
% human_example = create_human_from_measurement;

% c) load existing struct
load('human_example.mat');

%% create pattern
pattern = create_pattern_shirt(human_example, 'slim', 'long', 'round');

plot_basic_pattern(pattern);
plot_production_pattern(pattern)

%% optional: visual check of pattern
% plot_construction_points(pattern); hold on;
% plot_construction_points_sleeve(pattern);

% plot_all_sizes(pattern);

%% create production files
create_production_files(human_example, pattern);

