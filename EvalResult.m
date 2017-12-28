function [Precision, Recall, EER, PrecEER] = ...
          EvalResult(SalImgList, MaskList)

SalImages = gpuArray(cell2mat(SalImgList));
Masks = gpuArray(cell2mat(MaskList));

[Precision, Recall] = EvalPRFast(SalImages, Masks, []);
[~,idx] = min(abs(Precision - Recall));
EER = Recall(idx);
PrecEER = Precision(idx);
end

function [precision, recall, threshold] = EvalPRFast(smapImg, gtImg, threshold)
smapImg = smapImg(:);
gtImg = logical(gtImg(:));

if nargin == 2 || isempty(threshold)
    num_thresh = 1000;
    qvals = (1:(num_thresh-1))/num_thresh;
    threshold = [min(smapImg) quantile(smapImg,qvals)];
end

gtPxlNum = sum(gtImg(:));

try
    targetHist = histc(smapImg(gtImg), threshold);
catch
    threshold = sort(threshold, 'ascend');
    targetHist = histc(smapImg(gtImg), threshold);
end
nontargetHist = histc(smapImg(~gtImg), threshold);
targetHist = flipud(targetHist);
nontargetHist = flipud(nontargetHist);

targetHist = cumsum( targetHist );
nontargetHist = cumsum( nontargetHist );

precision = targetHist ./ (targetHist + nontargetHist);

if any(isnan(precision))
    warning('there exists NAN in precision, this is because of your saliency map do not have a full range specified by cutThreshes\n');    
end

recall = targetHist / gtPxlNum;
recall(recall==Inf) = 1;
recall(isnan(recall)) = 1;
precision(precision==Inf) = 1;
precision(isnan(precision)) = 1;

precision = gather(precision);
recall = gather(recall);
threshold = gather(threshold);
end
