function SPGraph = CreateSPGraph(Img,SPMap)
[NumRows, NumCols, NumChannles, NumImgs] = size(Img);
 
SPGraph = cell(NumImgs,1);
for i = 1:NumImgs
    TempSPMap = SPMap(:,:,i);
    SPIndex = unique(TempSPMap(:))';
    if SPIndex(1) == 0
        TempSPMap = TempSPMap + 1;
        SPIndex = SPIndex + 1;
    end
     
    NumSPs = length(SPIndex);
    TempImg = reshape(im2single(Img(:,:,:,i)),[NumRows * NumCols, NumChannles]);
    MeanColors = zeros(NumSPs,3,'double');
    for j = SPIndex
        MeanColors(j,:) = mean(TempImg(TempSPMap == j,:));
    end
    Len = sharebdylen(TempSPMap);
    [CurrentNode, NeiNode] = find(Len > 0);
    MeanColorDiff = MatRowNorm(MeanColors(CurrentNode,:) - MeanColors(NeiNode,:),2) .^ 2;
    Sigma = 2 * mean(MeanColorDiff);
    MeanColorDiff = exp(-MeanColorDiff / Sigma);
    PairMat = zeros(NumSPs,'double');
    PairMat(Len > 0) = MeanColorDiff ./ Len(Len > 0);
    SPGraph{i} = sparse(PairMat);
end

end

