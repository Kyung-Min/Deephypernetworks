%% Generate Image & Sentence given qeury image & text
run 'configure';
Sampling_policy = 2;
LEARNING_RATE = 0.5;
time = 39;
nCluster = 40; % cluster를 사용할까 말까
char_idx = [];
nCharBestC = 5;
SAME_PATCH_THRESHOLD = 0.5;
T_COVER_THRESHOLD = 1/2;
MAX_IMG_FOR_GEN = 10;
DISCOUNT_VAL_FOR_NEXT_SEQ = 10;

seed_img = imread('/media/kmkim/BACKUP/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH4/Pororo_ENGLISH4_2/images/Pororo_ENGLISH4_2_818918.bmp');
sentence = 'pororo come down from the mountain';
seed_sentence = splitStn(sentence);
seed_cp = zeros(1, concept_num);

seed_bundle = struct;
bundle_idx = zeros(1, nObjects);
%% Detecting characters in the query image and make bundle
fprintf('Detecting characters in the query image\n');
rcnn_model = rcnn_load_model(rcnn_model_file, use_gpu);
im = seed_img;
dets = rcnn_detect(im, rcnn_model, box_thresh);
all_dets = [];
for k = 1:length(dets)
  all_dets = cat(1, all_dets, [k * ones(size(dets{k}, 1), 1) dets{k}]);
end
[~, ord] = sort(all_dets(:,end), 'descend');

idx = 1;
for k = 1:length(ord)
    score = all_dets(ord(k), end);
    if bundle_idx(1, all_dets(ord(k), 1)) == 0
        if all_dets(ord(k), 1) <= concept_num - 1 && score >= ch_thresh
            seed_cp(1,all_dets(ord(k), 1)) = 1;
        else
            seed_cp(1, end) = 1;
        end
        bundle_idx(1, all_dets(ord(k), 1)) = idx;
        boxes = all_dets(ord(k), 2:5);
        boxes_crop = [boxes(1), boxes(2), boxes(3)-boxes(1), boxes(4)-boxes(2)];
        im_obj = imcrop(im, boxes_crop);
        seed_bundle(idx).img = im_obj;
        seed_bundle(idx).img_vector = rcnn_features(im_obj, boxes, rcnn_model); 
        seed_bundle(idx).clr_hist = color_hist(im_obj);
        seed_bundle(idx).score = score;
        seed_bundle(idx).object = rcnn_model.classes{all_dets(ord(k), 1)};
        idx = idx + 1;
    else
        idx_b = bundle_idx(1, all_dets(ord(k), 1));
        score_b = seed_bundle(idx_b).score;
        if score > score_b
            boxes = all_dets(ord(k), 2:5);
            boxes_crop = [boxes(1), boxes(2), boxes(3)-boxes(1), boxes(4)-boxes(2)];
            im_obj = imcrop(im, boxes_crop);
            seed_bundle(idx_b).img = im_obj;
            seed_bundle(idx_b).img_vector = rcnn_features(im_obj, boxes, rcnn_model); 
            seed_bundle(idx_b).clr_hist = color_hist(im_obj);
            seed_bundle(idx_b).score = score;
        end
    end
end
if length(seed_bundle) > N_PATCH_THRESHOLD
    bundle_tmp_tmp = seed_bundle;
    bundle_tmp_tmp = nestedSortStruct(bundle_tmp_tmp, 'score');
    seed_bundle = bundle_tmp_tmp(length(bundle_tmp_tmp)-N_PATCH_THRESHOLD+1:end);
end

seed_img_vectors = [];
for k=1:size(seed_bundle, 2)
    cnn_feat = seed_bundle(1, k).img_vector;
    color_hist_vec = [];
    for m=1:10
        for n=1:10
            tmp2 = seed_bundle(1, k).clr_hist(:, m, n)';
            color_hist_vec = [color_hist_vec tmp2];
        end                
    end
    img_vec = [cnn_feat color_hist_vec];
    seed_img_vectors = [seed_img_vectors; img_vec];
end

