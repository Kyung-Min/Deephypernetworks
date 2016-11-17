%% test for Video QA
load('/home/kmkim/Documents/Codes/HN_2015/HN/Sampling_policy2/HN_Pororo_ENGLISH2_1_ep2.mat');
content_path = '/media/kmkim/BACKUP/kkm/project/Kidsvideo/Pororo';
dic_path = [content_path '/Preprocessing/Dic'];
load([dic_path '/total_wordvec.mat']);

HE_tmp = HE(1:100);
q = 'what color is crong?';

%% extract word vectors in the video
content_word_list = [];
for i=1:length(HE_tmp)
    content_word_list = [content_word_list; HE_tmp(i).t_words];
end
content_word_list = unique(content_word_list);

content_word_vec_list = [];
for i=1:length(content_word_list)
    word = content_word_list(i);
    [~, idx] = ismember(word, total_wordvec(:,1));
    if idx == 0
        disp('the control should not reach here');
    end
    content_word_vec_list = [content_word_vec_list; total_wordvec(idx, 2:end)];
end
content_word_vec_list = cell2mat(content_word_vec_list);

%% extract word vectors in the question
q_word_list = [];
q_word_list = splitStn(q);
q_word_list = unique(q_word_list);

q_word_vec_list = [];
for i=1:length(q_word_list)
    word = q_word_list(i);
    [~, idx] = ismember(word, total_wordvec(:,1));
    if idx == 0
        disp('the control should not reach here');
    end
    q_word_vec_list = [q_word_vec_list; total_wordvec(idx, 2:end)];
end
q_word_vec_list = cell2mat(q_word_vec_list);

%% get candidate answers by calculating cosine distances of content word vecs and q word vecs
cand_word_idx_list = [];
for i=1:size(q_word_vec_list,1)
    q_word_vec = q_word_vec_list(i, :);
    best = 0;
    best_idx = 0;
    for j=1:size(content_word_vec_list,1)
        cos_dist = sum(q_word_vec .* content_word_vec_list(j,:)) / (norm(q_word_vec)*norm(content_word_vec_list(j,:)));
        if cos_dist > best
            best = cos_dist;
            best_idx = j;
        end
    end
    cand_word_idx_list = [cand_word_idx_list; best_idx];
end

cand_word_list = [];
for i=1:length(cand_word_idx_list)
    content_word_idx = cand_word_idx_list(i);
    cand_word_list = [cand_word_list; content_word_list(content_word_idx)];
end

%% get candidate HEs using candidate answers
cand_HEs = [];
for i=1:length(HE_tmp)
    for j=1:length(cand_word_list)
        [~, idx] = ismember(cand_word_list(j), HE_tmp(i).t_words); 
        if idx ~= 0
            cand_HEs = [cand_HEs; HE_tmp(i)];
            break;
        end
    end
end


for i=1:length(cand_HEs)
    for j=1:3
        cand_HEs(i).t_words(j)
    end
end