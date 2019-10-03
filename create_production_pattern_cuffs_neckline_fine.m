function pattern = create_production_pattern_cuffs_neckline_fine(pattern)
pattern.part_names = [pattern.part_names, "cuffs_neckline_fine"];

% length
l = pattern.construction_points.necklength_front + pattern.construction_points.necklength_back+10;

% width
w = pattern.construction_dimensions.cm_cuff;

% create contour
PL = pattern.construction_points.B+[20 0];
PL = [PL; PL(1,:)+[0 -l]];
PL = [PL; PL(end,:)+[pattern.construction_dimensions.cm_cuff 0]];
PL = [PL; PL(1,:)+[pattern.construction_dimensions.cm_cuff 0]];

pattern.production_pattern = [pattern.production_pattern;PL; NaN NaN];
    