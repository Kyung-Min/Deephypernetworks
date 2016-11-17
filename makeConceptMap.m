%% make concept map from the learned HN
%% extract HEs considering the clustering info
Sampling_policy = 0;
LEARNING_RATE = 0.5;
time = 13;
nCluster = 23;
char_idx = [1];
nCharBestC = 5;

dir_path = ['Updated_HN/Sampling_policy' num2str(Sampling_policy) '/'];
HN_dir_path = [dir_path 'HN/'];
HN_path = [HN_dir_path 'Upated_HN_' num2str(time) '.mat'];
meta_HN_dir_path = [dir_path 'meta_HN/'];
meta_HN_path = [meta_HN_dir_path 'meta_HN_' num2str(time) '.mat'];
HE_Center_dir_path = [dir_path 'clustering_info/Learning_rate' num2str(LEARNING_RATE) '/HE_Center/'];
HE_Center_path = [HE_Center_dir_path 'HE_Center_' num2str(time) '.mat'];
HE_assgnm_dir_path = [dir_path 'clustering_info/Learning_rate' num2str(LEARNING_RATE) '/HE_assgnm/'];
HE_assgnm_path = [HE_assgnm_dir_path 'HE_assgnm_' num2str(time) '.mat'];
load(HN_path);
load(meta_HN_path);
load(HE_Center_path);
load(HE_assgnm_path);

content_path = '/media/kmkim/BACKUP/kkm/project/Kidsvideo/Pororo';
bundle_path = [content_path '/Preprocessing/Bundle'];

dic_path = [content_path '/Preprocessing/Dic'];
load([dic_path '/dic.mat']);
nChar = 11;
i_order = 2;
t_order = 3;
K = 300;
WORD_DIM = 200;

% find best cluster
best_cluster_idx = zeros(1,3);
c_dir_pre = ['Updated_HN/Sampling_policy' num2str(Sampling_policy) '/clustering_info/Learning_rate' num2str(LEARNING_RATE) '/cluster/time' num2str(time)];
char_dist_cluster = zeros(nCluster, nChar+1);
for i=1:nCluster
    char_file_name = [c_dir_pre '/' int2str(i) '/' int2str(i) '_char.txt'];
    f = fopen(char_file_name);
    tmp_cell = textscan(f,'%s','Delimiter','\n');
    tmp_cell = tmp_cell{1,1};
    for j=1:nChar
        char_dist = tmp_cell{j,1};
        prob = strsplit(char_dist, ':');
        if strcmp(prob{1,2}, ' NaN')
            prob = 0;
        else
            prob = str2double(prob{1,2});
        end
        char_dist_cluster(i,j) =  prob;
    end
    char_dist_cluster(i,nChar+1) =  i;
    fclose(f);
end

for i=1:size(char_idx, 1)
    char_dist_cluster = sortrows(char_dist_cluster, char_idx(i,1) * -1);
    for j=1:nCharBestC
        [~, c_idx] = ismember(char_dist_cluster(j, nChar+1), best_cluster_idx(:,1));
        if c_idx == 0
            best_cluster_idx = [best_cluster_idx; char_dist_cluster(j, nChar+1) char_dist_cluster(j, char_idx(i,1)) char_idx(i,1)];
        end
    end
end

load([dic_path '/total_wordvec.mat']);
load([dic_path '/counted_dic.mat']);
HEs = [];
word_list = [];
counted_word_list = [];
img_features = [];
patch_db = [];
i_weight = 0;
t_weight = 0;
tot_i_weight = 0;
tot_t_weight = 0;
idx = 1;

ep_idx = 1;
ep_content = meta_HN{ep_idx,1};
ep_name = meta_HN{ep_idx,2};
ep_length = meta_HN{ep_idx,3};
load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
% extract HEs
disp('extract HEs from pop');
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
    
    [~, c_idx] = ismember(HE_assgnm(i), best_cluster_idx(:,1));
    if c_idx == 0
        continue;
    end
       
    HE = struct;
    HE.i_idx = zeros(i_order,1);
    for j=1:i_order
        cnn_feat = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).img_vector;
        color_hist = [];
        for m=1:10
            for n=1:10
                tmp2 = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).clr_hist(:, m, n)';
                color_hist = [color_hist tmp2];
            end                
        end
