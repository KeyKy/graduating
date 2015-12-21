function the_ori_galif = tilePatch(patch, n_row_tile, n_col_tile)
[n_row, n_col] = size(patch);
each_row_tile = round(n_row/ n_row_tile);
each_col_tile = round(n_col/ n_col_tile);
row_idx_array = [1 : n_row];
row_tiles = {}; start = 1;
for i = 1 : n_row_tile-1
    row_tiles{end+1} = row_idx_array(start:start+each_row_tile-1);
    start = start + each_row_tile;
end
row_tiles{end+1} = row_idx_array(start : end);

col_idx_array = [1 : n_col];
col_tiles = {}; start = 1;
for i = 1 : n_col_tile-1
    col_tiles{end+1} = col_idx_array(start:start+each_row_tile-1);
    start = start + each_row_tile;
end
col_tiles{end+1} = col_idx_array(start : end);
the_ori_galif = [];
for i = 1 : n_row_tile
    row_idx = row_tiles{i};
    for j = 1 : n_col_tile
        col_idx = col_tiles{j};
        tile = patch(row_idx, col_idx);
        total_resp_tile = sum(sum(tile));
        the_ori_galif = [the_ori_galif total_resp_tile];
    end
end


end