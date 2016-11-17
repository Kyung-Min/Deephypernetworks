function clusters = kmeansGiveC(centers, descripots)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dist = zeros(size(centers, 2), size(descripots, 2));
for i=1:size(centers,2)
    tmpCent = centers(:,i);
    for j=1:size(descripots,2)
        tmpDes = double(descripots(:,j));
        tmpGap = tmpCent-tmpDes;
        tmpSq = sum(tmpGap.*tmpGap);
        dist(i,j) = tmpSq;
    end
end

[~, idx] = min(dist, [], 1);
clusters = idx';
end

