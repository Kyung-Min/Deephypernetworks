cnt = 0;
indices = [];
for i=1:size(region, 1)
    tmp = region{i};
    if size(tmp, 1) < 1
        cnt = cnt + 1;
        indices = [indices; i];
    end
end