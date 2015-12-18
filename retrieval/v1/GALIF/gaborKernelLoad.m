function [ kernel ] = gaborKernelLoad()


basePath = 'F:\\gabor\\kernel\\';
kernelFiles = dir(basePath);
for i = 3 : length(kernelFiles)
    fileName = kernelFiles(i).name;
    delete(sprintf('%s%s', basePath, fileName));
end
system('E:\\Python27\\python gaborKernel.py');
kernelFiles = dir(basePath);
kernel = {};
for i = 3 : length(kernelFiles)
    fileName = kernelFiles(i).name;
    stru = load(sprintf('%s%s', basePath, fileName));
    g = stru.g;
    kernel{end+1} = g;
end

end

