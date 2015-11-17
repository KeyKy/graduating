function [ rank ] = M4_recomRetrival_v2( sketchOrPath, strokeSeq, userName )
if ~exist('sketchOrPath', 'var')
    sketchOrPath = 'F:\sketch\total\m531_kangyang_0.png';  %�����ֻ�ͼ
    fid = fopen('F:\sketch\total\m531_kangyang_0.txt');    %�����ֻ�ͼ��Txt�ļ�
    strokeSeq = fgetl(fid);
    fclose(fid);
    userName = 'kangyang';  %�����û���
end

if isstr(sketchOrPath)
    [~,~,sketch] = imread(sketchOrPath);
end

load 'F:\dict\z_total_all_data\all_total_model_struct.mat' all_total_model_struct
load 'F:\dict\z_total_all_data\dictionary.mat' dictionary
load 'F:\dict\z_total_all_data\eigvector.mat' eigvector
load 'F:\dict\userSketInfos.mat' userSketInfos
load 'F:\dict\genRecomTable.mat' genRecomTable

image = csToMatlab(sketch);
boundImg = imageBoxBounding(image);
rescaleImg = imageResizeWithNearest(boundImg);
rescaleBinaryImg = imageRescaledBinaryzation(rescaleImg, 0.8);
fixExpandImg = imageBoundaryExpandFixSize(rescaleBinaryImg, 200, 200);
Contours = downSampleSketCont(strokeSeq);

[sket_articu_cont, sket_n_contsamp, sket_n_contsamp_of_conn_cont_mat, sket_adjacencyList] = articulateSketContour(Contours, 5);
plot(sket_articu_cont(:,1), 200 - sket_articu_cont(:,2), '.');

[sket_feats] = extractFeature(sket_articu_cont);
reduced_sket_feats = sket_feats' * eigvector;
[sket_histogram] = assign_(dictionary, reduced_sket_feats); %��ȡ�ֻ�ͼ��ֱ��ͼ����

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
            temp_dist = []; ifExistUserDraw = 0;
            for si = 2 : length(floor(sorted_idx/2))
                the_most_sim_userId = sorted_idx(si); 
                the_most_sim_userName = cell2mat(userNames(the_most_sim_userId));  %ȡ�����Լ��������Ƶ��û�
                the_most_sim_drawCell = userSketInfos(the_most_sim_userName); 
                the_most_sim_drawed = length(the_most_sim_drawCell{model_idx}) >= 1; %�ж������Ƶ��û���û������ǰ������ģ��
                if the_most_sim_drawed  %����������û�������ǰ������ģ�ͣ���ֱ���Ƽ��ò�ͼ�����û�ȥ�������ƶ�
                    the_histogram = the_most_sim_drawCell{model_idx}{1}.the_histogram;
                    temp_dist = [temp_dist calcDist(sket_histogram, the_histogram, options)];
                    ifExistUserDraw = 1;
                end
            end
            if ifExistUserDraw == 1
                distance(1, model_idx) = min(temp_dist);
            else %����������û�Ҳû��������ֱ��ƥ��14��ͶӰͼȡ��С��ֱ��ͼ���룬��Ϊ�뵱ǰ����ģ�͵ľ���
                the_histograms = all_total_model_struct{model_idx}.the_histograms(1:2:end,:);
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
    subplot(5,5,i); img = imread(sprintf('%s%d_thumb.jpg','F:\projections\result\m',sorted_final_idx(i)-1)); imshow(img);
end

end

