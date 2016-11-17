%% find a first found pair number given the query words
run 'configure'
query_words = splitStn('crong take this and go to loopy house first');
found_flag = 0;

content_name = 'Pororo_ENGLISH2_1';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH2_2';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH2_3';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH2_4';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH3_1';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH3_2';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH3_3';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH3_4';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH4_1';
for i=1:6
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH4_2';
for i=1:6
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH4_3';
for i=1:7
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_ENGLISH4_4';
for i=1:7
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_Rescue';
for i=1:7
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_The Racing Adventure';
for i=1:7
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_English_education_1';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_English_education_2';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end
content_name = 'Pororo_English_education_3';
for i=1:13
    episode_name = [content_name '_ep' num2str(i)];
    load([pair_path '/' content_name '/pair_' episode_name '.mat']);
    
    for j=1:size(pair,1)
        if sum(ismember(query_words, pair{j,2})) == size(query_words, 2) 
            found_flag = 1;
        end
        if found_flag
            fprintf('%d seq in %s\n', j, episode_name);
            return;
        end
    end
end