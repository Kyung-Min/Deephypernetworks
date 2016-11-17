%% Make Dictionary for Question + Pororo words
function makeDic_for_QPororowords()
run 'configure';

Q_dic = [];
Q_dic = countQWords();

save([dic_path '/Q_dic.mat'], 'Q_dic'); 
load([dic_path '/' 'counted_dic.mat']);

% combine with question words
counted_dic = combine_QDic_PororoDic(Q_dic, counted_dic);

save([dic_path '/' 'counted_QPororo_dic.mat'], 'counted_dic');
end

%% make dictionary
function Q_dic = countQWords()
    pair_path = '/media/kmkim/cfe3bb2a-9516-4747-b061-03475877634a/kmkim/Documents/Project/AAAI2016/Data/Pororo Q&A Data/Preprocessing/Pair';
    pair_list = dir(pair_path);
    Q_dic = [];
    for i = 3:size(pair_list, 1)
        load([pair_path '/' pair_list(i, 1).name]);
        for j = 1:size(pair, 1)
            sentence = pair{j, 2}; 
            for k = 1:size(sentence, 2)
                if isempty(sentence{1,k}) || strcmp(sentence{1,k}, ',') || strcmp(sentence{1,k}, '?')
                    continue;
                end
                word = lower(sentence{1,k});
                if ismember(word, Q_dic) == 0
                    tmp = cell(1,1); tmp{1,1} = word;
                    Q_dic = [Q_dic; tmp];                
                end
            end        
        end
    end
end

function counted_dic = combine_QDic_PororoDic(Q_dic, counted_dic)
    for i=1:size(Q_dic, 1)
        word = Q_dic{i,1};
        [~,idx] = ismember(word, counted_dic(:,1));
        if idx == 0
            tmp = cell(1,1); tmp{1,1} = 1;
            counted_dic = [word tmp; counted_dic];
        else
            cnt = counted_dic{idx, 2};
            tmp = cell(1,1); tmp{1,1} = cnt;
            counted_dic(idx, :) = ''; % deletion
            counted_dic = [word tmp; counted_dic];
        end
    end
end