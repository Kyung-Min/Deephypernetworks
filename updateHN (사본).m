function [pop, meta_HN] = updateHN(pop, meta_HN, time, episode_name)
    global content_name;
    global HE_CLUSTER_K;
    global CLUSTER_THRESHOLD;
    global initial_Meand;
    
    run 'configure';
    load([dic_path '/' 'dic.mat']);
    
    dir_path = ['Updated_HN/Sampling_policy' num2str(SAMPLING_POLICY) '/'];
    mkdir(dir_path);
    HN_dir_path = [dir_path 'HN/'];
    mkdir(HN_dir_path);
    meta_HN_dir_path = [dir_path 'meta_HN/'];
    mkdir(meta_HN_dir_path);
    HE_Center_dir_path = [dir_path 'clustering_info/Learning_rate' num2str(LEARNING_RATE) '/HE_Center/'];
    mkdir(HE_Center_dir_path);
    HE_assgnm_dir_path = [dir_path 'clustering_info/Learning_rate' num2str(LEARNING_RATE) '/HE_assgnm/'];
    mkdir(HE_assgnm_dir_path);
    HN_save_path = [HN_dir_path 'Updated_HN_' num2str(time) '.mat'];
    meta_HN_save_path = [meta_HN_dir_path 'meta_HN_' num2str(time) '.mat'];
    HE_Center_save_path = [HE_Center_dir_path 'HE_Center_' num2str(time) '.mat'];
    HE_assgnm_save_path = [HE_assgnm_dir_path 'HE_assgnm_' num2str(time) '.mat'];
    %% load newly observed HN
    dir_path = ['HN/Sampling_policy' num2str(SAMPLING_POLICY) '/'];
    load_path = [dir_path 'HN_' episode_name '.mat'];
    load(load_path);
    
    %% update HN
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    load([bundle_path '/' content_name '/bundle_' episode_name '.mat']);
    load([cp_path '/' content_name '/cp_' episode_name '.mat']);
    
    train_pair = pair;
    train_bundle = bundle;
    train_presence = cp;

    if isempty(meta_HN) && isempty(pop)
        tmp_cell1 = cell(1,1); tmp_cell1{1,1} = content_name;
        tmp_cell2 = cell(1,1); tmp_cell2{1,1} = episode_name;
        tmp_cell3 = cell(1,1); tmp_cell3{1,1} = size(HE, 1);
        meta_HN = [meta_HN; tmp_cell1 tmp_cell2 tmp_cell3];
        pop = [pop; HE];
        disp('save HN..');
        save(HN_save_path, 'pop', '-v7.3');
        save(meta_HN_save_path, 'meta_HN', '-v7.3');
        return;
    end
    
    % TF matrix 
    fprintf('Making TF matrix...');
    tf_matrix = zeros(size(train_pair, 1), size(dic, 1));
    tf_matrix(:) = 0.001;
    for i=1:size(train_pair, 1)    
        tf_matrix(i, ismember(dic, train_pair{i, 2}))=1;
    end
%     mm = sum(tf_matrix, 1);
    idf_vector = log(size(train_pair, 1)./(sum(tf_matrix, 1)+1));
    idf_vector = repmat(idf_vector, size(train_pair, 1), 1);
    tf_idf = log(tf_matrix+1);
    tf_idf = tf_idf .* idf_vector;
    sum_tf_idf = sum(tf_idf, 2);
    n_tf_idf = tf_idf ./ repmat(sum_tf_idf, 1, size(tf_idf, 2));
    fprintf('done\n');
    
    fprintf('Making same patch matrix...');
    patch_cnt = 0;
    all_patches = [];
    for i=1:size(train_bundle, 1)
        patch_cnt = patch_cnt + size(train_bundle{i, 1}, 2);
        for j=1:size(train_bundle{i, 1}, 2)
            cnn_feat = train_bundle{i,1}(1, j).img_vector;
            color_hist = [];
            for m=1:10
                for n=1:10
                    tmp2 = train_bundle{i, 1}(1, j).clr_hist(:, m, n)';
                    color_hist = [color_hist tmp2];
                end                
            end
            img_vec = [cnn_feat color_hist];
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

