function plotPoints( points )
plot(points(:,1), points(:,2), '.');
grid on;
for i = 1 : size(points, 1)
    text(points(i,1), points(i,2), [num2str(i)], 'color','b');
end

end