fprintf('Making same patch matrix...\n');
content_name = 'Pororo_ENGLISH2_1';
episode_name = 'Pororo_ENGLISH2_1_ep1';
load([bundle_path '/' content_name '/bundle_' episode_name '.mat']);
patch_bundle = bundle;
clear('bundle');
patch_cnt = 0;
all_patches = [];
for i=1:size(patch_bundle, 1)
    patch_cnt = patch_cnt + size(patch_bundle{i, 1}, 2);
    for j=1:size(patch_bundle{i, 1}, 2)
        cnn_feat = patch_bundle{i,1}(1, j).img_vector;
        color_hist_vec = [];
        for m=1:10
            for n=1:10
                tmp2 = patch_bundle{i, 1}(1, j).clr_hist(:, m, n)';
                color_hist_vec = [color_hist_vec tmp2];
            end                
        end
        img_vec = [cnn_feat color_hist_vec];
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

dir_path = ['Updated_HN/Sampling_policy' num2str(Sampling_policy) '/'];
HN_dir_path = [dir_path 'HN/'];
HN_path = [HN_dir_path 'Updated_HN_' num2str(time) '.mat'];
meta_HN_dir_path = [dir_path 'meta_HN/'];
meta_HN_path = [meta_HN_dir_path 'meta_HN_' num2str(time) '.mat'];
load(HN_path);
load(meta_HN_path);

%% Find the best HE which mostly contains the qeury information
SE_pop = [];
distances = [];
fprintf('Selecting HEs...\n');
ep_idx = 1;
ep_content = meta_HN{ep_idx,1};
ep_name = meta_HN{ep_idx,2};
ep_length = meta_HN{ep_idx,3};
load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
for i=1:size(pop, 1)
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
    
    i_cover = 0;
    distance = 0;
    for k=1:i_order
        cnn_feat = org_bundle{pop(i,1).file{1,3},1}(1, pop(i,1).file{1,4}(1, k)).img_vector;
        color_hist_vec = [];
        for m=1:10
            for n=1:10
                tmp2 = org_bundle{pop(i,1).file{1,3},1}(1, pop(i,1).file{1,4}(1, k)).clr_hist(:, m, n)';
                color_hist_vec = [color_hist_vec tmp2];
            end                
        end
        HE_img_vec = [cnn_feat color_hist_vec];
        dist = seed_img_vectors - repmat(HE_img_vec, size(seed_img_vectors, 1), 1);
        dist = sqrt(sum(dist .* dist, 2));
        if min(dist) < patch_mean*SAME_PATCH_THRESHOLD % how can I set the threshod to know whether the two images are same or not
            i_cover = i_cover + 1;
            distance = distance + min(dist);
        end
    end
    
    t_cover = sum(ismember(pop(i,1).t_words, seed_sentence));
    c_cover = sum(pop(i,1).concepts & seed_cp);
    
    if  i_cover == i_order && t_cover >= t_order * T_COVER_THRESHOLD && c_cover == sum(seed_cp)
        SE_pop = [SE_pop;pop(i,1)];
        distances = [distances;distance];
    end
end

% [~, idx] = sort(distances, 'ascend');
%bestHE = SE_pop(idx(1),1);

%% Generate image & text
% Actually, generation part should have its own visualization system like human brain
% Now, it just shows copies of training images stored in the Hyperedges. 

% It should consider sequence of Hyperedges
% SE_pop has temporal set of Hyperedges
seq_idx = 1;
end_flag = 0;
while ~end_flag
    fprintf('Seq.%d, Generating images..\n', seq_idx);
    imgs_list = [];
    tmp_ep_name = '';
    for i=1:size(SE_pop, 1)
        num = randperm(100, 1);
        if i < MAX_IMG_FOR_GEN
            thres = 0;
        else
            break;
        end
