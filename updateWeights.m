%% 웨이트를 업데이트하는 부분: 데이터 복원생성에서의 기여도 + 가능하면 적게 사용된 정보 포함 가중치
function HE = updateWeights(pop, selected_idx, text_data, org_img_clusters, regionClusterCnt, dicCnt, regionDB, dic)   
FEATURE_THRESHOLD = 0.5;
for i=1:size(pop, 1)
    if sum(ismember(i, selected_idx)) < 1
        continue;
    end
    he_reg_clusters = [];
    for j=1:size(pop(i, 1).i_DBidx, 2)
        he_reg_clusters(1, j) = regionDB{pop(i, 1).i_DBidx(1, j), 1}.region_cluster;
    end
    val = sum(ismember(he_reg_clusters, org_img_clusters)) + sum(ismember(pop(i, 1).t_words, text_data));
    if val / (size(he_reg_clusters, 2)+size(pop(i, 1).t_words, 1)) < FEATURE_THRESHOLD
        pop(i,1).weight = pop(i,1).weight - 0.05;
    else
        pop(i,1).weight = pop(i,1).weight + 0.05;
    end    
    if pop(i,1).weight < 0
        pop(i,1).weight = 0;
    end
end
HE = pop;
end