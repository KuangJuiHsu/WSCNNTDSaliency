function len = sharebdylen(segmap)
% SHAREBDYLEN calculates the length of shared boundary between each pair of
% superpixels. Use 4-neighbor.
% INPUT
%   segmap      Pixel to superpixel relation. Minimum element in segmap
%               should be 1.
% OUTPUT
%   len         N-by-N matrix. len(i,j) is the shared boundary between
%               superpixel i and j,

% 2010.03.26
% Jyun-Fan Tsai (jyunfan@gmail.com)

if min(segmap(:))==0
    segmap = segmap+1;
end

N = max(segmap(:));

map1 = circshift(segmap, [1 0]);
map1(1,:) = segmap(1,:);
M(:,:,1) = map1;
M(:,:,2) = segmap;
A1 = reshape(M, [size(M,1)*size(M,2) 2]);

map2 = circshift(segmap, [-1 0]);
map2(end,:) = segmap(end,:);
M(:,:,1) = map2;
M(:,:,2) = segmap;
A2 = reshape(M, [size(M,1)*size(M,2) 2]);

map3 = circshift(segmap, [0 1]);
map3(:,1) = segmap(:,1);
M(:,:,1) = map3;
M(:,:,2) = segmap;
A3 = reshape(M, [size(M,1)*size(M,2) 2]);

map4 = circshift(segmap, [0 -1]);
map4(:,end) = segmap(:,end);
M(:,:,1) = map4;
M(:,:,2) = segmap;
A4 = reshape(M, [size(M,1)*size(M,2) 2]);

A = [A1; A2; A3; A4];

A = sub2ind([N N], A(:,1), A(:,2));

H = histc(A, 0.5:1:double(N)^2);

len = reshape(H, [N N]);

% Remove values on the diagonal.
len = len .* (1-eye(N));