%         sift_idx = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).feature_idx; 
% %             img_vec = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).img_vector;
%         sift_hist = zeros(1,K);
%         color_hist = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).img_vector(38401:39400);
%         for k=1:length(sift_idx)
%             sift_hist(1,sift_idx(k)) = sift_hist(1,sift_idx(k)) + 1;
%         end
%             img_vec = [img_vec img_vec(38401:39400) img_vec(38401:39400) img_vec(38401:39400) img_vec(38401:39400) img_vec(38401:39400)];
%             instance = [instance img_vec];
        img_vec = [cnn_feat color_hist];
        img_features = [img_features; img_vec];
        tmp_cell = cell(1,1);
        tmp_cell{1,1} = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).img;
        patch_db = [patch_db; tmp_cell];
        HE.i_weight = pop(i).i_weight * best_cluster_idx(c_idx,2);
        tot_i_weight = tot_i_weight + HE.i_weight;
        HE.i_idx(j) = idx;
        idx = idx + 1;
    end

    HE.t_words = cell(t_order,1);
    for j=1:t_order
        word = cell(1,1);
        word{1,1} = pop(i).t_words{j,1};
        word_list = [word_list; word];
        HE.t_words{j,1} = pop(i).t_words{j,1};
        HE.t_weight = pop(i).t_weight * best_cluster_idx(c_idx,2);
        tot_t_weight = tot_t_weight + HE.t_weight;
        
        if isempty(counted_word_list)
            tmp_cell1 = cell(1,1);
            tmp_cell2 = cell(1,1);
            tmp_cell1{1,1} = word{1,1};
            tmp_cell2{1,1} = 1;
            counted_word_list = [counted_word_list; tmp_cell1 tmp_cell2];
        else
            [~, idx_cnt_dic] = ismember(word, counted_word_list(:,1));
            if idx_cnt_dic == 0
                tmp_cell1 = cell(1,1);
                tmp_cell2 = cell(1,1);
                tmp_cell1{1,1} = word{1,1};
                tmp_cell2{1,1} = 1;
                counted_word_list = [counted_word_list; tmp_cell1 tmp_cell2];
            else
                counted_word_list{idx_cnt_dic, 2} = counted_word_list{idx_cnt_dic, 2} + 1;
            end
        end
            
    end
    HEs = [HEs; HE];
    fprintf('extract HEs %d / %d\n', i, size(pop, 1));
end

% too small t_weight than i_weight. so normalize
disp('normalizing weight');
max_cnt_tmp = max(cell2mat(counted_word_list(:,2)));
for i=1:size(HEs, 1)
%     HEs(i).i_weight = HEs(i).i_weight / tot_i_weight;
    t_weight_sum = 0;
    for j=1:t_order
        word = HEs(i).t_words{j,1};
        [~, idx_dic] = ismember(word, counted_dic(:,1));
        if idx_dic == 0
            factor1 = 0;
        else
            cnt_tot = counted_dic{idx_dic,2};
            [~, idx_list] = ismember(word, counted_word_list(:, 1));
            cnt_tmp = counted_word_list{idx_list, 2};
            factor1 = cnt_tmp / cnt_tot;
            factor2 = cnt_tmp / max_cnt_tmp;
            end
        t_weight_sum = t_weight_sum + factor1 + factor2;
    end
    HEs(i).t_weight = t_weight_sum;
end
% 
K_image = size(img_features, 1);%10000; %
% 
% %% image patches clustering
% [img_assgnm, img_center, img_sumd] = kmeans(double(img_features), K_image, 'start','sample', 'emptyaction','singleton');
% 
% while length(unique(img_assgnm))<K_image %|| histc(histc(tmp_assgnm,[1 2]),1)~=0
% % i.e. while one of the clusters is empty -- or -- we have one or more clusters with only one member
% [img_assgnm, img_center, img_sumd] = kmeans(double(img_features), K_image, 'start','sample', 'emptyaction','singleton');
% end  
% 
% save('img_assgnm.mat', 'img_assgnm', '-v7.3');
% save('img_center.mat', 'img_center', '-v7.3');
% %% image patches cluster number assignment
% for i=1:size(img_features, 1)
%      assgnm_val = img_assgnm(i);
%      HE_num = ceil(i / i_order);
%      i_idx = mod(i, i_order);
%      if i_idx == 0
%          i_idx = 2;
%      end
%      HEs(HE_num, 1).i_idx = HEs(HE_num, 1).i_idx(1:2, 1);
%      HEs(HE_num, 1).i_idx(i_idx, 1) = assgnm_val;
% end

