% % Ÿ��Ʋ 1�� ��� ���Ǽҵ� ���� ������ ����(�۾� ���Ǹ� ����)
% intervals = [1; 21; 115; 217; 313; 396; 489; 586; 691; 765; 856; 955; 1044; 1134; 1215; 1230];
% for i=1:size(intervals, 1)-1
%     f_name = sprintf('./pororo/Preprocessing/Bundle/ep_1_%d.mat', i-1);
%     tmp_bundle = bundle(intervals(i, 1):intervals(i+1, 1)-1, 1);   
%     save(f_name, 'tmp_bundle', '-v7.3');
%     disp(sprintf('%d', i));
% end
% 
% 
% % ��ġ Ŭ�����͸��� ���� �ҽ� �ڵ�(vlad�� �÷� ������׷��� �ϳ��� ���ͷ� ��� Ŭ�����͸�, �����غ��� ���� ����ϰ� ��)
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
    % ��ġ Ŭ�����͸� �ϴ� �ҽ��� ���� ���⿡ �ݿ��ؼ� ���� ���鿡�� ��ǥ ��ġ�� �����ϵ��� �Ѵ�.(�޸� �Ҹ� �ʹ� ����)
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
        
        max_area = zeros(2,5); %�� Ŭ������ �� �ִ� ���� ���ϱ�
        for pp=1:size(bundle{i,1}, 2)
           if(max_area(1, k(pp)) < bundle{i,1}(1, pp).area)
               max_area(1, k(pp)) = bundle{i,1}(1, pp).area;
               max_area(2, k(pp)) = pp;
           end
        end
        
        %���� ������ ������ 10���� ������
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