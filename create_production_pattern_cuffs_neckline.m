function pattern = create_production_pattern_cuffs_neckline(pattern, allowance, varargin)
%% pattern = create_production_pattern_cuffs_neckline(pattern, allowance, [factor_shorten]) - creates a pattern of neckline cuff
% (created by Christina M. Hein, 2019-October-11)
% (last changes by Christina M. Hein, -)
%
% This function creates the production pattern for the neckline cuff.
%
% pattern = create_production_pattern_cuffs_neckline(pattern, allowance, [factor_shorten]) 
%
% === INPUT ARGUMENTS ===
% pattern           = struct of type pattern (for neckline length)
% allowance         = allowance, for seam or to be shorten while sewing
% factor_shorten    = factor to shorten length
%
% === OUTPUT ARGUMENTS ===
% pattern     = struct containing PL of construction points, CPLs of basic 
%               pattern and production pattern, part names, material and
%               label information - with cuffs_neckline added


pattern.part_names = [pattern.part_names, "cuffs_neckline"];

% only want 1 optional inputs at most
numvarargs = length(varargin);
if numvarargs > 1
    error('create_production_ pattern_cuffs_neckline: Too many inputs, requieres at most 4 optional inputs')
end

% set defaults for optional inputs
if numvarargs == 0
    factor_shorten = 1;
elseif numvarargs == 1
    [factor_shorten] = varargin{1};
else 
    error('create_production_pattern_cuffs_neckline: Too many input arguments.');
end

% length
l = pattern.construction_points.necklength_front + pattern.construction_points.necklength_back+allowance;
l = l*factor_shorten;

% width
w = pattern.construction_dimensions.cm_cuff;

% create contour
PL = pattern.construction_points.B+[20 0];
PL = [PL; PL(1,:)+[0 -l]];
PL = [PL; PL(end,:)+[pattern.construction_dimensions.cm_cuff 0]];
PL = [PL; PL(1,:)+[pattern.construction_dimensions.cm_cuff 0]];

pattern.production_pattern = [pattern.production_pattern;PL; NaN NaN];
    