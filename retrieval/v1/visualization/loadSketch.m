function [sketch, strokeSeq] = loadSketch(sketch_png_path, sketch_txt_path)
[~,~,sketch] = imread(sketch_png_path);
fid = fopen(sketch_txt_path);
strokeSeq = fgetl(fid);
fclose(fid);
end