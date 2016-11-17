%% Image to Text generatioin 
run 'configure';
test_bundle = dvd3_ep2(40,:);
test_pair = dvd3_ep2_pair(40, :);
test_presence = dvd3_ep2_pre(40, :);
acc_perplexity = zeros(size(test_bundle, 1), 2);
acc_perplexity2 = zeros(size(test_bundle, 1), 2);
precision1 = zeros(size(test_bundle, 1), 2);
precision2 = precision1;
sum_words = 0;
n_sum_words = 0;
words1 = cell(20, 10);
words2 = cell(20, 10);
% aaa = zeros(test_bundle, 1);

% %TF matrix ���
disp('TF matrix ���');
tf_matrix = zeros(size(test_pair, 1), size(dic, 1));
tf_matrix(:) = 0.001;
for i=1:size(test_bundle, 1)
    aa = ismember(dic, test_pair{i, 2})==1;
    tf_matrix(i, ismember(dic, test_pair{i, 2})==1)=1;
end
mm = sum(tf_matrix, 1);
idf_vector = log(size(test_pair, 1)./(sum(tf_matrix, 1)+1));
idf_vector = repmat(idf_vector, size(test_pair, 1), 1);
tf_idf = log(tf_matrix+1);
tf_idf = tf_idf .* idf_vector;
sum_tf_idf = sum(tf_idf, 2);
t_n_tf_idf = tf_idf ./ repmat(sum_tf_idf, 1, size(tf_idf, 2));

tmp_bundle = dvd3_ep13;
tmp_pair = dvd3_ep13_pair;
tmp_presence = dvd3_ep13_pre;

disp('������ matrix ���');
% �Բ� �⿬�� �� ���(���� �⿬�� �󵵰� ���� ���� ���缺�� ������ ������ �ܾ�-�̹��� KL-divergence�� �����̵ȴ�.)
together_matrix = zeros(size(tmp_presence, 2));
for i=1:size(tmp_presence, 1)
    aa = find(tmp_presence(i, :) > 0);
    for j=1:size(aa, 2)
        together_matrix(aa(j), aa(j)) = together_matrix(aa(j), aa(j))+1;
        for k=j+1:size(aa, 2)
            together_matrix(aa(j), aa(k)) = together_matrix(aa(j), aa(k))+1;
            together_matrix(aa(k), aa(j)) = together_matrix(aa(k), aa(j))+1;
        end
    end
end
together_matrix = together_matrix ./ repmat(sum(together_matrix, 2)+0.1, 1, size(together_matrix, 2));

% ��ġ�鰣�� ���缺 ��Ʈ���� ���
disp('��ġ ���缺 matrix ���');
patch_cnt = 0;
all_patches = [];
for i=1:size(tmp_bundle, 1)
%     if size(tmp_bundle{i, 1}, 2) < 2  % �� ��ġ�� 1���� ���� ������?
%         continue;
%     end
    disp(sprintf('%d', i));
    patch_cnt = patch_cnt + size(tmp_bundle{i, 1}, 2);
    for j=1:size(tmp_bundle{i, 1}, 2)
        all_patches = [all_patches; tmp_bundle{i, 1}(1, j).img_vector];
    end
end

disp('��ġ���� �Ÿ� ���');
patch_matrix = zeros(patch_cnt);
for i=1:patch_cnt
    tmp_patch = repmat(all_patches(i, :), patch_cnt, 1);
    val = all_patches - tmp_patch;
    val = val .* val;
    dist = sqrt(sum(val, 2));
    patch_matrix(i, :) = dist';
end

patch_mean = mean(mean(patch_matrix));

pop = update_pop12;
for query_idx=1:size(test_bundle, 1)
    if size(test_bundle{query_idx, 1}, 2) < 2
        continue;
    end    
    edge_query_patch_dist = zeros(size(pop, 1), i_order);
    sel_img = test_bundle{query_idx, 1};
    for i=1:size(pop, 1)
        HE = pop(i, 1);
        
