function [ sorted_final_score, sorted_final_idx ] = SCMtch4_retrieval_recom(all_total_model_struct, userSketInfos, genRecomTable,genRecomModelTable,modelSketInfos)

if ~exist('sketchOrPath', 'var')
    sketchOrPath = 'F:\sketch\total\m323_kangyang_0.png';  %输入手绘图
    fid = fopen('F:\sketch\total\m323_kangyang_0.txt');    %输入手绘图的Txt文件
    strokeSeq = fgetl(fid);
    fclose(fid);
    userName = 'kangyang';  %输入用户名
end

if isstr(sketchOrPath)
    [~,~,sketch] = imread(sketchOrPath);
end

globalVar;
 load 'F:\SCDict_unRota\15\all_total_model_struct.mat' all_total_model_struct
 load 'F:\SCRecomDict\\15\\userSketInfos.mat' userSketInfos
 load 'F:\SCRecomDict\\15\\genRecomTable.mat' genRecomTable
 load 'F:\SCRecomDict\\15\\genRecomModelTable.mat' genRecomModelTable
 load 'F:\SCRecomDict\\15\\modelSketInfos.mat' modelSketInfos

bwSket = im2bw(sketch, 0); %% 提取角点
opts.isPlot = 0; opts.harris_k = 0.12;
[cornerA] = findInterestPoints(bwSket, opts);
assignment = DBSCAN(cornerA, 2, 4); need_delete = [];
max_v = max(assignment); 
for i = 1 : max_v
    idx = find(assignment == i);
    need_delete = [need_delete, idx];
    sim_points = cornerA(idx,:);
    avg_sim_pts = mean(sim_points, 1);
    cornerA(end+1,:) = avg_sim_pts;
end
cornerA(need_delete,:) = [];
cornerA = unique(cornerA, 'rows'); 
[~, sket_articu_cont] = preproc_extractCont(sketch, strokeSeq); %%提取采样点

[sket_feats, sket_dist_mat, sket_ang_mat] = extractFeature(sket_articu_cont);
[corner_points_feats] = compu_corner_SC(cornerA, sket_articu_cont, sket_dist_mat, sket_ang_mat);

distance = 9999*ones(1, length(all_total_model_struct)); recom_factor = 0.95;
for model_idx = 1 : length(all_total_model_struct)
    if model_idx == 779
        asd = 123;
    end
    if userSketInfos.isKey(userName)
        drawCell = userSketInfos(userName);
        drawed = length(drawCell{model_idx}) >= 1;
        if drawed
            dist_A_B = assignDistanceA2B(corner_points_feats, drawCell{model_idx}{1}.the_feats);
            dist_B_A = assignDistanceA2B(drawCell{model_idx}{1}.the_corner_feats, sket_feats);
            distance(1, model_idx) = dist_A_B + dist_B_A;
        else
            userSim = genRecomTable.dist;
            userNames = genRecomTable.the_userNames;
            
            for id = 1 : length(userNames)
                if strcmp(userName, userNames{id}) == 1
                    the_uid = id;
                end
            end
            
            need_recom_sketchInfo = {};
            the_dist_between_user = userSim(the_uid,:);        %取出该用户与其他用户的距离向量
            [~, sorted_idx] = sort(the_dist_between_user, 'ascend');  %排序用户距离
            the_most_sim_userId = sorted_idx(2); 
            the_most_sim_userName = cell2mat(userNames(the_most_sim_userId));  %取出除自己外最相似的用户
            the_most_sim_drawCell = userSketInfos(the_most_sim_userName);
            the_most_sim_drawed = length(the_most_sim_drawCell{model_idx}) >= 1 && the_dist_between_user(the_most_sim_userId) ~= 999; %判断最相似的用户有没画过当前检索的模型
            
            if the_most_sim_drawed  %如果最相似用户画过当前检索的模型，则直接推荐该草图给该用户去计算相似度
                need_recom_sketchInfo{end+1} = the_most_sim_drawCell{model_idx}{1};
            end
            
            modelSim = genRecomModelTable.dist;
            the_dist_between_model = modelSim(model_idx,:);
            [~, sorted_model_idx] = sort(the_dist_between_model, 'ascend');
            the_most_sim_modelId = sorted_model_idx(2);
            the_most_sim_modelName = sprintf('m%d',the_most_sim_modelId-1);
            
            the_most_sim_model_drawCell = modelSketInfos(the_most_sim_modelName);
            the_most_sim_model_drawed = length(the_most_sim_model_drawCell{the_uid}) >= 1 && the_dist_between_model(the_most_sim_modelId) ~= 9999;
            if the_most_sim_model_drawed
                need_recom_sketchInfo{end+1} = the_most_sim_model_drawCell{the_uid}{1};
            end
            
            n_recom = length(need_recom_sketchInfo);
            
            if the_most_sim_drawed == 0 && the_most_sim_model_drawed == 0
                need_recom_sketchInfo{end+1} = all_total_model_struct{model_idx};
            end
            
            min_dist = 9999; 
            for i = 1 : length(need_recom_sketchInfo)
                if i <= n_recom
                    sketchInfo = need_recom_sketchInfo{i};
                    distA = assignDistanceA2B(corner_points_feats, sketchInfo.the_feats);
                    distB = assignDistanceA2B(sketchInfo.the_corner_feats, sket_feats);
                    recomDist = recom_factor * (distA+distB);
                    if recomDist < min_dist
                        min_dist = recomDist;
                    end
                else
                    projInfo = need_recom_sketchInfo{i};
                    for k = 1 : length(projInfo.viewName)
                        distA = assignDistanceA2B(corner_points_feats, projInfo.the_feats{k});
                        distB = assignDistanceA2B(projInfo.the_corner_feats{k}, sket_feats);
                        if min_dist > distA+distB
                            min_dist = distA+distB;
                        end
                    end
                end
            end
            distance(1, model_idx) = min_dist;
        end
    else
        projInfo = all_total_model_struct{model_idx};
        min_dist = 9999;
        for i = 1 : length(projInfo.viewName)
            distA = assignDistanceA2B(corner_points_feats, projInfo.the_feats{i});
            distB = assignDistanceA2B(projInfo.the_corner_feats{i}, sket_feats);
            if min_dist > distA+distB
                min_dist = distA+distB;
            end
        end
        distance(1, model_idx) = min_dist;
    end
    disp(model_idx);
end

[sorted_final_score, sorted_final_idx] = sort(distance, 'ascend');
figure(2);
for i = 1 : 25
    subplot(5,5,i); img = imread(sprintf('%sm%d_thumb.jpg','F:\projections\result\',sorted_final_idx(i)-1)); imshow(img);
end
end

