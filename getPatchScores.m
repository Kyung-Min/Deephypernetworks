function scores = getPatchScores(query, pop, patches)
selectedHE = [];
BUFF_SIZE = 100;
patch_score = zeros(20000, 2);
scores = zeros(size(patches,1)+1,2);
patches = cell2mat(patches);
%% select hyperedges which has a quey in population
split_query = regexp(query, '\s', 'split');
%split_query = 'rabbit';
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
% for i=1:size(pop, 1)
%     buf{i,1} = pop(i,1);
%     if sum(ismember(patches, pop(i,1).bundle.idx)==1) > 0
%         selectedHE = [selectedHE;buf];
%     end
% end
%% save images which has high weights
if isempty(selectedHE)
    disp([split_query ' is not exist']);
else
    bundle_list = [];
    bundle_list = [bundle_list;selectedHE{1, 1}];
    for i=1:size(selectedHE, 1)
        flag = 0;
        for j=1:size(bundle_list, 1)
            if bundle_list(j,1).bundle.idx == selectedHE{i, 1}.bundle.idx
                flag = 1;
                break;
            end
        end
        if flag == 0
            bundle_list = [bundle_list;selectedHE{i, 1}];
        end
    end
    temp = zeros(size(bundle_list, 1), 1);
    w_sum = 0;
    for i = 1:size(bundle_list, 1)
        temp(i, 1) = bundle_list(i, 1).weight;
        w_sum = w_sum + bundle_list(i, 1).weight;
    end 
    [B, idx] = sort(temp, 'descend');    
    for i = 1:size(B, 1)
        patch_score(bundle_list(idx(i), 1).bundle.idx, 1) = bundle_list(idx(i), 1).weight*sqrt(size(bundle_list, 1)) / w_sum;
        patch_score(bundle_list(idx(i), 1).bundle.idx, 2) = patch_score(bundle_list(idx(i), 1).bundle.idx, 2) + bundle_list(idx(i), 1).weight;
    end
    for i=1:size(scores, 1)-1
        scores(i,2) = patch_score(patches(i,1), 2);
        if patch_score(patches(i,1),1) == 0
            scores(i,1) = 0;            
        else
            scores(i,1) = patch_score(patches(i,1),1);
        end
    end
    scores(size(scores, 1), 1) = w_sum;
end
    
end    