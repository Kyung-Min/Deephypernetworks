%% HN Classifier
run 'configure';

% tr : ~ 78 ep.
% te : 79 ~ 115 ep.

%% load model
content_path = '/home/ci/ci/Documents/kkm/Kidsvideo/Pororo';
SAMPLING_POLICY = 2;
LEARNING_RATE = 0.5;
tr_ep = 78;
NUM_MICROCODES = 3;
nChar = 13;
THRESHOLD = 0.5 * NUM_MICROCODES;
IMG_WEIGHT = 5;
PATCH_SIM_THRESHOLD = 0.2;
i_order = 2;
t_order = 3;

c_dir_pre = ['Updated_HN/Sampling_policy' num2str(SAMPLING_POLICY) '/clustering_info/Learning_rate' num2str(LEARNING_RATE) '/cluster/time' num2str(tr_ep)];

dir_path = ['Updated_HN/Sampling_policy' num2str(SAMPLING_POLICY) '/'];
HN_dir_path = [dir_path 'HN/'];
meta_HN_dir_path = [dir_path 'meta_HN/'];
HE_Center_dir_path = [dir_path 'clustering_info/Learning_rate' num2str(LEARNING_RATE) '/HE_Center/'];
HE_assgnm_dir_path = [dir_path 'clustering_info/Learning_rate' num2str(LEARNING_RATE) '/HE_assgnm/'];

load([HN_dir_path 'Upated_HN_' num2str(tr_ep) '.mat']);
load([meta_HN_dir_path 'meta_HN_' num2str(tr_ep) '.mat']);
load([HE_assgnm_dir_path 'HE_assgnm_' num2str(tr_ep) '.mat']);

%% load test data
content_name = 'Pororo_ENGLISH3_3';
ep = 1;
load([pair_path '/' content_name '/pair_' content_name '_ep' num2str(ep) '.mat']);
load([bundle_path '/' content_name '/bundle_' content_name '_ep' num2str(ep) '.mat']);
load([cp_path '/' content_name '/cp_' content_name '_ep' num2str(ep) '.mat']);

test_pair = pair;
test_bundle = bundle;
label = cp;

disp('Calculate patch mean matrix..');
all_patches = [];
patch_cnt = 0;
for i=1:size(test_bundle, 1)
    fprintf('%d', i);
    patch_cnt = patch_cnt + size(test_bundle{i, 1}, 2);
    for j=1:size(test_bundle{i, 1}, 2)
        sift_idx = test_bundle{i,1}(1, j).feature_idx; 
        sift_hist = zeros(1,K);
        color_hist = test_bundle{i,1}(1, j).img_vector(38401:39400);
        for k=1:length(sift_idx)
            sift_hist(1,sift_idx(k)) = sift_hist(1,sift_idx(k)) + 1;
        end
        img_vec = [sift_hist sift_hist sift_hist color_hist];
        all_patches = [all_patches; img_vec]; 
    end
end

patch_matrix = zeros(patch_cnt);
for i=1:patch_cnt
    tmp_patch = repmat(all_patches(i, :), patch_cnt, 1);
    val = all_patches - tmp_patch;
    val = val .* val;
    dist = sqrt(sum(val, 2));
    patch_matrix(i, :) = dist';
end

patch_mean = mean(mean(patch_matrix));

disp('Classify characters..');
patch_idx = 1;
pr_recall = zeros(size(test_bundle, 1), 2);
score = cell(size(test_bundle, 1), 1);
prediction = cell(size(test_bundle, 1), 2);
confidence_val = cell(size(test_bundle, 1), 1);

for i=1:size(test_bundle, 1)
    fprintf('Classify %d-th image-subtitle pair', i);
    score{i,1} = zeros(size(pop, 1), 2);
    test_patches = all_patches(patch_idx:patch_idx + size(test_bundle{i, 1}, 2) - 1, :);
    patch_idx = patch_idx + size(test_bundle{i,1}, 2);
   
    ep_idx = 1;
    ep_content = meta_HN{ep_idx,1};
    ep_name = meta_HN{ep_idx,2};
    ep_length = meta_HN{ep_idx,3};
    load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
    
    for j=1:size(pop, 1)
        fprintf('Calculate %d-th microcode similarities for %d-th query\n', j, i);
        if i <= ep_length
            org_bundle = bundle;
        else
            ep_idx = ep_idx + 1;
            ep_content = meta_HN{ep_idx,1};
            ep_name = meta_HN{ep_idx,2};
            ep_length = meta_HN{ep_idx,3};
            load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
            org_bundle = bundle;
        end
        % image score
        img_sumval = 0;
        for k=1:i_order
            sift_idx = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, k)).feature_idx; 
            sift_hist = zeros(1,K);
            color_hist = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, k)).img_vector(38401:39400);
            for l=1:length(sift_idx)
                sift_hist(1,sift_idx(l)) = sift_hist(1,sift_idx(l)) + 1;
            end
            img_vector = [sift_hist sift_hist sift_hist color_hist];
            dist = test_patches - repmat(img_vector, size(test_patches, 1), 1);
            dist = sqrt(sum(dist .* dist, 2));
            if min(dist) < patch_mean * PATCH_SIM_THRESHOLD
                img_sumval = img_sumval + 1 * IMG_WEIGHT;
            end
        end
        % text score
        txt_sumval = sum(ismember(test_pair{i, 2}, pop(j,1).t_words));
        score{i,1}(j, 1) = img_sumval + txt_sumval;
        score{i,1}(j, 2) = j;
    end
    
    fprintf('Calculate best microcodes for %d-th query\n', i);
    score{i,1} = sortrows(score{i,1}, -1);
    best_microcodes = score{i,1}(1:NUM_MICROCODES, 2);
    fprintf('Classify characters for %d-th query\n', i);
    
    char_prob_dist = zeros(NUM_MICROCODES, nChar);
    for j=1:NUM_MICROCODES
        microcodes_w = (pop(best_microcodes(j), 1).i_weight + pop(best_microcodes(j), 1).t_weight) / 2;
        c_idx = HE_assgnm(best_microcodes(j));
        
        char_file_name = [c_dir_pre '/' int2str(c_idx) '/' int2str(c_idx) '_char.txt'];
        f = fopen(char_file_name);
        tmp_cell = textscan(f,'%s','Delimiter','\n');
        tmp_cell = tmp_cell{1,1};
        for k=1:nChar
            char_dist = tmp_cell{k,1};
            prob = strsplit(char_dist, ':');
            if strcmp(prob{1,2}, ' NaN')
                prob = 0;
            else
                prob = str2double(prob{1,2});
            end
            char_prob_dist(j,k) =  prob * microcodes_w;
        end
        fclose(f);
    end
        
    confidence_val{i,1} = sum(char_prob_dist, 1);
    prediction{i,1} = (confidence_val{i,1} > THRESHOLD);
    prediction{i,2} = label(i,:);
    pr_recall(i, 1) = length(find((prediction{i,1}.*label(i, :))))/length(find(prediction{i,1}));
    pr_recall(i, 2) = length(find((prediction{i,1}.*label(i, :))))/length(find(label(i, :)));
end
