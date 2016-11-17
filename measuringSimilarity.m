%% Similarity 측정

run 'configure';
%tot_pop = [];
% for i=1:1
%     disp(sprintf('%d-th pop loading', i));
%     load_hn_path = [pop_path 'new' sprintf('%d/',i)];
%     img_folder_list = dir(load_hn_path);
%     file_num = [];
%     file_names = [];
%     for j=4:size(img_folder_list, 1)
%         file_names{j-3, 1} = img_folder_list(j).name(4:length(img_folder_list(j).name)-4);
%     end    
%     for j=1:size(file_names,1)
%         aa = file_names{j, 1};
%         file_num(j,1) = str2num(aa);
%     end
%     pop_name = ['pop' sprintf('%d.mat', max(file_num))];
%     load([load_hn_path pop_name]);
%     tot_pop = [tot_pop; pop];
% end
% pop = tot_pop;
% cent_list = dir(region_centroid_path);
% 
% cent_name = [region_centroid_path 'tot_reg_cent.mat'];
% load(cent_name);


DIST_COEFF = -0.05;
% 대상이 되는 pair, bundle, centroid등 을 각각 불러온다. --> 이건 수동으로 하자
text_info = pair(:, 2);
score_sum = [];
for i=1:size(bundle, 1)
    disp(sprintf('%d-th bundle', i));
    bund = bundle{i,1};
    tmp_score_sum = 0;
    %텍스트 매칭되는 것 개수 카운트
    for j=1:size(pop, 1)
        he = pop(i,1);
        t_score = sum(ismember(he.t_words', text_info{i, :})); 
%         if t_score < 1            
%             continue;
%         end        
        for k=1:size(bund, 2)
            org_C(:, k) = bund(1,k).feature_vector';
        end
        dist_matrix = zeros(size(he.i_idx, 2), size(org_C, 2));
        for k=1:size(he.i_idx,2)
            tmpCent = C(:, he.i_clusters(1,k));
            for m=1:size(org_C, 2)
                tmpDes = double(org_C(:,m));
                tmpGap = tmpCent-tmpDes;
                tmpSq = sum(tmpGap.*tmpGap);
                dist_matrix(k,m) = tmpSq;                
            end              
        end
        [min_dists, ~] = min(dist_matrix, [], 2);
        i_score = 0;
        for k=1:size(min_dists, 1)
%             tmp = 10 + DIST_COEFF*min_dists(k,1);
%             if tmp < 1
%                 tmp = 1;
%             end
%             i_score = i_score + log10(tmp); 
            i_score = exp(DIST_COEFF*min_dists(k,1));
        end 
        tmp_score_sum = tmp_score_sum + (i_score + t_score);
    end
    score_sum(i,1) = tmp_score_sum;
end
tot_sum = [];
tot_sum(1,1) = score_sum(1,1);
for i=2:size(score_sum, 1)
    tot_sum(i,1) = tot_sum(i-1,1) + score_sum(i, 1);
end
slide_wnd_score = zeros(size(score_sum, 1), 1);
for i=10:size(slide_wnd_score, 1)
   slide_wnd_score(i,1) =  sum(score_sum(i-9:i, 1));
end