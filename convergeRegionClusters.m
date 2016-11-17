function convergeRegionClusters()

run 'configure';

cent_list = dir(region_centroid_path);
bundle_list = dir(org_bundle_path);
mkdir(bundle_path);

cent_name = [region_centroid_path 'reg_cent1.mat'];
load(cent_name);
base_C = C;
clear C;

for i=4:size(bundle_list, 1)
    disp(sprintf('%d-th bundle', i-2));
    bundle_name = [org_bundle_path sprintf('/bundle%d.mat', i-2)];
    load(bundle_name);
    org_bundle = bundle;
    clear bundle ;
    
    cent_name = [region_centroid_path sprintf('/reg_cent%d.mat', i-2)];
    load(cent_name);
    org_C = C;
    clear C;    
    
    % centroid들 간의 거리 계산

    dist_matrix = zeros(size(base_C, 2), size(org_C, 2));
    for j=1:size(base_C,2)
        tmpCent = base_C(:,j);
        for k=1:size(org_C,2)
            tmpDes = double(org_C(:,k));
            tmpGap = tmpCent-tmpDes;
            tmpSq = sum(tmpGap.*tmpGap);
            dist(j,k) = tmpSq;
        end
    end
    [min_dists, idx] = min(dist, [], 1);
    min_dists = min_dists';
    clusters = idx';
    
    avg_dist = mean(min_dists);
    max_dist = max(min_dists);
    threshold_dist = max_dist*THRE_CUT + avg_dist*(1-THRE_CUT);      
    
    idx_cnt = 1;    
    new_clster_idx = zeros(1, 2);
    for j=1:size(min_dists, 1)
        if min_dists(j,1) > threshold_dist
            new_clster_idx(idx_cnt, 1) = j;
            new_clster_idx(idx_cnt, 2) = size(base_C, 2)+idx_cnt;
            idx_cnt = idx_cnt + 1;
        end
    end
    % outliar 들은 따로 클러스터의 센트로이드로 설정
    for j=1:size(new_clster_idx, 1)
        base_C = [base_C org_C(:, new_clster_idx(j,1))];
    end    
    % 새로운 클러스트들 부터 bundle에 재반영
    for j=1:size(org_bundle, 1)
        for k=1:size(org_bundle{j,1}, 2)
            if sum(ismember(org_bundle{j,1}(1, k).region_cluster, new_clster_idx(:, 1))) > 0
                org_bundle{j,1}(1, k).region_cluster = new_clster_idx(find(ismember(new_clster_idx(:, 1), org_bundle{j,1}(1, k).region_cluster)), 2);
            else
                org_bundle{j,1}(1, k).region_cluster = clusters(org_bundle{j,1}(1, k).region_cluster, 1);
            end            
        end            
    end
    bundle = org_bundle;
    bundle_name = sprintf([bundle_path '/bundle%d.mat'], i - 2);
    disp('bundle made');
    save(bundle_name, 'bundle', '-v7.3');
end
C = base_C;
cent_name = sprintf([region_centroid_path '/tot_reg_cent.mat']);
save(cent_name, 'C');      

end