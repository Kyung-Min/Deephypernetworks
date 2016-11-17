function pop = cmpBundle2Img()
run 'configure';
pop = [];

mkdir('./genPop3_5000/');

%% load Dic
load([dic_path './dic.mat']);


%% load preprocessing
disp('Loading data');
pair_name = sprintf('./pair1.mat');
load([pair_path pair_name]);
bundle_name = sprintf('./bundle1.mat');
load([bundle_path bundle_name]);


%%training data 의 크기를 설정하는 부분
tmp = pair;
pair = cell(data_size, 2);

for m=1:size(pair,1)
    pair(m, :) = tmp(m, :);
end

tmp = bundle;
bundle = cell(data_size, 2);
for m=1:size(bundle,1)
    bundle(m, :) = tmp(m, :);
end   

disp('The 1st epoch');

       
% %% 새로 HE 만들기
patch_cnt = zeros(30000, 1);
words_cnt = zeros(size(dic, 1), 1);

for m=1:data_size
    st = sprintf('The %dth data instance===============', m);
    disp(st); 
    if size(fieldnames(bundle{m, 1})) < 2
        pop_name = sprintf('pop%d.mat', m);    
        save(['./genPop3_5000/' pop_name], 'pop', '-v7.3');         
        continue;
    end
    %% 기존 에지들이 포함한 정보를 갖지 않은 새로운 정보에 대해 어드벤티지를 주기위해 카운팅하는 부분
    for i=1:size(pop, 1)
        for j=1:size(pop(i,1).bundle,2)
            patch_cnt(pop(i,1).bundle(j).idx, 1) = patch_cnt(pop(i,1).bundle(j).idx, 1)+1;
        end
        aa = ismember(dic, pop(i,1).text);
        words_cnt(:,1) = words_cnt(:,1)+aa;
    end    
    if size(pop, 1) >= max_size
        kind = 1;
    else
        kind = 0;
    end
    HE = sampling(pair(m, 2), bundle(m,1), kind, m);
    
    %% 만들어진 HE를 현재 데이터에 대해 학습
    HE = cmpHE(HE, pair(m, 2), bundle(m,1), dic, 0, patch_cnt, words_cnt);
    if m ~= 1
    	pop = cmpHE(pop, pair(m, 2), bundle(m,1), dic, 1, patch_cnt, words_cnt);
    end 
    %clear pair  bundle;
    
    %% 만들어진 HE를 이전 데이터에 대해 학습
%     for j = 1:(i - 1)
%         pair_name = sprintf('./pair%d.mat', j);
%         load([pair_path pair_name]);
%         bundle_name = sprintf('./bundle%d.mat', j);
%         load([bundle_path bundle_name]);
%         HE = cmpHE(HE, pair(:, 2), bundle, dic);
%         clear pair  bundle;
%     end
    
    %% 만들어진 HE를 pop에 추가
%     pop = [pop; HE];
    
    %% i편까지 학습된 pop을 저장
%     pop_name = sprintf('pop%d.mat', m);
%     save(['./genPop/' pop_name], 'pop', '-v7.3');
    
    pair_num = ceil(cut_ratio*size(HE,1));
    
    temp = zeros(size(HE,1), 1);
    for j = 1:size(HE, 1)
        temp(j, 1) = HE(j, 1).weight;
    end
    [B, idx] = sort(temp, 'descend');
    
    

    if size(HE, 1) == 1
        HE = [];
    else
        tmp = struct;
        for j=1:(size(HE,1)-pair_num)
            tmp(j,1).text = HE(idx(j), 1).text;
            tmp(j,1).bundle = HE(idx(j), 1).bundle;
            tmp(j,1).weight = HE(idx(j), 1).weight;
            tmp(j,1).img_idx = HE(idx(j), 1).img_idx;
        end
        HE = tmp;
        clear tmp;
    end   
    for j=1:size(pop,1)
        pop(j, 1).weight = pop(j, 1).weight*decay_ratio;
    end
    for j=1:epoch
        HER = resampling(pair(m, 2), bundle(m,1), pair_num, m); 
        HER = cmpHE(HER, pair(m, 2), bundle(m,1), dic, 0, patch_cnt, words_cnt);           
        HE = [HE; HER];
        temp = zeros(size(HE,1), 1);
        for j = 1:size(HE, 1)
            temp(j, 1) = HE(j, 1).weight;
        end
        [B, idx] = sort(temp, 'descend');
        if size(HE, 1) < 2
            HE = [];
        else
            tmp = struct;
            pair_num = ceil(cut_ratio*size(HE,1));
            for k=1:(size(HE,1)-pair_num)
                tmp(k,1).text = HE(idx(k), 1).text;
                tmp(k,1).bundle = HE(idx(k), 1).bundle;
                tmp(k,1).weight = HE(idx(k), 1).weight;
                tmp(k,1).img_idx = HE(idx(k), 1).img_idx;
            end    
            HE = tmp;      
            clear tmp;
        end
    end
    if (size(pop,1) >= max_size)
        temp = zeros(size(pop,1), 1);
        for j = 1:size(pop, 1)
            temp(j, 1) = pop(j, 1).weight;
        end
        [B, idx] = sort(temp, 'descend');
        tmp = struct;
        for k=1:max_size-size(HE, 1);
            tmp(k,1).text = pop(idx(k), 1).text;
            tmp(k,1).bundle = pop(idx(k), 1).bundle;
            tmp(k,1).weight = pop(idx(k), 1).weight;
            tmp(k,1).img_idx = HE(idx(k), 1).img_idx;
        end    
        pop = tmp;     
    end
    pop = [pop; HE];
    if mod(m, 100) == 0
        pop_name = sprintf('pop%d.mat', m);    
        save(['./genPop3_5000/' pop_name], 'pop', '-v7.3');  
    end
