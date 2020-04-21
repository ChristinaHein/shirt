function pattern = create_production_pattern_cuffs_neckline_simple(pattern, seam)
pattern.part_names = [pattern.part_names, "cuffs_neckline_simple"];

% length
l = pattern.construction_dimensions.necklength_front + pattern.construction_dimensions.necklength_back+seam;

% angle
alpha = pattern.construction_points.alpha_neck;

% create contour
PL = pattern.construction_points.B+[10 0];
PL = [PL; PL(1,:)+[0 -l]];
temp = (pattern.construction_dimensions.cm_cuff/2)/tan(alpha);
PL = [PL; PL(end,:)+[pattern.construction_dimensions.cm_cuff/2 temp]];
PL = [PL; PL(end-1,:)+[pattern.construction_dimensions.cm_cuff 0]];
PL = [PL; PL(1,:)+[pattern.construction_dimensions.cm_cuff 0]];

pattern.production_pattern = [pattern.production_pattern;PL; NaN NaN];
    