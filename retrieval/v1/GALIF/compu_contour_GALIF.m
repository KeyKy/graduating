function [ the_galif_feats ] = compu_contour_GALIF( resp, samp_cont )
n_Resp = length(resp);
[n_y, n_x] = size(resp{1});
n_samp = size(samp_cont,1);
the_galif_feats = [];
for i = 1 : n_samp
    %[samp_x, samp_y] = samp_cont(i,:);
    samp_x = samp_cont(i,1); samp_y = samp_cont(i,2);
%     if samp_x - 18 < 0 || samp_x + 17 > n_x || samp_y - 18 < 0 || samp_y + 17 > n_y
%         continue;
%     end
    samp_galif = [];
    for j = 1 : n_Resp
        patch = resp{j}(samp_y-18:samp_y+17,samp_x-18:samp_x+17);
%        imshow(patch,[]);
        the_ori_galif = tilePatch(patch, 4, 4);
        samp_galif = [samp_galif the_ori_galif];
    end
    samp_galif = samp_galif ./ norm(samp_galif, 2);
    %vis_galif = reshape(samp_galif, 16, 8);
    the_galif_feats = [the_galif_feats samp_galif'];
end


end

