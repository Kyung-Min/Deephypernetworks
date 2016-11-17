%% 패치의 이미지, 칼라히스토그램, 패치면적을 계산하는 부분
function [sub_img, hist, cnt] = seperateRegions(img, m)
sub_img = uint8(zeros(size(img)));
sub_img(:) = 255;
hist = zeros(10, 10, 10);
cnt = 0;
for  i = 1:size(img, 1)
    for j = 1:size(img, 2)
        if m(i, j) == 1           
            sub_img(i, j, :) = img(i, j, :);            
            r = floor(single(sub_img(i, j, 1))/26) + 1;
            g = floor(single(sub_img(i, j, 2))/26) + 1;
            b = floor(single(sub_img(i, j, 3))/26) + 1;    
            hist(r,g,b) = hist(r,g,b) + 1;
            cnt = cnt+1;
        end
    end
end
hist = hist / cnt;

w_sum = sum(m); h_sum = sum(m, 2);
w_first = find(w_sum, 1, 'first'); w_last = find(w_sum, 1, 'last');
h_first = find(h_sum, 1, 'first'); h_last = find(h_sum, 1, 'last');
sub_img = imcrop(sub_img, [w_first h_first (w_last - w_first + 1) (h_last - h_first + 1)]);
end