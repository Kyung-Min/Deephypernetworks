run 'configure';

pool=1000;
dir_name = './compare/';
mkdir(dir_name);
%file_name = sprintf('./genPop1_5000/pop%d.mat', pool);
%load(file_name);
pop = [];
base_pop = pop;
querys = {'beach';
'bird';
'boat';
'bridge';
'building';
'castle';
'cat';
'chair';
'dog';
'dress';
'fish';
'floor';
'flower';
'girl';
'grass';
'house';
'kitchen';
'mountain';
'office';
'river';
'road';
'rock';
'room';
'sand';
'sky';
'table';
'tower';
'tree';
'wall';
'water'};
for kk=7:7%size(querys, 1) 
    pop = base_pop;
    %query = querys{kk,1};
    query = 'water';
    pool_name = sprintf([dir_name '/%d/' query '/'], pool);
    mkdir(pool_name);
    %% Load Dic
    % load([dic_path './dic.mat']);


    %% Load preprocessed test data
    disp('Loading training data');
    % pair_name = sprintf('./testpair1.mat');
    % load([pair_path pair_name]);
    % bundle_name = sprintf('./testbundle1.mat');
    % load([bundle_path bundle_name]);
    % bundle = test_bundle;
    % clear test_bundle;
    % pair = test_pair;
    % clear test_pair;


    pair_name = sprintf('/pair1.mat');
    load([pair_path pair_name]);
    bundle_name = sprintf('/bundle1.mat');
    load([bundle_path bundle_name]);
    selectedHE = [];
    disp('Expanding from textual query to visual query');
    %% select hyperedges which has a quey in population
    split_query = regexp(query, '\s', 'split');

    if length(split_query) == 1
        count = 1;
        for i = 1:size(pair, 1)
            if sum(ismember(split_query, pair{i, 2})) >= 1
                for j=1:size(bundle{i,1}, 2)
                    if sum(size(fieldnames(bundle{i,1}))) > 2  
                        selectedHE = [selectedHE;bundle{i,1}(1,j)];
                    end
                end
            end
        end
    else
        count = 1;
%         for i = 1:size(pop, 1)
%             if sum(ismember(split_query, pop(i, 1).text)) >= length(split_query)
%                 buffer{count, 1} = pair{i, 2};
%                 count = count + 1;
%                 if count == BUFF_SIZE + 1
%                     selectedHE = [selectedHE; buffer];
%                     count = 1;
%                 end
%             end
%         end
    end
    disp('Clearning training data');
    clear bundle;
    clear pair;
    pop = selectedHE;
    disp('Loading test data');
    pair_name = sprintf('./testpair1.mat');
    load([pair_path pair_name]);
    bundle_name = sprintf('./testbundle1.mat');
    load([bundle_path bundle_name]);
    
    bundle_score = zeros(size(test_bundle, 1),1);    %similarity scores
    disp('Estimating the similarity between visual query and test image');
    if isempty(selectedHE)
        disp([split_query ' is not exist']);
    else
        pop_bundle = zeros(size(pop, 1), K);
        pop_size = zeros(size(pop, 1), 1);            
        for i=1:size(pop,1)        
            if ~isempty(fieldnames(pop(i, 1))) 
                pop_bundle(i, pop(i, 1).features) = 1;
                pop_size(i, 1) = pop_size(i, 1)+length(pop(i, 1).features);
                %pop_size(i, 1) = length(pop(i, 1).bundle.features);
            end
        end     
        pop_bundle = pop_bundle .* repmat(pop_size, 1, K);
        norm = sum(pop_bundle, 2);         
        for i=1:size(test_bundle, 1)
            img_bundle = zeros(K, size(test_bundle{i, 1}, 2)); 
            if size(fieldnames(test_bundle{i,1}), 1) < 2
                continue;
            end
            for j = 1:size(test_bundle{i, 1}, 2)
                img_bundle(test_bundle{i, 1}(j).features, j) = 1;
            end
            cmp_bundle = pop_bundle * img_bundle;
            cmp_bundle = cmp_bundle ./ repmat(norm, 1, size(test_bundle{i, 1}, 2));
            cmp_bundle(cmp_bundle < FEATURE_THRESHOLD) = 0;
            for j = 1:size(cmp_bundle, 1)
                for k=1:size(cmp_bundle, 2)
                    hist_score = sum(sum(abs(pop(j, 1).hist - test_bundle{i, 1}(k).hist)));
                    hist_weight = sum(sum(pop(j, 1).hist, 2) ~= 0) / 255;     
                    cmp_bundle(j, k) = (FEATURE_COEFF * cmp_bundle(j, k) + HIST_COEFF * hist_weight * (1 - hist_score));
                end
            end              
            bundle_score(i,1) = bundle_score(i,1) + sum(sum(cmp_bundle));            
            if mod(i, 10) == 0
                aa = sprintf('%d',i);
                disp(aa);
            end
        end        
    end
    disp('Writing images');
    [B, idx] = sort(bundle_score, 'descend');
    for i=1:20
        name = sprintf([pool_name '/%d_%d.jpg'], i, idx(i));
        imwrite(test_pair{idx(i),1}, name);
    end
    clear test_pair;
    clear test_bundle;
end