%     sum_patches = sum(patch_matrix, 2);
%     n_patch_matrix = patch_matrix ./ repmat(sum_patches, 1, size(patch_matrix, 2));
    patch_mean = mean(mean(patch_matrix));
%     same_patch_matrix = zeros(size(patch_matrix));
%     same_patch_matrix(find(patch_matrix < patch_mean*0.5)) = 1;
%     sum_same_patch_matrix = sum(same_patch_matrix, 2);
%     fprintf('done\n');

    % I need to know how much File I/O make the algorithm slow
    fprintf('loading all bundles\n');
    for i=1:size(meta_HN, 1)
        ep_content = meta_HN{i,1};
        ep_name = meta_HN{i,2};
        load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']); 
        varname = genvarname(['bundle' num2str(i)]);
        eval([varname '=bundle']);
        clear('bundle');
    end
    
    disp('Update HN weight..');
    ep_idx = 1;
%     ep_content = meta_HN{ep_idx,1};
%     ep_name = meta_HN{ep_idx,2};
    ep_length = meta_HN{ep_idx,3};
%     load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
    org_bundle = bundle1;
    for i=1:size(pop, 1)
        if i <= ep_length
%             org_bundle = bundle;
        else
            ep_idx = ep_idx + 1;
%             ep_content = meta_HN{ep_idx,1};
%             ep_name = meta_HN{ep_idx,2};
            ep_length = meta_HN{ep_idx,3};
%             load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
%             org_bundle = bundle;
            varname = 'org_bundle';
            eval([varname ['=bundle' num2str(ep_idx)]]);
        end
        pop(i,1).t_cover = [];
        pop(i,1).i_cover = [];
        
        for j=1:size(train_pair, 1)
            if size(train_bundle{j, 1}, 2) < 2
                continue;
            end
            sumval = sum(ismember(train_pair{j, 2}, pop(i,1).t_words))/size(pop(i,1).t_words, 1);
            if sumval > 0.8
                pop(i,1).t_cover = [pop(i,1).t_cover j];
            end    
            cnt = 0;
            img_vectors = [];
            for k=1:size(train_bundle{j, 1}, 2)
                cnn_feat = train_bundle{j,1}(1, k).img_vector;
                color_hist = [];
                for m=1:10
                    for n=1:10
                        tmp2 = train_bundle{j, 1}(1, k).clr_hist(:, m, n)';
                        color_hist = [color_hist tmp2];
                    end                
                end
                img_vec = [cnn_feat color_hist];
                img_vectors = [img_vectors; img_vec];
            end
            if size(org_bundle{pop(i,1).file{1,3},1}, 2) < 2
                continue;
            end
            for k=1:i_order
                cnn_feat = org_bundle{pop(i,1).file{1,3},1}(1, pop(i,1).file{1,4}(1, k)).img_vector;
                color_hist = [];
                for m=1:10
                    for n=1:10
                        tmp2 = org_bundle{pop(i,1).file{1,3},1}(1, pop(i,1).file{1,4}(1, k)).clr_hist(:, m, n)';
                        color_hist = [color_hist tmp2];
                    end                
                end
                img_vec = [cnn_feat color_hist];
                dist = img_vectors - repmat(img_vec, size(img_vectors, 1), 1);
                dist = sqrt(sum(dist .* dist, 2));
                if min(dist) < patch_mean*0.5
                    cnt = cnt + 1;
                end
            end
            if cnt > 0
                pop(i,1).i_cover = [pop(i,1).i_cover j];
            end
        end
        aa = sum(power(prod(n_tf_idf(pop(i, 1).t_cover, ismember(dic, pop(i, 1).t_words)), 2), 1/3));    
        pop(i,1).t_weight = TIME_RATIO*pop(i,1).t_weight + (1-TIME_RATIO)*aa;   
        pop(i,1).i_weight = TIME_RATIO*pop(i,1).i_weight + (1-TIME_RATIO)*1/5*size(pop(i,1).i_cover, 2);  
        fprintf('%s-%d iter\n', episode_name, i);
    end
    
    %% add newly observed HE to pop
    fprintf('add newly observed HE to pop\n');
    % update meta HN 
    nPrevPop = size(pop, 1);
    nHE = size(HE, 1);
    pop = [pop; HE];
    del_cnt = 0;
    
    for i=nPrevPop+1:size(pop, 1)
        if i > size(pop, 1)
            break;
        end
        new_img_vectors = [];
        for k=1:i_order
            cnn_feat = train_bundle{pop(i,1).file{1,3},1}(1, pop(i,1).file{1,4}(1, k)).img_vector;
            color_hist = [];
            for m=1:10
                for n=1:10
                    tmp2 = train_bundle{pop(i,1).file{1,3},1}(1, pop(i,1).file{1,4}(1, k)).clr_hist(:, m, n)';
                    color_hist = [color_hist tmp2];
                end                
            end
            img_vec = [cnn_feat color_hist];
            new_img_vectors = [new_img_vectors; img_vec];
        end
        new_words = pop(i,1).t_words;
        
        ep_idx = 1;
