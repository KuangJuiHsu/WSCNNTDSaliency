function opts = CNNTrain(varargin)
opts.expDir = 'data/WSSaliency' ;
opts.dataDir = [pwd '/Dataset/Graz02'];
opts.modelType = 'fcn8s' ;
opts.FCNModelPath = 'data/models/imagenet-vgg-verydeep-16.mat' ;
opts.DataSetName = 'Graz02';
opts.Lambda = [4 0]; 
opts.GPUID = 1;
opts.ClassName = [];
opts.ClassifierModelPath = [];
opts.learningRate = 0.00001 * ones(1, 100);
opts.IsReturnData = false;
[opts, varargin] = vl_argparse(opts, varargin) ;
if isempty(opts.ClassName) || isempty(opts.ClassifierModelPath)
    error('No Class Name Specified Or No Classifier Model Path Specified!!')
end
if length(opts.Lambda) == 1
    opts.Lambda = [opts.Lambda 0];
end
opts.expDir = New_mkdir([opts.expDir '/' opts.ClassName '/Lambda' num2str(opts.Lambda(1)) '&' num2str(opts.Lambda(2))]);
     
% training options (SGD)
opts.train.batchSize = 20 ;
opts.train.numSubBatches = 5;
opts.train.continue = true ;
opts.train.gpus = opts.GPUID;
opts.train.prefetch = true ;
opts.train.expDir = opts.expDir ;
opts.train.learningRate = opts.learningRate;
opts.train.numEpochs = numel(opts.train.learningRate) ;
[opts] = vl_argparse(opts, varargin) ;
IsModelExist = exist([opts.expDir '/' sprintf('net-epoch-%d.mat', numel(opts.train.learningRate))], 'file');
if ~IsModelExist || opts.IsReturnData
    % -------------------------------------------------------------------------
    % Setup data
    % -------------------------------------------------------------------------
     
    imdb = SetupDataset(opts);
    train = find(imdb.images.set == 1);
    if IsModelExist
        return;
    end
    % -------------------------------------------------------------------------
    % Setup model
    % -------------------------------------------------------------------------
    
    % Get initial model from VGG-VD-16
    InitialModelPath = [opts.expDir '/net-epoch-0.mat'];
    if ~exist(InitialModelPath, 'file')
        net = fcnInitializeSaliencyModel('sourceModelPath', opts.FCNModelPath) ;
        if any(strcmp(opts.modelType, {'fcn16s', 'fcn8s'}))
            % upgrade model to FCN16s
            net = fcnInitializeSaliencyModel16s(net) ;
        end
        if strcmp(opts.modelType, 'fcn8s')
            % upgrade model fto FCN8s
            net = fcnInitializeSaliencyModel8s(net) ;
        end
        [net, AvgImage] = InitializeWSModel(net, opts);
        
        net_ = net ;
        net = net_.saveobj() ;
        save(InitialModelPath, 'net', 'AvgImage');
        clear net_ net
    end
    save([opts.expDir '/opts.mat'], 'opts');
    % -------------------------------------------------------------------------
    % Train
    % -------------------------------------------------------------------------
    
    % Launch SGD
    
    net = load(InitialModelPath, 'net', 'AvgImage') ;
    AvgImage = net.AvgImage;
    net = dagnn.DagNN.loadobj(net.net) ;
    net.layers(net.getLayerIndex('objective')).block.SetLambdas([1 opts.Lambda]);
    BGSegMaskList = zeros([size(AvgImage,1 ) size(AvgImage,2) , 1, ceil(opts.train.batchSize/opts.train.numSubBatches)], 'single');
    FunHand = @(imdb,batch)getBatch(imdb, batch, AvgImage, BGSegMaskList, opts);
    WS_CNN_Train(net, imdb, FunHand, ...
        opts.train, ....
        'train', train, ...
        'val', [], ...
        opts.train) ;
end
end

function y = getBatch(imdb, images, AvgImage, BGSegMaskList, opts)
% GET_BATCH  Load, preprocess, and pack images for CNN evaluation
ImageList = imdb.ImageList(:,:,:,images);
ImageLabelList = imdb.ImageLabelList(images);
BGSegMaskList = BGSegMaskList(:,:,:,1:sum(ImageLabelList == 0));
if ~isempty(opts.train.gpus) > 0
    ImageList = gpuArray(ImageList);
    ImageLabelList = gpuArray(ImageLabelList);
    AvgImage = gpuArray(AvgImage);
    BGSegMaskList = gpuArray(BGSegMaskList);
