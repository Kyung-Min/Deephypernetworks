function [pop, tot_nHE] = makeHyperedge(text_data, bundle, pre, content_name, episode_name, counted_dic, counted_QPororo_dic, tot_nHE, pp)
    run 'configure';
    pop = [];

    counted_dic = counted_dic.counted_dic;
    counted_QPororo_dic = counted_QPororo_dic.counted_QPororo_dic;
    
    if size(text_data, 2) < t_order
        text_data = [text_data text_data text_data];
    end

    sr = size(text_data, 2)-(t_order-1); 
    max_rank = find(cell2mat(counted_dic(:,2)) == 1, 1);

    ranks = zeros(1, size(text_data, 2));
    p = zeros(1, size(text_data, 2));
    for i=1:size(ranks, 2)
        word = text_data(i);
        if SAMPLING_POLICY == 0
            [~, ranks(i)] = ismember(word, counted_dic(:,1));
            if ranks(i) > max_rank || ranks(i) == 0
                ranks(i) = max_rank;
            end
            p(i) = 1 + (rank(i) - 1) * -1 / (max_rank - 1) + 0.01;
        elseif SAMPLING_POLICY == 1
            counted_dic = sortrows(counted_dic, 2);
            rank_discount_val = size(counted_dic, 1) - max_rank;
            [~, ranks(i)] = ismember(word, counted_dic(:,1));
            if ranks(i) <= rank_discount_val+1
                ranks(i) = 1;
            else
                ranks(i) = ranks(i) - rank_discount_val;
            end
                p(i) = 1 + (ranks(i) - 1) * -1 / (max_rank - 1);
        elseif SAMPLING_POLICY == 2
            p(i) = 0.5;
        elseif SAMPLING_POLICY == 3
            p(i) = rand;
        end
    end

    p = p ./ sum(p);

    edge_cnt = 0;
    while(edge_cnt < 3)
        for i=1:sr
            words = [];
            for j=i:i+t_order-1
                words = [words; text_data(j)];
            end

            p_tmp = zeros(1, t_order);
            for j=1:t_order
                p_tmp(j) = p(i+j-1); 
            end
            max_p = max(p_tmp);

            for j=1:SAMPLING_RATE
                gen_num = rand(1);
                if gen_num >= max_p
                    edge_cnt = edge_cnt + 1;
                    HE = struct;
                    HE.dup = 1;
                    tmp = cell(1,4);
                    tmp{1,1} = content_name;
                    tmp{1,2} = episode_name;
                    tmp{1,3} = pp;
                    HE.file = tmp;
                    HE.t_weight = 0;
                    HE.i_weight = 0;
                    HE.t_cover = [];
                    HE.i_cover = [];
                    HE.weight = 1.0;
                    tot_nHE = tot_nHE + 1;
                    HE.idx = tot_nHE;
                    if i == 1
                        HE.t_flag = 0; % 0 means the start of the sentence
                    elseif i == sr
                        HE.t_flag = 2; % 2 means the last of the sentence
                    else
                        HE.t_flag = 1;
                    end
                    img_data = bundle;
                    if size(img_data{1, 1}, 2) >= i_order
                        HE.file{1,4} = (randsample(size(img_data{1, 1}, 2), i_order, false))';
                    else
                        HE.file{1,4} = ones(1, 2);
                    end  
                    for k=1:size(words)
                        HE.t_words{k,1} = words{k,1};
                    end
                    % Object vector
                    HE_vec = zeros(1, img_voc_size + txt_voc_size);
                    HE_vec(1, 1:(length(pre)-1)) = pre(1:(length(pre)-1)); % char
                    for k=1:i_order % img
                        patch_idx = HE.file{1,4}(k);
                        if bundle{1,1}(patch_idx).score >= 0.7
                            obj_idx = bundle{1,1}(patch_idx).object;
                            HE_vec(1, (length(pre)-1)+obj_idx) = 1;
                        else
                            HE_vec(1, img_voc_size) = 1;
                        end 
                    end
                    
                    for k=1:t_order
                        word = HE.t_words{k,1};
                        [~, idx] = ismember(word, counted_QPororo_dic(:,1));
                        if idx > txt_voc_size
                            continue; 
                        end
                        HE_vec(1, img_voc_size + idx) = 1;
                    end
                    % HE vector
                    HE.voc_vec = HE_vec; % 31 dims(img obj) + 800 dims(words)
                    pop = [pop; HE];
                end
            end    
        end
    end
end