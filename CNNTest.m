function [DataSet, SalImg, PrecEER]  = CNNTest(varargin)
% experiment and data paths
opts.expDir = [];
opts.GPUID = [];
opts.TestDir = [];
opts.TestClassName = [];
opts.imdb = [];
opts = vl_argparse(opts, varargin) ;

ModelList = dir([opts.expDir '/net-epoch*.mat']);
NumEpoches = numel(ModelList) - 1;



opts.ModelPath = cell(1, NumEpoches);
for i = 1:NumEpoches
    opts.ModelPath{i} = [opts.expDir '/net-epoch-' num2str(i) '.mat'];
end

averageImage = load(strrep(opts.ModelPath{1}, '-1.mat','-0.mat'), 'AvgImage');

averageImage = averageImage.AvgImage(1, 1, :);
inputVar = 'input';


imdb = load([opts.TestDir  '/TrainTestSplit.mat'], 'TestSet');
AllClassName = {imdb.TestSet.ClassName};
ClassID = strcmp(AllClassName,opts.TestClassName);
imdb = imdb.TestSet(ClassID);
NumImages = numel(imdb.ImageName);
ImageList = cell(NumImages, 1);
MaskList = cell(NumImages, 1);
DataSet = struct('Image', ImageList, 'Mask', ImageList, ...
    'ImageLabel', ImageList, 'ImageName', ImageList);

for imId = 1:NumImages
    rgbPath = [opts.TestDir '/' imdb.ImageName{imId}];
    labelsPath = [opts.TestDir '/' imdb.MaskName{imId}];
    Image = imread(rgbPath);
    Mask = imread(labelsPath);
    ImageList{imId} = bsxfun(@minus, single(Image), averageImage);
    MaskList{imId} = vec(single(Mask));
    DataSet(imId).Image = Image;
    DataSet(imId).Mask = Mask;
    DataSet(imId).ImageLabel = imdb.ImageLabel(imId);
    [~,ImageName,~] = fileparts(imdb.ImageName{imId});
    DataSet(imId).ImageName = ImageName;
end
PrecEER = zeros(numel(opts.ModelPath), 1);
SalImg = cell(NumImages, 1);
TempSalImg = cell(NumImages, 1); 
for EpochID = 1:numel(opts.ModelPath)
    if isempty(opts.ModelPath{EpochID})
        continue
    end
    disp(['EpochID: ' num2str(EpochID) '/' num2str(numel(opts.ModelPath))])
    tic
    SalImgList = cell(NumImages, 1);
    [net, predVar] = LoadNet(opts.ModelPath{EpochID}, opts.GPUID);
    for imId = 1:NumImages
        Image = ImageList{imId};
        sz = [size(Image,1), size(Image,2)] ;
        sz_ = round(sz / 32)*32 ;
        Image_ = imresize(Image, sz_) ;
        if ~isempty(opts.GPUID)
            Image_ = gpuArray(Image_) ;
        end
        net.eval({inputVar, Image_});
        
        scores = gather(net.vars(predVar).value);
        SalMap = imresize(scores, sz);
        SalImgList{imId, 1} = vec(SalMap);
        TempSalImg{imId} = SalMap;
        net.reset();
    end
    [Precision, Recall, EER, TempPrecEER] = EvalResult(SalImgList, MaskList);
    toc
    if TempPrecEER > max(PrecEER)
        SalImg = TempSalImg;
    end
    PrecEER(EpochID) = TempPrecEER;
    
end
end

function [net, predVar] = LoadNet(ModelPath, GPUID)
net = load(ModelPath) ;
net = dagnn.DagNN.loadobj(net.net);
LayerName = {net.layers.name}';
Temp = strfind(LayerName, 'Classifier');
RemoveLayerName = LayerName(cellfun(@NonEmpty, Temp));
RemoveLayerName{end+1} = 'objective';
net.removeLayer(RemoveLayerName);
predVar = net.getVarIndex('ObjSalPred') ;
net.vars(predVar).precious = true;
net.mode = 'test' ;
if ~isempty(GPUID)
    net.move('gpu') ;
end
end

function V = NonEmpty(V)
V = ~isempty(V);
end

function V = vec(V)
V = V(:);
end