end
end

function HE = sampling(text_data, bundle, kind, m)
run 'configure';
pair_num = size(text_data, 1);
%HE = struct;
HE = [];
count = 1;
if kind < 1
    sam_num = sampling_rate;
else
    sam_num = ceil(max_size*rep_ratio);
end
for i = 1:pair_num
    %% bundle이 존재할 경우 sampling
    if ~isempty(fieldnames(bundle{1, 1}))
        % sampling 중복 체크를 위한 shelter 생성
        shelter = cell(sam_num, i_order + t_order);
        text = unique(text_data{1, 1});
        %text = text_data{i,1}; %For generating sentences
        length = size(text, 2);
        for j = 1:sam_num    
            if size(bundle{1,1}, 2) <= i_order
                for k=1:size(bundle{1,1}, 2)
                    shelter{j, k} = k;
                end
                for k=size(bundle{1,1}, 2)+1:i_order
                    shelter{j, k} = k;
                end
            else
            i_idx = randsample(size(bundle{1, 1}, 2), i_order, false);
                [sorted_patch, ~] = sort(i_idx);
                for k=1:i_order            
                     shelter{j, k} = sorted_patch(k,1);
                end
            end
            if length <= 3
                shelter(j,i_order+1:size(text, 2) + i_order) = text(1:length);
            else
                idx = randperm(length);
%                 shelter(j,2) = text(idx(1));
%                 shelter(j,3) = text(idx(1)+1);
%                 shelter(j,4) = text(idx(1)+2);
                for k=1:t_order
                    shelter(j,i_order + k) = text(idx(k));
                end
            end
        end
        temp = cellfun(@isempty, shelter);
        addpath('./Mytoolbox/Cell');
        shelter(temp) = {-1};
        shelter = uniqueRowsCA(shelter, 'rows');
        for j = 1:size(shelter, 1)
            for k = 1:size(shelter, 2)
                if shelter{j, k} == -1
                    shelter{j, k} = [];
                end
            end
        end
        for j = 1:size(shelter, 1)
            he = struct;
            length = t_order - sum(cellfun(@isempty, shelter(j, i_order+1:i_order+t_order)));
            he.text = shelter(j, i_order+1:i_order+t_order);
            maxiter=0;
            if size(bundle{1,1}, 2) <= i_order
                maxiter = size(bundle{1,1}, 2);
            else
                maxiter = i_order;
            end
            for k=1:maxiter
                he.bundle(1,k) = bundle{1, 1}(shelter{j, k});
            end
            for k=maxiter+1:i_order
                he.bundle(1,k) = bundle{1, 1}(shelter{j, maxiter});
            end             
            he.weight = 0;
            he.img_idx = m;
            HE = [HE;he];
        end
    end
end
end

function HE = resampling(text_data, bundle, pair_num, m)
run 'configure';
HE = [];
count = 1;
for i = 1:1
    %% bundle이 존재할 경우 sampling
    if ~isempty(fieldnames(bundle{1, 1}))
        % sampling 중복 체크를 위한 shelter 생성
        shelter = cell(pair_num, i_order + t_order);
        text = unique(text_data{1, 1});
        %text = text_data{i,1}; %For generating sentences
        length = size(text, 2);
        maxiter=0;
        if size(bundle{1,1}, 2) <= i_order
            maxiter = size(bundle{1,1}, 2);
        else
            maxiter = i_order;
        end        
        for j = 1:pair_num
            i_idx = randsample(size(bundle{1, 1}, 2), maxiter, false);
            [sorted_patch, ~] = sort(i_idx);
            for k=1:maxiter            
                 shelter{j, k} = sorted_patch(k,1);
            end           
            if length <= 3
                shelter(j,i_order+1:size(text, 2) + i_order) = text(1:length);
            else
                idx = randperm(length);
