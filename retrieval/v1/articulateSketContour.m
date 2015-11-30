function [articu_cont, n_contsamp, n_contsamp_of_conn_cont_mat, adjacencyList, total_cont] = articulateSketContour( Contours, samp_step_length )
articu_cont = []; 
n_contsamp = 0;
n_contsamp_of_conn_cont_mat = zeros(length(Contours), 1);
adjacencyList = [];
total_cont = [];
for conn_cont_idx = 1 : length(Contours)
    the_articu_cont = Contours{conn_cont_idx}';
    total_cont = [total_cont the_articu_cont'];
    
    %[min_v,id]	= min(the_articu_cont(:,2)+the_articu_cont(:,1));
    %the_articu_cont		= circshift(the_articu_cont,[length(the_articu_cont)-id+1]);
    
    % 通过采样前contour长度，以及samp_step_length采样步长参数，来计算对于该轮廓合适的采样点总数
    [redundancy_removed_cur_cont_length  col_size] = size(the_articu_cont);
    cur_conn_comp_n_contsamp =  round(redundancy_removed_cur_cont_length / samp_step_length);   % 该段的大致目标采样点数预估，注意四舍五入取整
    
    % -------------- Downsampling contour
    if cur_conn_comp_n_contsamp < 3       % 当该段去冗余轮廓线有3个或以上采样点数时，才进行均匀采样(加此限制能有效去除视图中的离散噪声点)，否则直接丢弃不采样
        continue;
    end
    [XIs,YIs]	= uniform_interp(the_articu_cont(:,1), the_articu_cont(:,2), cur_conn_comp_n_contsamp - 1);   %均匀采样
    the_articu_cont	  = [the_articu_cont(1,:); [XIs YIs]];
    % 均匀差值算法导致的插值样本点坐标值为实数，所以需要用 round 函数四舍五入取整，去除小数部分
    the_articu_cont = round(the_articu_cont);
    [n_contsamp_of_conn_component, col_size] = size(the_articu_cont);
    n_contsamp_of_conn_cont_mat(conn_cont_idx, 1) = n_contsamp_of_conn_component;
    articu_cont = [articu_cont; the_articu_cont];
    
    % calculate adjacency list,注意对整个列表的头尾特殊处理
    [num_of_samp_pts, col_size] = size(the_articu_cont);
    for samp_p_idx = 1 : num_of_samp_pts
        prev_idx = 0;      % initialize as an invalid index (normal index start from 1)
        next_idx = 0;      % ditto
        % 注意对整个列表的头尾特殊处理
        if  samp_p_idx == 1                              % 如果是the_articu_cont第一个采样点
            % 与上一个采样点(the_articu_cont最后一个采样点，类似循环链表)比较判断是否满足邻接关系：轮廓线采样点相邻(基于采样点有序)，以及欧氏距离与采样步长之间的比较
            if euclideanDist(the_articu_cont(samp_p_idx, 1), the_articu_cont(samp_p_idx, 2), the_articu_cont(num_of_samp_pts, 1), the_articu_cont(num_of_samp_pts, 2)) <= 2 * samp_step_length
                prev_idx = n_contsamp + num_of_samp_pts;
            end
            % 下一个采样点
            next_idx = n_contsamp + samp_p_idx + 1;
        elseif samp_p_idx == num_of_samp_pts             % 如果是the_articu_cont最后一个采样点
            % 上一个采样点
            prev_idx = n_contsamp + samp_p_idx - 1;
            % 与下一个采样点比较(the_articu_cont第一个采样点)，类似循环链表
            if euclideanDist(the_articu_cont(samp_p_idx, 1), the_articu_cont(samp_p_idx, 2), the_articu_cont(1, 1), the_articu_cont(1, 2)) <= 2 * samp_step_length
                next_idx = n_contsamp + 1;
            end
        else                                             % the_articu_cont中部的采样点
            prev_idx = n_contsamp + samp_p_idx - 1;      % 上一个采样点
            next_idx = n_contsamp + samp_p_idx + 1;      % 下一个采样点
        end
        adjacencyList = [adjacencyList;  prev_idx  next_idx];
    end
    % 累加 n_contsamp
    n_contsamp = n_contsamp + num_of_samp_pts;
end


end

