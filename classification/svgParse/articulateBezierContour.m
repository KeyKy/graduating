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
    cur_conn_comp_n_contsamp =  round(redundancy_removed_cur_cont_length / samp_step_length);   % �öεĴ���Ŀ���������Ԥ����ע����������ȡ��
    
    if cur_conn_comp_n_contsamp < 2       % ���ö�ȥ������������3�������ϲ�������ʱ���Ž��о��Ȳ���(�Ӵ���������Чȥ����ͼ�е���ɢ������)������ֱ�Ӷ���������
        continue;
    end
    [XIs,YIs]	= uniform_interp(the_articu_cont(:,1), the_articu_cont(:,2), cur_conn_comp_n_contsamp - 1);   %���Ȳ���
    the_articu_cont	  = [the_articu_cont(1,:); [XIs YIs]];
    % ���Ȳ�ֵ�㷨���µĲ�ֵ����������ֵΪʵ����������Ҫ�� round ������������ȡ����ȥ��С������
    the_articu_cont = round(the_articu_cont);
    [n_contsamp_of_conn_component, col_size] = size(the_articu_cont);
    n_contsamp_of_conn_cont_mat(conn_cont_idx, 1) = n_contsamp_of_conn_component;
    articu_cont = [articu_cont; the_articu_cont];
end

end

