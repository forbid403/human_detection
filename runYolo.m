
function image = runYolo(image)

% Download yolo network %
if exist('yolonet.mat','file') == 0
    url = 'https://www.mathworks.com/supportfiles/gpucoder/cnn_models/Yolo/yolonet.mat';
    websave('yolonet.mat',url);
end

% load yolo network %
if exist('yolonet') ~= 1
    load yolonet.mat
end

% the first time we run the script, we need to modify yolonet and save it
% with a new name (yoloml)

if exist('yoloml.mat','file') == 0
    display('modifying network')
    
    % extract a layer graph from the network. We need to modify this graph.
    lgraph = layerGraph(yolonet.Layers);
    
    % the yolo network from MATLAB is built like a classifier.
    % We need to convert it to a regression network. This means modifying the
    % last two layers
    lgraph = removeLayers(lgraph,'ClassificationLayer');
    lgraph = removeLayers(lgraph,'softmax');
    
    % According to the original YOLO paper, the last transfer function
    % is not a leaky, but a normal ReLu (I think).
    % In MATLAB, this is equivalent to a leaky ReLu with Scale = 0.
    alayer = leakyReluLayer('Name','linear_25','Scale',0);
    rlayer = regressionLayer('Name','routput');
    lgraph = addLayers(lgraph,rlayer);
    lgraph = replaceLayer(lgraph,'leakyrelu_25',alayer);
    lgraph = connectLayers(lgraph,'FullyConnectedLayer1','routput');
    yoloml = assembleNetwork(lgraph);
    
    %save the network with a new name
    display('saving modified network')
    save yoloml yoloml    
 
% if we have created and saved yoloml but not loaded it to workspace, load
% it now.
elseif exist('yoloml') ~= 1
    load('yoloml.mat')
end


probThresh = 0.10;
iouThresh = 0.4;   

%preprocess an image for analysis. For my image of a dog named Stella, I need 
% to resize to 448x448 pixels, and convert from an
%unsigned 8bit to a single with pixel values scaled to [0,1]. I could not find
%the appropriate pixel value scale for yolo recorded anywhere, but convinced
%myself through reverse engineering that [0,1] is correct.

image = single(imresize(image,[448 448]))/255;

% Define class labels
classLabels = ["person"];

%run the image through the network. Replace 'gpu' with 'cpu' if you do not
%have a CUDA enbled GPU.

tic
out = predict(yoloml,image,'ExecutionEnvironment','gpu');
toc

%plot the 1x1470 output vector. Indices 1-980 are class probabilities,
%981-1079 are cell/box probabilities, and 1080-1470 are bounding box parameters
% figure(2)
% plot(out)


% in order to make interpretation of this output vector more manageable
% with my finite visual-spatial skills, I decided to reshape the vector
% into a 7x7x30 array with the third dimension containing all information
% for each of the 7x7 cells.

class = out(1:980);
boxProbs = out(981:1078);
boxDims = out(1079:1470);

outArray = zeros(7,7,30);
temp = class;
    for j = 0:6
        for i = 0:6
            outArray(i+1,j+1,1:20) = class(i*20*7+j*20+1:i*20*7+j*20+20);
            outArray(i+1,j+1,21:22) = boxProbs(i*2*7+j*2+1:i*2*7+j*2+2);
            outArray(i+1,j+1,23:30) = boxDims(i*8*7+j*8+1:i*8*7+j*8+8);
        end
    end

%find boxes with probabilities above a defined probability threshold. 0.2 seems to
%work well. cellIndex tells us which of two bounding boxes for each cell
%has higher probability. 1 for vertical box and 2 for horizontal box.

[cellProb cellIndex] = max(outArray(:,:,21:22),[],3);
contain = max(outArray(:,:,21:22),[],3)>probThresh;

%find highest probability object class type for each cell, save it to
%classMaxIndex
[classMax,classMaxIndex] = max(outArray(:,:,1:20),[],3);

% figure(3)
% imagesc(contain);

%put object containing box coordinates and other relevant information in a cell
%array
counter = 0;
for i = 1:7
    for j = 1:7
        if contain(i,j) == 1
            counter = counter+1;           
            
            % Bounding box center relative to cell
            x = outArray(i,j,22+1+(cellIndex(i,j)-1)*4);
            y = outArray(i,j,22+2+(cellIndex(i,j)-1)*4);
            
            % Yolo outputs the square root of the width and height of the
            % bounding boxes (subtle detail in paper that took me forver to realize). 
            % Relative to image size.
            w = (outArray(i,j,22+3+(cellIndex(i,j)-1)*4))^2;
            h = (outArray(i,j,22+4+(cellIndex(i,j)-1)*4))^2;
           
           %absolute values scaled to image size
            wS = w*448; 
            hS = h*448;
            xS = (j-1)*448/7+x*448/7-wS/2;
            yS = (i-1)*448/7+y*448/7-hS/2;
            
            % this array will be used for drawing bounding boxes in Matlab
            boxes(counter).coords = [xS yS wS hS]; 
            
            %save cell indices in the structure
            boxes(counter).cellIndex = [i,j];
            
            %save classIndex to structure
            boxes(counter).classIndex = classMaxIndex(i,j);    
            
            % save cell proability to structure
            boxes(counter).cellProb = cellProb(i,j);

            % put in a switch for non max which we will use later
            boxes(counter).nonMax = 1;
        end            
    end
end

image = insertShape(image, 'Rectangle', boxes(1).coords, 'LineWidth', 4);
figure
imshow(image);



