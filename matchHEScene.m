function newHE = matchHEScene(HE, scenes, subtitles, patch_indices, same_patch_matrix)
    matching = 0;
    newHE = HE;
    for i=1:size(scenes, 1)
    %     aa = dot(HE.concepts, presence(i, :))/max(sum(presence(i, :)), sum(HE.concepts));
    %     if aa < 0
    %         continue;
    %     end
        sumval = sum(ismember(subtitles{i, 1}, HE.t_words))/size(HE.t_words, 1); %size(HE.t_idx, 2);
        if sumval > 0.8
            matching = matching+1;
            newHE.t_cover = [newHE.t_cover i];
        end
        cnt = 0;
        for j=1:size(newHE.file{1,4}, 2)      
            if newHE.file{1,3} > 1
                row_val = sum(patch_indices(1:newHE.file{1,3}-1, 1))+newHE.file{1,4}(1, j);
            else
                row_val = newHE.file{1,4}(1, j);
            end
            if i > 1
                col_val = sum(patch_indices(1:i-1, 1))+1;
            else
                col_val = 1;
            end
            tmp_same_vector = same_patch_matrix(row_val, :);
            if sum(tmp_same_vector(1, col_val:col_val+patch_indices(i, 1)-1)) > 0
                cnt = cnt + 1;
            end
        end
        if cnt > 0
            newHE.i_cover = [newHE.i_cover i];
        end
    end
end


