function [ rank ] = M4_recomRetrival( sketchOrPath, strokeSeq, userName )
if ~exist('sketchOrPath', 'var')
    sketchOrPath = 'F:\sketch\����ͼƬ\m39_wangfei_0.png';  %�����ֻ�ͼ
    projectionPath = 'F:\sketch\����ͼƬ\m39_6_1.png';  %����ͶӰͼ
    fid = fopen('F:\sketch\����ͼƬ\m39_wangfei_0.txt');    %�����ֻ�ͼ��Txt�ļ�
    strokeSeq = fgetl(fid);
    fclose(fid);
    userName = 'wangfei';  %�����û���
end

if isstr(sketchOrPath)
    [~,~,sketch] = imread(sketchOrPath);
end

all_total_model_struct = load ('F:\sketch\����ͼƬ\trainedData\trainedData\all_total_model_struct.mat'); 
aa  =all_total_model_struct.all_total_model_struct;
load 'F:\sketch\����ͼƬ\trainedData\trainedData\dictionary.mat' dictionary
load 'F:\sketch\����ͼƬ\trainedData\trainedData\eigvector.mat' eigvector
load 'F:\sketch\����ͼƬ\trainedData\trainedData\userSketInfos.mat' userSketInfos
load 'F:\sketch\����ͼƬ\trainedData\trainedData\genRecomTable.mat' genRecomTable
x = load ('F:\sketch\����ͼƬ\trainedData\trainedData\dictionary.mat');
dic = x.dictionary;
y = load ('F:\sketch\����ͼƬ\trainedData\trainedData\eigvector.mat');
dic2 = y.eigvector;

%�ֻ��ͼ��Ԥ����
image = csToMatlab(sketch);
boundImg = imageBoxBounding(image);
rescaleImg = imageResizeWithNearest(boundImg);
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, 0.8);
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, 200, 200);


%ͶӰͼ��Ԥ����
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
% sket_articu_cont һ�����鱣���������������ֵ
% n_contsamp �ܹ��ж��ٲ�����
% n_contsamp_of_conn_cont_mat Contours��ÿһ�β�����ĸ���
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
[sket_histogram] = assign_(dictionary, reduced_sket_feats); %��ȡ�ֻ�ͼ��ֱ��ͼ����
plot(sket_histogram,'-');
distance = 9999 * ones(1,2000); options.method = 'euclidean';
for model_idx = 1 : length(all_total_model_struct)
    if userSketInfos.isKey(userName)               %�жϵ�ǰ�û��Ƿ������û�
        drawCell = userSketInfos(userName);        %�������û���ȡ�����û�������Щģ��
        drawed = length(drawCell{model_idx}) >= 1;
        if drawed                                  %������û�������ǰ������ģ�ͣ���ֱ�������ֻ�ͼ�������
            the_histogram = drawCell{model_idx}{1}.the_histogram;
            distance(1, model_idx) = calcDist(sket_histogram, the_histogram, options);
        else                                       %������û�û������ǰ������ģ�ͣ����ҵ���������û����Ƽ�
            userSim = genRecomTable.dist;
            userNames = genRecomTable.the_userNames; the_uid = 0;
            
            for id = 1 : length(userNames)
                if strcmp(userName, userNames{id}) == 1
                    the_uid = id;
                end
            end
            the_dist_between_user = userSim(the_uid,:);        %ȡ�����û��������û��ľ�������
            [~, sorted_idx] = sort(the_dist_between_user, 'ascend');  %�����û�����
            the_most_sim_userId = sorted_idx(2); the_most_sim_userName = cell2mat(userNames(the_most_sim_userId));  %ȡ�����Լ��������Ƶ��û�
            the_most_sim_drawCell = userSketInfos(the_most_sim_userName); 
            the_most_sim_drawed = length(the_most_sim_drawCell{model_idx}) >= 1; %�ж������Ƶ��û���û������ǰ������ģ��
            if the_most_sim_drawed  %����������û�������ǰ������ģ�ͣ���ֱ���Ƽ��ò�ͼ�����û�ȥ�������ƶ�
                the_histogram = the_most_sim_drawCell{model_idx}{1}.the_histogram;
                distance(1, model_idx) = calcDist(sket_histogram, the_histogram, options);
            else %����������û�Ҳû��������ֱ��ƥ��14��ͶӰͼȡ��С��ֱ��ͼ���룬��Ϊ�뵱ǰ����ģ�͵ľ���
                the_histograms = all_total_model_struct{model_idx}.the_histograms;
                tmp_dist = [];
                for i = 1 : size(the_histograms,1)
                    tmp_dist = [tmp_dist calcDist(sket_histogram,the_histograms(i,:),options)];
                end
                [sorted_score_14_view] = sort(tmp_dist, 'ascend');
                distance(1, model_idx) = sorted_score_14_view(1);
            end
        end
    else  %���Ϊ���û���ֱ��ƥ��14��ͶӰͼ
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

