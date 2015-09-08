% 手绘图和投影图放在相同目录下，通过文件名前缀( m 或 s ) 区分 (扩展名都为 png )
addPathsAndLoadVariables;
sket_training_set_arr = generate_training_or_testing_arr('C:\MATLAB\P_R_Curves\splitedTrain.txt');
% 外层：根目录下的各个大类目录
categoryNamesDirs = dir(txtViewFilePath);       % 列出大类的根目录下的所有子目录
categoryNamesDirsArr = struct2cell(categoryNamesDirs)' ;    % 结构体(struct搜索)转换成元胞类型(cell)，转置一下是让文件名按列排列
categoryNamesArr = categoryNamesDirsArr( : , 1);   % 第一列是目录名
category_names_num = size(categoryNamesArr);
for category_idx = 3 : category_names_num         % 下标从3开始循环，因为目录的下标为1的是'.',下标为2的是'..'
    categoryName = cell2mat(categoryNamesArr(category_idx));
    % 分别训练该大类三维模型的 front 、 side 和 top 视图的 部件分割CRF 模型
    for view_idx = 1 : 3
        switch view_idx
            case 1
                viewName = 'front';
            case 2
                viewName = 'side';
            case 3
                viewName = 'top';
        end
        labeledFilePathCellArr = {};    % 循环读取该大类的文件，根据是否已经加了标记，将其路径归入 labeledFilePathCellArr 或 unlabeledFilePathCellArr
        unlabeledFilePathCellArr = {};
        for img_type_idx = 1 : 2
            % 中层：大类目录下的各个小类目录
            classNamesDirs = dir(fullfile(txtViewFilePath, categoryName));       % 列出大类的根目录下的所有子目录
            classNamesDirsArr = struct2cell(classNamesDirs)' ;    % 结构体(struct搜索)转换成元胞类型(cell)，转置一下是让文件名按列排列
            classNamesArr = classNamesDirsArr( : , 1);   % 第一列是目录名
            class_names_num = size(classNamesArr);
            for class_idx = 3 : class_names_num          % 下标从3开始循环，因为目录的下标为1的是'.',下标为2的是'..'
                className = cell2mat(classNamesArr(class_idx));
                % 内层：小类目录下的该视角的各个文件
                if img_type_idx == 1
                    fileNamesDirs = dir(fullfile(txtViewFilePath, categoryName, className, sprintf('m*%s.png', viewName)));   % 返回相应视角的 png 文件的路径
                elseif img_type_idx == 2
                    fileNamesDirs = dir(fullfile(txtViewFilePath_for_SKET, categoryName, className, sprintf('s*%s.png', viewName)));   % 返回相应视角的 png 文件的路径
                end
                fileNamesDirsArr = struct2cell(fileNamesDirs)' ;    % 结构体(struct搜索)转换成元胞类型(cell)，转置一下是让文件名按列排列
                fileNamesArr = fileNamesDirsArr( : , 1);   % 第一列是文件名
                file_names_num = size(fileNamesArr);
                for file_idx = 1 : file_names_num       % 注意文件的下标不涉及'.'和'..'，所以应该从1开始，不同于目录下标（从3开始）
                    imageFilename = cell2mat(fileNamesArr(file_idx));             % projImgFilename 格式 e.g., m267_front.png  or  s123_side.png
                    % 根据label文件的名字来找到对应视图的文件名和相应目录
                    
                    splitted_projImgFilename = regexp(imageFilename, '\.', 'split');
                    projImgFilename_without_extension = cell2mat(splitted_projImgFilename( : , 1));
                    labelFilename = sprintf('seg_%s.txt', projImgFilename_without_extension);             % labelFilename 格式 e.g.，seg_m267_front.txt
                    
                    % 拼接路径，打开相应视图文件
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
                    
                    % 轮廓线采样，并基于采样点进行一元特征和二元特征提取
                    [sampled_contour, n_contsamp, adjacencyList, SC_feats, AED_feats, dist_to_img_center_feats, ...
                        belonged_conn_cont_ratio_feats, shape_diameter_feats, tangent_angle_relative_to_img_center_angle_feats, ...
                        shape_diameter_abs_diff_feats, tangent_angle_abs_diff_feats, outer_angle_feats ] ...
                        = sampling_and_calc_feats(filledFixExpandImg, imgEdgeLength, samp_step_length, n_dist, n_theta, bTangent);
                    
                    label_x_y_mat = cell(n_contsamp , 3);               % 每行存label、采样点x坐标、y坐标。每幅图像计算前要清空
                    labeled_file_fid = fopen(fullLabelFilenameWithPath, 'r');       % 打开label文本文件
                    labeled_pts_cnt = 0;
                    
                    % 将加了标记和特征的一元特征和二元特征文件的路径，按井号(#)分隔写入 labelWithFeatsFilePath
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
                        % 将加了默认初始标记和特征的一元特征和二元特征文件，按井号(#)分隔写入 unlabeledFilePathCellArr
                        labeledFilePathCellArr = [labeledFilePathCellArr; {labelWithFeatsFilePath} ];
                        line_s = fgetl(labeled_file_fid);
                        while line_s ~= -1
                            labeled_pts_cnt = labeled_pts_cnt + 1;
                            splitted_str_cell_arr = regexp(line_s, '\s+', 'split');
                            label_str = cell2mat(splitted_str_cell_arr( : , 1));
                            samp_p_x = str2double(cell2mat(splitted_str_cell_arr( : , 2)));
                            samp_p_y = str2double(cell2mat(splitted_str_cell_arr( : , 3)));
                            % 保存在数据线结构中
                            label_x_y_mat(labeled_pts_cnt, :) = [{label_str} {samp_p_x} {samp_p_y}];
                            line_s = fgetl(labeled_file_fid);
                        end
                        fclose(labeled_file_fid);
                    else        % 如果尚且不存在该视图的标记文件
                        % 将加了默认初始标记和特征的一元特征和二元特征文件，按井号(#)分隔写入 unlabeledFilePathCellArr
                        unlabeledFilePathCellArr = [unlabeledFilePathCellArr ; {labelWithFeatsFilePath} ];
                        % 对于尚未标记的视图，先统一将所有采样点标记为该大类label set里的第一个标签
                        for samp_p_idx = 1 : n_contsamp
                            samp_p_x = sampled_contour(samp_p_idx, 1);
                            samp_p_y = sampled_contour(samp_p_idx, 2);
                            label_x_y_mat(samp_p_idx, :) = [{'?'} {samp_p_x} {samp_p_y}];
                        end
                    end
                    
                    % 拼接成 unaryFeats 目标目录的路径
                    unaryFeatsOutputFileName = sprintf('unary_feat_%s', labelFilename);
                    if img_type_idx == 1
                        unaryFeatsFullPath = fullfile(unaryFeatsPartialPath, categoryName, className, unaryFeatsOutputFileName);
                    elseif img_type_idx == 2
                        unaryFeatsFullPath = fullfile(unaryFeatsPartialPath_for_SKET, categoryName, className, unaryFeatsOutputFileName);
                    end
                    unary_fid = fopen(unaryFeatsFullPath, 'w');                 % 写入文件
                    % 拼接成 pairwiseFeats 目标目录的路径
                    pairwiseFeatsOutputFileName = sprintf('pairwise_feat_%s', labelFilename);
                    if img_type_idx == 1
                        pairwiseFeatsFullPath = fullfile(pairwiseFeatsPartialPath, categoryName, className, pairwiseFeatsOutputFileName);
                    elseif img_type_idx == 2
                        pairwiseFeatsFullPath = fullfile(pairwiseFeatsPartialPath_for_SKET, categoryName, className, pairwiseFeatsOutputFileName);
                    end
                    pairwise_fid = fopen(pairwiseFeatsFullPath, 'w');           % 写入文件
                    
                    [samp_pts_num, col_size] = size(sampled_contour);
                    for samp_p_idx = 1 : samp_pts_num   % row_size等于每幅图像标记的采样点数
                        samp_p_x = sampled_contour(samp_p_idx, 1);
                        samp_p_y = sampled_contour(samp_p_idx, 2);
                        % contour采样点序列 与 label_x_y_mat 坐标对应关系校验，确保写入label与坐标点对应关系正确
                        if samp_p_x ~= cell2mat(label_x_y_mat(samp_p_idx, 2))  |  samp_p_y ~= cell2mat(label_x_y_mat(samp_p_idx, 3))
                            error('sampled_contour采样点序列 与 label_x_y_mat 坐标不对应！');
                        else
                            point_label_str = cell2mat(label_x_y_mat(samp_p_idx, 1));
                            %-- 写入unaryFeats文件
                            % 写入label;p_x,p_y;
                            fprintf(unary_fid, '%s;%d,%d;', point_label_str, samp_p_x, samp_p_y);
                            % 写入 SC 特征 (5 * 12维，归一化)
                            fprintf(unary_fid, '%f,', SC_feats( :, samp_p_idx));
                            % 写入 AED 特征 (11维，归一化)
                            fprintf(unary_fid, '%f,', AED_feats( samp_p_idx, :));
                            % 写入 dist_to_img_center_feats 特征 (1维，未归一化)
                            fprintf(unary_fid, '%f,', dist_to_img_center_feats( samp_p_idx, 1));
                            % 写入 belonged_conn_component_ratio_feats 特征 (1维，归一化)
                            fprintf(unary_fid, '%f,', belonged_conn_cont_ratio_feats( samp_p_idx, 1));
                            % 写入 shape_diameter_feats 特征 (7维，未归一化)
                            fprintf(unary_fid, '%f,', shape_diameter_feats(samp_p_idx, :));
                            % 写入 tangent_angle_relative_to_img_center_angle_feats 特征 (1维，未归一化)
                            fprintf(unary_fid, '%f\n', tangent_angle_relative_to_img_center_angle_feats(samp_p_idx, 1));
                            
                            %-- 写入pairwiseFeats文件
                            [row_size, adj_p_num] = size(adjacencyList(samp_p_idx, :));
                            % 写入当前点label;samp_p_idx;p_x,p_y#
                            fprintf(pairwise_fid, '%s;%d;%d,%d#', point_label_str, samp_p_idx, samp_p_x, samp_p_y);
                            for adj_i = 1 : adj_p_num
                                adj_p_idx = adjacencyList(samp_p_idx, adj_i);
                                adj_p_x = sampled_contour(adj_p_idx, 1);
                                adj_p_y = sampled_contour(adj_p_idx, 2);
                                adj_p_label_str = cell2mat(label_x_y_mat(adj_p_idx, 1));
                                % 写入二元项label;adj_p_idx;adj_p_x,adj_p_y;
                                % label为0代表当前点与该邻接点部件标签相同，1代表不相同
                                fprintf(pairwise_fid, '%d;%d;%d,%d;', abs(strcmp(point_label_str, adj_p_label_str) - 1), adj_p_idx, adj_p_x, adj_p_y);
                                % 写入 shape_diameter_absolute_diff_feats 特征 (7维，未归一化)
                                fprintf(pairwise_fid, '%f,', shape_diameter_abs_diff_feats(samp_p_idx, (adj_i - 1) * 7 + 1 : (adj_i - 1) * 7 + 7));
                                % 写入 tangent_angle_abs_diff_feats 特征 (1维，未归一化)
                                fprintf(pairwise_fid, '%f#', tangent_angle_abs_diff_feats(samp_p_idx, adj_i));
                            end
                            % 写入 outer_angle_feats 特征 (1维，未归一化) TO-DO: 可扩展性
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
        %----------------------- CRF模型参数学习，基于学到的最优CRF参数给该大类未标记的模型依次加标记
        % 指定训练的大类名称，程序会自动将该大类未标记的模型依次依照学习得到的最优CRF模型进行部件标记
        % 自动从 labeledFilePathCellArr 和 unlabeledFilePathCellArr 读取已经标记的label文件，写入相应path文件。
        % 要是能批处理到每个大类都自动处理并生成到相应目录下，将当前大类下的已标记的文件的文件名，按4:1比例写入相应path文件
        getGlobalVariables;     %TRAIN_PATH、CV_PATH、TEST_PATH从getGlobalVariables读取
        % trainMatFilePath、JointBoost output param 的输出文件等各文件，归入文件夹，否则被覆盖？
        trainMatFilePath = fullfile(basePath, viewName, categoryName, '__CRFTrainOutput.mat');
        [labeledFileNum, colSize] = size(labeledFilePathCellArr);
        [unlabeledFileNum, columnSize] = size(unlabeledFilePathCellArr);
        subsetSize = ceil(labeledFileNum / 5);        % 将 labeledFilePathCellArr 等分为5份(向上取整)，其中4份写入 TRAIN_PATH ，另1份写入 CV_PATH
        
        % 把 unlabeledFilePathCellArr 每一行，都写入 TEST_PATH 文件
        test_path_fid = fopen(TEST_PATH, 'w');
        for idx = 1 : unlabeledFileNum
            fprintf(test_path_fid, '%s\n', cell2mat(unlabeledFilePathCellArr(idx, 1)) );
        end
        fclose(test_path_fid);
        
        if labeledFileNum <= 0    % 仅对于已标记的视图样本较少时才进行交叉验证，穷举所有组合情况，分别学模型，选取测试集误差(testerr)值最小的一个最为最终的模型
            % 组合数函数，生成validation set的路径在路径向量里的下标的组合
            combinations_idx_arr = combntns( 1 : labeledFileNum , subsetSize);       % 列举出所有的组合情况，返回值combinations_idx_arr是含有subsetSize个下标的向量
            [combination_num, col_size] = size(combinations_idx_arr);
            trainPath = TRAIN_PATH;
            crossValidatePath = CV_PATH;
            testPath = CV_PATH;    % 进行交叉验证，在训练该大类的最优模型时，将validation set作为test set，因此要暂时将test set的路径覆盖为validation set的路径
            % 用于在交叉验证时，目标路径，备份当前最优的CRF参数
            curOptimalCRFparams = fullfile(basePath, viewName, categoryName, '__curOptimalCRFTrainOutput.mat');
            min_CVerr = 99999999;
            for comb_idx = 1 : combination_num
                train_path_fid = fopen( TRAIN_PATH , 'w');      % write corresponding filepath to path file, in 4 : 1 ratio
                cv_path_fid = fopen( CV_PATH , 'w');
                file_idx_arr = combinations_idx_arr(comb_idx,  :  );
                for file_path_idx = 1 : labeledFileNum
                    file_path = cell2mat(labeledFilePathCellArr(file_path_idx, : ));
                    if ismember( file_path_idx, file_idx_arr) == 1       % 在 curr_combination 里，那么写入 CV_PATH 的文件
                        fprintf(cv_path_fid, '%s\n', file_path );
                    else                                                 % 不在 curr_combination 里，那么写入 TRAIN_PATH 的文件
                        fprintf(train_path_fid, '%s\n', file_path );
                    end
                end
                fclose(train_path_fid);
                fclose(cv_path_fid);
                % 第一步， JointBoost 用 isTest = false跑一遍
                system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 0 %s %s', categoryName, viewName));
                % 第二步， CRF 用isTest = 0跑一遍
                [sketches, CVsketches, err, CVerr] = trainLabelSketches(0, trainPath, crossValidatePath, testPath, categoryName, viewName);
                % 第三步， JointBoost 用 isTest = true跑一遍
                system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 1 %s %s', categoryName, viewName));
                % 第四步，CRF 用 Validation Set 验证集跑一遍
                [sketches, CVsketches, err, CVerr] = trainLabelSketches(1, trainPath, crossValidatePath, testPath, categoryName, viewName);
                % 判断testErr是否更小，如果是的话，就更新min_TestErr值，并将当前最优的模型参数存储到curOptimalCRFparams.mat文件中
                if CVerr < min_CVerr
                    min_CVerr = CVerr;
                    % 将学到的当前最优的CRF参数备份在__curOptimalCRFTrainOutput.mat文件里，保存起来
                    copyfile(trainMatFilePath, curOptimalCRFparams);
                end
            end
            % 将最优模型参数写入mat文件，并按此最优模型重新学习该
            copyfile(curOptimalCRFparams, trainMatFilePath);
            % 按最优参数重复第三步，JointBoost 用isTest = true跑一遍
            system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 1 %s %s', categoryName, viewName));
            % 按最优参数重复第四步， CRF 用isTest = 1跑一遍
            [sketches, CVsketches, err, CVerr, categoryLabels] = trainLabelSketches(1, TRAIN_PATH, CV_PATH, TEST_PATH, categoryName, viewName);   % 用原始的TRAIN_PATH、CV_PATH、TEST_PATH参数
            % 最后，用parseResult()函数显示结果
            [testSketches, testErr, testPathOrSketches] = parseResults(categoryLabels, categoryName, viewName);
        else          % 如果已标记的视图样本数量大于7，训练样本较多，那么就不必进行交叉验证了，否则计算很耗时也分类精度却不会有太大提升
            % 用在组合数所有可能情况里选取其中一种组合情况，进行机器学习
            step = floor(labeledFileNum / subsetSize);
            if step == 0
                error('Step equal to zero!');       % 防止由于样本过少，出现步长为0的情况( 样本过少应该会走入交叉验证的分支)
            end
            file_idx_arr = [];
            for i = 1 : subsetSize
                file_idx = 1 + (i - 1) * step;      % 等间隔生成选取的 file idx 序列
                file_idx_arr = [file_idx_arr;  file_idx];
            end
            train_path_fid = fopen( TRAIN_PATH , 'w');      % write corresponding filepath to path file, in 4 : 1 ratio
            cv_path_fid = fopen( CV_PATH , 'w');
            for file_path_idx = 1 : labeledFileNum
                file_path = cell2mat(labeledFilePathCellArr(file_path_idx, : ));
                if ismember( file_path_idx, file_idx_arr) == 1       % 在 curr_combination 里，那么写入 CV_PATH 的文件
                    fprintf(cv_path_fid, '%s\n', file_path );
                else                                                % 不在 curr_combination 里，那么写入 TRAIN_PATH 的文件
                    fprintf(train_path_fid, '%s\n', file_path );
                end
            end
            fclose(train_path_fid);
            fclose(cv_path_fid);
            
            % 第一步，JointBoost 用isTest = false跑一遍
            system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 0 %s %s', categoryName, viewName));
            % 第二步， CRF 用isTest = 0跑一遍
            [sketches, CVsketches, err, CVerr] = trainLabelSketches(0, TRAIN_PATH, CV_PATH, TEST_PATH, categoryName, viewName);
            if unlabeledFileNum > 0     % 仅在有需要预测样本的情形下才进行预测并显示结果；没有需要预测样本的话，则仅是由前两步训练出新的CRF模型参数
                % 第三步，JointBoost 用isTest = true跑一遍
                system(sprintf('C:\\MATLAB\\imseg\\sketchSeg\\Debug\\sketchSeg.exe 1 %s %s', categoryName, viewName));
                % 第四步， CRF 用validation set验证集跑一遍
                [sketches, CVsketches, err, CVerr, categoryLabels] = trainLabelSketches(1, TRAIN_PATH, CV_PATH, TEST_PATH, categoryName, viewName);
                % 最后，用parseResult()函数显示结果
                [testSketches, testErr, testPathOrSketches] = parseResults(categoryLabels, categoryName, viewName);
            end
        end
        
        if unlabeledFileNum > 0         % 仅在有需要预测样本的情形下才进行预测文件的归类移动
            % 将预测出的label文件从tmp下的PredictedLabelFiles文件夹移动到labelContour读取的训练集相应大类下的小类目录里，方便手工微调label
            predictedFileDirsStruct = dir(fullfile(OUTPUT_BASE_PATH, sprintf('PredictedLabelFiles/*.txt')));  % 在tmp文件夹下的PredictedLabelFiles文件夹
            predictedFileDirsArr = struct2cell(predictedFileDirsStruct)' ;    % 结构体(struct搜索)转换成元胞类型(cell)，转置一下是让文件名按列排列
            predictedFileNamesArr = predictedFileDirsArr( : , 1);   % 第一列是文件名
            predicted_file_num = size(predictedFileNamesArr);
            for file_idx = 1 : predicted_file_num             % 注意文件的下标不涉及'.'和'..'，所以应该从1开始，不同于目录下标（从3开始）
                predictedLabelFilename = cell2mat(predictedFileNamesArr(file_idx));            % projImgFilename格式 e.g., seg_m267_front.txt
                splitted_str_cell_arr = regexp(predictedLabelFilename, '_', 'split');
                model_id_str = cell2mat(splitted_str_cell_arr( : , 2));         % 获得该模型所属小类名称
                thumbFilename = sprintf('%s_thumb.jpg', model_id_str);          % 根据model_id_str 拼接出 thumbFilename, e.g.:  m123_thumb.jpg
                % 到当前学习预测的大类目录下查找相应文件
                subdir = dir(fullfile(categorizeRefThumbFilePath, categoryName));         % 列出大类的根目录下的所有子目录
                classNamesDirsArr = struct2cell(classNamesDirs)' ;    % 结构体(struct搜索)转换成元胞类型(cell)，转置一下是让文件名按列排列
                classNamesArr = classNamesDirsArr( : , 1);   % 第一列是文件名
                class_names_num = size(classNamesArr);
                for class_idx = 3 : class_names_num                   % 下标从3开始循环，因为目录的下标为1的是'.',下标为2的是'..'
                    className = cell2mat(classNamesArr(class_idx));
                    data_fn = dir(fullfile(categorizeRefThumbFilePath, categoryName, className, thumbFilename));
                    [row_size, col_size] = size(data_fn);
                    if row_size == 1        % 如果找到该文件，就在相应大类目录下写入文本文件，从而进行归类
                        % 拼接成 OutputFilePath 目标目录的路径，移动文件
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
