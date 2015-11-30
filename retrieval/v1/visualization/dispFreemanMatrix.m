%mat = rand(5);           %# A 5-by-5 matrix of random values from 0 to 1
mat = [ 0 0 0 0 0 0
        0 1 1 0 0 0
        0 0 0 1 0 0
        0 0 0 1 0 0
        0 0 0 0 0 0
        0 0 0 0 0 0];
pcolor(mat);
colormap(flipud(gray));
axis ij
axis square
[x,y] = meshgrid(1:5);   %# Create x and y coordinates for the strings
set(gca,'XTick',1.5:5.5,...                         %# Change the axes tick marks
        'XTickLabel',{'1','2','3','4','5'},...      %#   and tick labels
        'XAxisLocation', 'top',...
        'YTick',1.5:5.5,...
        'YTickLabel',{'1','2','3','4','5'},...
        'TickLength',[0 0]);
if 0
imagesc(mat);            %# Create a colored plot of the matrix values


colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

textStrings = num2str(mat(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:5);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
v = get(gca,'CLim');
midValue = mean(v);  %# Get the middle value of the color range
textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
c = num2cell(textColors,2);                                             
set(hStrings,{'Color'}, c);  %# Change the text colors

set(gca,'XTick',1.5:5.5,...                         %# Change the axes tick marks
        'XTickLabel',{'1','2','3','4','5'},...  %#   and tick labels
        'XAxisLocation', 'top',...
        'YTick',1.5:5.5,...
        'YTickLabel',{'1','2','3','4','5'},...
        'TickLength',[0 0]);
end
