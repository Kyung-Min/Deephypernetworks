function [gen_data, selected_idx] = generate(pop, seed_region, seed_keyword, regionDB, img_leng, txt_leng)
% 하이퍼넷을 구성하는 에지들 중에서 주어진 img, text 키워드를 포함하는 데이터를 생성한다.
selected_pop = [];
selected_idx = [];
gen_data = cell(1,2);
for i=1:size(pop, 1)
    he = pop(i,1);
    for j=1:size(he.i_DBidx, 2)
        clusters(1, j) = regionDB{he.i_DBidx(1, j),1}.region_cluster;
    end
    if sum(ismember(seed_region, clusters)) > 0        
        selected_pop = [selected_pop; he];
        selected_idx = [selected_idx; i];
    elseif sum(ismember(seed_keyword, he.t_words)) > 0
        selected_pop = [selected_pop; he];
        selected_idx = [selected_idx; i];
    end
end
if size(selected_idx, 1) < 1
    return
end
img_pop = [];text_pop = [];img_cnt = 1;txt_cnt = 2;img_idx = [];text_pop = [];img_score = [];text_score = [];
for i=1:size(selected_pop, 1)
    for j=1:size(selected_pop(i,1).i_idx, 2)
        img_idx = [img_idx; [selected_pop(i,1).i_DBidx(1, j) selected_pop(i,1).weight]];        
    end
    for j=1:size(selected_pop(i,1).t_idx, 1)
        text_pop = [text_pop; selected_pop(i,1).t_words(j,1)];
        text_score = [text_score; selected_pop(i,1).weight];
    end
end

for i=1:size(img_idx, 1)
    if sum(ismember(img_pop, img_idx(i, 1))) < 1
        img_pop(1, img_cnt) = img_idx(i, 1);
        img_score(1, img_cnt) = img_idx(i, 2);
        img_cnt = img_cnt + 1;
    else
        found_idx = find(ismember(img_pop, img_idx(i, 1)));
        img_score(1, found_idx) = img_score(1, found_idx) + img_idx(i, 2);
    end        
end
tmp_text = text_pop(1,1);
tmp_text_score = text_score(1, 1);
for i=2:size(text_pop, 1)
    if sum(ismember(tmp_text, text_pop(i, 1))) < 1
        tmp_text = [tmp_text; text_pop(i, 1)];
        tmp_text_score(txt_cnt, 1) = text_score(i, 1);
        txt_cnt = txt_cnt + 1;
    else
        found_idx = find(ismember(tmp_text, text_pop(i, 1)));
        tmp_text_score(found_idx, 1) = tmp_text_score(found_idx, 1) + text_score(i, 1);
    end       
end
% img_pop = unique(img_idx);    
% text_pop = unique(text_pop);    
[txt_srt txt_idx] = sort(tmp_text_score, 'descend');
if size(txt_srt, 1) > txt_leng
    text_pop = tmp_text(txt_idx(1:txt_leng), 1);
else
    text_pop = tmp_text(txt_idx(1:size(txt_srt, 1)), 1);
end
[img_srt img_srt_idx] = sort(img_score, 'descend');
if size(img_srt, 2) > img_leng
    img_pop = img_pop(1, img_srt_idx(1:img_leng));
else
    img_pop = img_pop(1, img_srt_idx(1:size(img_pop, 2)));
end
gen_data{1,1} = img_pop;
gen_data{1,2} = text_pop;

end