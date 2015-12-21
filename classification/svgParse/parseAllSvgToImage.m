function [ filed ] = parseAllSvgToImage( D )
%max_value = 0;
filed = [];
for i = 1 : size(D,1);
    try
    disp(i);
    totalStroke = parseOneSvgToPts(D{i,3});
%     for j = 1 : length(totalStroke)
%         max_tmp = max(max(totalStroke{j}));
%         if max_tmp > max_value
%             max_value = max_tmp;
%         end
%     end
    [outImage] = drawSvgImage(totalStroke);
    imwrite(outImage, sprintf('D:\\svgToImage\\%d.png',i));
    
    catch
        filed = [filed i];
    end
end

end

