%% scatter_character
Sampling_policy = 2;
Learning_rate = 0.5;
nCluster = 40;
time = 52;
nCharBestC = 3;
char_idx = [1;3;4];

% load(['/home/ci/ci/Documents/kkm/HN code/for_clustering_all/' int2str(Sampling_policy) '/total_pop.mat']);
load(['/home/ci/ci/Documents/kkm/HN code/Updated_HN/Sampling_policy' num2str(Sampling_policy) '/HN/Upated_HN_' num2str(time) '.mat']);
% load(['/home/ci/ci/Documents/kkm/HN code/for_clustering_all/' int2str(Sampling_policy) '/total_meta_HN.mat']);
load(['/home/ci/ci/Documents/kkm/HN code/Updated_HN/Sampling_policy' num2str(Sampling_policy) '/meta_HN/meta_HN_' num2str(time) '.mat']);
% load(['/home/ci/ci/Documents/kkm/HN code/for_clustering_all/' int2str(Sampling_policy) '/HE_assgnm.mat']);
load(['/home/ci/ci/Documents/kkm/HN code/Updated_HN/Sampling_policy' num2str(Sampling_policy) '/clustering_info/Learning_rate' num2str(Learning_rate) '/HE_assgnm/HE_assgnm_' num2str(time) '.mat']);
load(['/home/ci/ci/Documents/kkm/HN code/Updated_HN/Sampling_policy' num2str(Sampling_policy) '/clustering_info/Learning_rate' num2str(Learning_rate) '/HE_Center/HE_Center_' num2str(time) '.mat']);

content_path = '/home/ci/ci/Documents/kkm/Kidsvideo/Pororo';
bundle_path = [content_path '/Preprocessing/Bundle'];
dic_path = [content_path '/Preprocessing/Dic'];
nChar = 13;

i_order = 2;
t_order = 3;
K = 300;
WORD_DIM = 200;

% find best cluster
best_cluster_idx = zeros(1,2);
c_dir_pre = ['/home/ci/ci/Documents/kkm/HN code/Updated_HN/Sampling_policy' num2str(Sampling_policy) '/clustering_info/Learning_rate' num2str(Learning_rate) '/cluster/time' num2str(time)];
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

for i=1:nCharBestC
    for j=1:size(char_idx, 1)
        char_dist_cluster = sortrows(char_dist_cluster, char_idx(j,1) * -1);
        i_tmp = i;
        [~, c_idx] = ismember(char_dist_cluster(i_tmp, nChar+1), best_cluster_idx(:, 1));
        while c_idx ~= 0
            i_tmp = i_tmp + 1;
            [~, c_idx] = ismember(char_dist_cluster(i_tmp, nChar+1), best_cluster_idx(:, 1));
        end
        best_cluster_idx = [best_cluster_idx; char_dist_cluster(i_tmp, nChar+1) char_idx(j,1)];
    end
end
% 
% for i=1:size(char_idx, 1)
%     char_dist_cluster = sortrows(char_dist_cluster, char_idx(i,1) * -1);
%     for j=1:nCharBestC
%         [~, c_idx] = ismember(char_dist_cluster(j, nChar+1), best_cluster_idx(:,1));
%         if c_idx == 0
%             
%         end
%     end
% end

load([dic_path '/total_wordvec.mat']);
HE_features = [];
y = [];
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
    
    [~, c_idx] = ismember(HE_assgnm(i), best_cluster_idx(:,1));
    if c_idx == 0
        continue;
    end
       
    instance = [];
    for j=1:i_order
        sift_idx = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).feature_idx; 
%             img_vec = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).img_vector;
        sift_hist = zeros(1,K);
        color_hist = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).img_vector(38401:39400);
        for k=1:length(sift_idx)
            sift_hist(1,sift_idx(k)) = sift_hist(1,sift_idx(k)) + 1;
        end
