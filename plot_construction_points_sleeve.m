function plot_construction_points_sleeve(pattern)
if ~strcmp(pattern.property.sleeve_length,'sleeveless')
    cp = pattern.construction_points;

    % figure

    % vertical
    plot_line_2P(cp.sA, cp.sB);
    hold on;
    plot_line_2P(cp.sF, cp.sG);
    plot_line_2P(cp.sa, cp.sH);
    daspect([1 1 1])

    % horizontal
    plot_line_2P(cp.sA, cp.sa);
    plot_line_2P(cp.sC, cp.sE);
    plot_line_2P(cp.sB, cp.sH);

    % incicline
    plot_line_2P(cp.sC, cp.sD);
    plot_line_2P(cp.sD, cp.sE);

    % points
    plot(cp.P1(1),cp.P1(2), '*');
    plot(cp.P2(1),cp.P2(2), '*');
    plot(cp.P3(1),cp.P3(2), '*');
    plot(cp.P1a(1),cp.P1a(2), '*');
    plot(cp.P1b(1),cp.P1b(2), '*');
    plot(cp.P3a(1),cp.P3a(2), '*');
end
end