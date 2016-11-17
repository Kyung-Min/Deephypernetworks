function hist = rgbhist(img) 
% pixel_num = numel(img);
white_pixel_num = 0;
img_h = size(img, 1);
img_w = size(img, 2);
img = single(img);
hist = zeros(10, 10, 10);
for h = 1:img_h
    for w = 1:img_w
        if(img(h, w, 1) == 255 && img(h, w, 2) == 255 && img(h, w, 3) == 255)
            white_pixel_num = white_pixel_num + 1;
            continue;
        end
        
        r = floor(img(h, w, 1)/26) + 1;
        g = floor(img(h, w, 2)/26) + 1;
        b = floor(img(h, w, 3)/26) + 1;
        
        hist(r,g,b) = hist(r,g,b) + 1;
    end
end

hist = hist / white_pixel_num;
end

% hist_tmp(:, 1) = imhist(img(:,:,1), 256); 
% hist_tmp(:, 2) = imhist(img(:,:,2), 256); 
% hist_tmp(:, 3) = imhist(img(:,:,3), 256);
% for i = 1:3
%     for j = 1:25
%        hist(j, i) = sum(hist_tmp((j-1)*10+1:(j-1)*10+10, i)); 
%     end
% end
% for i = 1:3
%     hist(26, i) = sum(hist_tmp(251:256, i));
% end
% hist = hist / pixel_num;
% end