%         elseif i < size(SE_pop, 1)*0.8
%             thres = 30;
%         else
%             thres = 30;
%         end
%         if num < thres
%             continue;
%         end

        % load bundle
        if ~strcmp(tmp_ep_name, SE_pop(i).file{1,2})
            load([bundle_path '/' SE_pop(i).file{1,1} '/bundle_' SE_pop(i).file{1,2} '.mat']);
        end
        tmp_ep_name = SE_pop(i).file{1,2};

        for j=1:size(SE_pop(i,1).file{1,4}, 2)
            imgs = struct;
            img = bundle{SE_pop(i,1).file{1,3}, 1}(1,SE_pop(i,1).file{1,4}(1,j)).img;
            imgs.img = img;
            imgs_list = [imgs_list;imgs];
        end
    end
    SIZE_X = 800;
    SIZE_Y = 800;
    base_img = zeros(SIZE_X, SIZE_Y);
    new_img = double(zeros(SIZE_X, SIZE_Y, 3));
    new_img(:) = 0;
    for i=1:size(imgs_list, 1)
        img = imgs_list(i, 1).img;
        start_x = randperm(SIZE_X-size(img, 1), 1);
        start_y = randperm(SIZE_Y-size(img, 2), 1);
        for j=start_x+1:start_x+size(img, 1)
            for k=start_y+1:start_y+size(img, 2)
                if sum(double(img(j-start_x, k-start_y, :))) < 765
                    base_img(j, k) = base_img(j, k) + 1;
                    new_img(j, k, :) = new_img(j, k, :) + double(img(j-start_x, k-start_y, :));
                end
            end
        end    
    end

    for k=1:size(base_img, 1)
        for j=1:size(base_img, 2)
            if base_img(k, j) < 1
               new_img(k, j, :) = 255;
            else
               new_img(k, j, :) = new_img(k, j, :) / base_img(k, j);
            end        
        end
    end

    for i=1:size(new_img, 1)
        for j=1:size(new_img, 2)
            for k=1:size(new_img, 3)
                if new_img(i,j,k) > 255
                    new_img(i,j,k) = 1;
                else
                    new_img(i,j,k) = new_img(i,j,k)/255;
                end
            end
        end
    end

    file_name = [sentence num2str(seq_idx)];
    imwrite(new_img, ['Generated_imgs_txt/' file_name '.jpg'], 'jpg');

    %% generate sentence from the HEs
    fprintf('Seq.%d, Generating sentence..\n', seq_idx);
    NUM_SENTENCE = 5;
    ODM1 = 1;
    corpus = [];
    corpus_score = [];
    corpus_flag = [];

    for i=1:size(SE_pop, 1)
        corpus = [corpus; SE_pop(i,1).t_words'];
        corpus_score = [corpus_score; 1];
        corpus_flag = [corpus_flag; SE_pop(i,1).t_flag];
    end

    dic = [];
    for i=1:size(corpus, 2)
        dic = [dic; corpus(1,i)];
    end
    weighted_corpus = [corpus(1,:) corpus_score(1,:) corpus_flag(1,:)];
    for i=2:size(corpus, 1)
        index = -1;
        for j=1:size(weighted_corpus, 1)
           tmp = ismember(corpus(i,1:t_order), weighted_corpus(j,1:t_order));
           if sum(tmp) == t_order
               index = j;
               break;
           end       
        end
        if index == -1
            weighted_corpus = [weighted_corpus; corpus(i,:) corpus_score(i,:) corpus_flag(i,:)];
        else
            weighted_corpus{index, t_order+1} = weighted_corpus{index, t_order+1} + corpus_score(i,1);
        end
        
        for j=1:size(corpus, 2)
            if ismember(corpus(i,j), dic) == 0
                dic = [dic; corpus(i,j)];
            end
        end
    end

    key = dic(floor(size(dic,1)/2), 1);
    key_corpus = Corpus_Search(weighted_corpus, key, t_order, ODM1);

    if isempty(key_corpus)
        fprintf('corpus not found\n'); 
    end

    base_corpuses = [];
    t_flags = [];
    for x=1:NUM_SENTENCE
        [corpus, t_flag] = rouletteSelection(key_corpus, 10, t_order);
        base_corpuses = [base_corpuses; corpus];
        t_flags = [t_flags; t_flag t_flag];
    end

    generated_sentence = base_corpuses;
    
    TS = 1;
    max_word_num = 20;
    for i=1:floor((max_word_num-t_order)/2)
        tmp_GeneratedSentence = [];
        for r=1:size(generated_sentence, 1)
            if t_flags(r,1) == 0
                tmp_cell = '<s>';
                tmp_Sentence = generated_sentence(r,:);
                for j=1:t_order-ODM1
                    tmp_Sentence = [tmp_cell tmp_Sentence];
                end
            else
                f1key = generated_sentence(r, 1:ODM1);
                f1Search = Corpus_Search(weighted_corpus, f1key, t_order, ODM1);
                countf = 0;
                f1Search2 = [];
                for r_tmp=1:size(f1Search, 1)
                    tempf = f1Search(r_tmp, t_order-ODM1+1:t_order);
                    if ismember(f1key, tempf)
                        tmp_cell = f1Search(r_tmp, 1:t_order+2);
                        f1Search2 = [f1Search2; tmp_cell];
                    else
                        countf = countf + 1;
                    end
                end
                if size(f1Search, 1) ~= 0 && size(f1Search2, 1) ~= 0
                    if countf/size(f1Search, 1) <= TS
                        [opwf, t_flag] = rouletteSelection(f1Search2, 3, t_order);
                        tmp_cell = generated_sentence(r, 1+ODM1:size(generated_sentence,2));
                        tmp_Sentence = [opwf tmp_cell];
                        t_flags(r,1) = t_flag;
                    end
                else
                    %% find forkward word once again with larger ODM1
                    ODM1 = 2;
                    f1key = generated_sentence(r, 1:ODM1);
                    f1Search = Corpus_Search(weighted_corpus, f1key, t_order, ODM1);
                    countf = 0;
                    f1Search2 = [];
                    for r_tmp=1:size(f1Search, 1)
                        tempf = f1Search(r_tmp, t_order-ODM1+1:t_order);
                        if ismember(f1key, tempf)
                            tmp_cell = f1Search(r_tmp, 1:t_order+2);
                            f1Search2 = [f1Search2; tmp_cell];
                        else
                            countf = countf + 1;
                        end
                    end
                    if size(f1Search, 1) ~= 0 && size(f1Search2, 1) ~= 0
                        if countf/size(f1Search, 1) <= TS
                            [opwf, t_flag] = rouletteSelection(f1Search2, 3, t_order);
                            if t_flag == 0
                                tmp_cell = generated_sentence(r, 1+ODM1:size(generated_sentence,2));
                                tmp_cell1 = cell(1,1);
                                tmp_cell1{1,1} = '<s>';
                                tmp_Sentence = [tmp_cell1 opwf tmp_cell];
                                t_flags(r,1) = t_flag;
                            else
                                ODM1 = 1;
                                tmp_cell = cell(1,1);
                                tmp_cell{1,1} = '<s>';
                                tmp_Sentence = generated_sentence(r,:);
                                for j=1:t_order-ODM1
                                    tmp_Sentence = [tmp_cell tmp_Sentence];
                                end
                                t_flags(r,1) = 0;
                            end
                        end
                        ODM1 = 1;
                    else
                        ODM1 = 1;
                        tmp_cell = cell(1,1);
                        tmp_cell{1,1} = '<s>';
                        tmp_Sentence = generated_sentence(r,:);
                        for j=1:t_order-ODM1
                            tmp_Sentence = [tmp_cell tmp_Sentence];
                        end
                        t_flags(r,1) = 0;
                    end
                end
            end
            tmp_order = size(tmp_Sentence, 2);
            if t_flags(r,2) == 2 
                tmp_cell = '</s>';
                for j=1:t_order-ODM1
                    tmp_Sentence = [tmp_Sentence tmp_cell];
                end
            else
                b1key = tmp_Sentence(1, (tmp_order-ODM1+1):tmp_order);
                b1Search = Corpus_Search(weighted_corpus, b1key, t_order, ODM1);
                countb = 0;
                b1Search2 = [];
                for r_tmp=1:size(b1Search, 1)
                    tempb = b1Search(r_tmp, 1:ODM1);
                    if ismember(b1key, tempb)
                        tmp_cell = b1Search(r_tmp, 1:t_order+2);
                        b1Search2 = [b1Search2; tmp_cell];
                    else
                        countb = countb + 1; 
                    end
                end
                if size(b1Search, 1) ~= 0 && size(b1Search2, 1) ~= 0
                    if countb/size(b1Search, 1) <= TS
                        [opwb, t_flag] = rouletteSelection(b1Search2, 3, t_order);
                        tmp_cell = tmp_Sentence(1, 1:(size(tmp_Sentence,2)-ODM1));
                        tmp_Sentence = [tmp_cell opwb];
                        t_flags(r,2) = t_flag;
                    end
                else
                    %% find backward word once again with larger ODM1
                    ODM1 = 2;
                    b1key = tmp_Sentence(1, (tmp_order-ODM1+1):tmp_order);
                    b1Search = Corpus_Search(weighted_corpus, b1key, t_order, ODM1);
                    countb = 0;
                    b1Search2 = [];
                    for r_tmp=1:size(b1Search, 1)
                        tempb = b1Search(r_tmp, 1:ODM1);
                        if ismember(b1key, tempb)
                            tmp_cell = b1Search(r_tmp, 1:t_order+2);
                            b1Search2 = [b1Search2; tmp_cell];
                        else
                            countb = countb + 1; 
                        end
                    end
                    if size(b1Search, 1) ~= 0 && size(b1Search2, 1) ~= 0
                        if countb/size(b1Search, 1) <= TS
                            [opwb, t_flag] = rouletteSelection(b1Search2, 3, t_order);
                            if t_flag == 2
                                tmp_cell = tmp_Sentence(1, 1:(size(tmp_Sentence,2)-ODM1));
                                tmp_cell1 = cell(1,1);
                                tmp_cell1{1,1} = '</s>';
                                tmp_Sentence = [tmp_cell opwb tmp_cell1];
                                t_flags(r,2) = t_flag;
                            else
                                ODM1 = 1;
                                tmp_cell = cell(1,1);
                                tmp_cell{1,1} = '</s>';
                                for j=1:t_order-ODM1
                                    tmp_Sentence = [tmp_Sentence tmp_cell];
                                end
                                t_flags(r,2) = 2;
                            end
                        end
                        ODM1 = 1;
                    else
                        ODM1 = 1;
                        tmp_cell = cell(1,1);
                        tmp_cell{1,1} = '</s>';
                        for j=1:t_order-ODM1
                            tmp_Sentence = [tmp_Sentence tmp_cell];
                        end
                        t_flags(r,2) = 2;
                    end
                end
            end
            tmp_GeneratedSentence = [tmp_GeneratedSentence; tmp_Sentence];
        end
        generated_sentence = tmp_GeneratedSentence;
    end
    
    %% write generated text into the file
    f_id = fopen(['Generated_imgs_txt/' sentence '.txt'], 'a');

    for r=1:NUM_SENTENCE
        fprintf(f_id, '%d : ', seq_idx);
        tmp_Sentence = '';
        for c=1:size(generated_sentence, 2)
            if strcmp(generated_sentence{r,c}, '<s>')
                continue;
            end
            if strcmp(generated_sentence{r,c}, '</s>')
                break;
            end
            
            tmp_Sentence = strcat(tmp_Sentence, generated_sentence{r,c});
            tmp_Sentence = strcat(tmp_Sentence, {' '});
        end
        fprintf(f_id, tmp_Sentence{1,1});
        fprintf(f_id, '\n');
    end
    fclose(f_id);
    
    %% get next sequence
    next_seq = [];
    for i=1:size(SE_pop, 1)
        for j=1:size(SE_pop(i).n, 1)
            next_seq = [next_seq; SE_pop(i).n(j).idx SE_pop(i).n(j).weight];
        end
    end
    if isempty(next_seq)
        end_flag = 1;
        continue;
    end
    
    next_seq = unique(next_seq, 'rows');
    next_seq = sortrows(next_seq, -2);
    highest_weight = next_seq(1,2);
    
    SE_pop = [];
    for i=1:size(next_seq, 1)
%         if next_seq(i,2) == highest_weight;
        if next_seq(i,2) >= highest_weight - DISCOUNT_VAL_FOR_NEXT_SEQ
            pop_idx_list = [pop(:).idx]';
            row = find(pop_idx_list(:) == next_seq(i,1));
            SE_pop = [SE_pop; pop(row,1)];
        else
            break;
        end
    end
    seq_idx = seq_idx + 1;
end
