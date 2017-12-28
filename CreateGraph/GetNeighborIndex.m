% Created by KJHsu, 2013/11/20
function [CurrentIndex, NeiIndex, NeighborMap] = GetNeighborIndex(IndicatorMap,IsBoundary)
Size = size(IndicatorMap);
if IsBoundary
    [CurrentRow,CurrentCol,NeiRow,NeiCol, Count] = SegBoundaryNeiIndexMex(IndicatorMap);
else
    [CurrentRow,CurrentCol,NeiRow,NeiCol, Count] = NeighborIndexMex(IndicatorMap);
end
CurrentRow(Count + 1:end) = [];
CurrentCol(Count + 1:end) = [];
NeiRow(Count + 1:end) = [];
NeiCol(Count + 1:end) = [];
CurrentIndex = sub2ind(Size,CurrentRow,CurrentCol);
NeiIndex = sub2ind(Size,NeiRow,NeiCol);
if nargout > 2
    NumIndex = Size(1) * Size(2);
    NeighborMap = sparse(CurrentIndex,NeiIndex,ones(length(CurrentIndex),1),NumIndex,NumIndex);
end
end