%                 shelter(j,2) = text(idx(1));
%                 shelter(j,3) = text(idx(1)+1);
%                 shelter(j,4) = text(idx(1)+2);
                for k=1:t_order
                    shelter(j,k + i_order) = text(idx(k));
                end
            end
        end
        temp = cellfun(@isempty, shelter);
        shelter(temp) = {-1};
        shelter = uniqueRowsCA(shelter, 'rows');
        for j = 1:size(shelter, 1)
            for k = 1:size(shelter, 2)
                if shelter{j, k} == -1
                    shelter{j, k} = [];
                end
            end
        end
        for j = 1:size(shelter, 1)
            he = struct;
            length = t_order - sum(cellfun(@isempty, shelter(j, i_order+1:i_order+t_order)));
            he.text = shelter(j, i_order+1:i_order+t_order);
            for k=1:maxiter
                he.bundle(1,k) = bundle{1, 1}(shelter{j, k});
            end
            for k=maxiter+1:i_order
                he.bundle(1,k) = bundle{1, 1}(shelter{j, maxiter});
            end            
            he.weight = 0;
            he.img_idx = m;
            HE = [HE;he];
        end
    end
end
end

function pop = cmpHE(pop, text_data, bundle, dic, kind, patch_cnt, words_cnt)
run 'configure';

if kind(1) < 1
    ratio = 0;
else
    ratio = alp;
end
%% pop에서 pop size * dic size의 text 정보를 가지고 있는 배열 생성
pop_text = zeros(size(pop, 1), size(dic, 1));

for i = 1:size(pop, 1)
    for j = 1:size(pop(i,1).text,2)
        if isempty(pop(i,1).text{j})
            pop(i,1).text = pop(i,1).text(:,1:j-1);
        break;
        end
    end
    pop_text(i, ismember(dic, pop(i,1).text) == 1) = 1;
    
end
pop_text = sparse(pop_text);
%% compare pop text with image text
img_text = zeros(size(dic, 1), 1);
img_text(ismember(dic, text_data{1, 1}) == 1) = 1;
cmp_text = pop_text * img_text;
%% 주어진 이미지의 번들을 incidence matrix로 변환
img_bundle = zeros(K, size(bundle{1, 1}, 2));  
if ~isempty(fieldnames(bundle{1,1}))
    for j = 1:size(bundle{1, 1}, 2)
        img_bundle(bundle{1, 1}(j).features, j) = 1;
    end
end   
%% pop에서 pop size * K의 bundle 정보를 가지고 있는 배열 생성
for m=1:i_order
    pop_bundle = zeros(size(pop, 1), K);
    pop_size = zeros(size(pop, 1), 1);
    for i = 1:size(pop, 1)
        if ~isempty(fieldnames(pop(i, 1).bundle)) 
            pop_bundle(i, pop(i, 1).bundle(1,m).features) = 1;
            pop_size(i, 1) = pop_size(i, 1)+length(pop(i, 1).bundle(1,m).features);
            %pop_size(i, 1) = length(pop(i, 1).bundle.features);
        end
    end
    %pop_bundle = sparse(pop_bundle);
    % pop_size = pop_size / (image_width * image_height);    
    pop_bundle = pop_bundle .* repmat(pop_size, 1, K);
    norm = sum(pop_bundle, 2);

%for i = 1:size(bundle, 1)
    %% compare pop bundle with image bundle
 
    cmp_bundle = pop_bundle * img_bundle;
    cmp_bundle = cmp_bundle ./ repmat(norm, 1, size(bundle{1, 1}, 2));
    cmp_bundle = cmp_bundle .* repmat(cmp_text ~= 0, 1, size(bundle{1, 1}, 2)); %1보다 크면 1을 곱하고 아니면 0을 곱해서 텍스트가 하나라도 맞으면 그대로 두는 부분
    cmp_bundle(cmp_bundle < FEATURE_THRESHOLD) = 0;
    
    %% 일정 값 이상의 점수를 가진 bundle을 선택하여 hist 차이를 추가
    [row, col] = find(cmp_bundle >= FEATURE_THRESHOLD);
    for j = 1:size(row, 1)
        r = row(j, 1);
        c = col(j, 1);
        hist_score = sum(sum(abs(pop(r, 1).bundle(m).hist - bundle{1, 1}(c).hist)));
        hist_weight = sum(sum(pop(r, 1).bundle(m).hist, 2) ~= 0) / 255;     
        cmp_bundle(r, c) = FEATURE_COEFF * cmp_bundle(r, c) + HIST_COEFF * hist_weight * (1 - hist_score);
        cmp_bundle(r, c) = cmp_bundle(r, c)*(cmp_text(r, 1)*cmp_text(r, 1)/(sum(img_text, 1)*sum(img_text, 1))); %매칭되는 텍스트워드가 많을수록 유리하게 보정
    end    
    
    %% 계산한 점수를 pop에 추가
    score = max(cmp_bundle, [], 2);    
    for j = 1:size(pop, 1)
        v_part = 1/(patch_cnt(pop(j, 1).bundle(m).idx, 1)+1);
        aa = words_cnt(ismember(dic, pop(j,1).text)==1, 1)+1;
        w_part = sum(1./aa);
        if (kind < 1)
            pop(j, 1).weight = pop(j, 1).weight*ratio + (1-ratio)*score(j, 1)+v_part*w_part;
        else
            %pop(j, 1).weight = pop(j, 1).weight*ratio + (1-ratio)*score(j, 1);
            pop(j, 1).weight = pop(j, 1).weight + score(j, 1);
        end
    end
end
end

