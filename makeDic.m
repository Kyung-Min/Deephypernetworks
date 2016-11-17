function makeDic()
%% loading 'binding words list'
run 'configure';
% run 'bindingwords_list';

%% make dictionary
dic = [];
counted_dic = [];
pair_list = dir(pair_path);
test_pair = [];
pair = [];

for i = 3:size(pair_list, 1)
    load([pair_path '/' pair_list(i, 1).name]);
    for j = 1:size(pair, 1)
        sentence = pair{j, 2}; 
        for k = 1:size(sentence, 2)
            if ismember(sentence{1, k}, dic) == 0 % dic�� �ܾ ������ �߰�
                dic = [dic; sentence(1, k)];                
            end
            if isempty(counted_dic)
                tmp = cell(1,1); tmp{1,1} = 1;
                counted_dic = [counted_dic; sentence(1,k) tmp];
            else 
                [~,idx] = ismember(sentence{1, k}, counted_dic(:,1));
                if  idx == 0
                    tmp = cell(1,1); tmp{1,1} = 1;
                    counted_dic = [counted_dic; sentence(1,k) tmp];
                else
                    counted_dic{idx, 2} = counted_dic{idx, 2} + 1;
                end
            end
        end        
    end
    for j = 1:size(test_pair, 1)
        sentence = test_pair{j, 2};
        for k = 1:size(sentence, 2)
            if ismember(sentence{1, k}, dic) == 0 % dic�� �ܾ ������ �߰�
                dic = [dic; sentence(1, k)];                
            end                
        end        
    end
    
end

counted_dic = sortrows(counted_dic, -2);
mkdir(dic_path);
save([dic_path '/' 'dic.mat'], 'dic');
save([dic_path '/' 'counted_dic.mat'], 'counted_dic');
xlswrite([dic_path '/' 'dic.xls'], dic);
xlswrite([dic_path '/' 'counted_dic.xls'], counted_dic);
save('./allwords.mat', 'dic');

end
