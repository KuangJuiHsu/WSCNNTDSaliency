function S = SPNeighborhood(Smap)
% function S = superpixel_info(Smap)
% Extract information of each superpixel.
% INPUT
%   Smap    Pixel to superpixel mapping.
% OUTPUT
%   S A structure representing each superpixel s:
%     S(s).ind     An linear index to all pixels which form the
%                     superpixel.
%     S(s).count   The size of the superpixel in pixels.
%     S(s).color   The mean color of the superpixel.
%     S(s).adj     The neighbors of the superpixel. 1-based indexing.

% Jyun-Fan Tsai 2010.03.25

% Integrity check

labels = unique(Smap);
min_label = min(labels);
if min_label == 0
    fprintf('Warning: Smap should start from 1. Automatically fixed\n');
    Smap = Smap+1;
    labels = labels+1;
elseif min_label ~= 1
    error('Elements in smap should start from 1');
end

S = struct('adj', []);
map1 = circshift(Smap, [1 0]);
map1(1,:) = Smap(1,:);
map2 = circshift(Smap, [-1 0]);
map2(end,:) = Smap(end,:);
map3 = circshift(Smap, [0 1]);
map3(:,1) = Smap(:,1);
map4 = circshift(Smap, [0 -1]);
map4(:,end) = Smap(:,end);

for i=1:length(labels)
    ind = find(Smap(:) == labels(i));
    adj = [map1(ind) map2(ind) map3(ind) map4(ind)];
    adj = unique(adj(:));
    adj = setdiff(adj, labels(i));
    S(i).adj = uint16(adj);
end
