% % 타이틀 1의 경우 에피소드 별로 번들을 저장(작업 편의를 위해)
% intervals = [1; 21; 115; 217; 313; 396; 489; 586; 691; 765; 856; 955; 1044; 1134; 1215; 1230];
% for i=1:size(intervals, 1)-1
%     f_name = sprintf('./pororo/Preprocessing/Bundle/ep_1_%d.mat', i-1);
%     tmp_bundle = bundle(intervals(i, 1):intervals(i+1, 1)-1, 1);   
%     save(f_name, 'tmp_bundle', '-v7.3');
%     disp(sprintf('%d', i));
% end
% 
% 
% % 패치 클러스터링을 위한 소스 코드(vlad와 컬러 히스토그램을 하나의 벡터로 묶어서 클러스터링, 직접해보니 제법 비슷하게 됨)
% test_patches = zeros(24, 39400);
% 
% for pp=1:size(bundle, 1)
%     for i=1:size(bundle, 2)
%         tmp = bundle{pp, 1}(1, i).vlad_feature';
%         for j=1:10
%             for k=1:10
%                 tmp2 = bundle{47, 1}(1, i).clr_hist(:, j, k)';
%                 tmp = [tmp tmp2];
%             end                
%         end
%         test_patches(i, :) = tmp;
%     end
% end
% 
% [c, k] = vl_kmeans(test_patches', 5, 'algorithm', 'elkan');
% k = k';

for i=21:114
    % 패치 클러스터링 하는 소스를 보고 여기에 반영해서 최종 번들에는 대표 패치만 저장하도록 한다.(메모리 소모가 너무 많음)
    if size(bundle{i,1},2) > 5
        test_patches = zeros(size(bundle{i,1},2), 39400);

        for pp=1:size(bundle{i,1}, 2)
            tmp = bundle{i, 1}(1, pp).vlad_feature';
            for j=1:10
                for k=1:10
                    tmp2 = bundle{i, 1}(1, pp).clr_hist(:, j, k)';
                    tmp = [tmp tmp2];
                end                
            end
            test_patches(pp, :) = tmp;
        end

        [c, k] = vl_kmeans(test_patches', 5, 'algorithm', 'elkan');
        k = k';
        
        max_area = zeros(2,5); %각 클러스터 당 최대 넓이 구하기
        for pp=1:size(bundle{i,1}, 2)
           if(max_area(1, k(pp)) < bundle{i,1}(1, pp).area)
               max_area(1, k(pp)) = bundle{i,1}(1, pp).area;
               max_area(2, k(pp)) = pp;
           end
        end
        
        %이제 번들의 개수를 10개로 재정비
        tmp_bundle = cell(1,1);
        for pp=1:5
           tmp_bundle{1,1}(1,pp) = bundle{i,1}(1,max_area(2, pp));
        end
        bundle{i,1} = tmp_bundle{1,1}; 
    end
    
    disp(sprintf('%d', i));
end
% %vlad_Pororo = cellfun(@vl_vlad, descriptors_cell, C_cell, assignments_cell, 'UniformOutput', false);
% disp('vlad done..');
% disp('save bundle..');
% intervals = [1; 21; 115; 217; 313; 396; 489; 586; 691; 765; 856; 955; 1044; 1134; 1215; 1230];
% for i=1:size(intervals, 1)-1
%     f_name = sprintf('./pororo/Preprocessing/Bundle/ep_1_%d.mat', i-1);
%     tmp_bundle = bundle(intervals(i, 1):intervals(i+1, 1)-1, 1);   
%     save(f_name, 'tmp_bundle', '-v7.3');
%     disp(sprintf('%d', i));
% end