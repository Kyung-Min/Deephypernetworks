%function [pop, i_error, t_error] = buildingHypernetwork()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
run 'configure';
rng('shuffle');
episode_num = 2;
hn_path = [pop_path sprintf('/_prior/%d', episode_num), '/'];
mkdir(hn_path);


load([region_centroid_path '/tot_reg_cent.mat']);
IK = size(C, 2);

%% load Dic
load([dic_path './dic.mat']);
HN_dic_cnt = ones(size(dic, 1), 1);
HN_cls_cnt = ones(size(C, 2), 1);
%% load preprocessing
total_pair = [];
total_bundle = [];
for pp=episode_num:episode_num
    disp(sprintf('The %d-th dataset', pp));
    disp('Loading data');
    pair_name = sprintf('./pair%d.mat', pp);
    load([pair_path pair_name]);
    total_pair = [total_pair; pair];
    bundle_name = sprintf('/bundle%d.mat', pp);
    load([bundle_path bundle_name]);
    total_bundle = [total_bundle; bundle];
end

pop = [];
regionDB = cell(1,1);   % 하이퍼에지로 사용된 bundle region을 저장하는 저장소
regionIDXDB = zeros(1, 3); % 사용된 region의 인덱스 저장소
%regionDBcnt = 1;
regionIDXDBcnt = 1; %저장소의 현재 인덱스
regionClusterCnt = zeros(IK, 1);
dicCnt = zeros(size(dic, 1), 1);

i_error = zeros(1, 3);
t_error = zeros(1, 3);
error_cnt = 1;
regionDB = [];
for pp=1:size(pair, 1)
    st = sprintf('The %dth data instance===============', pp);
    disp(st);
    if size(fieldnames(bundle{pp, 1})) < 2
        pop_name = sprintf('pop%d.mat', pp);    
        save([hn_path pop_name], 'pop', '-v7.3');         
        continue;
    end   
    seed_region = [];
    seed_word = [];  
    org_img_clusters = [];
    for j=1:size(bundle{pp, 1}, 2)
        org_img_clusters(j, 1) = bundle{pp, 1}(1,j).region_cluster;
    end    
    for i=1:epoch     
        %% Seed 생성
        seed_region = bundle{pp,1}(1,randsample(size(bundle{pp, 1}, 2), 1, false)).region_cluster;
        seed_word = pair{pp, 2}{1, randsample(size(pair{pp, 2}, 2), 1, false)};
        %% Error estimation 
        [gen_data, selected_idx] = generate(pop, seed_region, seed_word, regionDB, size(bundle{pp, 1}, 2)*2, size(pair{pp, 2}, 2)*2);               
        gen_img_clusters = [];
        for j=1:size(gen_data{1,1}, 2)
            %gen_img_clusters(1, j) = regionDB{gen_data{1,1}(1,j)}.region_cluster;
            gen_img_clusters(1, j) = gen_data{1,1}(1,j);
        end
        i_error(error_cnt, 1) = pp;i_error(error_cnt, 2) = i;
        i_error(error_cnt, 3) = 1-sum(ismember(org_img_clusters, gen_img_clusters)) / size(org_img_clusters, 1);
        t_error(error_cnt, 1) = pp;t_error(error_cnt, 2) = i;        
        if size(gen_data{1,2}, 2) > 0
            t_error(error_cnt, 3) = 1-sum(ismember(pair{pp, 2}, gen_data{1,2})) / size(pair{pp, 2}, 2);
        else
            t_error(error_cnt, 3) = 1;
        end
        error_cnt = error_cnt + 1;
        %% Correction and Update weights        
        [HE, HN_dic_cnt, HN_cls_cnt] = makeHyperedgePrior(pair{pp, 2}, bundle(pp, 1), pp, sampling_rate, bundle{pp, 1}, dic, HN_dic_cnt, HN_cls_cnt);
%         for j=1:size(HE, 1)
%             he = HE(j);
%             for k=1:size(he.i_idx, 2)
%                 if sum(ismember(he.i_absIdx(k), regionIDXDB(:, 1))) < 1
%                     regionIDXDB(regionIDXDBcnt, 1) = he.i_absIdx(k);
%                     regionIDXDB(regionIDXDBcnt, 2) = he.file_idx;
%                     regionIDXDB(regionIDXDBcnt, 3) = he.i_idx(k);
%                     regionDB{regionIDXDBcnt, 1} = bundle{he.file_idx, 1}(1, he.i_idx(k));
%                     HE(j).i_DBidx(1, k) = regionIDXDBcnt;
%                     regionIDXDBcnt = regionIDXDBcnt + 1;                    
%                 else                    
%                     HE(j).i_DBidx(1, k) = (find(ismember(regionIDXDB(:, 1), he.i_absIdx(k))));
%                 end
%             end            
%         end
        HE.episode = episode_num;
        tmp = pp*i;
        if tmp > 1
            tmp_weights = zeros(size(pop, 1), 1);
            for j=1:size(pop, 1)
                tmp_weights(j, 1) = pop(j,1).weight;
            end
            HE.weight = max(tmp_weights)*0.5 + mean(tmp_weights)*0.5;
        end
        pop = [pop; HE];                
        pop = updateWeights(pop, selected_idx, pair{pp, 2}, org_img_clusters, regionClusterCnt, dicCnt, regionDB, dic);   
    end
    if mod(pp, 20) == 0
        pop_name = sprintf('pop%d.mat', pp);    
        save([hn_path pop_name], 'pop', '-v7.3');  
    end    
end
pop_name = sprintf('pop%d.mat', pp);    
save([hn_path pop_name], 'pop', '-v7.3');  