end
ImageList = bsxfun(@minus, ImageList, AvgImage);
y = {'input', ImageList, 'AvgImage', AvgImage, ...
    'ImageLabel', ImageLabelList, 'BGSegMask', BGSegMaskList};
end

function imdb = SetupDataset(opts)
DataAugFunList = {@(X)(X), @(X)flip(X,1), @(X)flip(X,2), @(X)rot90(X), @(X)rot90(rot90(X)), @(X)rot90(rot90(rot90(X)))};
Dataset = load([opts.dataDir  '/TrainTestSplit.mat'], 'TrainSet', 'TestSet');
TrainSet = Dataset.TrainSet;
TestSet = Dataset.TestSet;
ClassName = opts.ClassName;
ClassID = strcmp({TrainSet.ClassName}, ClassName);
TrainSet = TrainSet(ClassID);

NumImgs = numel(TrainSet.ImageName) * 6;
imdb.ImageList = -ones(384, 384, 3, NumImgs, 'single');
imdb.ImageLabelList = -ones(NumImgs, 1, 'single');
Count = 0;
for i = 1:numel(TrainSet.ImageName)
    Image = single(imresize(imread([opts.dataDir  '/' TrainSet.ImageName{i}]), [384 384]));
    ImageLabel = TrainSet.ImageLabel(i);
    for DataAugFun = DataAugFunList
        Count = Count + 1;
        TempImage = DataAugFun{1}(Image);
        imdb.ImageList(:,:,:,Count) = TempImage;
        imdb.ImageLabelList(Count) = ImageLabel;
    end
end

imdb.images.set = uint8(ones(1, numel(TrainSet.ImageName) * 6));
end

function [net, AvgImage]= InitializeWSModel(net, opts)
ObjectClassiferNet = load(opts.ClassifierModelPath);
AvgImage = ObjectClassiferNet.AvgImage;
ObjectClassiferNet = rmfield(ObjectClassiferNet, 'AvgImage');
ObjectClassiferNet = dagnn.DagNN.loadobj(ObjectClassiferNet);
LayerNameList = {ObjectClassiferNet.layers.name};
LayerRenameList = strcat('Classifier_', LayerNameList);
for i = 1:length(LayerNameList)
    ObjectClassiferNet.renameLayer(LayerNameList{i}, LayerRenameList{i});
end

VarNameList = {ObjectClassiferNet.vars.name};
VarRenameList = strcat('Classifier_', VarNameList);
for i = 1:length(VarNameList)
    ObjectClassiferNet.renameVar(VarNameList{i}, VarRenameList{i});
end

net.meta.normalization = [];

net.renameVar('prediction', 'RawSalScore');
net.addLayer('ObjSigmoidNormize', ...
  dagnn.Sigmoid(), 'RawSalScore', 'ObjSalPred');
net.addLayer('BGSigmoidNormize', ...
  ElementProcess('Scale', -1, 'Shift', 1), 'ObjSalPred', 'BGSalPred');

net.addLayer('SalMulImage', ...
        SalMulImage(), ...
        {'BGSalPred', 'ObjSalPred', 'input', 'AvgImage', 'ImageLabel'}, ...
        {ObjectClassiferNet.vars(1).name, 'label', 'BGSegSaliency', 'FGSegSaliency'});    
for i = 1:length(ObjectClassiferNet.layers)
    
    Layer = ObjectClassiferNet.layers(i);
    net.addLayer(Layer.name, ...
                 Layer.block, ...
                 Layer.inputs, ...
                 Layer.outputs, ...
                 Layer.params);
    ParamIndex1 = net.getParamIndex(Layer.params);
    ParamIndex2 = ObjectClassiferNet.getParamIndex(Layer.params);
    for j = 1:length(ParamIndex1)
        net.params(ParamIndex1(j)).value = ObjectClassiferNet.params(ParamIndex2(j)).value;
        net.params(ParamIndex1(j)).learningRate = 0;
        net.params(ParamIndex1(j)).weightDecay = 0;
    end
end
net.setLayerInputs('objective', {net.vars(end).name, 'label', 'BGSegSaliency', 'BGSegMask', 'FGSegSaliency'});
net.layers(net.getLayerIndex('objective')).block = EuclidEntropyLoss('NumLosses', 3);
net.removeLayer('accuracy');
net.rebuild();
end
