function makeBundles()
run 'configure';
global content_name;
mkdir(bundle_path); 
% mkdir(region_centroid_path);
pair_list = dir(pair_path);%dir([pair_path '/' content_name]);
% region_list = dir(region_path);
% vw_list = dir(vw_path);
%% initialize R-CNN
fprintf('Initializing R-CNN model (this might take a little while)\n');
rcnn_model = rcnn_load_model(rcnn_model_file, use_gpu);
fprintf('done\n');
%% for loop
for i = 3:size(pair_list, 1)
    load([pair_path '/' pair_list(i, 1).name]); 
    fprintf('%s loaded\n', pair_list(i,1).name);
    
    tmp = strsplit(pair_list(i,1).name, '.mat');
    tmp = tmp{1,1}; tmp = strsplit(tmp, 'pair_');
    file_name = tmp{1,2};
%     tmp = strsplit(pair_list(i,1).name, 'ep');
%     tmp = tmp{1,2}; tmp = strsplit(tmp, '.mat'); 
%     ep_num = tmp{1,1};
%     load([region_path '/' region_list(i, 1).name]); %'./Pororo/Preprocessing/Region'
%     load([common_vw_path '/total_VWdata1.mat']); %'./Pororo/Preprocessing/VW'
%     load(['total_VWCenteroid.mat']);
    cp = zeros(size(pair,1), concept_num);
    bundle = cell(size(pair,1),1);
    for j=1:size(pair, 1)
%         if length(VWdata{j,1}) == 0
%             bundle{j,1} = selectVW(region{j,1}, VWdata{j-1,1}, pair{j, 1});
%         else
%             bundle{j,1} = selectVW(region{j,1}, VWdata{j,1}, pair{j, 1});
%         end
        idx = 1;
        bundle_tmp = struct;
        bundle_idx = zeros(1, nObjects);
        fprintf('%s - %d\n', pair_list(i,1).name, j); 
        %% first, we need to extract object regions using R-CNN
        im = pair{j,1};
        th = tic;
        dets = rcnn_detect(im, rcnn_model, box_thresh);
        fprintf('Total %d-class detection time: %.3fs\n', length(rcnn_model.classes), toc(th));
        all_dets = [];
        for k = 1:length(dets)
          all_dets = cat(1, all_dets, [k * ones(size(dets{k}, 1), 1) dets{k}]);
        end
        [~, ord] = sort(all_dets(:,end), 'descend');
        for k = 1:length(ord)
            score = all_dets(ord(k), end);
            %   if score < -0.5
            %     break;
            %   end
%             cls = rcnn_model.classes{all_dets(ord(k), 1)};
            if bundle_idx(1, all_dets(ord(k), 1)) == 0
                if all_dets(ord(k), 1) <= concept_num - 1 && score >= ch_thresh
                    cp(j,all_dets(ord(k), 1)) = 1;
                else
                    cp(j, end) = 1;
                end
                bundle_idx(1, all_dets(ord(k), 1)) = idx;
                boxes = all_dets(ord(k), 2:5);
                boxes_crop = [boxes(1), boxes(2), boxes(3)-boxes(1), boxes(4)-boxes(2)];
                im_obj = imcrop(im, boxes_crop);
                bundle_tmp(idx).img = im_obj;
                bundle_tmp(idx).img_vector = rcnn_features(im_obj, boxes, rcnn_model); 
                bundle_tmp(idx).clr_hist = color_hist(im_obj);
                bundle_tmp(idx).score = score;
                bundle_tmp(idx).object = rcnn_model.classes{all_dets(ord(k), 1)};
                idx = idx + 1;
            else
                idx_b = bundle_idx(1, all_dets(ord(k), 1));
                score_b = bundle_tmp(idx_b).score;
                if score > score_b
                    boxes = all_dets(ord(k), 2:5);
                    boxes_crop = [boxes(1), boxes(2), boxes(3)-boxes(1), boxes(4)-boxes(2)];
                    im_obj = imcrop(im, boxes_crop);
                    bundle_tmp(idx_b).img = im_obj;
                    bundle_tmp(idx_b).img_vector = rcnn_features(im_obj, boxes, rcnn_model); 
                    bundle_tmp(idx_b).clr_hist = color_hist(im_obj);
                    bundle_tmp(idx_b).score = score;
                end
            end
        end
        if length(bundle_tmp) > N_PATCH_THRESHOLD
            bundle_tmp_tmp = bundle_tmp;
            bundle_tmp_tmp = nestedSortStruct(bundle_tmp_tmp, 'score');
            bundle_tmp = bundle_tmp_tmp(length(bundle_tmp_tmp)-N_PATCH_THRESHOLD+1:end);
        end
        if length(bundle_tmp) == 0
            fprintf('error\n');
        end
        fprintf('n patch = %d\n', length(bundle_tmp));
        bundle{j,1} = bundle_tmp;
