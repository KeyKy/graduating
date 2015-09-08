% �ֻ�ͼ��ͶӰͼ������ͬĿ¼�£�ͨ���ļ���ǰ׺( m �� s ) ���� (��չ����Ϊ png )
addPathsAndLoadVariables;
sket_training_set_arr = generate_training_or_testing_arr('C:\MATLAB\P_R_Curves\splitedTrain.txt');
% ��㣺��Ŀ¼�µĸ�������Ŀ¼
categoryNamesDirs = dir(txtViewFilePath);       % �г�����ĸ�Ŀ¼�µ�������Ŀ¼
categoryNamesDirsArr = struct2cell(categoryNamesDirs)' ;    % �ṹ��(struct����)ת����Ԫ������(cell)��ת��һ�������ļ�����������
categoryNamesArr = categoryNamesDirsArr( : , 1);   % ��һ����Ŀ¼��
category_names_num = size(categoryNamesArr);
for category_idx = 3 : category_names_num         % �±��3��ʼѭ������ΪĿ¼���±�Ϊ1����'.',�±�Ϊ2����'..'
    categoryName = cell2mat(categoryNamesArr(category_idx));
    % �ֱ�ѵ���ô�����άģ�͵� front �� side �� top ��ͼ�� �����ָ�CRF ģ��
    for view_idx = 1 : 3
        switch view_idx
            case 1
                viewName = 'front';
            case 2
                viewName = 'side';
            case 3
                viewName = 'top';
        end
        labeledFilePathCellArr = {};    % ѭ����ȡ�ô�����ļ��������Ƿ��Ѿ����˱�ǣ�����·������ labeledFilePathCellArr �� unlabeledFilePathCellArr
        unlabeledFilePathCellArr = {};
        for img_type_idx = 1 : 2
            % �в㣺����Ŀ¼�µĸ���С��Ŀ¼
            classNamesDirs = dir(fullfile(txtViewFilePath, categoryName));       % �г�����ĸ�Ŀ¼�µ�������Ŀ¼
            classNamesDirsArr = struct2cell(classNamesDirs)' ;    % �ṹ��(struct����)ת����Ԫ������(cell)��ת��һ�������ļ�����������
            classNamesArr = classNamesDirsArr( : , 1);   % ��һ����Ŀ¼��
            class_names_num = size(classNamesArr);
            for class_idx = 3 : class_names_num          % �±��3��ʼѭ������ΪĿ¼���±�Ϊ1����'.',�±�Ϊ2����'..'
                className = cell2mat(classNamesArr(class_idx));
                % �ڲ㣺С��Ŀ¼�µĸ��ӽǵĸ����ļ�
                if img_type_idx == 1
                    fileNamesDirs = dir(fullfile(txtViewFilePath, categoryName, className, sprintf('m*%s.png', viewName)));   % ������Ӧ�ӽǵ� png �ļ���·��
                elseif img_type_idx == 2
                    fileNamesDirs = dir(fullfile(txtViewFilePath_for_SKET, categoryName, className, sprintf('s*%s.png', viewName)));   % ������Ӧ�ӽǵ� png �ļ���·��
                end
                fileNamesDirsArr = struct2cell(fileNamesDirs)' ;    % �ṹ��(struct����)ת����Ԫ������(cell)��ת��һ�������ļ�����������
                fileNamesArr = fileNamesDirsArr( : , 1);   % ��һ�����ļ���
                file_names_num = size(fileNamesArr);
                for file_idx = 1 : file_names_num       % ע���ļ����±겻�漰'.'��'..'������Ӧ�ô�1��ʼ����ͬ��Ŀ¼�±꣨��3��ʼ��
                    imageFilename = cell2mat(fileNamesArr(file_idx));             % projImgFilename ��ʽ e.g., m267_front.png  or  s123_side.png
                    % ����label�ļ����������ҵ���Ӧ��ͼ���ļ�������ӦĿ¼
                    
                    splitted_projImgFilename = regexp(imageFilename, '\.', 'split');
                    projImgFilename_without_extension = cell2mat(splitted_projImgFilename( : , 1));
                    labelFilename = sprintf('seg_%s.txt', projImgFilename_without_extension);             % labelFilename ��ʽ e.g.��seg_m267_front.txt
                    
                    % ƴ��·��������Ӧ��ͼ�ļ�
                    if img_type_idx == 1
                        fullFilenameWithPath = fullfile(txtViewFilePath, categoryName, className, imageFilename);
                        [image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(fullFilenameWithPath, imgEdgeLength);
                        fullLabelFilenameWithPath = fullfile(labelFilePath, categoryName, className, labelFilename)      % Running Phase Indicator, without semicolon at the end
                    elseif img_type_idx == 2
                        fullFilenameWithPath = fullfile(txtViewFilePath_for_SKET, categoryName, className, imageFilename);
                        splitted_projImgFilename = regexp(imageFilename, '_', 'split');
                        sket_name_without_view_or_extension = cell2mat(splitted_projImgFilename( : , 1));
                        sket_path_without_view_or_extention = fullfile(txtViewFilePath_for_SKET, categoryName, className, sket_name_without_view_or_extension);
                        if ismember(sket_path_without_view_or_extention, sket_training_set_arr) == 0
                            continue;
                        end
                        [image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessSketImage(fullFilenameWithPath, imgEdgeLength);
                        fullLabelFilenameWithPath = fullfile(labelFilePath_for_SKET, categoryName, className, labelFilename)      % Running Phase Indicator, without semicolon at the end
                    end
                    %figure; imshow(1 - fixExpandImg); hold on;
                    
                    % �����߲����������ڲ��������һԪ�����Ͷ�Ԫ������ȡ
                    [sampled_contour, n_contsamp, adjacencyList, SC_feats, AED_feats, dist_to_img_center_feats, ...
                        belonged_conn_cont_ratio_feats, shape_diameter_feats, tangent_angle_relative_to_img_center_angle_feats, ...
                        shape_diameter_abs_diff_feats, tangent_angle_abs_diff_feats, outer_angle_feats ] ...
                        = sampling_and_calc_feats(filledFixExpandImg, imgEdgeLength, samp_step_length, n_dist, n_theta, bTangent);
                    
                    label_x_y_mat = cell(n_contsamp , 3);               % ÿ�д�label��������x���ꡢy���ꡣÿ��ͼ�����ǰҪ���
                    labeled_file_fid = fopen(fullLabelFilenameWithPath, 'r');       % ��label�ı��ļ�
                    labeled_pts_cnt = 0;
                    
                    % �����˱�Ǻ�������һԪ�����Ͷ�Ԫ�����ļ���·����������(#)�ָ�д�� labelWithFeatsFilePath
                    if img_type_idx == 1
                        labelWithFeatsFilePath =  sprintf('C://MATLAB//FeatureExtractionModule//projection_labeled_feats_for_training//%d//unary_features//%s//%s//unary_feat_%s#C://MATLAB//FeatureExtractionModule//projection_labeled_feats_for_training//%d//pairwise_features//%s//%s//pairwise_feat_%s', ...
                            samp_step_length, categoryName, className, labelFilename, samp_step_length, categoryName, className, labelFilename);
                    elseif img_type_idx == 2
                        labelWithFeatsFilePath =  sprintf('C://MATLAB//FeatureExtractionModule//sket_labeled_feats_for_training//%d//unary_features//%s//%s//unary_feat_%s#C://MATLAB//FeatureExtractionModule//sket_labeled_feats_for_training//%d//pairwise_features//%s//%s//pairwise_feat_%s', ...
                            samp_step_length, categoryName, className, labelFilename, samp_step_length, categoryName, className, labelFilename);
                    end
                    %labelWithFeatsFilePath =  sprintf('C://MATLAB//FeatureExtractionModule//projection_labeled_feats_for_training//%d//unary_features//%s//%s//unary_feat_%s#C://MATLAB//FeatureExtractionModule//projection_labeled_feats_for_training//%d//pairwise_features//%s//%s//pairwise_feat_%s', ...
                    %    samp_step_length, categoryName, className, labelFilename, samp_step_length, categoryName, className, labelFilename);
                    if labeled_file_fid ~= -1
                        % ������Ĭ�ϳ�ʼ��Ǻ�������һԪ�����Ͷ�Ԫ�����ļ���������(#)�ָ�д�� unlabeledFilePathCellArr
                        labeledFilePathCellArr = [labeledFilePathCellArr; {labelWithFeatsFilePath} ];
                        line_s = fgetl(labeled_file_fid);
                        while line_s ~= -1
                            labeled_pts_cnt = labeled_pts_cnt + 1;
                            splitted_str_cell_arr = regexp(line_s, '\s+', 'split');
                            label_str = cell2mat(splitted_str_cell_arr( : , 1));
                            samp_p_x = str2double(cell2mat(splitted_str_cell_arr( : , 2)));
                            samp_p_y = str2double(cell2mat(splitted_str_cell_arr( : , 3)));
                            % �����������߽ṹ��
                            label_x_y_mat(labeled_pts_cnt, :) = [{label_str} {samp_p_x} {samp_p_y}];
                            line_s = fgetl(labeled_file_fid);
                        end
                        fclose(labeled_file_fid);
                    else        % ������Ҳ����ڸ���ͼ�ı���ļ�
                        % ������Ĭ�ϳ�ʼ��Ǻ�������һԪ�����Ͷ�Ԫ�����ļ���������(#)�ָ�д�� unlabeledFilePathCellArr
                        unlabeledFilePathCellArr = [unlabeledFilePathCellArr ; {labelWithFeatsFilePath} ];
                        % ������δ��ǵ���ͼ����ͳһ�����в�������Ϊ�ô���label set��ĵ�һ����ǩ
                        for samp_p_idx = 1 : n_contsamp
                            samp_p_x = sampled_contour(samp_p_idx, 1);
                            samp_p_y = sampled_contour(samp_p_idx, 2);
                            label_x_y_mat(samp_p_idx, :) = [{'?'} {samp_p_x} {samp_p_y}];
                        end
                    end
                    
                    % ƴ�ӳ� unaryFeats Ŀ��Ŀ¼��·��
                    unaryFeatsOutputFileName = sprintf('unary_feat_%s', labelFilename);
                    if img_type_idx == 1
                        unaryFeatsFullPath = fullfile(unaryFeatsPartialPath, categoryName, className, unaryFeatsOutputFileName);
                    elseif img_type_idx == 2
                        unaryFeatsFullPath = fullfile(unaryFeatsPartialPath_for_SKET, categoryName, className, unaryFeatsOutputFileName);
                    end
                    unary_fid = fopen(unaryFeatsFullPath, 'w');                 % д���ļ�
                    % ƴ�ӳ� pairwiseFeats Ŀ��Ŀ¼��·��
                    pairwiseFeatsOutputFileName = sprintf('pairwise_feat_%s', labelFilename);
                    if img_type_idx == 1
                        pairwiseFeatsFullPath = fullfile(pairwiseFeatsPartialPath, categoryName, className, pairwiseFeatsOutputFileName);
                    elseif img_type_idx == 2
                        pairwiseFeatsFullPath = fullfile(pairwiseFeatsPartialPath_for_SKET, categoryName, className, pairwiseFeatsOutputFileName);
                    end
                    pairwise_fid = fopen(pairwiseFeatsFullPath, 'w');           % д���ļ�
                    
                    [samp_pts_num, col_size] = size(sampled_contour);
                    for samp_p_idx = 1 : samp_pts_num   % row_size����ÿ��ͼ���ǵĲ�������
                        samp_p_x = sampled_contour(samp_p_idx, 1);
                        samp_p_y = sampled_contour(samp_p_idx, 2);
                        % contour���������� �� label_x_y_mat �����Ӧ��ϵУ�飬ȷ��д��label��������Ӧ��ϵ��ȷ
                        if samp_p_x ~= cell2mat(label_x_y_mat(samp_p_idx, 2))  |  samp_p_y ~= cell2mat(label_x_y_mat(samp_p_idx, 3))
                            error('sampled_contour���������� �� label_x_y_mat ���겻��Ӧ��');
                        else
                            point_label_str = cell2mat(label_x_y_mat(samp_p_idx, 1));
                            %-- д��unaryFeats�ļ�
                            % д��label;p_x,p_y;
                            fprintf(unary_fid, '%s;%d,%d;', point_label_str, samp_p_x, samp_p_y);
                            % д�� SC ���� (5 * 12ά����һ��)
                            fprintf(unary_fid, '%f,', SC_feats( :, samp_p_idx));
                            % д�� AED ���� (11ά����һ��)
                            fprintf(unary_fid, '%f,', AED_feats( samp_p_idx, :));
                            % д�� dist_to_img_center_feats ���� (1ά��δ��һ��)
                            fprintf(unary_fid, '%f,', dist_to_img_center_feats( samp_p_idx, 1));
                            % д�� belonged_conn_component_ratio_feats ���� (1ά����һ��)
                            fprintf(unary_fid, '%f,', belonged_conn_cont_ratio_feats( samp_p_idx, 1));
                            % д�� shape_diameter_feats ���� (7ά��δ��һ��)
                            fprintf(unary_fid, '%f,', shape_diameter_feats(samp_p_idx, :));
                            % д�� tangent_angle_relative_to_img_center_angle_feats ���� (1ά��δ��һ��)
                            fprintf(unary_fid, '%f\n', tangent_angle_relative_to_img_center_angle_feats(samp_p_idx, 1));
                            
                            %-- д��pairwiseFeats�ļ�
                            [row_size, adj_p_num] = size(adjacencyList(samp_p_idx, :));
                            % д�뵱ǰ��label;samp_p_idx;p_x,p_y#
                            fprintf(pairwise_fid, '%s;%d;%d,%d#', point_label_str, samp_p_idx, samp_p_x, samp_p_y);
                            for adj_i = 1 : adj_p_num
                                adj_p_idx = adjacencyList(samp_p_idx, adj_i);
                                adj_p_x = sampled_contour(adj_p_idx, 1);
                                adj_p_y = sampled_contour(adj_p_idx, 2);
                                adj_p_label_str = cell2mat(label_x_y_mat(adj_p_idx, 1));
                                % д���Ԫ��label;adj_p_idx;adj_p_x,adj_p_y;
                                % labelΪ0����ǰ������ڽӵ㲿����ǩ��ͬ��1������ͬ
                                fprintf(pairwise_fid, '%d;%d;%d,%d;', abs(strcmp(point_label_str, adj_p_label_str) - 1), adj_p_idx, adj_p_x, adj_p_y);
                                % д�� shape_diameter_absolute_diff_feats ���� (7ά��δ��һ��)
                                fprintf(pairwise_fid, '%f,', shape_diameter_abs_diff_feats(samp_p_idx, (adj_i - 1) * 7 + 1 : (adj_i - 1) * 7 + 7));
                                % д�� tangent_angle_abs_diff_feats ���� (1ά��δ��һ��)
                                fprintf(pairwise_fid, '%f#', tangent_angle_abs_diff_feats(samp_p_idx, adj_i));
                            end
                            % д�� outer_angle_feats ���� (1ά��δ��һ��) TO-DO: ����չ��
                            for adj_i = 1 : adj_p_num
                                if adj_i ~= adj_p_num
                                    fprintf(pairwise_fid, '%d,%f;', adjacencyList(samp_p_idx, adj_i), outer_angle_feats(samp_p_idx, 1));
                                else
                                    fprintf(pairwise_fid, '%d,%f\n', adjacencyList(samp_p_idx, adj_i), outer_angle_feats(samp_p_idx, 1));
                                end
                            end
                        end
                    end
                    fclose(unary_fid);
                    fclose(pairwise_fid);
                end
            end
        end
        %----------------------- CRFģ�Ͳ���ѧϰ������ѧ��������CRF�������ô���δ��ǵ�ģ�����μӱ��
        % ָ��ѵ���Ĵ������ƣ�������Զ����ô���δ��ǵ�ģ����������ѧϰ�õ�������CRFģ�ͽ��в������
        % �Զ��� labeledFilePathCellArr �� unlabeledFilePathCellArr ��ȡ�Ѿ���ǵ�label�ļ���д����Ӧpath�ļ���
        % Ҫ����������ÿ�����඼�Զ��������ɵ���ӦĿ¼�£�����ǰ�����µ��ѱ�ǵ��ļ����ļ�������4:1����д����Ӧpath�ļ�
        getGlobalVariables;     %TRAIN_PATH��CV_PATH��TEST_PATH��getGlobalVariables��ȡ
        % trainMatFilePath��JointBoost output param ������ļ��ȸ��ļ��������ļ��У����򱻸��ǣ�
        trainMatFilePath = fullfile(basePath, viewName, categoryName, '__CRFTrainOutput.mat');
        [labeledFileNum, colSize] = size(labeledFilePathCellArr);
        [unlabeledFileNum, columnSize] = size(unlabeledFilePathCellArr);
        subsetSize = ceil(labeledFileNum / 5);        % �� labeledFilePathCellArr �ȷ�Ϊ5��(����ȡ��)������4��д�� TRAIN_PATH ����1��д�� CV_PATH
        
        % �� unlabeledFilePathCellArr ÿһ�У���д�� TEST_PATH �ļ�
        test_path_fid = fopen(TEST_PATH, 'w');
        for idx = 1 : unlabeledFileNum
            fprintf(test_path_fid, '%s\n', cell2mat(unlabeledFilePathCellArr(idx, 1)) );
        end
        fclose(test_path_fid);
        
        if labeledFileNum <= 0    % �������ѱ�ǵ���ͼ��������ʱ�Ž��н�����֤������������������ֱ�ѧģ�ͣ�ѡȡ���Լ����(testerr)ֵ��С��һ����Ϊ���յ�ģ��
            % ���������������validation set��·����·����������±�����
            combinations_idx_arr = combntns( 1 : labeledFileNum , subsetSize);       % �оٳ����е�������������ֵcombinations_idx_arr�Ǻ���subsetSize���±������
            [combination_num, col_size] = size(combinations_idx_arr);
            trainPath = TRAIN_PATH;
            crossValidatePath = CV_PATH;
            testPath = CV_PATH;    % ���н�����֤����ѵ���ô��������ģ��ʱ����validation set��Ϊtest set�����Ҫ��ʱ��test set��·������Ϊvalidation set��·��
            % �����ڽ�����֤ʱ��Ŀ��·�������ݵ�ǰ���ŵ�CRF����
            curOptimalCRFparams = fullfile(basePath, viewName, categoryName, '__curOptimalCRFTrainOutput.mat');
            min_CVerr = 99999999;
            for comb_idx = 1 : combination_num
                train_path_fid = fopen( TRAIN_PATH , 'w');      % write corresponding filepath to path file, in 4 : 1 ratio
                cv_path_fid = fopen( CV_PATH , 'w');
                file_idx_arr = combinations_idx_arr(comb_idx,  :  );
                for file_path_idx = 1 : labeledFileNum
                    file_path = cell2mat(labeledFilePathCellArr(file_path_idx, : ));
                    if ismember( file_path_idx, file_idx_arr) == 1       % �� curr_combination ���ôд�� CV_PATH ���ļ�
                        fprintf(cv_path_fid, '%s\n', file_path );
                    else                                                 % ���� curr_combination ���ôд�� TRAIN_PATH ���ļ�
                        fprintf(train_path_fid, '%s\n', file_path );
                    end
                end
                fclose(train_path_fid);
                fclose(cv_path_fid);
                % ��һ���� JointBoost �� isTest = false��һ��
                system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 0 %s %s', categoryName, viewName));
                % �ڶ����� CRF ��isTest = 0��һ��
                [sketches, CVsketches, err, CVerr] = trainLabelSketches(0, trainPath, crossValidatePath, testPath, categoryName, viewName);
                % �������� JointBoost �� isTest = true��һ��
                system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 1 %s %s', categoryName, viewName));
                % ���Ĳ���CRF �� Validation Set ��֤����һ��
                [sketches, CVsketches, err, CVerr] = trainLabelSketches(1, trainPath, crossValidatePath, testPath, categoryName, viewName);
                % �ж�testErr�Ƿ��С������ǵĻ����͸���min_TestErrֵ��������ǰ���ŵ�ģ�Ͳ����洢��curOptimalCRFparams.mat�ļ���
                if CVerr < min_CVerr
                    min_CVerr = CVerr;
                    % ��ѧ���ĵ�ǰ���ŵ�CRF����������__curOptimalCRFTrainOutput.mat�ļ����������
                    copyfile(trainMatFilePath, curOptimalCRFparams);
                end
            end
            % ������ģ�Ͳ���д��mat�ļ�������������ģ������ѧϰ��
            copyfile(curOptimalCRFparams, trainMatFilePath);
            % �����Ų����ظ���������JointBoost ��isTest = true��һ��
            system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 1 %s %s', categoryName, viewName));
            % �����Ų����ظ����Ĳ��� CRF ��isTest = 1��һ��
            [sketches, CVsketches, err, CVerr, categoryLabels] = trainLabelSketches(1, TRAIN_PATH, CV_PATH, TEST_PATH, categoryName, viewName);   % ��ԭʼ��TRAIN_PATH��CV_PATH��TEST_PATH����
            % �����parseResult()������ʾ���
            [testSketches, testErr, testPathOrSketches] = parseResults(categoryLabels, categoryName, viewName);
        else          % ����ѱ�ǵ���ͼ������������7��ѵ�������϶࣬��ô�Ͳ��ؽ��н�����֤�ˣ��������ܺ�ʱҲ���ྫ��ȴ������̫������
            % ������������п��������ѡȡ����һ�������������л���ѧϰ
            step = floor(labeledFileNum / subsetSize);
            if step == 0
                error('Step equal to zero!');       % ��ֹ�����������٣����ֲ���Ϊ0�����( ��������Ӧ�û����뽻����֤�ķ�֧)
            end
            file_idx_arr = [];
            for i = 1 : subsetSize
                file_idx = 1 + (i - 1) * step;      % �ȼ������ѡȡ�� file idx ����
                file_idx_arr = [file_idx_arr;  file_idx];
            end
            train_path_fid = fopen( TRAIN_PATH , 'w');      % write corresponding filepath to path file, in 4 : 1 ratio
            cv_path_fid = fopen( CV_PATH , 'w');
            for file_path_idx = 1 : labeledFileNum
                file_path = cell2mat(labeledFilePathCellArr(file_path_idx, : ));
                if ismember( file_path_idx, file_idx_arr) == 1       % �� curr_combination ���ôд�� CV_PATH ���ļ�
                    fprintf(cv_path_fid, '%s\n', file_path );
                else                                                % ���� curr_combination ���ôд�� TRAIN_PATH ���ļ�
                    fprintf(train_path_fid, '%s\n', file_path );
                end
            end
            fclose(train_path_fid);
            fclose(cv_path_fid);
            
            % ��һ����JointBoost ��isTest = false��һ��
            system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 0 %s %s', categoryName, viewName));
            % �ڶ����� CRF ��isTest = 0��һ��
            [sketches, CVsketches, err, CVerr] = trainLabelSketches(0, TRAIN_PATH, CV_PATH, TEST_PATH, categoryName, viewName);
            if unlabeledFileNum > 0     % ��������ҪԤ�������������²Ž���Ԥ�Ⲣ��ʾ�����û����ҪԤ�������Ļ����������ǰ����ѵ�����µ�CRFģ�Ͳ���
                % ��������JointBoost ��isTest = true��һ��
                system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 1 %s %s', categoryName, viewName));
                % ���Ĳ��� CRF ��validation set��֤����һ��
                [sketches, CVsketches, err, CVerr, categoryLabels] = trainLabelSketches(1, TRAIN_PATH, CV_PATH, TEST_PATH, categoryName, viewName);
                % �����parseResult()������ʾ���
                [testSketches, testErr, testPathOrSketches] = parseResults(categoryLabels, categoryName, viewName);
            end
        end
        
        if unlabeledFileNum > 0         % ��������ҪԤ�������������²Ž���Ԥ���ļ��Ĺ����ƶ�
            % ��Ԥ�����label�ļ���tmp�µ�PredictedLabelFiles�ļ����ƶ���labelContour��ȡ��ѵ������Ӧ�����µ�С��Ŀ¼������ֹ�΢��label
            predictedFileDirsStruct = dir(fullfile(OUTPUT_BASE_PATH, sprintf('PredictedLabelFiles/*.txt')));  % ��tmp�ļ����µ�PredictedLabelFiles�ļ���
            predictedFileDirsArr = struct2cell(predictedFileDirsStruct)' ;    % �ṹ��(struct����)ת����Ԫ������(cell)��ת��һ�������ļ�����������
            predictedFileNamesArr = predictedFileDirsArr( : , 1);   % ��һ�����ļ���
            predicted_file_num = size(predictedFileNamesArr);
            for file_idx = 1 : predicted_file_num             % ע���ļ����±겻�漰'.'��'..'������Ӧ�ô�1��ʼ����ͬ��Ŀ¼�±꣨��3��ʼ��
                predictedLabelFilename = cell2mat(predictedFileNamesArr(file_idx));            % projImgFilename��ʽ e.g., seg_m267_front.txt
                splitted_str_cell_arr = regexp(predictedLabelFilename, '_', 'split');
                model_id_str = cell2mat(splitted_str_cell_arr( : , 2));         % ��ø�ģ������С������
                thumbFilename = sprintf('%s_thumb.jpg', model_id_str);          % ����model_id_str ƴ�ӳ� thumbFilename, e.g.:  m123_thumb.jpg
                % ����ǰѧϰԤ��Ĵ���Ŀ¼�²�����Ӧ�ļ�
                subdir = dir(fullfile(categorizeRefThumbFilePath, categoryName));         % �г�����ĸ�Ŀ¼�µ�������Ŀ¼
                classNamesDirsArr = struct2cell(classNamesDirs)' ;    % �ṹ��(struct����)ת����Ԫ������(cell)��ת��һ�������ļ�����������
                classNamesArr = classNamesDirsArr( : , 1);   % ��һ�����ļ���
                class_names_num = size(classNamesArr);
                for class_idx = 3 : class_names_num                   % �±��3��ʼѭ������ΪĿ¼���±�Ϊ1����'.',�±�Ϊ2����'..'
                    className = cell2mat(classNamesArr(class_idx));
                    data_fn = dir(fullfile(categorizeRefThumbFilePath, categoryName, className, thumbFilename));
                    [row_size, col_size] = size(data_fn);
                    if row_size == 1        % ����ҵ����ļ���������Ӧ����Ŀ¼��д���ı��ļ����Ӷ����й���
                        % ƴ�ӳ� OutputFilePath Ŀ��Ŀ¼��·�����ƶ��ļ�
                        predictedLabelSourceFilePath = fullfile(OUTPUT_BASE_PATH, 'PredictedLabelFiles', predictedLabelFilename);
                        if strcmp(predictedLabelFilename(5), 'm') == 1
                            predictedLabelDestinationFilePath = fullfile(labelFilePath, categoryName, className, predictedLabelFilename);
                        elseif strcmp(predictedLabelFilename(5), 's') == 1
                            predictedLabelDestinationFilePath = fullfile(labelFilePath_for_SKET, categoryName, className, predictedLabelFilename);
                        else
                            error('prefix error: %s', predictedLabelFilename(5));
                        end
                        copyfile(predictedLabelSourceFilePath, predictedLabelDestinationFilePath);
                        delete(predictedLabelSourceFilePath);
                    end
                end
            end
        end
    end
end
