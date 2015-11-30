function [ rank ] = M4_recomRetrival( sketchOrPath, strokeSeq, userName )
if ~exist('sketchOrPath', 'var')
    sketchOrPath = 'F:\sketch\测试图片\m39_wangfei_0.png';  %输入手绘图
    projectionPath = 'F:\sketch\测试图片\m39_6_1.png';  %输入投影图
    fid = fopen('F:\sketch\测试图片\m39_wangfei_0.txt');    %输入手绘图的Txt文件
    strokeSeq = fgetl(fid);
    fclose(fid);
    userName = 'wangfei';  %输入用户名
end

if isstr(sketchOrPath)
    [~,~,sketch] = imread(sketchOrPath);
end

all_total_model_struct = load ('F:\sketch\测试图片\trainedData\trainedData\all_total_model_struct.mat'); 
aa  =all_total_model_struct.all_total_model_struct;
load 'F:\sketch\测试图片\trainedData\trainedData\dictionary.mat' dictionary
load 'F:\sketch\测试图片\trainedData\trainedData\eigvector.mat' eigvector
load 'F:\sketch\测试图片\trainedData\trainedData\userSketInfos.mat' userSketInfos
load 'F:\sketch\测试图片\trainedData\trainedData\genRecomTable.mat' genRecomTable
x = load ('F:\sketch\测试图片\trainedData\trainedData\dictionary.mat');
dic = x.dictionary;
y = load ('F:\sketch\测试图片\trainedData\trainedData\eigvector.mat');
dic2 = y.eigvector;

%手绘草图的预处理
image = csToMatlab(sketch);
boundImg = imageBoxBounding(image);
rescaleImg = imageResizeWithNearest(boundImg);
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, 0.8);
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, 200, 200);


%投影图的预处理
% [image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg]= preprocessProjImage(projectionPath,200);
% img= checkangle2(filledFixExpandImg)

imshow(fixExpandImg);
Contours = downSampleSketCont(strokeSeq);
[cellm,celln]=size(Contours);
gg = Contours{1};
 img = zeros(400,400);
 mm=1;
 for i=1:cellm
     arraynm = Contours{i};
     [arrayn,arraym] = size(arraynm);
     
     for k=1:arraym-1
         nn1=arraynm(:,k);
         nn2=arraynm(:,k+1);
         img = DrawLineImage(img,nn1(1,1),nn1(2,1),nn2(1,1),nn2(2,1));
         imshow(img);
     end 
 end
% sket_articu_cont 一个数组保存清晰化后的坐标值
% n_contsamp 总共有多少采样点
% n_contsamp_of_conn_cont_mat Contours中每一段采样点的个数
% [sket_articu_cont, sket_n_contsamp, sket_n_contsamp_of_conn_cont_mat, sket_adjacencyList] = articulateSketContour(Contours, 5);
% 
% 
%  xx = sket_articu_cont(:,1);
%  yy=  sket_articu_cont(:,2);
%  plot(xx,yy,'r.');
%  [lines,m] = size(sket_n_contsamp_of_conn_cont_mat);
%  img = zeros(400,400);
%  mm=1;
%  for i=1:lines
%      for k=mm:sket_n_contsamp_of_conn_cont_mat(i)+mm-2
%          img = DrawLineImage(img,xx(k),yy(k),xx(k+1),yy(k+1));
%          imshow(img);
%      end
%      mm =mm+sket_n_contsamp_of_conn_cont_mat(i);
%  end
%  img = imdilate(img,[1,1;1,1])
%  imshow(img);
img= checkangle2(img)




% ll =checkangle(fixExpandImg);







% plot(sket_adjacencyList(:,1), sket_adjacencyList(:,2), '.');

[sket_feats] = extractFeature(sket_articu_cont);
reduced_sket_feats = sket_feats' * eigvector;
[sket_histogram] = assign_(dictionary, reduced_sket_feats); %提取手绘图的直方图特征
plot(sket_histogram,'-');
distance = 9999 * ones(1,2000); options.method = 'euclidean';
for model_idx = 1 : length(all_total_model_struct)
    if userSketInfos.isKey(userName)               %判断当前用户是否是新用户
        drawCell = userSketInfos(userName);        %不是新用户则取出该用户画过哪些模型
        drawed = length(drawCell{model_idx}) >= 1;
        if drawed                                  %如果该用户画过当前检索的模型，则直接用其手绘图计算距离
            the_histogram = drawCell{model_idx}{1}.the_histogram;
            distance(1, model_idx) = calcDist(sket_histogram, the_histogram, options);
        else                                       %如果该用户没画过当前检索的模型，则找到最相近的用户做推荐
            userSim = genRecomTable.dist;
            userNames = genRecomTable.the_userNames; the_uid = 0;
            
            for id = 1 : length(userNames)
                if strcmp(userName, userNames{id}) == 1
                    the_uid = id;
                end
            end
            the_dist_between_user = userSim(the_uid,:);        %取出该用户与其他用户的距离向量
            [~, sorted_idx] = sort(the_dist_between_user, 'ascend');  %排序用户距离
            the_most_sim_userId = sorted_idx(2); the_most_sim_userName = cell2mat(userNames(the_most_sim_userId));  %取出除自己外最相似的用户
            the_most_sim_drawCell = userSketInfos(the_most_sim_userName); 
            the_most_sim_drawed = length(the_most_sim_drawCell{model_idx}) >= 1; %判断最相似的用户有没画过当前检索的模型
            if the_most_sim_drawed  %如果最相似用户画过当前检索的模型，则直接推荐该草图给该用户去计算相似度
                the_histogram = the_most_sim_drawCell{model_idx}{1}.the_histogram;
                distance(1, model_idx) = calcDist(sket_histogram, the_histogram, options);
            else %如果最相似用户也没画过，则直接匹配14个投影图取最小的直方图距离，作为与当前检索模型的距离
                the_histograms = all_total_model_struct{model_idx}.the_histograms;
                tmp_dist = [];
                for i = 1 : size(the_histograms,1)
                    tmp_dist = [tmp_dist calcDist(sket_histogram,the_histograms(i,:),options)];
                end
                [sorted_score_14_view] = sort(tmp_dist, 'ascend');
                distance(1, model_idx) = sorted_score_14_view(1);
            end
        end
    else  %如果为新用户则直接匹配14个投影图
        the_histograms = all_total_model_struct{model_idx}.the_histograms;
        tmp_dist = [];
        for i = 1 : size(the_histograms,1)
            tmp_dist = [tmp_dist calcDist(sket_histogram,the_histograms(i,:),options)];
        end
        [sorted_score_14_view] = sort(tmp_dist, 'ascend');
        distance(1, model_idx) = sorted_score_14_view(1);
    end
end

[sorted_final_score, sorted_final_idx] = sort(distance, 'ascend');
figure(2);
for i = 1 : 25
    subplot(5,5,i); img = imread(sprintf('%sm%d_thumb.jpg','F:\projections\result\',sorted_final_idx(i)-1)); imshow(img);
end

end

