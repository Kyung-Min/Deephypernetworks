function key_corpus = Corpus_Search(corpus_list, key, order, ODM1)
    key_corpus = [];
    
    for r=1:size(corpus_list, 1)
        if ODM1 == 1
            for c=1:order
               if strcmp(corpus_list{r,c}, key)
                   tmp_cell = corpus_list(r,:);
                   key_corpus = [key_corpus; tmp_cell]; 
               end
            end
        else
            if sum(ismember(key, corpus_list(r,1:order))) == size(key, 2)
                tmp_cell = corpus_list(r,:);
                key_corpus = [key_corpus; tmp_cell]; 
            end
        end     
    end
end