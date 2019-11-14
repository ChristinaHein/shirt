%% Exampel: How to use functions to create all files for  a made-to-measure shirt
%
% written by Christina Hein, 11/2019

close all; clc; clear all;

%% take measurements
% Open dimensionsheet for measurement description and note 
open('Dimensionsheet.pdf');

%% create struct of type 'human' for individual measurements

% option 1: direct function input
human_example = create_human_from_measurement('Sam Sample','female', 33, 23, 40, 87, 63.5, 90.5, 58, 24.4, 15);
 
% option 2: input help
% human_example = create_human_from_measurement;


%% define shirt properties
fit = 'slim';
sleeve = 'long';

%% a) prepare internal fabrication
% approx. 3 hours personnel costs for student assistants ~ 45 Euro
% material costs for 1.5 m fabric ~ 15 Euro
% estimated costs: 60 Euro (without machine costs)

pattern = shirt_intern_production (human_example, fit, sleeve);

plot_basic_pattern(pattern);
plot_production_pattern(pattern);
% plot_all_sizes(pattern); % optional: visual check of pattern


%% b) prepare internal cutting and external sewing
% cutting: approx. 1/2 hour personnel costs for student assistants ~ 8 Euro
% sewing: Tailor ~ 40 Euro
% material costs for 1.5 m fabric ~ 15 Euro
% estimated costs: 63 Euro (without machine costs)

shirt_intern_cutting_extern_sewing(human_example, fit, sleeve);

%% c) prepare external cutting and sewing at TWO suppliers
% cutting: Waldman Textech ~ 90 Euro
% sewing: Tailor ~ 40 Euro
% material costs for 2 m fabric ~ 20 Euro
% estimated costs: 150 Euro

shirt_extern_production_two(human_example, fit, sleeve);

%% d) prepare external cutting and sewing at ONE supplier
% cutting and sewing: Waldmann Textech ~ 250 Euro
% material costs for 2 m fabric ~ 20 Euro
% estimated costs: 270 Euro

shirt_extern_production_one(human_example, fit, sleeve);

