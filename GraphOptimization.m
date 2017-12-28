function [SalImg_Smooth, PrecEER_Smooth] = GraphOptimization(DataSet, SalImg, Lambda)

NumImages = length(DataSet);
SalImg_Smooth = SalImg;
SaliencyList = cell(1, NumImages);
MaskList = cell(1, NumImages);
for j = 1:NumImages
    Image = DataSet(j).Image;
    [~, LapMat] = GetGraph(Image, @(I)Gb_CSG(I));
    MaskList{j} = DataSet(j).Mask(:);
    TempSalImg = sparse(double(SalImg{j}));
    EyeMat = speye(size(LapMat));
    TempTerm = Lambda * LapMat + EyeMat;
    Saliency = single(full(TempTerm \ TempSalImg(:)));
     
    SaliencyList{j} = cat(1, SaliencyList{j}, Saliency);
    SalImg_Smooth{j} = reshape(Saliency, size(SalImg{j}));
end
[Precision, Recall, EER, PrecEER_Smooth] = EvalResult(SaliencyList, MaskList);
    
end

