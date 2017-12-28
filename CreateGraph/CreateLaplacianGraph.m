function LaplacianGraph = CreateLaplacianGraph(Graph)
NumPixels = size(Graph,1);
D = sparse(1:NumPixels,1:NumPixels, double(sum(Graph)),NumPixels,NumPixels);
LaplacianGraph = D - Graph;
end

