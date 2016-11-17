tic;
run 'configure';
pool=1000;
query = 'chair';
dir_name = './retrieved_training_afors/';
mkdir(dir_name);
pool_name = sprintf([dir_name '/%d/' query '/'], pool);
patch_name = sprintf([pool_name 'patches/']);
mkdir(pool_name);
mkdir(patch_name);
%% Load Dic
% load([dic_path './dic.mat']);


%% Load preprocessed test data
disp('Loading data');
pair_name = sprintf('./pair1.mat');
load([pair_path pair_name]);
bundle_name = sprintf('./bundle1.mat');
load([bundle_path bundle_name]);

file_name = sprintf('./genPop1_5000/pop%d.mat', pool);
load(file_name);


selectedHE = [];

%% select hyperedges which has a quey in population
disp('Finding text query');
split_query = regexp(query, '\s', 'split');

if length(split_query) == 1
    count = 1;
    for i = 1:size(pop, 1)
        if sum(ismember(split_query, pop(i, 1).text)) >= 1
            selectedHE = [selectedHE;pop(i,1)];
        end
    end
else
    count = 1;
    for i = 1:size(pop, 1)
        if sum(ismember(split_query, pop(i, 1).text)) >= length(split_query)
            buffer{count, 1} = pop(i, 1);
            count = count + 1;
            if count == BUFF_SIZE + 1
                selectedHE = [selectedHE; buffer];
                count = 1;
            end
        end
    end
end

pop = selectedHE;
for i=1:size(pop, 1)
    for j=1:i_order
        name = sprintf([patch_name '/%d_%d.jpg'], i, j);
        imwrite(pop(i,1).bundle(1,j).img, name);
    end
end

bundle_score = zeros(size(bundle, 1),1);    %similarity scores
disp('Expanding the text query to the image query');
if isempty(selectedHE)
    disp([split_query ' is not exist']);
else
    for m=1:i_order
        pop_bundle = zeros(size(pop, 1), K);
        pop_size = zeros(size(pop, 1), 1);            
        for i=1:size(pop,1)        
            if ~isempty(fieldnames(pop(i, 1).bundle)) 
                pop_bundle(i, pop(i, 1).bundle(1,m).features) = 1;
                pop_size(i, 1) = pop_size(i, 1)+length(pop(i, 1).bundle(1,m).features);
                %pop_size(i, 1) = length(pop(i, 1).bundle.features);
            end
        end     
        pop_bundle = pop_bundle .* repmat(pop_size, 1, K);
        norm = sum(pop_bundle, 2);         
        for i=1:size(bundle, 1)
            img_bundle = zeros(K, size(bundle{i, 1}, 2)); 
            if size(fieldnames(bundle{i,1}), 1) < 2
                continue;
            end
            for j = 1:size(bundle{i, 1}, 2)
                img_bundle(bundle{i, 1}(j).features, j) = 1;
            end
            cmp_bundle = pop_bundle * img_bundle;
            cmp_bundle = cmp_bundle ./ repmat(norm, 1, size(bundle{i, 1}, 2));
            cmp_bundle(cmp_bundle < FEATURE_THRESHOLD) = 0;
            for j = 1:size(cmp_bundle, 1)
                for k=1:size(cmp_bundle, 2)
                    hist_score = sum(sum(abs(pop(j, 1).bundle(m).hist - bundle{i, 1}(k).hist)));
                    hist_weight = sum(sum(pop(j, 1).bundle(m).hist, 2) ~= 0) / 255;     
                    cmp_bundle(j, k) = FEATURE_COEFF * cmp_bundle(j, k) + HIST_COEFF * hist_weight * (1 - hist_score);
                end
            end              
            bundle_score(i,1) = bundle_score(i,1) + sum(sum(cmp_bundle));            
        end        
    end
end
[B, idx] = sort(bundle_score, 'descend');
for i=1:20
    name = sprintf([pool_name '/%d_%d.jpg'], i, idx(i));
    imwrite(pair{idx(i),1}, name);
end
toc;
