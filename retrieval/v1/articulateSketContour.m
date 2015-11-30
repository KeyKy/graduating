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
    
    % ͨ������ǰcontour���ȣ��Լ�samp_step_length����������������������ڸ��������ʵĲ���������
    [redundancy_removed_cur_cont_length  col_size] = size(the_articu_cont);
    cur_conn_comp_n_contsamp =  round(redundancy_removed_cur_cont_length / samp_step_length);   % �öεĴ���Ŀ���������Ԥ����ע����������ȡ��
    
    % -------------- Downsampling contour
    if cur_conn_comp_n_contsamp < 3       % ���ö�ȥ������������3�������ϲ�������ʱ���Ž��о��Ȳ���(�Ӵ���������Чȥ����ͼ�е���ɢ������)������ֱ�Ӷ���������
        continue;
    end
    [XIs,YIs]	= uniform_interp(the_articu_cont(:,1), the_articu_cont(:,2), cur_conn_comp_n_contsamp - 1);   %���Ȳ���
    the_articu_cont	  = [the_articu_cont(1,:); [XIs YIs]];
    % ���Ȳ�ֵ�㷨���µĲ�ֵ����������ֵΪʵ����������Ҫ�� round ������������ȡ����ȥ��С������
    the_articu_cont = round(the_articu_cont);
    [n_contsamp_of_conn_component, col_size] = size(the_articu_cont);
    n_contsamp_of_conn_cont_mat(conn_cont_idx, 1) = n_contsamp_of_conn_component;
    articu_cont = [articu_cont; the_articu_cont];
    
    % calculate adjacency list,ע��������б��ͷβ���⴦��
    [num_of_samp_pts, col_size] = size(the_articu_cont);
    for samp_p_idx = 1 : num_of_samp_pts
        prev_idx = 0;      % initialize as an invalid index (normal index start from 1)
        next_idx = 0;      % ditto
        % ע��������б��ͷβ���⴦��
        if  samp_p_idx == 1                              % �����the_articu_cont��һ��������
            % ����һ��������(the_articu_cont���һ�������㣬����ѭ������)�Ƚ��ж��Ƿ������ڽӹ�ϵ�������߲���������(���ڲ���������)���Լ�ŷ�Ͼ������������֮��ıȽ�
            if euclideanDist(the_articu_cont(samp_p_idx, 1), the_articu_cont(samp_p_idx, 2), the_articu_cont(num_of_samp_pts, 1), the_articu_cont(num_of_samp_pts, 2)) <= 2 * samp_step_length
                prev_idx = n_contsamp + num_of_samp_pts;
            end
            % ��һ��������
            next_idx = n_contsamp + samp_p_idx + 1;
        elseif samp_p_idx == num_of_samp_pts             % �����the_articu_cont���һ��������
            % ��һ��������
            prev_idx = n_contsamp + samp_p_idx - 1;
            % ����һ��������Ƚ�(the_articu_cont��һ��������)������ѭ������
            if euclideanDist(the_articu_cont(samp_p_idx, 1), the_articu_cont(samp_p_idx, 2), the_articu_cont(1, 1), the_articu_cont(1, 2)) <= 2 * samp_step_length
                next_idx = n_contsamp + 1;
            end
        else                                             % the_articu_cont�в��Ĳ�����
            prev_idx = n_contsamp + samp_p_idx - 1;      % ��һ��������
            next_idx = n_contsamp + samp_p_idx + 1;      % ��һ��������
        end
        adjacencyList = [adjacencyList;  prev_idx  next_idx];
    end
    % �ۼ� n_contsamp
    n_contsamp = n_contsamp + num_of_samp_pts;
end


end