%         tmp_bundle = dvd3_ep13;
        if i <= 564%94*ITER
            tmp_bundle = dvd3_ep1;
        elseif i <= 564+597%196*ITER
            tmp_bundle = dvd3_ep2;
        elseif i <= 564+597+536%292*ITER
            tmp_bundle = dvd3_ep3;
        elseif i <= 564+597+536+530%375*ITER
            tmp_bundle = dvd3_ep4;
        elseif i <= 564+597+536+530+405%468*ITER
            tmp_bundle = dvd3_ep5;
        elseif i <= 564+597+536+530+405+543%565*ITER
            tmp_bundle = dvd3_ep6;
        elseif i <= 564+597+536+530+405+543+328%670*ITER
            tmp_bundle = dvd3_ep7;
        elseif i <= 564+597+536+530+405+543+328+537%744*ITER
            tmp_bundle = dvd3_ep8;
        elseif i <= 564+597+536+530+405+543+328+537+517%835*ITER
            tmp_bundle = dvd3_ep9;
        elseif i <= 564+597+536+530+405+543+328+537+517+519%934*ITER
            tmp_bundle = dvd3_ep10;
        elseif i <= 564+597+536+530+405+543+328+537+517+519+566%1023*ITER
            tmp_bundle = dvd3_ep11;            
        elseif i <= 564+597+536+530+405+543+328+537+517+519+566+448%1113*ITER
            tmp_bundle = dvd3_ep12;            
        else
            tmp_bundle = dvd3_ep13;            
        end          
        %tmp_bundle = ep13_bundle;  
        features = zeros(i_order, 39400);
        for j=1:size(HE.i_idx, 2)
            if size(tmp_bundle{HE.file_idx, 1}, 2) > 1
                features(j, :) = tmp_bundle{HE.file_idx, 1}(1, HE.i_idx(1, j)).img_vector;
            end
        end
        if sum(sum(features)) == 0
            features(:) = 1;
        end
        img_features = [];
        for j=1:size(sel_img, 2)
            img_features = [img_features; sel_img(1, j).img_vector];
        end
        for j=1:size(features, 1)
            tmp = repmat(features(j, :), size(img_features, 1), 1);
            edge_query_patch_dist(i, j) = min(sum((img_features - tmp) .* (img_features - tmp), 2));
        end
    end
    edge_query_patch_dist = sqrt(edge_query_patch_dist);
%     edge_query_patch_dist = edge_query_patch_dist / sum(sum(edge_query_patch_dist));
%     min_patch_dist = zeros(size(edge_query_patch_dist, 1), 1);
%     for i=1:size(edge_query_patch_dist, 1)
%         if edge_query_patch_dist(i, 1) > edge_query_patch_dist(i, 2)
%             min_patch_dist(i, 1) = edge_query_patch_dist(i, 2);
%         else
%             min_patch_dist(i, 1) = edge_query_patch_dist(i, 1);
%         end
%     end
%     [patch_B, patch_IDX] = sort(min_patch_dist, 'ascend');
%     
%     THRE = 6/10000000;
%     sel_HEs = [];
%     for i=1:100
%         sel_HEs = [sel_HEs; pop(patch_IDX(i, 1), 1)];        
%     end
    sel_HEs = [];
    sel_HE_c = [];
    sum_weight = 0;
    sum_weight_c = 0;
    for i=1:size(pop, 1)
        co_occur = dot(pop(i,1).concepts, test_presence(query_idx, :))/min(sum(test_presence(query_idx, :)), sum(pop(i,1).concepts)); 
        if edge_query_patch_dist(i, 1) < patch_mean*0.5 && edge_query_patch_dist(i, 2) < patch_mean*0.5          
            if co_occur > 0
                sel_HE_c = [sel_HE_c; pop(i, 1)];
                sum_weight_c = sum_weight_c + pop(i,1).i_weight;
            end
            if co_occur > - 1 && (edge_query_patch_dist(i, 1) < patch_mean && edge_query_patch_dist(i, 2) < patch_mean)
                sel_HEs = [sel_HEs; pop(i, 1)];
                sum_weight = sum_weight + pop(i,1).i_weight;
            end
        end
    end
    dic_cnt = zeros(2, size(dic, 1));   % ������ �̿����� �ʴ� ���� ���� row 1, �̿��ϴ� ��� row 2(���� ������ ������ ���� �̿�)

    if size(sel_HEs, 1) > 0
%         concept_cnt = zeros(1, size(together_matrix, 1));
        if size(sel_HE_c, 1) < 1
            sel_HE_c = sel_HEs;
            sum_weight_c = sum_weight;
        end
        for i=1:size(sel_HEs, 1)
            aa = ismember(dic, sel_HEs(i, 1).t_words)';   
            dic_cn t(1, :) = dic_cnt(1, :) + aa*sel_HEs(i,1).i_weight/sum_weight;
    %         concept_cnt(1, :) = concept_cnt(1, :) + sel_HEs(i,1).i_weight*sel_HEs(i, 1).concepts;    
        end
        for i=1:size(sel_HE_c, 1)
            aa = ismember(dic, sel_HE_c(i, 1).t_words)';   
            dic_cnt(2, :) = dic_cnt(2, :) + aa*sel_HE_c(i,1).i_weight/sum_weight_c;
    %         concept_cnt(1, :) = concept_cnt(1, :) + sel_HEs(i,1).i_weight*sel_HEs(i, 1).concepts;    
        end    

