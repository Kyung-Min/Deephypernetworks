load('pr_recall_for_flickr.mat')

for i=31:49
    prediction = zeros(1, size(dic, 1));
    gen_text_list = pr_recall{i,3};
    for j=1:30%size(gen_text_list, 1)
     [~, idx] = ismember(gen_text_list{j,1}, dic);
     if idx == 0
         fprintf('error\n');
         idx = randi(size(dic, 1));
     end
     prediction(1, idx) = 1;
    end

    label = zeros(1, size(dic, 1));
    for j=1:size(pr_recall{i,4}, 2)
     [~, idx] = ismember(pr_recall{i,4}{1,j}, dic);
     if idx == 0
         fprintf('error\n');
         idx = randi(size(dic, 1));
     end
     label(1, idx) = 1;
    end

    pr_recall{i,1} = size(find(prediction(1,:) .* label(1,:)),2) / size(find(prediction(1,:)),2);
    pr_recall{i,2} = size(find(prediction(1,:) .* label(1,:)),2) / size(find(label(1,:)),2);
    pr_recall{i,3} = gen_text_list;
end

pr_recall_tmp = [];
for i=31:49
    if pr_recall{i,1} > 0
        pr_recall_tmp = [pr_recall_tmp; 1 pr_recall{i,2}];
    else
        pr_recall_tmp = [pr_recall_tmp; pr_recall{i,1} pr_recall{i,2}];
    end
end

mean(pr_recall_tmp(:, 1))
            