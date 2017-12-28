function S = superpixel_info(Smap, I, NeighborPair)
% function S = superpixel_info(Smap, I)
% Extract information of each superpixel.
% INPUT
%   Smap    Pixel to superpixel mapping.
%   I       Image. (optional)
% OUTPUT
%   S A structure representing each superpixel s:
%     S(s).ind     An linear index to all pixels which form the
%                     superpixel.
%     S(s).count   The size of the superpixel in pixels.
%     S(s).color   The mean color of the superpixel.
%     S(s).adj     The neighbors of the superpixel. 1-based indexing.

% Jyun-Fan Tsai 2010.03.25

% Integrity check
[NumRows,NumCols] = size(Smap);
if exist('I','var') && ~isempty(I)
    if size(I,1)~=NumRows || size(I,2)~=NumCols
        error('size of I and Smap should be the same');
    end
end

labels = unique(Smap);
min_label = min(labels);
if min_label == 0
%     fprintf('Warning: Smap should start from 1. Automatically fixed\n');
    Smap = Smap+1;
    labels = labels+1;
elseif min_label ~= 1
    error('Elements in smap should start from 1');
end

S = struct('ind', [], 'count', [], 'color', [], 'adj', [], 'UnNormalizedCenter',[], 'NormalizedCenter', [], 'NeighborPair', []);
map1 = circshift(Smap, [1 0]);
map1(1,:) = Smap(1,:);
map2 = circshift(Smap, [-1 0]);
map2(end,:) = Smap(end,:);
map3 = circshift(Smap, [0 1]);
map3(:,1) = Smap(:,1);
map4 = circshift(Smap, [0 -1]);
map4(:,end) = Smap(:,end);

if exist('I','var') && ~isempty(I)
    mc = cell(size(I, 3), 1);
    for k=1:size(I, 3)
      mc{k} = zeros(size(Smap,1), size(Smap,2));
    end
    
    % Separate channels
    Ic = cell(size(I, 3), 1);
    for k=1:size(I, 3);
        Ic{k} = I(:,:,k);
    end
end

for i=1:length(labels)
    ind = find(Smap(:) == labels(i));
    S(i).ind = ind;
    S(i).count = length(ind);
    if exist('NeighborPair','var') && ~isempty(NeighborPair)
        Index1 = ismember(NeighborPair(:,1),ind);
        Index2 = ismember(NeighborPair(:,2),ind);
        S(i).NeighborPair = NeighborPair(Index1 & Index2,:); 
    end
    if exist('I','var') && ~isempty(I)
        for k=1:size(I,3)
            S(i).color(k) = mean(Ic{k}(ind));
            mc{k}(ind) = S(i).color(k);
        end
    end

    adj = [map1(ind) map2(ind) map3(ind) map4(ind)];
    adj = unique(adj(:));
    adj = setdiff(adj, labels(i));
    S(i).adj = adj;
    [Rows, Cols] = find(Smap == labels(i));
    S(i).UnNormalizedCenter = [mean(Rows)  mean(Cols) ];
    S(i).NormalizedCenter = S(i).UnNormalizedCenter ./ [NumRows,NumCols];
end
end