%         sum_weight = WS_NOR;
%         sum_weight_c = WS_NOR; 
        epsilon = 0.0001;
        epsilon_c = 0.0001;
        dic_cnt(1, :) = dic_cnt(1, :) + epsilon;
        dic_cnt(2, :) = dic_cnt(2, :) + epsilon_c; 
        dic_prob = zeros(2, size(dic, 1));


        bb = ismember(dic', test_pair{query_idx,2});    
        cc = ones(1,size(bb, 2));
        cc = logical(cc - bb);
        dic_prob(1, bb) = log(exp(dic_cnt(1, bb))/exp(sum_weight+epsilon));
%         dic_prob(1, bb) = log(exp(dic_cnt(1, bb))/exp(weight_sum+epsilon));
        %dic_prob(1, cc) = log(1-exp(dic_cnt(1, cc))/exp(weight_sum+epsilon)+0.0001);
        dic_prob(2, bb) = log(exp(dic_cnt(2, bb))/exp(sum_weight_c+epsilon));
%         dic_prob(2, bb) = log(exp(dic_cnt(2, bb))/exp(weight_sum_c+epsilon));
        %dic_prob(2, cc) = log(1-exp(dic_cnt(2, cc))/exp(weight_sum_c+epsilon)+0.0001); 

    %     dic_cnt = dic_cnt ./ repmat(sum(dic_cnt, 2), 1, size(dic_cnt, 2));

        [B1, IDX1] = sort(dic_cnt(1, :)', 'descend');
        [B2, IDX2] = sort(dic_cnt(2, :)', 'descend');
        word_num = size(test_pair{query_idx, 2}, 2);
        if word_num < 5
            word_num = 5;
        end
        words1(1:word_num, query_idx) = dic(IDX1(1:word_num), 1);
        words2(1:word_num, query_idx) = dic(IDX2(1:word_num), 1);
        precision1(query_idx, 1) = sum(t_n_tf_idf(ismember(test_pair{query_idx, 2}, words1(1:word_num, query_idx))));
        aaa(query_idx, 1) = sum(ismember(test_pair{query_idx, 2}, words1(1:word_num, query_idx)));
        precision2(query_idx, 1) = sum(t_n_tf_idf(ismember(test_pair{query_idx, 2}, words2(1:word_num, query_idx))));
        aaa(query_idx, 2) = sum(ismember(test_pair{query_idx, 2}, words2(1:word_num, query_idx)));
        sum_words = sum_words + size(test_pair{query_idx, 2}, 2);
        
        aa = sum(log(dic_cnt(:, ismember(dic, test_pair{query_idx,2})==1)), 2);
        n_sum_words = n_sum_words + sum(t_n_tf_idf(ismember(dic, test_pair{query_idx, 2})));
        acc_perplexity(query_idx, :) = aa';
        acc_perplexity2(query_idx, 1) = sum(dic_prob(1,:));
        acc_perplexity2(query_idx, 2) = sum(dic_prob(2,:));    
    else
        sum_words = sum_words + size(test_pair{query_idx, 2}, 2);
        dic_prob(:) = log(0.5);
        acc_perplexity2(query_idx, 1) = sum(dic_prob(1,:));
        acc_perplexity2(query_idx, 2) = sum(dic_prob(2,:));         
    end
    disp(sprintf('The %d-th data', query_idx));
end
perple = exp(-1*sum(acc_perplexity,1) / sum_words);
perple2 = exp(-1*sum(acc_perplexity2,1) / sum_words);
prec1 = zeros(1, 3);
prec2 = prec1;
prec1(1,1) = sum(sum(precision1>0,1))/size(test_bundle, 1);
prec1(1,2) = sum(sum(precision1,1))/n_sum_words;
prec1(1, 3) = sum(aaa(1:10, 1))/sum_words;
prec2(1,1) = sum(sum(precision2>0,1))/size(test_bundle, 1);
prec2(1,2) = sum(sum(precision2,1))/n_sum_words;
prec2(1, 3) = sum(aaa(1:10, 2))/sum_words;
% 
% 
% for i=1:size(intervals, 1)-1
%     f_name = sprintf('./pororo/Preprocessing/Bundle/ep_1_%d.mat', i-1);
%     tmp_bundle = bundle(intervals(i, 1):intervals(i+1, 1)-1, 1);   
%     save(f_name, 'tmp_bundle', '-v7.3');
%     disp(sprintf('%d', i));
% end