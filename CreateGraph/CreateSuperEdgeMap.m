function [EdgeMap, EdgeWeight, H]  = CreateSuperEdgeMap(ImageSize, Scale, Image)
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
[CenterRowIndex, CenterColIndex, NeiRowIndex1, NeiColIndex1, ...
 NeiRowIndex2, NeiColIndex2, EdgeType, NumEdges] = SuperEdgeNeighborIndexMex(true(ImageSize));

CenterRowIndex = CenterRowIndex(1:NumEdges);
CenterColIndex = CenterColIndex(1:NumEdges);
NeiRowIndex1 = NeiRowIndex1(1:NumEdges);
NeiColIndex1 = NeiColIndex1(1:NumEdges);
NeiRowIndex2 = NeiRowIndex2(1:NumEdges);
NeiColIndex2 = NeiColIndex2(1:NumEdges);
EdgeType = EdgeType(1:NumEdges);
EdgeIndex = repmat([1:NumEdges]',[3 1]);

Nei1Index = sub2ind(ImageSize, NeiRowIndex1, NeiColIndex1);
Nei1EdgeValue = ones(size(EdgeType));
Nei1EdgeValue(EdgeType == 1) = 1 / sqrt(2);

CenterIndex = sub2ind(ImageSize, CenterRowIndex, CenterColIndex);
CenterEdgeValue = -2 * ones(size(EdgeType));
CenterEdgeValue(EdgeType == 1) = -2 / sqrt(2);

Nei2Index = sub2ind(ImageSize, NeiRowIndex2, NeiColIndex2);

TotalPixleIndex = cat(1, Nei1Index, CenterIndex, Nei2Index);
TotalEdgeValue = cat(1, Nei1EdgeValue, CenterEdgeValue, Nei1EdgeValue);
EdgeMap = sparse(EdgeIndex, TotalPixleIndex, TotalEdgeValue, NumEdges, ImageSize(1) * ImageSize(2), NumEdges * 3);

if ~IsImage
    EdgeWeight = spdiags(ones(1, NumEdges),0, NumEdges, NumEdges);
    H = EdgeMap' * EdgeMap;
else 
    Nei1Color = Image(Nei1Index,:);
    CenterColor = Image(CenterIndex,:);
    Nei2Color = Image(Nei2Index,:);
    
    Nei1CenterDiff = MatRowNorm(Nei1Color - CenterColor, 2 );
    Nei2CenterDiff = MatRowNorm(Nei2Color - CenterColor, 2 );
    EdgeDiff = max([Nei1CenterDiff, Nei2CenterDiff], [], 2);
    
    Sigma = 2 * mean(EdgeDiff .^ 2) * Scale;
    EdgeWeight = spdiags(exp(-EdgeDiff / Sigma), 0, NumEdges,NumEdges);
    H = EdgeMap' * EdgeWeight * EdgeMap; 
end


end
