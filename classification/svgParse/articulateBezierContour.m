function [articu_cont, n_contsamp, n_contsamp_of_conn_cont_mat, adjacencyList, total_cont] = articulateBezierContour( Contours, samp_step_length )
articu_cont = []; 
n_contsamp = 0;
n_contsamp_of_conn_cont_mat = zeros(length(Contours), 1);
adjacencyList = [];
total_cont = [];
for conn_cont_idx = 1 : length(Contours)
    the_articu_cont = Contours{conn_cont_idx}';
    total_cont = [total_cont the_articu_cont'];
    
    [redundancy_removed_cur_cont_length  col_size] = size(the_articu_cont);
    cur_conn_comp_n_contsamp =  round(redundancy_removed_cur_cont_length / samp_step_length);   % 该段的大致目标采样点数预估，注意四舍五入取整
    
    if cur_conn_comp_n_contsamp < 2       % 当该段去冗余轮廓线有3个或以上采样点数时，才进行均匀采样(加此限制能有效去除视图中的离散噪声点)，否则直接丢弃不采样
        continue;
    end
    [XIs,YIs]	= uniform_interp(the_articu_cont(:,1), the_articu_cont(:,2), cur_conn_comp_n_contsamp - 1);   %均匀采样
    the_articu_cont	  = [the_articu_cont(1,:); [XIs YIs]];
    % 均匀差值算法导致的插值样本点坐标值为实数，所以需要用 round 函数四舍五入取整，去除小数部分
    the_articu_cont = round(the_articu_cont);
    [n_contsamp_of_conn_component, col_size] = size(the_articu_cont);
    n_contsamp_of_conn_cont_mat(conn_cont_idx, 1) = n_contsamp_of_conn_component;
    articu_cont = [articu_cont; the_articu_cont];
end

end

