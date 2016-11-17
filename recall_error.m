run 'configure';
error_cnt = 1;
regionDB = [];
i_error = zeros(1, 2);
t_error = zeros(1, 2);
for pp=1:size(bundle, 1)
    disp(sprintf('%d-th bundle', pp));
    seed_region = [];
    seed_word = [];  
    org_img_clusters = [];
    for j=1:size(bundle{pp, 1}, 2)
        org_img_clusters(j, 1) = bundle{pp, 1}(1,j).region_cluster;
    end    
    i_error(error_cnt, 1) = pp;
    t_error(error_cnt, 1) = pp;
    for i=1:2     
        %% Seed »ý¼º
        seed_region = bundle{pp,1}(1,randsample(size(bundle{pp, 1}, 2), 1, false)).region_cluster;
        seed_word = pair{pp, 2}{1, randsample(size(pair{pp, 2}, 2), 1, false)};
        %% Error estimation 
        [gen_data, selected_idx] = generate(pop, seed_region, seed_word, regionDB, size(bundle{pp, 1}, 2)*2, size(pair{pp, 2}, 2)*2);               
        gen_img_clusters = [];
        for j=1:size(gen_data{1,1}, 2)            
            gen_img_clusters(1, j) = gen_data{1,1}(1,j);
        end
        i_error(error_cnt, 2) = i_error(error_cnt, 2)+ (1-sum(ismember(org_img_clusters, gen_img_clusters)) / size(org_img_clusters, 1));       
        if size(gen_data{1,2}, 2) > 0
            t_error(error_cnt, 2) = t_error(error_cnt, 2) + (1-sum(ismember(pair{pp, 2}, gen_data{1,2})) / size(pair{pp, 2}, 2));
        else
            t_error(error_cnt, 2) = t_error(error_cnt, 2) + 1;
        end        
    end
    i_error(error_cnt, 2) = i_error(error_cnt, 2)/epoch;
    t_error(error_cnt, 2) = t_error(error_cnt, 2)/epoch;
    error_cnt = error_cnt + 1; 
end


