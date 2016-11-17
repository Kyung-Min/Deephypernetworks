%% Synthesize image from the learned model
Sampling_policy = 2;
LEARNING_RATE = 0.5;
time = 184;
nCluster = 40;
char_idx = [1];
nCharBestC = 5;

query1 = {'clock', 'i', 'have', 'made', 'another', 'potion', 'come', 'and', 'try', 'it'};
query2 = {'clock', 'potion', 'come', 'try'};

% dir_path = ['Updated_HN/Sampling_policy' num2str(Sampling_policy) '/'];
% HN_dir_path = [dir_path 'HN/'];
% HN_path = [HN_dir_path 'Upated_HN_' num2str(time) '.mat'];
% meta_HN_dir_path = [dir_path 'meta_HN/'];
% meta_HN_path = [meta_HN_dir_path 'meta_HN_' num2str(time) '.mat'];
% load(HN_path);
% load(meta_HN_path);

ep_idx = 1;
ep_length = meta_HN{ep_idx, 3};
ep_dir = meta_HN{ep_idx, 1};
ep_name = meta_HN{ep_idx,2};
bundle_path = ['/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/Bundle/' ep_dir '/bundle_' ep_name '.mat'];
load(bundle_path);
imgs_lst = [];
SE_pop = [];
pop_indices = [];

disp('Selecting HEs...');
for i=1:size(pop, 1)
    if sum(ismember(pop(i,1).t_words, query1)) > 2 && sum(ismember(pop(i,1).t_words, query2)) > 1 %&& sum(pop(i,1).concepts(1, 1:2))> 1 && sum(pop(i,1).concepts) < 6
        SE_pop = [SE_pop;pop(i,1)];
        pop_indices = [pop_indices;i];
    end
end

disp('Getting images..');
org_bundle = bundle;
flag = false;
for i=1:size(SE_pop, 1)
    num = randperm(100, 1);
    if size(SE_pop, 1) < 10
        thres = 0;
    elseif i < size(SE_pop, 1)*0.8
        thres = 30;
    else
        thres = 30;
    end
    if num < thres
        continue;
    end
    while pop_indices(i,1) > ep_length
        ep_idx = ep_idx+1;        
        ep_length = meta_HN{ep_idx,3};  
        flag = true;
    end            
    ep_content = meta_HN{ep_idx,1};
    ep_dir = meta_HN{ep_idx, 1};
    ep_name = meta_HN{ep_idx,2};
    ep_length = meta_HN{ep_idx,3};
    if flag == true
        bundle_path = ['/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/Bundle/' ep_dir '/bundle_' ep_name '.mat'];
        load(bundle_path);
        org_bundle = bundle;
        flag = false;
    end   
    for j=1:size(SE_pop(i,1).i_idx, 2)
        imgs = struct;
        img = org_bundle{SE_pop(i,1).file_idx, 1}(1,SE_pop(i,1).i_idx(1,j)).img;
        imgs.img = img;
        imgs_lst = [imgs_lst;imgs];
    end
    fprintf('%d\n', i);
end
SIZE_X = 2400;
SIZE_Y = 2000;
base_img = zeros(SIZE_X, SIZE_Y);
new_img = double(zeros(SIZE_X, SIZE_Y, 3));
new_img(:) = 0;
for i=1:size(imgs_lst, 1)
    img = imgs_lst(i, 1).img;
    start_x = randperm(SIZE_X-size(img, 1), 1);
    start_y = randperm(SIZE_Y-size(img, 2), 1);
%     base_img(start_x+1:start_x+size(img, 1), start_y+1:start_y+size(img, 2)) = base_img(start_x+1:start_x+size(img, 1), start_y+1:start_y+size(img, 2)) +1;
%     new_img(start_x+1:start_x+size(img, 1), start_y+1:start_y+size(img, 2), :) = new_img(start_x+1:start_x+size(img, 1), start_y+1:start_y+size(img, 2), :)+double(img(:, :, :));
    for j=start_x+1:start_x+size(img, 1)
        for k=start_y+1:start_y+size(img, 2)
            if sum(double(img(j-start_x, k-start_y, :))) < 765
                base_img(j, k) = base_img(j, k) + 1;
                new_img(j, k, :) = new_img(j, k, :) + double(img(j-start_x, k-start_y, :));
            end
        end
    end    
end

for k=1:size(base_img, 1)
    for j=1:size(base_img, 2)
        if base_img(k, j) < 1
           new_img(k, j, :) = 255;
        else
           new_img(k, j, :) = new_img(k, j, :) / base_img(k, j);
        end        
    end
end

for i=1:size(new_img, 1)
    for j=1:size(new_img, 2)
        for k=1:size(new_img, 3)
            if new_img(i,j,k) > 255
                new_img(i,j,k) = 1;
            else
                new_img(i,j,k) = new_img(i,j,k)/255;
            end
        end
    end
end

file_name = [];
for i=1:size(query1, 2);
    file_name = [file_name '_' query1{1, i}]; 
end
imwrite(new_img, ['Generated_imgs/' file_name '.jpg'], 'jpg');
