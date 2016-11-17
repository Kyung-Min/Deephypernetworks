function makeVWdata()
run 'configure';

pair_list = dir(pair_path);
total_pair = cell(size(pair_list, 1) - 5, 1); % �� -5�� �Ǿ���?
for i = 3:size(pair_list, 1)
    load([pair_path '/' pair_list(i, 1).name]);
    total_pair{i - 2,1} = pair;
end
pair = total_pair;

%% run vl_SIFT and vl_kmeans to get the visual words per each images
%% make volume index table
volume_idx = zeros(size(pair, 1), 2);
start_idx = 1;
for i = 1:size(pair, 1)
    volume_idx(i, 1) = start_idx;
    volume_idx(i, 2) = start_idx + size(pair{i, 1}, 1) - 1;
    start_idx = volume_idx(i, 2) + 1;
end

%% concatenate imgs in total volume
imgs = cell(volume_idx(size(volume_idx,1), 2), 1);
for i = 1:size(pair, 1)
    imgs(volume_idx(i,1):volume_idx(i,2), 1) = pair{i, 1}(:, 1);
end

%% run SIFT
imgs = cellfun(@rgb2gray, imgs, 'UniformOutput', false);
imgs = cellfun(@single, imgs, 'UniformOutput', false);
[frames, descriptors] = cellfun(@vl_sift, imgs, 'UniformOutput', false);
clear imgs;

%% round x, y coordinates
frames = cell2mat(frames');
frames = round(frames(1:2, :)); 
frames = frames';

%% make scene index table
[~, d_size] = cellfun(@size, descriptors, 'UniformOutput', false);
d_size = cell2mat(d_size); 
scene_idx = zeros(size(d_size, 1), 2);
start_idx = 1;
for i = 1:size(scene_idx, 1)
    scene_idx(i, 1) = start_idx;
    scene_idx(i, 2) = start_idx + d_size(i, 1) - 1;
    start_idx = scene_idx(i, 2) + 1;
end

%% run Kmeans
descriptors = cell2mat(descriptors');

% ���� 2�� sift cluster�� �̿��ؼ� cluster assign�� �Ѵ�
load('cluster_center.mat');
load('cluster_kdtree.mat');

[A, ~] = vl_kdtreequery(kdtree, C, double(descriptors));
% [C, A] = vl_kmeans(double(descriptors), K, 'algorithm', 'elkan');
% A = A';
%clear descriptors;

% save('cluster_center.mat', 'C', '-v7.3');

% nn = A;
assignments = zeros(K,size(descriptors, 2));
%assignments(sub2ind(size(assignments), nn, 1:length(nn))) = 1;

for i = 1:size(assignments,2)
    assignments(A(i),i) = 1;
end

%% Encode data using vl_vlad
descriptors_cell = mat2cell(descriptors, size(descriptors,1 ), d_size');
assignments_cell = mat2cell(assignments, size(assignments,1 ), d_size');
C_cell = cell(1, size(descriptors_cell, 2));%size(volume_idx, 1));
for i=1:size(C_cell, 2)
    C_cell(1,i) = mat2cell(C, size(C, 1), size(C, 2));
end

descriptors_cell = cellfun(@double, descriptors_cell, 'UniformOutput', false);

disp('vlad start..');
% vlad_feature�� 1 x image ���� ��ŭ�� cell�ν� 
% �� cell�� image �ϳ��� feature�� ���� ���� (feature dimension : cluster���� x sift dimension)
vlad_feature = cellfun(@vl_vlad, descriptors_cell, C_cell, assignments_cell, 'UniformOutput', false);
disp('vlad done..');

%% organize result
kSIFT = [A frames];
total_VWdata = cell(size(volume_idx, 1), 1);
for i = 1:size(volume_idx, 1)
    total_VWdata{i, 1} = cell(volume_idx(i, 2) - volume_idx(i, 1) + 1, 1);
    for j = volume_idx(i, 1):volume_idx(i, 2)
        temp = kSIFT(scene_idx(j, 1):scene_idx(j, 2), :, :);
        temp = unique(temp, 'rows');
        for k = 1:size(temp, 1)
            total_VWdata{i, 1}{j - volume_idx(i, 1) + 1, 1}(k).feature_idx = temp(k, 1);
            total_VWdata{i, 1}{j - volume_idx(i, 1) + 1, 1}(k).row = temp(k, 3);
            total_VWdata{i, 1}{j - volume_idx(i, 1) + 1, 1}(k).column = temp(k, 2);
        end
    end
end      

%% make directory and save result
mkdir(vw_path);
for i = 1:size(volume_idx, 1)
    VWdata = total_VWdata{i, 1};
    vw_name = sprintf([vw_path '/VWdata%d.mat'], i);
    save(vw_name, 'VWdata');    
end
save([vw_path '/VWCenteroid.mat'], 'C');
end

