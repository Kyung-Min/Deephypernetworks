function hist = color_hist(img)
    hist = zeros(10, 10, 10);
    cnt = 0;
    for  i = 1:size(img, 1)
        for j = 1:size(img, 2)
            r = floor(single(img(i, j, 1))/26) + 1;
            g = floor(single(img(i, j, 2))/26) + 1;
            b = floor(single(img(i, j, 3))/26) + 1;    
            hist(r,g,b) = hist(r,g,b) + 1;
            cnt = cnt+1;
        end
    end
    hist = hist / cnt;
end