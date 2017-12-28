function ColorImage = Label2Color(LabelMap, ColorMap)
if nargin == 1 || isempty(EdgeFun)
    ColorMap = GenColorMap();
end
[NumLabel2Color, NumColorChannel] = size(ColorMap);
if min(LabelMap(:)) == 0
    LabelMap = LabelMap + 1;
end
if(max(LabelMap(:))) > NumLabel2Color
    error(['Only Support ' num2str(NumLabel2Color) ' kind of Colors !!!']);
end
if NumColorChannel > 4 || NumColorChannel == 2
    error('Wrong Number of Color Channels !!!');
end
if length(size(LabelMap)) > 3
    error('Only Support The 2D Matrix !!!');
end
ColorImage = zeros([size(LabelMap), 3]);
for i = 1:NumColorChannel
    ColorImage(:,:,i) = reshape(ColorMap(LabelMap,i),size(LabelMap));
end
end