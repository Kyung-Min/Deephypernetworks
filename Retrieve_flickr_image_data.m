%% Retrieve flickr data
run 'configure_for_flickr'

% load('flickr_tr_te_data/test_flickr_txt1.mat');
% 
% n_tags = [];
% for i=1:size(test_flickr_txt, 1)
%     tmp_cell = cell(1,1);
%     tmp_cell{1,1} = find(test_flickr_txt(i,:));
%     n_tags = [n_tags; tmp_cell i];
% end
% 
% n_tags = sortrows(n_tags, -2);
% 
% query_txt_idx = n_tags{5,1};
% target_idx = n_tags{5, 2};
% 
% query_txts = cell(1, length(query_txt_idx));
% 
% for i=1:size(query_txts, 2)
%     query_txts{1,i} = dic{query_txt_idx(1,i),1};
% end

% load([pair_path '/pair_MIRFLICKR_10000.mat']);

for i=1:size(pair,1)
    if isempty(pair{i,2}) 
        continue;
    elseif length(pair{i,2}) == length(query_txts) &&  length(pair{i,2}) == length(find(ismember(pair{i,2}, query_txts)))
        imshow(pair{i,1});
        pair{i,2}
        target_idx
        break;
    end
end