function tot_nHE = runHN(episode_name, tot_nHE)
    global content_name;
    global SAMPLING_RATE;
    run 'configure';
    dir_path = ['/media/kmkim/cfe3bb2a-9516-4747-b061-03475877634a/kmkim/Documents/Codes/HN_2016/HN/Sampling_policy' num2str(SAMPLING_POLICY) '/'];
    mkdir(dir_path);
    save_path = [dir_path 'HN_' episode_name '.mat'];

    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    load([bundle_path '/' content_name '/bundle_' episode_name '.mat']);
    load([cp_path '/' content_name '/cp_' episode_name '.mat']);
    
    tmp_bundle = bundle;
    tmp_pair = pair;
    tmp_presence = cp;
    dic = load([dic_path '/' 'dic.mat']);
    dic = dic.dic;
    
    % TF matrix 
    fprintf('Making TF matrix...');
    tf_matrix = zeros(size(tmp_pair, 1), size(dic, 1));
    tf_matrix(:) = 0.001;
    for i=1:size(tmp_bundle, 1)
        aa = (ismember(dic, tmp_pair{i, 2})==1);
        tf_matrix(i, aa)=1;
    end
    mm = sum(tf_matrix, 1);
    idf_vector = log(size(tmp_pair, 1)./mm);
    idf_vector = repmat(idf_vector, size(tmp_pair, 1), 1);
    tf_idf = log(tf_matrix+1);
    tf_idf = tf_idf .* idf_vector;
    sum_tf_idf = sum(tf_idf, 2);
    n_tf_idf = tf_idf ./ repmat(sum_tf_idf, 1, size(tf_idf, 2));

    fprintf('done\n');
    
    fprintf('Making same patch matrix...');
    patch_cnt = 0;
    all_patches = [];
    for i=1:size(tmp_bundle, 1)
        patch_cnt = patch_cnt + size(tmp_bundle{i, 1}, 2);
        for j=1:size(tmp_bundle{i, 1}, 2)
            all_patches = [all_patches; tmp_bundle{i, 1}(1, j).img_vector'];
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

    sum_patches = sum(patch_matrix, 2);
    n_patch_matrix = patch_matrix ./ repmat(sum_patches, 1, size(patch_matrix, 2));
    patch_mean = mean(mean(patch_matrix));
    same_patch_matrix = zeros(size(patch_matrix));
    same_patch_matrix(find(patch_matrix < patch_mean*0.5)) = 1;
    sum_same_patch_matrix = sum(same_patch_matrix, 2);
    fprintf('done\n');
    
    patch_indices = zeros(size(tmp_bundle, 1), 1);
    for pp=1:size(tmp_bundle, 1)
        if (size(tmp_bundle{pp, 1}, 2) >= 1)   
            patch_indices(pp, 1) = size(tmp_bundle{pp, 1}, 2);
        end   
    end
   
    counted_dic = load([dic_path '/' 'counted_dic.mat']);
    counted_QPororo_dic = load([dic_path '/' 'counted_QPororo_dic.mat']);
    fprintf('Making HN...'); 
    HE = [];
    nHE = zeros(size(tmp_pair, 1), 1);
    prevTot_nHE = tot_nHE;
    for iter=1:ITER
        fprintf('Iter = %d\n', iter);
        tmp_pop = [];  
        if iter == 1
            fprintf('Sampling HE...');
            for i=1:size(tmp_bundle, 1)
                [pop, tot_nHE] = makeHyperedge(tmp_pair{i, 2}, tmp_bundle(i, 1), tmp_presence(i, :), content_name, episode_name, counted_dic, counted_QPororo_dic, tot_nHE, i);  % 하이퍼에지 만들고
                for j=1:size(pop, 1) % 초기 웨이트를 위해 빈도수 체크용
                    newHE = matchHEScene(pop(j, 1), tmp_bundle, tmp_pair(:, 2), patch_indices, same_patch_matrix);
                    tmp_pop = [tmp_pop; newHE]; 
                end       
                nHE(i, 1) = size(pop, 1); 
            end
            
%             disp('make hypernetwork for each episode');
%             myCluster =  parcluster('local');
%             myCluster.NumWorkers=15;
%             parpool(myCluster, 
            HE = tmp_pop;
            
%             fprintf('Make adjacent connection...');
%             HE = makeAdjacentConn(HE, nHE, prevTot_nHE);
%             
%             fprintf('Eliminate duplicate HE...'); % 혹시 똑같은 하이퍼에지가 있는지 찾아보자
%             HE = eliminateDupHE(HE, patch_indices, same_patch_matrix);
%             fprintf('done\n');
            
            for i=1:size(HE, 1) % 초기 웨이트 정해주기
                sum_tfidf = power(prod(n_tf_idf(HE(i, 1).file{1,3}, ismember(dic, HE(i, 1).t_words))), 1/3);
                HE(i,1).t_weight = sum_tfidf*size(HE(i, 1).t_cover, 2);
                i_weight = 1;
                for j=1:size(HE(i,1).file{1,4}, 2)
                    if HE(i, 1).file{1,3} > 1
                        row_val = sum(patch_indices(1:HE(i, 1).file{1,3}-1, 1))+HE(i,1).file{1,4}(1, j);                    
                    else
                        row_val = HE(i,1).file{1,4}(1, j);                    
                    end
                    i_weight = i_weight * 1/sqrt(sum_same_patch_matrix(row_val, 1));
                end
                HE(i,1).i_weight = i_weight*size(HE(i,1).i_cover, 2);       
            end     
        end

        % 직감으로 iter가 1보다 높은 것이 얼만큼 차이를 만드는지 잘 모르겠음
        if iter > 1     
            filtered_pop = [];
            for pp=1:size(tmp_bundle, 1)
                tmp_pop = [];
                pop = makeHyperedge(tmp_pair{pp, 2}, tmp_bundle(pp, 1), tmp_presence(pp, :), content_name, episode_name, pp);  
                for j=1:size(pop, 1)
                    newHE = matchHEScene(pop(j, 1), tmp_bundle, tmp_pair(:, 2), patch_indices, same_patch_matrix);
                    tmp_pop = [tmp_pop; newHE]; 
                end
                for i=1:size(tmp_pop, 1)
                    sum_tfidf = power(prod(n_tf_idf(tmp_pop(i, 1).file{1,3}, ismember(dic, tmp_pop(i, 1).t_words))), 1/3);
                    tmp_pop(i,1).t_weight = sum_tfidf*size(tmp_pop(i, 1).t_cover, 2);
                    i_weight = 1;
                    for j=1:size(tmp_pop(i,1).file{1,4}, 2)
                        if tmp_pop(i, 1).file{1,3} > 1
                            row_val = sum(patch_indices(1:tmp_pop(i, 1).file{1,3}-1, 1))+tmp_pop(i,1).file{1,4}(1, j);                    
                        else
                            row_val = tmp_pop(i,1).file{1,4}(1, j);                    
                        end
                        i_weight = i_weight * 1/sqrt(sum_same_patch_matrix(row_val, 1));
                    end
                    tmp_pop(i,1).i_weight = i_weight*size(tmp_pop(i,1).i_cover, 2); 
                end              
                
                % image weight를 기준으로 iter 1번째에서 뽑힌 HE 만큼만 살림
                total_pop = [HE(sum(nHE(1:pp-1), 1)+1:sum(nHE(1:pp), 1), 1);tmp_pop]; % pp번째 pair에 해당하는 HE을 모아서 total_pop이라 함
                tmp_weight = zeros(size(total_pop, 1), 1);
                for j=1:size(total_pop, 1)
                    tmp_weight(j, 1) = total_pop(j,1).i_weight;
                end
                [B, IDX] = sort(tmp_weight, 'descend');
                for j=1:nHE(pp,1)
                    filtered_pop = [filtered_pop; total_pop(IDX(j,1), 1)];
                end
            end 
            HE = filtered_pop;
        end  
    end
    save(save_path, 'HE', '-v7.3'); 
end

function HE = makeAdjacentConn(HE, nHE, prevTot_nHE)
    for i=1:size(HE, 1)
        file_idx = HE(i,1).file{1,3};
        if file_idx == 1
            from = nHE(1, 1) + 1;
            to = from + nHE(2, 1) - 1;
            for j=from:to
                link = struct;
                link.idx = j + prevTot_nHE;
                link.weight = 1.0;
                HE(i,1).n = [HE(i,1).n; link];
            end
        elseif file_idx == size(nHE, 1)
            % back
            from = sum(nHE(1:file_idx-2, 1)) + 1;
            to = from + nHE(file_idx-1, 1) - 1;
            for j=from:to
                link = struct;
                link.idx = j + prevTot_nHE;
                link.weight = 1.0;
                HE(i,1).b = [HE(i,1).b; link];
            end
        else
            % next
            from = sum(nHE(1:file_idx, 1)) + 1;
            to = from + nHE(file_idx+1, 1) - 1;
            for j=from:to
                link = struct;
                link.idx = j + prevTot_nHE;
                link.weight = 1.0;
                HE(i,1).n = [HE(i,1).n; link];
            end
            % back
            from = sum(nHE(1:file_idx-2, 1)) + 1;
            to = from + nHE(file_idx-1, 1) - 1;
            for j=from:to
                link = struct;
                link.idx = j + prevTot_nHE;
                link.weight = 1.0;
                HE(i,1).b = [HE(i,1).b; link];
            end
        end
    end
end

function HE = eliminateDupHE(HE, patch_indices, same_patch_matrix)
    for i=1:size(HE, 1)-1
        if i > size(HE, 1)-1 % for loop을 돌 때마다 evaluate를 안하네..
            break;
        end
        same_patch_vector = [];
        for j=1:size(HE(i,1).file{1,4}, 2)
            if HE(i, 1).file{1,3} > 1
                row = sum(patch_indices(1:HE(i, 1).file{1,3}-1, 1))+HE(i,1).file{1,4}(1, j);                    
            else
                row = HE(i,1).file{1,4}(1, j);                    
            end
            same_patch_vector = [same_patch_vector; same_patch_matrix(row, :)];
        end
        words = HE(i,1).t_words;
        for j=i+1:size(HE, 1)
            if j > size(HE, 1) % for loop을 돌 때마다 evaluate를 안하네..
                break;
            end
            isSameImg = 0;
            isSameTxt = 0;
            HE_patch_vector = zeros(size(HE(i,1).file{1,4}, 2), size(same_patch_vector, 2));
            for k=1:size(HE(i,1).file{1,4}, 2)
                if HE(j, 1).file{1,3} > 1
                    HE_patch_vector(k, sum(patch_indices(1:HE(j, 1).file{1,3}-1, 1))+HE(j,1).file{1,4}(1, k)) = 1;
                else
                    HE_patch_vector(k, HE(j,1).file{1,4}(1, k)) = 1;
                end
            end
            
            tmp = (same_patch_vector & HE_patch_vector);
            same_patch_vector([1 2],:) = same_patch_vector([2 1],:);
            tmp2 = (same_patch_vector & HE_patch_vector);
            if sum(sum(tmp, 2),1) == size(HE(i,1).file{1,4}, 2) || sum(sum(tmp2, 2),1) == size(HE(i,1).file{1,4}, 2)
                isSameImg = 1;
            end
            
            if size(HE(i,1).t_words, 1) == sum(ismember(HE(j,1).t_words, words))
                isSameTxt = 1;
            end
            if isSameImg && isSameTxt
                HE(i,1).dup = HE(i,1).dup + 1;
                tmp = HE(j,1).file;
                HE(i,1).file = [HE(i,1).file; tmp];
                HE(i,1).t_weight = (HE(i,1).t_weight + HE(j,1).t_weight) / 2;
                HE(i,1).i_weight = (HE(i,1).i_weight + HE(j,1).i_weight) / 2;
                HE(i,1).concepts = double(HE(i,1).concepts | HE(j,1).concepts);
                for k=1:size(HE(j,1).n, 1)
                    tmpBit = 1;
                    for m=1:size(HE(i,1).n, 1)
                        if HE(j,1).n(k).idx == HE(i,1).n(m).idx
                            HE(i,1).n(m).weight =  HE(i,1).n(m).weight + HE(j,1).n(k).weight;
                            
                            idx = HE(j,1).n(k).idx;
                            tmp = [HE(:).idx]'; 
                            row = find(tmp(:) == idx);
                            tmp = [HE(row,1).b(:).idx];
                            tmp_idx = find(tmp(:) == HE(j,1).idx);
                            if length(HE(i,1).idx) ~= 1
                                fprintf('errpr');
                            end
                            if isempty(tmp_idx)
                                disp('se');
                            end
%                             tmp_idx
%                             HE(i,1).idx
                            tmp_weight = HE(row,1).b(tmp_idx).weight;
                            HE(row,1).b(tmp_idx) = [];
                            
                            idx = HE(i,1).n(m).idx;
                            tmp = [HE(:).idx]'; 
                            row = find(tmp(:) == idx);
                            tmp = [HE(row,1).b(:).idx];
                            tmp_idx = find(tmp(:) == HE(i,1).idx);
                            if length(HE(i,1).idx) ~= 1
                                fprintf('errpr');
                            end
                            if isempty(tmp_idx)
                                disp('se');
                            end
%                             tmp_idx
%                             HE(i,1).idx
                            HE(row,1).b(tmp_idx).weight = HE(row,1).b(tmp_idx).weight + tmp_weight;
                            
                            tmpBit = 0;
                            break;
                        end
                    end
                    if tmpBit 
                        HE(i,1).n = [HE(i,1).n; HE(j,1).n(k)];
                        
                        idx = HE(j,1).n(k).idx;
                        tmp = [HE(:).idx]'; 
                        row = find(tmp(:) == idx);
%                         if size(HE(row, 1).b, 1) > 0
%                             checkbit = 0;
%                         else
%                             checkbit = 1;
%                         end
                        tmp = [HE(row,1).b(:).idx];
                        tmp_idx = find(tmp(:) == HE(j,1).idx);
                        if length(HE(i,1).idx) ~= 1
                            fprintf('errpr');
                        end
                        if isempty(tmp_idx)
                            disp('se');
                        end
%                         tmp_idx
%                         HE(i,1).idx
                        HE(row,1).b(tmp_idx).idx = HE(i,1).idx;
                    end
                end
                for k=1:size(HE(j,1).b, 1)
                    tmpBit = 1;
                    for m=1:size(HE(i,1).b, 1)
                        if HE(j,1).b(k).idx == HE(i,1).b(m).idx
                            HE(i,1).b(m).weight =  HE(i,1).b(m).weight + HE(j,1).b(k).weight;
                            
                            idx = HE(j,1).b(k).idx;
                            tmp = [HE(:).idx]'; 
                            row = find(tmp(:) == idx);
                            tmp = [HE(row,1).n(:).idx];
                            tmp_idx = find(tmp(:) == HE(j,1).idx);
                            if length(HE(i,1).idx) ~= 1
                                fprintf('errpr');
                            end
                            if isempty(tmp_idx)
                                disp('se');
                            end
%                             tmp_idx
%                             HE(i,1).idx
                            tmp_weight = HE(row,1).n(tmp_idx).weight;
                            HE(row,1).n(tmp_idx) = [];
                            
                            idx = HE(i,1).b(m).idx;
                            tmp = [HE(:).idx]'; 
                            row = find(tmp(:) == idx);
                            tmp = [HE(row,1).n(:).idx];
                            tmp_idx = find(tmp(:) == HE(i,1).idx);
                            if length(HE(i,1).idx) ~= 1
                                fprintf('errpr');
                            end
                            if isempty(tmp_idx)
                                disp('se');
                            end
%                             tmp_idx
%                             HE(i,1).idx
                            HE(row,1).n(tmp_idx).weight = HE(row,1).n(tmp_idx).weight + tmp_weight;
                            
                            tmpBit = 0;
                            break;
                        end
                    end
                    if tmpBit 
                        HE(i,1).b = [HE(i,1).b; HE(j,1).b(k)];
                        
                        idx = HE(j,1).b(k).idx;
                        tmp = [HE(:).idx]'; 
                        row = find(tmp(:) == idx);
%                         if size(HE(row, 1).n, 1) > 0
%                             checkbit = 0;
%                         else
%                             checkbit = 1;
%                         end
                        tmp = [HE(row,1).n(:).idx];
                        tmp_idx = find(tmp(:) == HE(j,1).idx);
                        if isempty(tmp_idx)
                            disp('se');
                        end
                        if length(HE(i,1).idx) ~= 1
                            fprintf('errpr');
                        end
%                         tmp_idx
%                         HE(i,1).idx
                        HE(row,1).n(tmp_idx).idx = HE(i,1).idx;
                    end
                end                 
%                 HE(i,1).n = [HE(i,1).n; HE(j,1).n];
%                 HE(i,1).b = [HE(i,1).b; HE(j,1).b];
                % 중복된 엣지를 지우고 포인터 조정도 해줘야됨...
%                 for k=1:size(HE(j,1).n, 1)
%                     idx = HE(j,1).n(k).idx;
%                     tmp = [HE(:).idx]'; 
%                     row = find(tmp(:) == idx);
%                     if size(HE(row, 1).b, 1) > 0
%                         checkbit = 0;
%                     else
%                         checkbit = 1;
%                     end
%                     tmp = [HE(row,1).b(:).idx];
%                     tmp_idx = find(tmp(:) == HE(i,1).idx);
%                     if ~isempty(tmp_idx) % HE(j,1).n이 HE(i,1).idx을 포함하고 있을 때 HE(i,1).idx를 중복으로 갖지 않게 해야한다
%                         fprintf('a');
%                         HE(row,1).b(tmp_idx).idx
%                         HE(row,1).b(tmp_idx).weight = HE(row,1).b(tmp_idx).weight + HE(j,1).n(k).weight;
%                         checkbit = 1;
%                     else
%                         for m=1:size(HE(row, 1).b, 1)
%                             fprintf('a1');
%                             HE(row,1).b(m).idx
%                             fprintf('b1');
%                             HE(j,1).idx
%                             HE(row,1)
%                         	row
%                             if isempty(HE(row,1).b(m).idx)
%                                 disp('se');
%                             end
%                             if HE(row,1).b(m).idx == HE(j,1).idx;
%                                 HE(row,1).b(m).idx = HE(i,1).idx;
%                                 checkbit = 1;
%                                 break;
%                             end
%                         end
%                     end
%                     if ~checkbit
%                         fprintf('cant find HEb\n');
%                         exit(-1);
%                     end
%                 end
%                 for k=1:size(HE(j,1).b, 1)
%                     idx = HE(j,1).b(k).idx;
%                     tmp = [HE(:).idx]'; 
%                     row = find(tmp(:) == idx);
%                     if size(HE(row, 1).n, 1) > 0
%                         checkbit = 0;
%                     else
%                         checkbit = 1;
%                     end
%                     tmp = [HE(row,1).n(:).idx];
%                     tmp_idx = find(tmp(:) == HE(i,1).idx);
%                     if ~isempty(tmp_idx)
%                         HE(row,1).n(tmp_idx).weight = HE(row,1).n(tmp_idx).weight + HE(j,1).b(k).weight;
%                         checkbit = 1;
%                     else
%                         HE(row,1)
%                         row
%                         if isempty(HE(row,1))
%                             disp('se');
%                         end
%                         for m=1:size(HE(row, 1).n, 1)
%                             if HE(row,1).n(m).idx == HE(j,1).idx;
%                                 HE(row,1).n(m).idx = HE(i,1).idx;
%                                 checkbit = 1;
%                                 break;
%                             end
%                         end
%                     end
%                      if ~checkbit
%                         fprintf('cant find HEn\n');
%                         exit(-1);
%                     end
%                 end
                
%                 for k=1:size(HE, 1)
%                     for m=1:size(HE(k).n, 2)
%                         if HE(k).n(m).idx == HE(j).idx
%                             disp('error'); 
%                         end
%                     end
%                 end
%                 for k=1:size(HE, 1)
%                     for m=1:size(HE(k).b, 2)
%                         if HE(k).b(m).idx == HE(j).idx
%                             disp('error'); 
%                         end
%                     end
%                 end
%                 fprintf('%d delete\n', HE(j).idx);
                HE(j) = [];                
            end
        end
    end
end