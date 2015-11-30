function [ kernel ] = loadGaborKernel()
system('E:\\Python27\\python gaborKernel.py');
basePath = 'F:\\gabor\\kernel\\';
kernelFiles = dir(basePath);
kernel = {};
for i = 3 : length(kernelFiles)
    fileName = kernelFiles(i).name;
    stru = load(sprintf('%s%s', basePath, fileName));
    g = stru.g;
    kernel{end+1} = g;
end

end

