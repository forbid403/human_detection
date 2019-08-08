
function [param, sumOfImage] = MakeSumImage(param, f)

currAction = param.action(f);
file_path = char(strcat(param.srcPath,param.name,currAction));

% get files from directory %
fileList = dir([file_path '\*.jpg']);
tempFrame = struct('img',[]);

for i=1:length(fileList)
    tempFrame(i).img = imread([file_path '\' fileList(i).name]);
end

% sum of image difference %
%     numForLoop = length(fileList)-100;
numForLoop = 200;
sumOfImage = zeros(270, 480, 3, 'uint8');

% img loop %
for k = 130:numForLoop
    img1 = rgb2gray(tempFrame(k).img);
    img2 = rgb2gray(tempFrame(k+1).img);
    sumOfImage = sumOfImage + imabsdiff(img1,img2);
end

% set action number %
param.srtAction = f;

