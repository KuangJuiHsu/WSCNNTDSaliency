function [Graph, LaplacianGraph] = GetGraph(Img, EdgeFun)
[NumRows, NumCols, ~] = size(Img);
NumPixels = NumRows * NumCols;
[CurrentIndex, NeiIndex] = GetNeighborIndex(true([NumRows, NumCols]),0);
if nargin == 1 || isempty(EdgeFun)
    EdegeProb = zeros(size(CurrentIndex));
    Sigma = 1;
else
    EdegeProb = EdgeFun(Img); 
    EdegeProb = max(EdegeProb(CurrentIndex), EdegeProb(NeiIndex));
    Sigma = mean(EdegeProb).^2;
    if Sigma == 0
        Sigma = Sigma + eps;
    end
end
EdegeProb = exp(-EdegeProb./Sigma);
Graph = sparse(CurrentIndex,NeiIndex,double(EdegeProb),NumPixels,NumPixels);
if nargout == 2
    LaplacianGraph = CreateLaplacianGraph(Graph);
end
end
