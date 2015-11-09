function zipCate( cateToProj )
BASE_PATH = 'D:\\projections\\category_proj\\';
cateFiles = dir(BASE_PATH);
for i = 3 : length(cateFiles)
    cateName = cateFiles(i).name;
    n_projFile = 14 * length(cateToProj(cateName));
    projFiles = dir(sprintf('%s%s',BASE_PATH,cateName));
    if n_projFile == length(projFiles)-2
        %zip(sprintf('%s%s',BASE_PATH,cateName),sprintf('%s%s',BASE_PATH,cateName));
        rmdir(sprintf('%s%s',BASE_PATH,cateName), 's');
    end
end


end