%         ep_content = meta_HN{ep_idx,1};
%         ep_name = meta_HN{ep_idx,2};
        ep_length = meta_HN{ep_idx,3};
%         load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
        org_bundle = bundle1;
        for j=1:nPrevPop
             % comparing
            isSameImg = 0;
            isSameTxt = 0;
            
            if j <= ep_length
%                 org_bundle = bundle;
            else
                ep_idx = ep_idx + 1;
%                 ep_content = meta_HN{ep_idx,1};
%                 ep_name = meta_HN{ep_idx,2};
                ep_length = meta_HN{ep_idx,3};
%                 load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
%                 org_bundle = bundle;
                varname = 'org_bundle';
                eval([varname ['=bundle' num2str(ep_idx)]]);
            end
            
            % pop에서 피처뽑고
            cnt = 0;
            tmp_idx = 0;
            for k=1:i_order
                cnn_feat = org_bundle{pop(j,1).file{1,3},1}(1, pop(j,1).file{1,4}(1, k)).img_vector;
                color_hist = [];
                for m=1:10
                    for n=1:10
                        tmp2 = org_bundle{pop(j,1).file{1,3},1}(1, pop(j,1).file{1,4}(1, k)).clr_hist(:, m, n)';
                        color_hist = [color_hist tmp2];
                    end                
                end
                exst_img_vectors = [cnn_feat color_hist];
                dist = new_img_vectors - repmat(exst_img_vectors, size(new_img_vectors, 1), 1);
                dist = sqrt(sum(dist .* dist, 2));
                if k==1
                    [min_val, tmp_idx] = min(dist);
                    if min_val < patch_mean*0.5
                        cnt = cnt + 1;
                    end
                end
                if k==2
                    if dist(3-tmp_idx) < patch_mean*0.5 
                        cnt = cnt + 1;
                    end
                end
                    
            end
            if cnt == i_order
                isSameImg = 1;
            end
            if size(new_words, 1) == sum(ismember(pop(j,1).t_words, new_words))
                isSameTxt = 1;
            end

            %% 같다면 합체
            if isSameImg && isSameTxt
                pop(j,1).dup = pop(j,1).dup + 1;
                tmp = pop(i,1).file;
                pop(j,1).file = [pop(j,1).file; tmp];
                pop(j,1).t_weight = (pop(j,1).t_weight + pop(i,1).t_weight);
                pop(j,1).i_weight = (pop(j,1).i_weight + pop(i,1).i_weight);
                pop(j,1).concepts = double(pop(j,1).concepts | pop(i,1).concepts);
                for k=1:size(pop(i,1).n, 1)
                    tmpBit = 1;
                    for m=1:size(pop(j,1).n, 1)
                        if pop(i,1).n(k).idx == pop(j,1).n(m).idx
                            pop(j,1).n(m).weight =  pop(j,1).n(m).weight + pop(i,1).n(k).weight;
                            idx = pop(i,1).n(k).idx;
                            tmp = [pop(:).idx]'; 
                            row = find(tmp(:) == idx);
                            tmp = [pop(row,1).b(:).idx];
                            tmp_idx = find(tmp(:) == pop(i,1).idx);
                            
                            tmp_weight = pop(row,1).b(tmp_idx).weight;
                            pop(row,1).b(tmp_idx) = [];
                            
                            tmp_idx = find(tmp(:) == pop(j,1).idx);
                            pop(row,1).b(tmp_idx).weight = pop(row,1).b(tmp_idx).weight + tmp_weight;
                            tmpBit = 0;
                            break;
                        end
                    end
                    if tmpBit 
                        pop(j,1).n = [pop(j,1).n; pop(i,1).n(k)];
                        
                        idx = pop(i,1).n(k).idx;
                        tmp = [pop(:).idx]'; 
                        row = find(tmp(:) == idx);
                        tmp = [pop(row,1).b(:).idx];
                        tmp_idx = find(tmp(:) == pop(i,1).idx);
                        pop(row,1).b(tmp_idx).idx = pop(j,1).idx;
                    end
                end
                for k=1:size(pop(i,1).b, 1)
                    tmpBit = 1;
                    for m=1:size(pop(j,1).b, 1)
                        if pop(i,1).b(k).idx == pop(j,1).b(m).idx
                            pop(j,1).b(m).weight = pop(j,1).b(m).weight + pop(i,1).b(k).weight;
                            idx = pop(i,1).b(k).idx;
                            tmp = [pop(:).idx]'; 
                            row = find(tmp(:) == idx);
                            tmp = [pop(row,1).n(:).idx];
                            tmp_idx = find(tmp(:) == pop(i,1).idx);
                            tmp_weight = pop(row,1).n(tmp_idx).weight;
                            pop(row,1).n(tmp_idx) = [];
                            
                            tmp_idx = find(tmp(:) == pop(j,1).idx);
                            pop(row,1).n(tmp_idx).weight = pop(row,1).n(tmp_idx).weight + tmp_weight;
                            
                            tmpBit = 0;
                            break;
                        end
                    end
                    if tmpBit 
                        pop(j,1).b = [pop(j,1).b; pop(i,1).b(k)];
                        
                        idx = pop(i,1).b(k).idx;
                        tmp = [pop(:).idx]'; 
                        row = find(tmp(:) == idx);
                        tmp = [pop(row,1).n(:).idx];
                        tmp_idx = find(tmp(:) == pop(i,1).idx);
                        pop(row,1).n(tmp_idx).idx = pop(j,1).idx;
                    end
                end                 
                pop(i) = [];
                del_cnt = del_cnt + 1;
                i = i-1;
                break;
            end
        end
    end
    
    %% update meta HN 
    tmp_cell1 = cell(1,1); tmp_cell1{1,1} = content_name;
    tmp_cell2 = cell(1,1); tmp_cell2{1,1} = episode_name;
    tmp_cell3 = cell(1,1); tmp_cell3{1,1} = meta_HN{time-1, 3} + size(HE, 1) - del_cnt;
    meta_HN = [meta_HN; tmp_cell1 tmp_cell2 tmp_cell3];
    
    disp('save HN..');
    save(HN_save_path, 'pop', '-v7.3');
    save(meta_HN_save_path, 'meta_HN', '-v7.3');
end