function plot_basic_pattern(pattern)

bp = pattern.basic_pattern; hold on;

plot(bp(:,1)', bp(:,2)','k');
daspect([1 1 1])

end