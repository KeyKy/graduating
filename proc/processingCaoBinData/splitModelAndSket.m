function [ selectedModels, sketStr] = splitModelAndSket( originalStr )
splited = splitStr(originalStr, ';');
selectedModels = splited{1,1};
sketStr = splited{1,2};

end

