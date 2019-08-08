
% set config %
param = SetConfig();

for f = param.srtAction:length(param.action)
    
    % make sum images %
    [param, image] = MakeSumImage(param, f);
    
    % run YOLO %
    image = runYolo(image);

    % save modified images %
    saveModifiedImages(image, param);

end


