%% make selective search data for pororo
% train
load('imdb/cache/imdb_voc_pororo_train.mat');
images = imdb.image_ids';
boxes = cell(1, length(images));

for i = 1:length(boxes)
    im = imread(['/home/kmkim/Downloads/rcnn-master/datasets/VOCdevkit_pororo/VOC_pororo/JPEGImages/' images{i} '.bmp']);
    box = selective_search_boxes(im);
    boxes{1,i} = box;
end

save('data/selective_search_data/voc_pororo_train.mat', 'images', 'boxes');

% val
load('imdb/cache/imdb_voc_pororo_val.mat');
images = imdb.image_ids';
boxes = cell(1, length(images));

for i = 1:length(boxes)
    im = imread(['/home/kmkim/Downloads/rcnn-master/datasets/VOCdevkit_pororo/VOC_pororo/JPEGImages/' images{i} '.bmp']);
    box = selective_search_boxes(im);
    boxes{1,i} = box;
end

save('data/selective_search_data/voc_pororo_val.mat', 'images', 'boxes');

% test
load('imdb/cache/imdb_voc_pororo_test.mat');
images = imdb.image_ids';
boxes = cell(1, length(images));

for i = 1:length(boxes)
    im = imread(['/home/kmkim/Downloads/rcnn-master/datasets/VOCdevkit_pororo/VOC_pororo/JPEGImages/' images{i} '.bmp']);
    box = selective_search_boxes(im);
    boxes{1,i} = box;
end

save('data/selective_search_data/voc_pororo_test.mat', 'images', 'boxes');

