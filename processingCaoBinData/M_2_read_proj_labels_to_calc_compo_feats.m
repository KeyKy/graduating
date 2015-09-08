% 循环所有大类，将标记处理成部件的矩阵，保存部件的png图像，计算部件特征并将其写入SQL数据库，供在线检索时使用

addPathsAndLoadVariables;
clear_global_var();

conn = database('CSDB', 'xuchi', '123456');   % 连接数据库, 参数分别为数据库名称，用户名，登录密码
if strcmp(conn.AutoCommit, 'on') ~= 1           % 如果未正常连接，则报错并终止程序
    error('DB Not Connected: conn.Message = %s!',conn.Message);
end
exec(conn, 'DELETE FROM [CSDB].[dbo].[model]');
exec(conn, 'DELETE FROM [CSDB].[dbo].[classTable]');
exec(conn, 'DELETE FROM [CSDB].[dbo].[categoryTable]');

% 穷举大类目录名称，写入数组中，依次循环各个大类(共30大类)
% 外层：根目录下的各个大类目录
categoryNamesDirs = dir(labelFilePath);       % 列出 labelFilePath 的根目录下的所有大类
categoryNamesDirsArr = struct2cell(categoryNamesDirs)' ;    % 结构体(struct搜索)转换成元胞类型(cell)，转置一下是让文件名按列排列
categoryNamesArr = categoryNamesDirsArr( : , 1);     % 第一列是文件夹名
category_names_num = size(categoryNamesArr);
for category_idx = 3 : category_names_num            % 下标从3开始循环，因为目录的下标为1的是'.',下标为2的是'..'
    categoryName = cell2mat(categoryNamesArr(category_idx));
    
    tableName = 'categoryTable';
    columnNames =   {'categoryName'};
    compoFeatsData = [{categoryName}];
    fastinsert(conn, tableName, columnNames, compoFeatsData);
    
    % 迭代地读取该大类下每个小类的视图采样点标签文本
    
    % 中层：大类目录下的各个小类目录
    classNamesDirs = dir(fullfile(labelFilePath, categoryName));       % 列出大类的根目录下的所有子目录
    classNamesDirsArr = struct2cell(classNamesDirs)' ;      % 结构体(struct搜索)转换成元胞类型(cell)，转置一下是让文件名按列排列
    classNamesArr = classNamesDirsArr( : , 1);              % 第一列是文件夹名
    class_names_num = size(classNamesArr);
    for class_idx = 3 : class_names_num                     % 下标从3开始循环，因为目录的下标为1的是'.',下标为2的是'..'
        className = cell2mat(classNamesArr(class_idx));
        tableName = 'classTable';
        columnNames =   {'className', 'categoryName'};
        compoFeatsData = [{className}, {categoryName}];
        fastinsert(conn, tableName, columnNames, compoFeatsData);
        
        model_views_cnt_map = containers.Map();
        % 内层：小类目录下的各个文件
        fileNamesDirs = dir(fullfile(labelFilePath, categoryName, className, '*.txt'));   % 返回结构数组
        fileNamesDirsArr = struct2cell(fileNamesDirs)' ;    % 结构体(struct搜索)转换成元胞类型(cell)，转置一下是让文件名按列排列
        fileNamesArr = fileNamesDirsArr( : , 1);            % 第一列是文件名
        file_names_num = size(fileNamesArr);
        for file_idx = 1 : file_names_num        % 注意文件的下标不涉及'.'和'..'，所以应该从1开始，不同于目录下标（从3开始）
            projLabeledFilename = cell2mat(fileNamesArr(file_idx));
            splitted_labeledFilename = regexp(projLabeledFilename, '_', 'split');   % 标签文件格式示例：  seg_m123_front.txt
            modelName = cell2mat(splitted_labeledFilename( : , 2));            % model_id_str 格式示例： m123
            model_id = str2double( modelName(2 : length(modelName)));                  % 去除 model_id_str 的第一个字母m，余下的部分转为数字
            view_and_txt_str = cell2mat(splitted_labeledFilename( : , 3));            % view_and_txt_str 格式示例： front.txt
            view_and_txt_cell_arr = regexp(view_and_txt_str, '\.', 'split');
            viewName = cell2mat(view_and_txt_cell_arr( : , 1));
            
            if ismember(modelName, keys(model_views_cnt_map)) == 0           % 如果此模型的任何视角的label文件还未曾处理过，那么就初始化计数为0，初始化保存该模型三个视角数据的struct为空
                model_views_cnt_map(modelName)  = 0;
                modelStruct = [];
                currentModelName = modelName;       % 记录下，用于校验，防止由于读入文本文件乱序或缺失，导致出错
            end
            model_views_cnt_map(modelName) = model_views_cnt_map(modelName) + 1;
            % 读取投影视图的部件标签文件，拼接出各部件，分别存入矩阵
            projLabeledFilePath = fullfile(labelFilePath, categoryName, className, projLabeledFilename)       % Process indicator, without semicolon
            projLabeledFile_fid = fopen(projLabeledFilePath, 'r');
            line_s = fgetl(projLabeledFile_fid);
            total_samp_cnt = 0;                            % 采样点总数计数，用于计算部件的权重比例
            composMap = containers.Map();
            lastCompoLabel = '';
            while line_s ~= -1
                % 该部件采样点数递增1
                total_samp_cnt = total_samp_cnt + 1;
                splitted_str_cell_arr = regexp(line_s, ' ', 'split');
                compo_label = cell2mat(splitted_str_cell_arr( : , 1));
                
                samp_p_x = round(str2double(cell2mat(splitted_str_cell_arr( : , 2))) / 2);   % 部件图减小为原图一半，坐标相应减半
                samp_p_y = round(str2double(cell2mat(splitted_str_cell_arr( : , 3))) / 2);
                if ismember(compo_label, keys(composMap)) == 0   % 如果该label尚且不存在于映射中，则添加进去，记录部件数加1
                    compoStruct.samp_cnt = 0;
                    compoStruct.prev_p_x = 0;
                    compoStruct.prev_p_y = 0;
                    compoStruct.compo_mat = zeros(imgEdgeLength / 2, imgEdgeLength / 2);   % 部件图边长为视图的一半，即 200 / 2 = 100
                    compoStruct.compo_feats = [];  % 此时暂时不知道特征向量维数，故不用 zeros 快速初始化
                    compoStruct.compo_topo = {};
                    composMap(compo_label) = compoStruct;
                end
                compoStruct = composMap(compo_label);
                compoStruct.samp_cnt = compoStruct.samp_cnt + 1;
                % 按当前采样点与上一采样点顺序拼接(以 samp_step_length * 2 作为距离阈值)各部件(矩阵里相邻采样点间连线段)，保存在数据结构中
                prev_samp_p_x = compoStruct.prev_p_x;
                prev_samp_p_y = compoStruct.prev_p_y;
                % 如果从矩阵中读出的prev点x和y坐标都是0，说明当前点是该部件的第一个点，所以不做画线段处理，距离太远也不做画线处理
                if prev_samp_p_x ~= 0 & prev_samp_p_y ~= 0 & euclideanDist( samp_p_x, samp_p_y, prev_samp_p_x, prev_samp_p_y ) <= (samp_step_length * 2)
                    compoStruct.compo_mat = drawLineInMatrix(compoStruct.compo_mat, samp_p_x, samp_p_y, prev_samp_p_x, prev_samp_p_y);
                end
                % 不同部件的采样点交替出现，prev_samp_p 需要按部件分别记录，才有意义，把当前采样点作为该部件的 prev sample point，记录在矩阵里
                compoStruct.prev_p_x = samp_p_x;
                compoStruct.prev_p_y = samp_p_y;
                % Topology: 如果当前点label和上一个相邻点的label不同
                if strcmp(lastCompoLabel, '') == 0  & strcmp(compo_label, lastCompoLabel) == 0
                    lastCompoStruct = composMap(lastCompoLabel);
                    if ismember(compo_label, lastCompoStruct.compo_topo) == 0          % 判断当前点的label是否在 上一个点的邻接表里，如果尚且不在，就添加进去
                        lastCompoStruct.compo_topo = [lastCompoStruct.compo_topo;  {compo_label}];
                        composMap(lastCompoLabel) = lastCompoStruct;
                    end
                    if ismember(lastCompoLabel, compoStruct.compo_topo) == 0       % 判断上一个点的label是否在 当前点的邻接表里，如果尚且不在，就添加进去
                        compoStruct.compo_topo = [compoStruct.compo_topo;  {lastCompoLabel}];
                    end
                end
                composMap(compo_label) = compoStruct;
                lastCompoLabel = compo_label;
                line_s = fgetl(projLabeledFile_fid);
            end
            fclose(projLabeledFile_fid);
            
            %------------- 投影视图 各部件写入 png 格式的文件，对各部件分别进行包围盒、图像扩展预处理，然后分别进行 部件图 特征提取
            proj_or_sket = 'proj';
            composMap = calc_compos_feats(proj_or_sket, composMap, projCompoPngOutputFilePath, sketCompoPngOutputFilePath, categoryName , className, modelName, viewName);
            if strcmp(modelName, currentModelName) == 0
                error('Processing three-view labeled modelnames not consistent: modelName = %s, viewName = %s, currentModelName = %s', modelName, viewName, currentModelName);
            end
            if strcmp(viewName, 'front') == 1
                modelStruct.frontComposMap = composMap;
                modelStruct.frontTotalSampCnt = total_samp_cnt;
            elseif strcmp(viewName, 'side') == 1
                modelStruct.sideComposMap = composMap;
                modelStruct.sideTotalSampCnt = total_samp_cnt;
            elseif strcmp(viewName, 'top') == 1
                modelStruct.topComposMap = composMap;
                modelStruct.topTotalSampCnt = total_samp_cnt;
            else
                error('invalid viewName = %s', viewName);
            end
            
            %------------- 将该模型的三个视图的的部件特征向量，写入 SQL Server 数据库
            if model_views_cnt_map(modelName) == 3
                for view_idx = 1 : 3
                    switch view_idx
                        case 1
                            viewName = 'front';
                        case 2
                            viewName = 'side';
                        case 3
                            viewName = 'top';
                    end
                    if strcmp(viewName, 'front')
                        composMap = modelStruct.frontComposMap;
                        total_samp_cnt = modelStruct.frontTotalSampCnt;
                    elseif strcmp(viewName, 'side')
                        composMap = modelStruct.sideComposMap;
                        total_samp_cnt = modelStruct.sideTotalSampCnt;
                    elseif strcmp(viewName, 'top')
                        composMap = modelStruct.topComposMap;
                        total_samp_cnt = modelStruct.topTotalSampCnt;
                    else
                        error('invalid viewName: %s', viewName);
                    end
                    compo_keys_arr = keys(composMap);
                    compoLabels = '';
                    compoWeights = '';
                    compo_feats_str = '';
                    compoTopology = '';
                    [row_size, comp_keys_num] = size(compo_keys_arr);
                    for comp_key_idx = 1 : comp_keys_num
                        compo_str = cell2mat(compo_keys_arr(comp_key_idx));
                        compoStruct = composMap(compo_str);
                        % CompoLabels
                        if comp_key_idx ~= comp_keys_num
                            compoLabels = sprintf('%s%s#', compoLabels, compo_str);
                        else
                            compoLabels = sprintf('%s%s', compoLabels, compo_str);
                        end
                        % CompoWeights
                        if comp_key_idx ~= comp_keys_num
                            compoWeights = sprintf('%s%f#', compoWeights, compoStruct.samp_cnt / total_samp_cnt);
                        else
                            compoWeights = sprintf('%s%f', compoWeights, compoStruct.samp_cnt / total_samp_cnt);
                        end
                        % CompoFeats
                        [feats_row_num, feats_col_num] = size(compoStruct.compo_feats);
                        for feat_idx = 1 : feats_col_num - 1
                            compo_feats_str = sprintf('%s%f,', compo_feats_str, compoStruct.compo_feats(1, feat_idx));
                        end
                        if comp_key_idx ~= comp_keys_num
                            compo_feats_str = sprintf('%s%f#', compo_feats_str, compoStruct.compo_feats(1, feats_col_num)); % 末尾不能有分隔符
                        else
                            compo_feats_str = sprintf('%s%f', compo_feats_str, compoStruct.compo_feats(1, feats_col_num)); % 末尾不能有分隔符
                        end
                        % CompoTopology
                        [topo_row_num, topo_col_num] = size(compoStruct.compo_topo);
                        if topo_row_num > 0
                            for topo_adj_idx = 1 : topo_row_num - 1
                                compoTopology = sprintf('%s%s,', compoTopology, cell2mat(compoStruct.compo_topo(topo_adj_idx, : )));
                            end
                            if comp_key_idx ~= comp_keys_num
                                compoTopology = sprintf('%s%s#', compoTopology, cell2mat(compoStruct.compo_topo(topo_row_num, : )));
                            else
                                compoTopology = sprintf('%s%s', compoTopology, cell2mat(compoStruct.compo_topo(topo_row_num, : )));
                            end
                        end
                    end
                    %calculate entire original view image's global feats
                    viewTxtFileName = sprintf('%s_%s.png', modelName, viewName);
                    fullFilenameWithPath = fullfile(txtViewFilePath, categoryName, className, viewTxtFileName);
					[image, boundImg, rescaleImg, rescaleBinaryImg, fixExpandImg, filledFixExpandImg] = preprocessProjImage(fullFilenameWithPath, imgEdgeLength);
                    reverseFilledFixExpandImg = 1 - filledFixExpandImg;
                    %figure(1); imshow(reverseFilledFixExpandImg); title(viewTxtFileName); hold on;
                    global_feats = calc_global_feats(reverseFilledFixExpandImg);
                    [rowSize, global_feats_num] = size(global_feats);
                    global_feats_str = '';
                    for global_feat_idx = 1 : global_feats_num - 1
                        global_feats_str = sprintf('%s%f,', global_feats_str, global_feats(1 , global_feat_idx));
                    end
                    global_feats_str = sprintf('%s%f', global_feats_str, global_feats(1 , global_feats_num));
                    
                    if strcmp(viewName, 'front')
                        modelStruct.front_comp_keys_num = comp_keys_num;
                        modelStruct.front_compoLabels = compoLabels;
                        modelStruct.front_compoWeights = compoWeights;
                        modelStruct.front_compo_feats_str = compo_feats_str;
                        modelStruct.front_compoTopology = compoTopology;
                        modelStruct.front_global_feats_str = global_feats_str;
                    elseif strcmp(viewName, 'side')
                        modelStruct.side_comp_keys_num = comp_keys_num;
                        modelStruct.side_compoLabels = compoLabels;
                        modelStruct.side_compoWeights = compoWeights;
                        modelStruct.side_compo_feats_str = compo_feats_str;
                        modelStruct.side_compoTopology = compoTopology;
                        modelStruct.side_global_feats_str = global_feats_str;
                    elseif strcmp(viewName, 'top')
                        modelStruct.top_comp_keys_num = comp_keys_num;
                        modelStruct.top_compoLabels = compoLabels;
                        modelStruct.top_compoWeights = compoWeights;
                        modelStruct.top_compo_feats_str = compo_feats_str;
                        modelStruct.top_compoTopology = compoTopology;
                        modelStruct.top_global_feats_str = global_feats_str;
                    else
                        error('invalid viewName: %s', viewName);
                    end
                end
                
                % 写入 SQL Server 数据库
                tableName = 'model';
                columnNames =   {'m_name', 'm_photo_url', 'm_model_url', 'm_score', 'className', ...
                    'frontComposCnt', 'frontCompoLabels',  'frontCompoWeights', 'frontCompoFeats', 'frontCompoTopology', 'frontGlobalFeats' ...
                    'sideComposCnt', 'sideCompoLabels',  'sideCompoWeights', 'sideCompoFeats', 'sideCompoTopology', 'sideGlobalFeats' ...
                    'topComposCnt', 'topCompoLabels',  'topCompoWeights', 'topCompoFeats', 'topCompoTopology', 'topGlobalFeats' };
                m_photo_url = strcat('db/m',num2str(model_id),'/m',num2str(model_id),'_thumb.jpg');
                m_model_url = strcat('C:\modelsearch\db\m',num2str(model_id),'\m',num2str(model_id),'.off');
                compoFeatsData = [{modelName}, {m_photo_url}, {m_model_url}, {0}, {className}, ...
                    {modelStruct.front_comp_keys_num},{modelStruct.front_compoLabels},{modelStruct.front_compoWeights},{modelStruct.front_compo_feats_str}, {modelStruct.front_compoTopology},{modelStruct.front_global_feats_str} ...
                    {modelStruct.side_comp_keys_num}, {modelStruct.side_compoLabels}, {modelStruct.side_compoWeights}, {modelStruct.side_compo_feats_str} , {modelStruct.side_compoTopology}, {modelStruct.side_global_feats_str} ...
                    {modelStruct.top_comp_keys_num},  {modelStruct.top_compoLabels},  {modelStruct.top_compoWeights},  {modelStruct.top_compo_feats_str} ,  {modelStruct.top_compoTopology},  {modelStruct.top_global_feats_str} ];
                fastinsert(conn, tableName, columnNames, compoFeatsData);
            end
        end
    end
end

close(conn);        %断开数据库连接
