clear all
close all

%% Path 
run([pwd '/matconvnet-1.0-beta24/matlab/vl_setupnn.m']);
root = vl_rootnn() ;
if numel(dir(fullfile(root, 'matlab', 'mex', 'vl_nnconv.mex*'))) == 0
    vl_compilenn('enableGpu', true, 'enableImreadJpeg', false, 'enableCudnn', true, 'enableDouble', false);
end
addpath([pwd '/FCNCode'])
addpath('CreateGraph')
addpath('Gb_Code_Aug2014')

ClassifierModelDir = [pwd '/Model/Classifier'];
FCNModelPath = [pwd '/Model/PretrainedModel/imagenet-vgg-verydeep-16.mat'];
expDir = 'data';
SaveDirName = 'EvalResult/';
DataSetName = 'Graz02';
GPUID = 1;
%% Training
EvalSaveDir = New_mkdir([pwd '/' SaveDirName '/' DataSetName]);
TestClassNameList = {'bike', 'cars', 'person'};
Lambda = [2.5 0.6 2^12];
learningRate = 0.00001 * ones(1, 100);
PrecEER_Smooth_List = zeros(1, length(TestClassNameList));
for i = 1:length(TestClassNameList)
    opts = CNNTrain('DataSetName', DataSetName, 'expDir', [expDir '/' DataSetName], 'GPUID', GPUID,...
        'ClassName', TestClassNameList{i}, 'Lambda', Lambda(1:2), 'FCNModelPath', FCNModelPath, 'learningRate', learningRate, ...
        'ClassifierModelPath', [ClassifierModelDir '/' DataSetName '/' TestClassNameList{i} '/TrainedNet.mat']);
    EvalSaveName = [EvalSaveDir '/' TestClassNameList{i} '.mat'];
    if ~exist(EvalSaveName, 'file')
        [DataSet, SalImg, PrecEER] = CNNTest('expDir', opts.expDir, 'TestDir', [pwd '/Dataset/' DataSetName], ...
            'TestClassName', TestClassNameList{i}, 'GPUID', GPUID);
        save(EvalSaveName, 'DataSet', 'SalImg', 'PrecEER', 'Lambda');
    end
    VariableInfo = who('-file', EvalSaveName);
    if ~ismember('PrecEER_Smooth', VariableInfo)
        Data  = load(EvalSaveName);
        [SalImg_Smooth, PrecEER_Smooth] = GraphOptimization(Data.DataSet, Data.SalImg, Data.Lambda(end));
        save(EvalSaveName, 'SalImg_Smooth', 'PrecEER_Smooth', '-append');
    else
        Data = load(EvalSaveName, 'PrecEER_Smooth');
        PrecEER_Smooth = Data.PrecEER_Smooth;
    end
    PrecEER_Smooth_List(i) = PrecEER_Smooth;
    close all
end
