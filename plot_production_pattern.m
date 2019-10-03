function plot_production_pattern(pattern)

bp = pattern.production_pattern;

plot(bp(:,1), bp(:,2),'r'); hold on;
daspect([1 1 1])

end