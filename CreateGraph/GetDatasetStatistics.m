function [CoocCount, NormalizedCoocCount, LabelCost, ...
    DatasetLabelCount, DatasetLabelLocCount, DatasetPrior]...
    = GetDatasetStatistics(GTList, NumLabels)
[NumRows, NumCols, NumGTs] = size(GTList);
CoocCount = zeros(NumLabels);
DatasetLabelLocCount = zeros(NumRows,NumCols, NumLabels, 'single');
DatasetPrior = DatasetLabelLocCount;
DatasetLabelCount = hist(vec(GTList(GTList ~= 0)), 1:NumLabels);
for i = 1:NumLabels
    TempDatasetLabelLocCount = single(sum(GTList == i,3));
    DatasetLabelLocCount(:,:,i) = TempDatasetLabelLocCount;
    TempDatasetPrior = TempDatasetLabelLocCount/max(TempDatasetLabelLocCount(:)); % follow "label transfer"
    TempDatasetPrior(TempDatasetPrior == 0) = min(TempDatasetPrior(TempDatasetPrior~=0));
    DatasetPrior(:,:,i) = TempDatasetPrior; 
end
for i = 1:NumGTs
    if(sum(vec(GTList(:,:,i)) == 16) ~= 0)
        disp(num2str(i))
    end
    CoocCount = CoocCount + BoundaryLabelCount(GTList(:,:,i), NumLabels);
end
% DatasetPrior = -log(DatasetPrior + eps);
Cond1 = CoocCount ./ repmat(sum(CoocCount,2),1,NumLabels);
Cond2 = Cond1';
NormalizedCoocCount = (Cond1 + Cond2) / 2;
LabelCost = -log(NormalizedCoocCount + min(NormalizedCoocCount(NormalizedCoocCount ~= 0)));
LabelCost(logical(eye(NumLabels))) = 0;
end

