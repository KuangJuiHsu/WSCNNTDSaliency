function [CurrentIndex, NeiIndex, PairWiseMat, SumPairWiseMat, LapMatrix]  = CreatePairEdgeMap(ImageSize, Scale, Image)
IsImage = exist('Image','var') && ~isempty(Image);
if ~exist('Scale','var') || isempty(Scale)
    Scale = 1;
end

if IsImage
    if size(Image,3) == 1
        Image = repmat(Image,[1 1 3]);
    end
    Image = reshape(im2double(Image), [ImageSize(1) * ImageSize(2) 3]);
end

ImageSize = ImageSize(1:2);

[CurrentIndex, NeiIndex] = GetNeighborIndex(true(ImageSize),0);
if nargout > 2
    if ~IsImage
        EdgeValue = ones(length(CurrentIndex), 1);
    else
        EdgeValue = MatRowNorm(Image(CurrentIndex, :) - Image(NeiIndex, :), 2);
        EdgeValue = exp(-EdgeValue / (2 * mean(EdgeValue .^ 2))) * Scale;
    end
    NumPixel = ImageSize(1) * ImageSize(2);
    PairWiseMat = sparse(CurrentIndex,NeiIndex, EdgeValue, NumPixel, NumPixel);
    SumPairWiseMat = spdiags(sum(PairWiseMat,2), 0, NumPixel, NumPixel);
    LapMatrix = SumPairWiseMat - PairWiseMat;
end
end
