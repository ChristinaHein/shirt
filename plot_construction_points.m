function plot_construction_points(pattern)

cp = pattern.construction_points;

%figure
%vertical
plot_line_2P(cp.A, cp.B);
hold on;
plot_line_2P(cp.D, cp.C);
plot_line_2P(cp.F, cp.E);
plot_line_2P(cp.x, cp.x1);
plot_line_2P(cp.y, cp.y1);
plot_line_2P(cp.z, cp.z1);

%horizontal
plot_line_2P(cp.B, cp.E);
plot_line_2P(cp.A, cp.F);
plot_line_2P(cp.E1, cp.b3);
plot_line_2P(cp.F1, cp.a1);