%         for k=1:size(bundle{j,1}, 2)
% %             if size(bundle{j,1}, 2) < 2
% %                 continue;
% %             end
%             nn = bundle{j,1}(1,k).feature_idx';
%             assignments = zeros(K,size(bundle{j,1}(1,k).features, 1));
% 
%             for l = 1:size(assignments,2)
%                 assignments(nn(l),l) = 1;
%             end
%             vlad_data = vl_vlad(double(bundle{j,1}(1,k).features'), C, assignments);
%             bundle{j,1}(1,k).vlad_feature = vlad_data;          
%         end
        % ��ġ Ŭ�����͸� �ϴ� �ҽ��� ���� ���⿡ �ݿ��ؼ� ���� ��鿡�� ��ǥ ��ġ�� �����ϵ��� �Ѵ�.(�޸� �Ҹ� �ʹ� ����)
%         if size(bundle{j,1},2) >= 1
%             test_patches = zeros(size(bundle{j,1},2), 39400);
% 
%             for pp=1:size(bundle{j,1}, 2)
%                 tmp = bundle{j, 1}(1, pp).vlad_feature';
%                 for m=1:10
%                     for n=1:10
%                         tmp2 = bundle{j, 1}(1, pp).clr_hist(:, m, n)';
%                         tmp = [tmp tmp2];
%                     end                
%                 end
%                 test_patches(pp, :) = tmp;
%                 bundle{j, 1}(1, pp).img_vector = tmp;
%             end            
%             if size(bundle{j,1},2) > PATCH_CLUSTER
%                 [c, k] = vl_kmeans(test_patches', PATCH_CLUSTER, 'algorithm', 'elkan');
%                 k = k';
% 
%                 max_area = zeros(2,PATCH_CLUSTER); %�� Ŭ������ �� �ִ� ���� ���ϱ�
%                 for pp=1:size(bundle{j,1}, 2)
%                    if(max_area(1, k(pp)) < bundle{j,1}(1, pp).area)
%                        max_area(1, k(pp)) = bundle{j,1}(1, pp).area;
%                        max_area(2, k(pp)) = pp;
%                    end
%                 end
% 
%                 %���� ����� ������ 10���� ������
%                 tmp_bundle = cell(1,1);
%                 idx = 1;
%                 for pp=1:PATCH_CLUSTER
%                   pair_path '/' content_name '/' pair_list(i, 1).name]); 
%     fprintf('%  if max_area(2, pp) > 0
%                        tmp_bundle{1,1}(1,idx) = bundle{j,1}(1,max_area(2, pp));
%                        idx = idx + 1;
%                     end
%                 end
%                 bundle{j,1} = tmp_bundle{1,1}; 
%             end
%         end   
%     disp(sprintf('%d', j));   
    end
    
    cnt = 1;
    for k=1:size(bundle, 1)
        for j=1:size(bundle{k,1}, 2)
            bundle{k,1}(1,j).idx = cnt;
            cnt = cnt+1;
        end
    end    
    
    mkdir([bundle_path]);%'/' content_name]);
    bundle_name = sprintf([bundle_path '/bundle_' file_name '.mat']);
    disp('bundle made');
    save(bundle_name, 'bundle', '-v7.3');
    
    mkdir([cp_path]); %'/' content_name]);
    cp_name = sprintf([cp_path '/cp_' file_name '.mat']);
    disp('cp made');
    save(cp_name, 'cp', '-v7.3');
