function plot_all_sizes(pattern)
% plot all standard sizes with the same properties as the pattern which is
% supposed to be compared

if strcmp(pattern.property.type,'female')
    size = 32:2:46;
elseif strcmp(pattern.property.type,'male')
    size = 42:2:60;
end

for i=1:length(size)
    human = create_human_from_size(pattern.property.type,size(i),'test');
    pattern = create_pattern_shirt(human, pattern.property.fit, pattern.property.sleeve_length, pattern.property.neckline);
    plot(pattern.basic_pattern(:,1)', pattern.basic_pattern(:,2)','--');
    hold on;
    daspect([1 1 1]);
end
