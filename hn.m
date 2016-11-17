% Selecct HEs from the clustered HEs
configure;
% 
% he = [];
% score = [];
% char_pre = [];
% char_pre_tmp = [];
% sentence_cell = [];
% 
% for i=1:SERIES_NUM
%     CORPUS_FILE_NAME = sprintf('pororo_caption%d.txt',i);
%     f = fopen(CORPUS_FILE_NAME, 'r');
%     sentence_cell_tmp = textscan(f,'%s','Delimiter','\n');
%     sentence_cell = [sentence_cell; sentence_cell_tmp{1,1}];
%     fclose(f);
%     PRESENCE_FILE_NAME = sprintf('character_presence%d.mat',i);
%     c = load(PRESENCE_FILE_NAME);
%     char_pre_tmp = [char_pre_tmp; c.character_presence];
% end
% 
% dic = [];
% for sentence_idx=1 : size(sentence_cell,1)
%     word_list = strsplit(sentence_cell{sentence_idx, 1}, ' ');
%     for tmp=size(word_list, 2):-1:1
%        word_list(tmp+1) = word_list(tmp); 
%     end
%     word_list{1,1} = '<s>';
%     word_list{1,size(word_list, 2) + 1} = '</s>';
%     if size(word_list, 2) >= ORDER
%         t = 1;
%         for i=1 : size(word_list, 2)-(ORDER-1)
%             words = [];
%             for j=t : t+ORDER-1
%                 words = [words word_list(j)];
%             end
%             he = [he; words];
%             score = [score; 1];
%             char_pre = [char_pre; char_pre_tmp(sentence_idx, :)];
%             t = t+1;
%         end
%         
%         for i=1:size(word_list,2)
%             index = -1;
%             for j=1:size(dic, 1)
%                 if strcmp(word_list{1,i}, dic{j,1})
%                    index = j;
%                 end
%             end
%             if index == -1
%                tmp = cell(1,1);
%                tmp{1,1} = 1;
%                dic = [dic; [word_list{1,i} tmp]];
%             else
%                dic{index,2} = dic{index,2} + 1;
%             end
%         end
%     end
%     % 단어의 개수가 ORDER보다 작은 경우는?
%    disp(sentence_idx);
% end
% 
% dic = sortrows(dic, 1);

% he, score, char_pre가 만들어져 있어야함
load([Updated_HE_dir_pre int2str(Sampling_policy) '\HN\Updeted_HN_' int2str(Ep_idx) '.mat']);
load([Updated_HE_dir_pre int2str(Sampling_policy) '\HE_assgnm\Learning_rate' int2str(Learning_rate) '\HE_assgnm_' int2str(Ep_idx) '.mat']);

%이제 캐릭터를 가장 잘 포함하는 클러스터를 골라야 함.....
best_cluster_idx = [];
c_dir_pre = [Updated_HE_dir_pre int2str(Sampling_policy) '\cluster\Learning_rate' int2str(Learning_rate)];
char_dist_cluster = zeros(nCluster, nChar+1);
for i=1:nCluster
    char_file_name = [c_dir_pre '\' int2str(Ep_idx) '\' int2str(i) '\' int2str(i) '_char.txt'];
    f = fopen(char_file_name);
    tmp_cell = textscan(f,'%s','Delimiter','\n');
    tmp_cell = tmp_cell{1,1};
    for j=1:nChar
        char_dist = tmp_cell{j,1};
        prob = strsplit(char_dist, ':');
        if strcmp(prob{1,2}, ' NaN')
            prob = 0;
        else
            prob = str2double(prob{1,2});
        end
        char_dist_cluster(i,j) =  prob;
    end
    char_dist_cluster(i,nChar+1) =  i;
    fclose(f);
end

for i=1:size(char_idx, 1)
    char_dist_cluster = sortrows(char_dist_cluster, char_idx(i,1) * -1);
    for j=1:nCharBestC
        best_cluster_idx = [best_cluster_idx; char_dist_cluster(j, nChar+1)];
    end
end

he = [];
score = [];
char_pre = [];
t_flag = [];
for i=1:size(pop,1)
    isGoodC = 0;
    for j=1:nCharBestC
        if HE_assgnm(i) == best_cluster_idx(j)
            isGoodC = true;
        end
    end
    if isGoodC
        he = [he; pop(i,1).t_words'];
        score = [score; 1];
        char_pre = [char_pre; pop(i,1).concepts];
        t_flag = [t_flag; pop(i,1).t_flag];
    else
        continue;
    end
            
end


% eliminate duplicate hyperedges, summate score
weighted_he = [he(1,:) score(1,:) t_flag(1,:) char_pre(1,:)];
for i=2 : size(he, 1)
   index = -1;
   for j=1:size(weighted_he, 1)
       if ismember(he(i,1:ORDER), weighted_he(j,1:ORDER))
           index = j;
           break;
       end       
   end
   if index == -1
       tmp = [he(i,:) score(i,:) t_flag(i,:) char_pre(i,:)];
       weighted_he = [weighted_he; tmp];
   else
       weighted_he{index, ORDER+1} = weighted_he{index, ORDER+1} + score(i,1);
       weighted_he{index, ORDER+3} = weighted_he{index, ORDER+2} + char_pre(i,:);
   end
   disp(i);
end
weighted_he = sortrows(weighted_he, -4); % sorting
    
% save(sprintf('txt_net_%s',  MAT_FILE_NAME), 'txt_net', '-v7.3');    
save(MAT_FILE_NAME, 'weighted_he', '-v7.3');
% save(sprintf('dic_%s',  MAT_FILE_NAME), 'dic', '-v7.3');