end
end
% 
% % region�� ������ 0�� ��찡 �ִµ� �̷� ���� ��ü �̹����� ���ؼ� SIFT feature���� ����
% function result = selectVW(regions, VWdata, img, name, pairnum)
% result = struct;
% I = uint8(rgb2gray(img)); %�̹��� ũ�⸸ŭ free �����.
% count = 1;
% 
% if size(regions, 1) < 1
%     features = [];
%     m = ones(size(I));  %? �̹��� ��ü�� ���Ͽ� ����ŷ
%     for j=1: length(VWdata)  %? �̹��� ��ü�� �ϳ��� region�̹Ƿ� ��� SIFT feature�� �� ���� ����
%         features = [features [VWdata(j).feature_idx; VWdata(j).row; VWdata(j).column]];
%     end
%     if size(features, 2) > 1
%         ROF = sortrows(features', 1)'; %???? ���ϴ°��� �𸣰ٴ�;;;
%         COF = sortrows(features', 1)';
%         result(count).features = features(1, :);
%         result(count).feature_vector = accumToVector(result(count).features);
%         result(count).ROF = ROF(2, :);
%         result(count).COF = COF(3, :);
%         mixed_hist_index = seperateRegions(img, m); %�ε���, ������׷� ��ȯ
%         %result(count).img_index = mixed_hist_index{2};% ���� ũ��
%         result(count).file_name = name; %���� �̹��� ��ġ �̸� pair1 �̳� pair2��
%         result(count).pair_num = pairnum; %����pair�ȿ� ��ġ�� �̹����� ��ȣ��
%         result(count).region_num = size(regions, 1); % �ش� �̹������� �������� ���� ��ȣ �� �ϳ�
%         % result(count).region_maks = m; %����ũ�� �ʿ������?? �̰� �̹������� ������ ������.
%         result(count).hist = mixed_hist_index{1};  %������׷�
%         result(count).region = 0;
%         count = count + 1;
%     else
%         result(count).ROF = [];
%         result(count).COF = [];
%         result(count).features = [];
%         result(count).feature_vector = accumToVector(result(count).features);
%         mixed_hist_index = seperateRegions(img, m);
%         result(count).file_name = name;
%         result(count).pair_num = pairnum; %����pair�ȿ� ��ġ�� �̹����� ��ȣ��
%         result(count).region_num = size(regions, 1); % �ش� �̹������� �������� ���� ��ȣ �� �ϳ�  
%         result(count).hist = mixed_hist_index{1}; 
%         result(count).region = 0;
%         count = count + 1;
%     end
% else
%     for i = 1:size(regions, 1)
%         m = zeros(size(I));
%         s = vl_erfill(I, regions(i, 1));%region �� �ش��ϴ� ���� s���ƴٰ� ����
%         m(s) = 1; %�� ��ũ�� m���ٰ� 1�� ǥ��
%         features = [];        
%         for j = 1:length(VWdata)%feature ����??
%             if m(VWdata(j).row, VWdata(j).column) == 1
%                 features = [features [VWdata(j).feature_idx; VWdata(j).row; VWdata(j).column]];
%             end
%         end        
%         if size(features, 2) > 1
%             ROF = sortrows(features', 2)'; %???? ���ϴ°��� �𸣰ٴ�;;;
%             COF = sortrows(features', 3)';
%             result(count).features = features(1, :);
%             result(count).feature_vector = accumToVector(result(count).features);
%             result(count).ROF = ROF(1, :);
%             result(count).COF = COF(1, :);
%             mixed_hist_index = seperateRegions(img, m); %�ε���, ������׷� ��ȯ
%             %result(count).img_index = mixed_hist_index{2};% ���� ũ��
%             result(count).file_name = name; %���� �̹��� ��ġ �̸� pair1 �̳� pair2��
%             result(count).pair_num = pairnum; %����pair�ȿ� ��ġ�� �̹����� ��ȣ��
%             result(count).region_num = i; % �ش� �̹������� �������� ���� ��ȣ �� �ϳ�
%             % result(count).region_maks = m; %����ũ�� �ʿ������?? �̰� �̹������� ������ ������.
%             result(count).hist = mixed_hist_index{1};  %������׷�
%             result(count).region = regions(i,1);  
%             count = count + 1;     
%         else
%             result(count).ROF = [];
%             result(count).COF = [];
%             result(count).features = [];
%             result(count).feature_vector = accumToVector(result(count).features);
%             mixed_hist_index = seperateRegions(img, m);
%             result(count).file_name = name;
%             result(count).pair_num = pairnum; %����pair�ȿ� ��ġ�� �̹����� ��ȣ��
%             result(count).region_num = size(regions, 1); % �ش� �̹������� �������� ���� ��ȣ �� �ϳ�  
%             result(count).hist = mixed_hist_index{1}; 
%             result(count).region = 0;
%             count = count + 1;
%         end                    
%     end
% end
% end
% 
% % %�̹��� �������� img �� pairnum�� 
% % I = uint8(rgb2gray(img));
% % m = zeros(size(I));
% % s = vl_erfill(I, regions(i, 1));%region �� �ش��ϴ� ���� s���ƴٰ� ����
% % m(s) = 1;
% % sub_img = uint8(zeros(size(img)));
% % sub_img(:) = 255;
% % for  i = 1:size(img, 1)
% %     for j = 1:size(img, 2)
% %         if m(i, j) == 1
% %             sub_img(i, j, :) = img(i, j, :);
% %         end
% %     end
% % end
% %result(count).img_index %���⼭ �ҷ��鿩�ͼ� w,h �� ����)
% % sub_img = imcrop(sub_img, [w_first h_first (w_last - w_first + 1) (h_last - h_first + 1)]);
% 
% function sub_img_index = seperateRegions(img, m)
% sub_img = uint8(zeros(size(img)));
% sub_img(:) = 255;
% for  i = 1:size(img, 1)
%     for j = 1:size(img, 2)
%         if m(i, j) == 1
%             sub_img(i, j, :) = img(i, j, :); % 1�ΰ͸� �̹����� �����´�.
%         end
%     end
% end
% 
% w_sum = sum(m); h_sum = sum(m, 2);
% w_first = find(w_sum, 1, 'first'); w_last = find(w_sum, 1, 'last');
% h_first = find(h_sum, 1, 'first'); h_last = find(h_sum, 1, 'last');
% sub_img = imcrop(sub_img, [w_first h_first (w_last - w_first + 1) (h_last - h_first + 1)]);
% hist_img = rgbhist(sub_img);
% sub_img_index{1} = hist_img;
% sub_img_index{2} = [w_first; w_last ; h_first; h_last];
% %imshow(sub_img);
% end 
% 
% function hist = rgbhist(img) 
% pixel_num = numel(img);
% hist(:, 1) = imhist(img(:,:,1), 256); 
% hist(:, 2) = imhist(img(:,:,2), 256); 
% hist(:, 3) = imhist(img(:,:,3), 256);
% hist = hist / pixel_num;
% end
% 
% function feature_vector = accumToVector(features)
% run 'configure';
% feature_vector = zeros(1, K);
% for i=1:size(features, 2)
%     feature_vector(1, features(1, i)) = feature_vector(1, features(1, i)) + 1;
% end
% end

