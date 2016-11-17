function generateImgs(pop)
query = {'gon'};

for i = 1:size(query, 1)
    generateImg(query{i, 1}, pop);
end
end

% function text_cnt = countTxtFreq(pop)
% pop_text = zeros(size(pop, 1), size(dic, 1));
% for i = 1:size(pop, 1)
%     pop_text(i, ismember(dic, pop(i,1).text) == 1) = 1;
% end
% text_cnt = zeros(size(dic, 1),1);
% text_cnt = transpose(sum(pop_text,1));
% maxval = max(text_cnt);
% maxword = dic(ismember(123, text_cnt)==1,1);
% end

function generateImg(query, pop)
selectedHE = [];
BUFF_SIZE = 100;

%% select hyperedges which has a quey in population
split_query = regexp(query, '\s', 'split');
buffer = cell(BUFF_SIZE, 1);
if length(split_query) == 1
    count = 1;
    for i = 1:size(pop, 1)
        if sum(ismember(split_query, pop(i, 1).text)) >= 1
            buffer{count, 1} = pop(i, 1);
            count = count + 1;
            if count == BUFF_SIZE + 1
                selectedHE = [selectedHE; buffer];
                count = 1;
            end
        end
    end
else
    count = 1;
    for i = 1:size(pop, 1)
        if sum(ismember(split_query, pop(i, 1).text)) >= length(split_query)
            buffer{count, 1} = pop(i, 1);
            count = count + 1;
            if count == BUFF_SIZE + 1
                selectedHE = [selectedHE; buffer];
                count = 1;
            end
        end
    end
end

selectedHE = [selectedHE; buffer(1:count - 1)];

%% save images which has high weights
if isempty(selectedHE)
    disp([split_query ' is not exist']);
else
    bundle_idx_cnt = zeros(20000, 1);
    bundle_list = [];
    bundle_from_img = [];
    for i=1:size(selectedHE{1, 1}.bundle,2)
        bundle_list = [bundle_list;selectedHE{1, 1}.bundle(i)];
        bundle_from_img = [bundle_from_img;selectedHE{1, 1}.img_idx];
        bundle_idx_cnt(selectedHE{1, 1}.bundle(i).idx, 1) = bundle_idx_cnt(selectedHE{1, 1}.bundle(i).idx, 1) + selectedHE{1, 1}.weight;
    end    
    for i=1:size(selectedHE, 1)
        flag = 0;
        for j=1:size(selectedHE{i,1}.bundle, 2)
            if bundle_idx_cnt(selectedHE{i,1}.bundle(j).idx, 1) == 0
                bundle_list = [bundle_list;selectedHE{i, 1}.bundle(j)];
                bundle_from_img = [bundle_from_img;selectedHE{i, 1}.img_idx];
            end
            bundle_idx_cnt(selectedHE{i, 1}.bundle(j).idx, 1) = bundle_idx_cnt(selectedHE{i, 1}.bundle(j).idx, 1) + selectedHE{i, 1}.weight;
        end
    end
    temp = zeros(size(bundle_list, 1), 1);
    idx_cnt = 1;
    for i = 1:size(bundle_idx_cnt, 1)
        if bundle_idx_cnt(i) > 0
            temp(idx_cnt, 1) = bundle_idx_cnt(i);
            idx_cnt = idx_cnt + 1;
        end
    end
    [B, idx] = sort(temp, 'descend');
    dir_name = ['./genImg/' query '/'];
    mkdir(dir_name);
    for i = 1:size(B, 1)
        name = sprintf([dir_name '100_%d_%d_%d.jpg'], i, bundle_list(idx(i), 1).idx, bundle_from_img(idx(i), 1));
        imwrite(bundle_list(idx(i), 1).img, name);
    end
end
    
end