%% make network
disp('make network');
word_list = unique(word_list);
net = cell(K_image + size(word_list, 1)+1, K_image + size(word_list, 1)+1);

for i=1:size(net, 1)
    for j=1:size(net, 2)
        net{i,j} = 0;
    end
end

for i=1:K_image
    net{i+1, 1} = i;
    net{1, i+1} = i;
end

for i=1:size(word_list, 1)
    net{K_image + i + 1, 1} = word_list{i, 1};
    net{1, K_image + i + 1} = word_list{i, 1};
end

for i=1:size(HEs, 1)
    idxes = zeros(i_order + t_order, 1);
    for j=1:i_order
        idxes(j) = HEs(i,1).i_idx(j);
    end
    for j=1:t_order
        [~, idxes(i_order + j)] = ismember(HEs(i,1).t_words{j,1}, word_list);
        idxes(i_order + j) = idxes(i_order + j) + K_image; 
    end
    i_weight = HEs(i,1).i_weight;
    t_weight = HEs(i,1).t_weight;
    
    for j=1:size(idxes, 1)
        for k=1:size(idxes, 1)
            if j <= i_order && k <= i_order
                weight = i_weight;
            elseif j > i_order && k > i_order
                weight = t_weight;
            else
                weight = (i_weight + t_weight) / 2;
            end
            net{idxes(j)+1, idxes(k)+1} = net{idxes(j)+1, idxes(k)+1} + weight;
        end
    end
    fprintf('%d/%d\n', i, size(HEs, 1));
end

disp('save network');
dir = ['Concept_map/Sampling_policy' num2str(Sampling_policy) '/Learning_rate' num2str(LEARNING_RATE) '/time' num2str(time) '/char' num2str(char_idx(1))];
mkdir(dir);
save([dir '/net.mat'], 'net', '-v7.3');
% csvwrite([dir '/net.csv'], net);
f_csv = fopen([dir '/net.csv'], 'wb');
for i=1:size(net,1)
    for j=1:size(net,2)
        if i==1 && j >= K_image + 2
            fprintf(f_csv, '%s,', net{i,j});
        elseif i == 1 && j < K_image + 2
            fprintf(f_csv, '%d,', net{i,j});
        elseif j == 1 && i >= K_image + 2
            fprintf(f_csv, '%s,', net{i,j});
        elseif j == 1 && i < K_image + 2
            fprintf(f_csv, '%d,', net{i,j});
        elseif isempty(net{i,j})
            fprintf(f_csv, '0,');
        else
            fprintf(f_csv, '%f,', net{i,j});
        end
    end
    fprintf(f_csv, '\n');
end
fclose(f_csv);

dir = ['Concept_map/Sampling_policy' num2str(Sampling_policy) '/Learning_rate' num2str(LEARNING_RATE) '/time' num2str(time) '/char' num2str(char_idx(1)) '/patches'];
mkdir(dir);
% % cluster number should be considered
% cluster_rep_patch_db = cell(K_image, 1);
% img_list = cell(K_image, 1);
% for i=1:size(img_assgnm, 1)
%     img_list{img_assgnm(i), 1} = [img_list{img_assgnm(i), 1}; i];
% end
% for i=1:K_image
%     image_center = img_center(i, :);
%     dist = zeros(size(img_list{i, 1}, 1), 1);
%     for j=1:size(img_list{i, 1}, 1)
%         image_tmp = img_features(img_list{i, 1}(j), :);
%         V = image_center - image_tmp;
%         dist(j) = sqrt(V * V');
%     end
%     [~, idx] = ismember(min(dist), dist);
%     cluster_rep_patch_db{i, 1} = patch_db{img_list{i, 1}(idx), 1};
% end
% for i=1:size(cluster_rep_patch_db, 1)
%     imwrite(cluster_rep_patch_db{i,1}, [dir '/' num2str(i) '.jpg']); 
% end

% if you don't use clustering
for i=1:size(patch_db, 1)
    imwrite(patch_db{i,1}, [dir '/' num2str(i) '.jpg']); 
end
%%
% function makeConceptMap(word, modeorg_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).img)
% run 'configure';
% load 'dic';
% 
% current_folder = 'C:\Users\kmkim\Documents\ijcai_matlab\';
% 
% for i = 1
%     %% make folder for saving images
%     folder_name = sprintf('genMap/%s/%s/%d pop', mode, word, i);
%     mkdir(folder_name);
%     
%     %% load Pop   
%     pop_name = sprintf('%d', i);
%     pop_folder_name = [mode '/' pop_name];
%     load(pop_folder_name);     
%     
%     %% connection information�� vertex�� �ش��ϴ� pop�� ������ ���� ��
%     net = zeros(size(dic, 1), size(dic, 1));
%     bundle = cell(size(dic, 1), 1);
% 
%     %% ��� count ���
%     mean = sum(cell2mat(pop(:, 3))) / size(pop, 1);
%     
%     %% ��� �̻��� count�� ���� HE ����
%     for j = 1:size(pop, 1) 
%         HE_txt = pop{j, 2};
%         if pop{j, 3} >= mean && ismember(word, HE_txt) == 1
%             % connection �� ����
%             net = makeNet(net, HE_txt);
%             % HE text�� best count�� ����
%             for k = 1:size(HE_txt, 2)
%                 idx = find(ismember(dic, HE_txt(1, k)) == 1);
%                 bundle{idx, 1} = [bundle{idx, 1}; pop(j, :)];
%             end
%         end                
%     end
%     
%     %% ���� ����
%     for j = 1:size(net, 1)
%         net(j, j) = 0;
%     end
%     
%     %% edges csv ����
%     edges_name = [folder_name '/' 'edges.xls'];
%     edges_csv = [];
%     for j = 1:size(dic, 1)
%         for k = 1:size(dic, 1)
%             if net(j, k) == 1
%                 edges_csv = [edges_csv; dic(j,1), dic(k, 1)];
%             end
%         end
%     end
%     if strcmp(mode, 'VL')
%         idx = find(sum(net) > 0)';
%         for j = 1:size(idx, 1)
%             sub_vertex_size = size(bundle{idx(j, 1)}, 1);
%             if sub_vertex_size > 3
%                 sub_vertex_size = 3;
%             end
%             for k = 1:sub_vertex_size
%                 vertex_name = [dic{idx(j, 1),1} sprintf('_%d', k)];
%                 edges_csv = [edges_csv; dic(idx(j, 1),1), vertex_name];
%             end
%         end
%     end
%     
%     %% vertices csv ����
%     vertices_name = [folder_name '/' 'vertices.xls'];
%     idx = find(sum(net) > 0)';
%     for j = 1:size(idx, 1)
%         bundle{idx(j, 1)} = sortcell(bundle{idx(j, 1)}, 3);
%     end
%     count = 1;
%     vertices_csv = [];    
%     for j = 1:size(idx, 1)
%         % vertex ���� �߰�
%         vertex_name = dic(idx(j, 1)); 
%         vertices_csv = [vertices_csv; vertex_name, cell(1, 14), vertex_name, cell(1, 6)];
%         %sub vertex ���� �߰�
%         if strcmp(mode, 'VL')
%             sub_vertex_size = size(bundle{idx(j, 1)}, 1);
%             if sub_vertex_size > 3
%                 sub_vertex_size = 3;
%             end
% %             sub_vertex_size = 1;
%             x_diff = 600;
%             x_offset = 0;
%             y_diff = 0;
%             y_offset = -100;
%             for k = 1:sub_vertex_size
%                 vertex_name = [dic{idx(j, 1),1} sprintf('_%d', k)];
%                 temp = size(bundle{idx(j, 1)}, 1) + 1 - k;
%                 img = makeGrid(bundle{idx(j, 1), 1}{temp, 1});
%                 img_name = [folder_name '/' vertex_name '.jpg'];
%                 imwrite(img, img_name);
%                 img_path = [current_folder img_name];            
%                 x = sprintf('=U%d + %d + %d', count, x_diff * (k - 2), x_offset);
%                 y = sprintf('=V%d + %d + %d', count, y_diff * (k - 2), y_offset);
%                 vertices_csv = [vertices_csv; vertex_name, cell(1, 9), 'Image', '2.0', cell(1, 1), img_path, cell(1, 6), x, y];
%             end
%             count = count + k + 1;
%         else
%             count = count + 1;
%         end
%     end 
%     if strcmp(mode, 'VL')
%         filelist = dir([folder_name '/*.jpg']);
%         for j = 1:length(filelist)
%             filename = [folder_name '/' filelist(j).name];
%             a = imread(filename);
%             for k = j + 1:length(filelist)
%                 filename = [folder_name '/' filelist(k).name];
%                 b = imread(filename);
%                 if a == b
%                    edges_csv = [edges_csv; {strtok(filelist(j).name, '.')}, {strtok(filelist(k).name, '.')}];
%                 end
%             end
%         end
%         filelist = dir([folder_name '/*.jpg']);
%         for j = 1:length(filelist)
%             filename = [folder_name '/' filelist(j).name];
%             if exist(filename) ~= 0
%                 a = imread(filename);
%                 same_img = [];
%                 for k = j + 1:length(filelist)
%                     filename = [folder_name '/' filelist(k).name];
%                     if exist(filename) ~= 0
%                         b = imread(filename);
%                         if a == b
%                             same_img = [same_img; {filelist(k).name}];
%                         end
%                     end
%                 end 
%             end
%             for k = 1:size(same_img, 1)
%                 delete([folder_name '/' same_img{k, 1}]);
%             end            
%             for k = 1:size(vertices_csv, 1)
%                 vertices_name = vertices_csv{k, 1};
%                 for l = 1:size(same_img, 1)
%                     img_name = strtok(same_img{l, 1}, '.');
%                     if strcmp(vertices_name, img_name)
%                         vertices_csv{k, 1} = strtok(filelist(j).name, '.');
%                         vertices_csv{k, 14} = [current_folder folder_name '/' filelist(j).name];
%                     end
%                 end  
%             end
%             for k = 1:size(edges_csv, 1)
%                 edges_name1 = edges_csv{k, 1};
%                 edges_name2 = edges_csv{k, 2};
%                 for l = 1:size(same_img, 1)
%                     img_name = strtok(same_img{l, 1}, '.');
%                     if strcmp(edges_name1, img_name)
%                         edges_csv{k, 1} = strtok(filelist(j).name, '.');                        
%                     end
%                     if strcmp(edges_name2, img_name)
%                         edges_csv{k, 2} = strtok(filelist(j).name, '.');                        
%                     end
%                 end  
%             end            
%         end
%         max_size = size(edges_csv, 1);
%         idx = 1;
%         while idx <= max_size
%             if strcmp(edges_csv{idx, 1}, edges_csv{idx, 2})
%                 edges_csv(idx, :) = [];
%                 max_size = max_size - 1;
%                 idx = idx - 1;
%             end
%             idx = idx + 1;
%         end
%     end   
%     xlswrite([folder_name '\' 'edges.xls'], edges_csv);
%     xlswrite([folder_name '\' 'vertices.xls'], vertices_csv);
% end
% endallcotton76@gmail.com
% 
% 
% 
% %% HE text�� connection information ����
% function net = makeNet(net, HE_txt)
% load 'dic';
% 
% %% HE�� words ������ �ε����� �˻�
% idx = [];
% for i = 1:size(HE_txt, 2)
%     if isempty(HE_txt{1, i}) == 0
%         idx = [idx, find(ismember(dic, HE_txt(1, i)) == 1)];
%     end
% end
% 
% %% ���� ǥ��
% for i = 1:size(idx, 2)
%     for j = 1:size(idx, 2)
%         net(idx(1, i), idx(1, j)) = 1;
%         net(idx(1, j), idx(1, i)) = 1;
%     end     
% end
% end
% 
% function img = makeGrid(HE)
% 
% run 'configure';
% 
% img = zeros(3, 3, 3);
% img(1, 1, :) = HE{1, 1}.value;
% img(1, 2, :) = HE{1, 2}.value;
% img(1, 3, :) = HE{1, 3}.value;
% img(2, 1, :) = HE{1, 4}.value;
% img(2, 2, :) = HE{1, 5}.value;
% img(2, 3, :) = HE{1, 6}.value;
% img(3, 1, :) = HE{1, 7}.value;
% img(3, 2, :) = HE{1, 8}.value; 
% img(3, 3, :) = HE{1, 9}.value;
% img = img * dict_maker;
% img = uint8(img);
% end
% 