%             img_vec = [img_vec img_vec(38401:39400) img_vec(38401:39400) img_vec(38401:39400) img_vec(38401:39400) img_vec(38401:39400)];
%             instance = [instance img_vec];
        img_vec = [sift_hist sift_hist sift_hist color_hist];
        instance = [instance img_vec];
    end

    for j=1:t_order
        word_vec = [];
        word = pop(i).t_words{j,1};
        [~, idx] = ismember(word, total_wordvec(:,1));
        if idx == 0
            disp('the control should not reach here');
        end
        for k=1:WORD_DIM
            tmp_cell = cell(1,1);
            tmp_cell{1,1} = total_wordvec{idx, k+1};
            word_vec = [word_vec tmp_cell{1,1}];
        end
        instance = [instance word_vec];
    end
    HE_features = [HE_features; instance];
    char_name = cell(1,1);
    char_num = best_cluster_idx(c_idx, 2);
    if char_num == 1
        char_name{1,1} = 'Pororo';
    elseif char_num == 2
        char_name{1,1} = 'Crong';
    elseif char_num == 3
        char_name{1,1} = 'Loopy';
    elseif char_num == 4
        char_name{1,1} = 'Petty';
    elseif char_num == 5
        char_name{1,1} = 'Harry';
    elseif char_num == 6
        char_name{1,1} = 'Poby';
    elseif char_num == 7
        char_name{1,1} = 'Eddy';
    elseif char_num == 8
        char_name{1,1} = 'Robot';
    elseif char_num == 9
        char_name{1,1} = 'Shark';
    elseif char_num == 10
        char_name{1,1} = 'Tongtong';
    elseif char_num == 11
        char_name{1,1} = 'Pipi';
    elseif char_num == 12
        char_name{1,1} = 'Popo';
    elseif char_num == 13
        char_name{1,1} = 'Etc';
    end
    y = [y; char_name];
end

%% cluster centroid plotting
Centroid_features = [];
Centroid_y = [];
for i=1:nCluster
    [~, c_idx] = ismember(i, best_cluster_idx(:,1));
    if c_idx == 0
        c_idx = -1;
        continue;
    else
        Centroid_features = [Centroid_features; HE_center(i, :)];

        char_name = cell(1,1);
        char_num = best_cluster_idx(c_idx, 2);
        if char_num == 1
            char_name{1,1} = 'pororo';
        elseif char_num == 2
            char_name{1,1} = 'crong';
        elseif char_num == 3
            char_name{1,1} = 'loopy';
        elseif char_num == 4
            char_name{1,1} = 'petty';
        elseif char_num == 5
            char_name{1,1} = 'harry';
        elseif char_num == 6
            char_name{1,1} = 'poby';
        elseif char_num == 7
            char_name{1,1} = 'eddy';
        elseif char_num == 8
            char_name{1,1} = 'robot';
        elseif char_num == 9
            char_name{1,1} = 'shark';
        elseif char_num == 10
            char_name{1,1} = 'tongtong';
        elseif char_num == 11
            char_name{1,1} = 'pipi';
        elseif char_num == 12
            char_name{1,1} = 'popo';
        elseif char_num == 13
            char_name{1,1} = 'etc';
        end
        Centroid_y = [Centroid_y; char_name];
    end
end

%% plotting
h = figure;
[coeff, score, latent] = pca(HE_features);
gscatter(score(:,1), score(:,2), y); hold on 

dir = ['PCA/Sampling_policy' num2str(Sampling_policy) '/Learning_rate' num2str(Learning_rate) '/time' num2str(time) '/'];
mkdir(dir);
char_idx_tmp = [];
for i=1:size(char_idx, 1)
    char_idx_tmp = [char_idx_tmp '_' num2str(char_idx(i))];
end

saveas(h, [dir char_idx_tmp '.fig'], 'fig');
saveas(h, [dir char_idx_tmp '.jpg'], 'jpg');

Centroid_h = figure;
[Centroid_coeff, Centroid_score, Centroid_latent] = pca(Centroid_features);
gscatter(Centroid_score(:,1), Centroid_score(:,2), Centroid_y); hold on

saveas(Centroid_h, [dir 'Centroid_' char_idx_tmp '.fig'], 'fig');
saveas(Centroid_h, [dir 'Centroid_' char_idx_tmp '.jpg'], 'jpg');