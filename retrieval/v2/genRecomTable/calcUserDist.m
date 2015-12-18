function dist = calcUserDist(u1Info, u2Info, bothDrawModelIdx)
%利用SC的指派问题计算距离
dist = 0; 
n_bothDraw = length(bothDrawModelIdx);
for i = 1 : n_bothDraw
    u1_sketchStruct = u1Info{bothDrawModelIdx(i)}{1};
    u2_sketchStruct = u2Info{bothDrawModelIdx(i)}{1};
    
    [A2B_dist, A2B_assignment, ~] = assignDistanceA2B(u1_sketchStruct.the_corner_feats, u2_sketchStruct.the_feats);
    [B2A_dist, B2A_assignment, ~] = assignDistanceA2B(u2_sketchStruct.the_corner_feats, u1_sketchStruct.the_feats);
    
%     fig1 = figure(1); [~,~,sketchB] = imread(u2_sketchStruct.the_png_path); imshow(255 - sketchB); hold on;
%     plot(u2_sketchStruct.the_articu_cont(:,1), u2_sketchStruct.the_articu_cont(:,2), 'r*'); hold on;
%     for j = 1 : length(A2B_assignment)
%         plot(u2_sketchStruct.the_articu_cont(A2B_assignment(j),1), u2_sketchStruct.the_articu_cont(A2B_assignment(j),2), 'r*'); hold on;
%         text(u2_sketchStruct.the_articu_cont(A2B_assignment(j),1), u2_sketchStruct.the_articu_cont(A2B_assignment(j),2), num2str(j), 'Color', 'blue'); hold on;
%     end
%     
%     fig2 = figure(2); [~,~,sketchA] = imread(u1_sketchStruct.the_png_path); imshow(255 - sketchA); hold on;
%     for j = 1 : size(u1_sketchStruct.the_corner, 1)
%         plot(u1_sketchStruct.the_corner(j,2), u1_sketchStruct.the_corner(j,1), 'k.'); hold on;
%         text(u1_sketchStruct.the_corner(j,2), u1_sketchStruct.the_corner(j,1), num2str(j), 'Color', 'blue'); hold on;
%     end

%     fig1 = figure(1); [~,~,sketchA] = imread(u1_sketchStruct.the_png_path); imshow(255 - sketchA); hold on;
%     plot(u1_sketchStruct.the_articu_cont(:,1), u1_sketchStruct.the_articu_cont(:,2), 'r*'); hold on;
%     for j = 1 : length(B2A_assignment)
%         plot(u1_sketchStruct.the_articu_cont(B2A_assignment(j),1), u1_sketchStruct.the_articu_cont(B2A_assignment(j),2), 'r*'); hold on;
%         text(u1_sketchStruct.the_articu_cont(B2A_assignment(j),1), u1_sketchStruct.the_articu_cont(B2A_assignment(j),2), num2str(j), 'Color', 'blue'); hold on;
%     end
%     
%     fig2 = figure(2); [~,~,sketchB] = imread(u2_sketchStruct.the_png_path); imshow(255 - sketchB); hold on;
%     for j = 1 : size(u2_sketchStruct.the_corner, 1)
%         plot(u2_sketchStruct.the_corner(j,2), u2_sketchStruct.the_corner(j,1), 'k.'); hold on;
%         text(u2_sketchStruct.the_corner(j,2), u2_sketchStruct.the_corner(j,1), num2str(j), 'Color', 'blue'); hold on;
%     end
%     
%     close(fig1); close(fig2);
    dist = dist + A2B_dist + B2A_dist;
end
dist = dist / n_bothDraw;
end