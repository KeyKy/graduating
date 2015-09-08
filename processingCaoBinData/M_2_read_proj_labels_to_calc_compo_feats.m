% ѭ�����д��࣬����Ǵ���ɲ����ľ��󣬱��沿����pngͼ�񣬼��㲿������������д��SQL���ݿ⣬�����߼���ʱʹ��

addPathsAndLoadVariables;
clear_global_var();

conn = database('CSDB', 'xuchi', '123456');   % �������ݿ�, �����ֱ�Ϊ���ݿ����ƣ��û�������¼����
if strcmp(conn.AutoCommit, 'on') ~= 1           % ���δ�������ӣ��򱨴���ֹ����
    error('DB Not Connected: conn.Message = %s!',conn.Message);
end
exec(conn, 'DELETE FROM [CSDB].[dbo].[model]');
exec(conn, 'DELETE FROM [CSDB].[dbo].[classTable]');
exec(conn, 'DELETE FROM [CSDB].[dbo].[categoryTable]');

% ��ٴ���Ŀ¼���ƣ�д�������У�����ѭ����������(��30����)
% ��㣺��Ŀ¼�µĸ�������Ŀ¼
categoryNamesDirs = dir(labelFilePath);       % �г� labelFilePath �ĸ�Ŀ¼�µ����д���
categoryNamesDirsArr = struct2cell(categoryNamesDirs)' ;    % �ṹ��(struct����)ת����Ԫ������(cell)��ת��һ�������ļ�����������
categoryNamesArr = categoryNamesDirsArr( : , 1);     % ��һ�����ļ�����
category_names_num = size(categoryNamesArr);
for category_idx = 3 : category_names_num            % �±��3��ʼѭ������ΪĿ¼���±�Ϊ1����'.',�±�Ϊ2����'..'
    categoryName = cell2mat(categoryNamesArr(category_idx));
    
    tableName = 'categoryTable';
    columnNames =   {'categoryName'};
    compoFeatsData = [{categoryName}];
    fastinsert(conn, tableName, columnNames, compoFeatsData);
    
    % �����ض�ȡ�ô�����ÿ��С�����ͼ�������ǩ�ı�
    
    % �в㣺����Ŀ¼�µĸ���С��Ŀ¼
    classNamesDirs = dir(fullfile(labelFilePath, categoryName));       % �г�����ĸ�Ŀ¼�µ�������Ŀ¼
    classNamesDirsArr = struct2cell(classNamesDirs)' ;      % �ṹ��(struct����)ת����Ԫ������(cell)��ת��һ�������ļ�����������
    classNamesArr = classNamesDirsArr( : , 1);              % ��һ�����ļ�����
    class_names_num = size(classNamesArr);
    for class_idx = 3 : class_names_num                     % �±��3��ʼѭ������ΪĿ¼���±�Ϊ1����'.',�±�Ϊ2����'..'
        className = cell2mat(classNamesArr(class_idx));
        tableName = 'classTable';
        columnNames =   {'className', 'categoryName'};
        compoFeatsData = [{className}, {categoryName}];
        fastinsert(conn, tableName, columnNames, compoFeatsData);
        
        model_views_cnt_map = containers.Map();
        % �ڲ㣺С��Ŀ¼�µĸ����ļ�
        fileNamesDirs = dir(fullfile(labelFilePath, categoryName, className, '*.txt'));   % ���ؽṹ����
        fileNamesDirsArr = struct2cell(fileNamesDirs)' ;    % �ṹ��(struct����)ת����Ԫ������(cell)��ת��һ�������ļ�����������
        fileNamesArr = fileNamesDirsArr( : , 1);            % ��һ�����ļ���
        file_names_num = size(fileNamesArr);
        for file_idx = 1 : file_names_num        % ע���ļ����±겻�漰'.'��'..'������Ӧ�ô�1��ʼ����ͬ��Ŀ¼�±꣨��3��ʼ��
            projLabeledFilename = cell2mat(fileNamesArr(file_idx));
            splitted_labeledFilename = regexp(projLabeledFilename, '_', 'split');   % ��ǩ�ļ���ʽʾ����  seg_m123_front.txt
            modelName = cell2mat(splitted_labeledFilename( : , 2));            % model_id_str ��ʽʾ���� m123
            model_id = str2double( modelName(2 : length(modelName)));                  % ȥ�� model_id_str �ĵ�һ����ĸm�����µĲ���תΪ����
            view_and_txt_str = cell2mat(splitted_labeledFilename( : , 3));            % view_and_txt_str ��ʽʾ���� front.txt
            view_and_txt_cell_arr = regexp(view_and_txt_str, '\.', 'split');
            viewName = cell2mat(view_and_txt_cell_arr( : , 1));
            
            if ismember(modelName, keys(model_views_cnt_map)) == 0           % �����ģ�͵��κ��ӽǵ�label�ļ���δ�����������ô�ͳ�ʼ������Ϊ0����ʼ�������ģ�������ӽ����ݵ�structΪ��
                model_views_cnt_map(modelName)  = 0;
                modelStruct = [];
                currentModelName = modelName;       % ��¼�£�����У�飬��ֹ���ڶ����ı��ļ������ȱʧ�����³���
            end
            model_views_cnt_map(modelName) = model_views_cnt_map(modelName) + 1;
            % ��ȡͶӰ��ͼ�Ĳ�����ǩ�ļ���ƴ�ӳ����������ֱ�������
            projLabeledFilePath = fullfile(labelFilePath, categoryName, className, projLabeledFilename)       % Process indicator, without semicolon
            projLabeledFile_fid = fopen(projLabeledFilePath, 'r');
            line_s = fgetl(projLabeledFile_fid);
            total_samp_cnt = 0;                            % �������������������ڼ��㲿����Ȩ�ر���
            composMap = containers.Map();
            lastCompoLabel = '';
            while line_s ~= -1
                % �ò���������������1
                total_samp_cnt = total_samp_cnt + 1;
                splitted_str_cell_arr = regexp(line_s, ' ', 'split');
                compo_label = cell2mat(splitted_str_cell_arr( : , 1));
                
                samp_p_x = round(str2double(cell2mat(splitted_str_cell_arr( : , 2))) / 2);   % ����ͼ��СΪԭͼһ�룬������Ӧ����
                samp_p_y = round(str2double(cell2mat(splitted_str_cell_arr( : , 3))) / 2);
                if ismember(compo_label, keys(composMap)) == 0   % �����label���Ҳ�������ӳ���У�����ӽ�ȥ����¼��������1
                    compoStruct.samp_cnt = 0;
                    compoStruct.prev_p_x = 0;
                    compoStruct.prev_p_y = 0;
                    compoStruct.compo_mat = zeros(imgEdgeLength / 2, imgEdgeLength / 2);   % ����ͼ�߳�Ϊ��ͼ��һ�룬�� 200 / 2 = 100
                    compoStruct.compo_feats = [];  % ��ʱ��ʱ��֪����������ά�����ʲ��� zeros ���ٳ�ʼ��
                    compoStruct.compo_topo = {};
                    composMap(compo_label) = compoStruct;
                end
                compoStruct = composMap(compo_label);
                compoStruct.samp_cnt = compoStruct.samp_cnt + 1;
                % ����ǰ����������һ������˳��ƴ��(�� samp_step_length * 2 ��Ϊ������ֵ)������(���������ڲ���������߶�)�����������ݽṹ��
                prev_samp_p_x = compoStruct.prev_p_x;
                prev_samp_p_y = compoStruct.prev_p_y;
                % ����Ӿ����ж�����prev��x��y���궼��0��˵����ǰ���Ǹò����ĵ�һ���㣬���Բ������߶δ�������̫ԶҲ�������ߴ���
                if prev_samp_p_x ~= 0 & prev_samp_p_y ~= 0 & euclideanDist( samp_p_x, samp_p_y, prev_samp_p_x, prev_samp_p_y ) <= (samp_step_length * 2)
                    compoStruct.compo_mat = drawLineInMatrix(compoStruct.compo_mat, samp_p_x, samp_p_y, prev_samp_p_x, prev_samp_p_y);
                end
                % ��ͬ�����Ĳ����㽻����֣�prev_samp_p ��Ҫ�������ֱ��¼���������壬�ѵ�ǰ��������Ϊ�ò����� prev sample point����¼�ھ�����
                compoStruct.prev_p_x = samp_p_x;
                compoStruct.prev_p_y = samp_p_y;
                % Topology: �����ǰ��label����һ�����ڵ��label��ͬ
                if strcmp(lastCompoLabel, '') == 0  & strcmp(compo_label, lastCompoLabel) == 0
                    lastCompoStruct = composMap(lastCompoLabel);
                    if ismember(compo_label, lastCompoStruct.compo_topo) == 0          % �жϵ�ǰ���label�Ƿ��� ��һ������ڽӱ��������Ҳ��ڣ�����ӽ�ȥ
                        lastCompoStruct.compo_topo = [lastCompoStruct.compo_topo;  {compo_label}];
                        composMap(lastCompoLabel) = lastCompoStruct;
                    end
                    if ismember(lastCompoLabel, compoStruct.compo_topo) == 0       % �ж���һ�����label�Ƿ��� ��ǰ����ڽӱ��������Ҳ��ڣ�����ӽ�ȥ
                        compoStruct.compo_topo = [compoStruct.compo_topo;  {lastCompoLabel}];
                    end
                end
                composMap(compo_label) = compoStruct;
                lastCompoLabel = compo_label;
                line_s = fgetl(projLabeledFile_fid);
            end
            fclose(projLabeledFile_fid);
            
            %------------- ͶӰ��ͼ ������д�� png ��ʽ���ļ����Ը������ֱ���а�Χ�С�ͼ����չԤ����Ȼ��ֱ���� ����ͼ ������ȡ
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
            
            %------------- ����ģ�͵�������ͼ�ĵĲ�������������д�� SQL Server ���ݿ�
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
                            compo_feats_str = sprintf('%s%f#', compo_feats_str, compoStruct.compo_feats(1, feats_col_num)); % ĩβ�����зָ���
                        else
                            compo_feats_str = sprintf('%s%f', compo_feats_str, compoStruct.compo_feats(1, feats_col_num)); % ĩβ�����зָ���
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
                
                % д�� SQL Server ���ݿ�
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

close(conn);        %�Ͽ����ݿ�����
