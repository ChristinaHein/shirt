%% create_basic_pattern_sleeve(human, pattern) - creates the basic pattern of a sleeve
% (created by Christina M. Hein, 2019-May-22)
% (last changes by Christina M. Hein, 2019-August-02)
%
% This function creates a PL for the basic pattern of a sleeve for a
% shirt which is designed using the measurement data of the struct human.
% The PL is then added to the struct pattern into the field basic pattern.
% This function is intended to be used inside the function
% create_pattern_shirt.
%
% pattern = create_basic_pattern_sleeve(human, pattern)
%
% === INPUT ARGUMENTS ===
% human             = struct of type human (name, type, body dimensions)
% pattern           = struct for pattern, yet filled with construction
%                     points and optionally with other part's basic pattern
%                     created by create_pattern_shirt
%
% === OUTPUT ARGUMENTS ===
% pattern     = struct containing PL of construction points, CPLs of basic 
%               pattern and production pattern, part names, material and
%               label information.
%
% see create_human_from_measurement, create_human_from_size,
% create_pattern_shirt, create_sleeve_contour

function pattern = create_basic_pattern_sleeve(human, pattern)

    pattern.part_names = [pattern.part_names, "sleeve"];
    pattern = create_sleeve_contour(human,pattern);

    check_sleeve = pattern.construction_dimensions.ac-pattern.construction_dimensions.sac;
    correction_sleeve = check_sleeve;
    while abs(check_sleeve)> 0.2
        pattern = create_sleeve_contour(human,pattern, correction_sleeve);
        check_sleeve = pattern.construction_dimensions.ac-pattern.construction_dimensions.sac;
        correction_sleeve = correction_sleeve + check_sleeve/2;
    end

end
