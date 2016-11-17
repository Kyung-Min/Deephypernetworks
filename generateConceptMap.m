function generateConceptMap(word, pop, mode)
run configure;
load([dic_path '/dic.mat']);

%% make directory for saving
folder_name = sprintf('genMap/%s', word);
mkdir(folder_name);

%% connection information�� vertex�� �ش��ϴ� pop�� ������ ���� ����
words_num = size(dic, 1); 
net = zeros(words_num, words_num);

%% weight�� ��� ���
pop_size = size(pop, 1);
weight_sum = 0;
for i = 1:pop_size
    weight_sum = weight_sum + pop(i, 1).weight;
end
weight_mean = weight_sum / pop_size;

%% ��� weigth �̻��� ���� HE ����
for i = 1:pop_size
    text = unique(pop(i, 1).text);
    if pop(i, 1).weight >= weight_mean && ismember(word, text) == 1
        % dic���� �ش� idx ã��
        text_leng = length(text);
        text_idx = zeros(text_leng, 1);
        for j = 1:text_leng
            text_idx(j, 1) = find(ismember(dic, text(1, j)) == 1);
        end
        % net�� �ܾ� ������ ���� ���� & bowl�� �ܾ �ش��ϴ� HE ����
        for j = 1:text_leng
            for k = 1:text_leng
                net(text_idx(j, 1), text_idx(k, 1)) = 1;
                net(text_idx(k, 1), text_idx(j, 1)) = 1;
            end
        end
    end
end

%% ���� ����
for i = 1:words_num
    net(i, i) = 0;
end

%% edges csv ����
edges_name = [folder_name '/' 'edges.xls'];
edges_csv = [];
for i = 1:words_num
    for j = 1:words_num
        if net(i, j) == 1
            edges_csv = [edges_csv; dic(i,1), dic(j, 1)];
        end
    end
end

%% vertices csv ����
vertices_name = [folder_name '/' 'vertices.xls'];
vertices_csv = [];    
words_idx = find(sum(net) > 0)';
for i = 1:size(words_idx, 1)
    vertex_name = dic(words_idx(i, 1)); 
    vertices_csv = [vertices_csv; vertex_name, cell(1, 14), vertex_name, cell(1, 6)];
end 

if strcmp(mode, 'VL')
    bowl = cell(words_num, 1);
    for i = 1:size(pop, 1)
        for j = 1:size(words_idx, 1)
            word = dic(words_idx(j, 1));
            text = unique(pop(i, 1).text);
            if pop(i, 1).weight >= weight_mean && ismember(word, text) == 1
                bowl{words_idx(j, 1), 1} = [bowl{words_idx(j, 1), 1}; pop(i, 1)];
            end
        end
    end
    for i = 1:size(words_idx, 1)
        % bowl�� weight�� ���� ����
        [~, X] = sort([bowl{words_idx(i, 1)}.weight], 'descend');
        temp = size(bowl{words_idx(i, 1)}, 1);
        if temp > 3
            sub_vertex_size = 3;
        else
            sub_vertex_size = temp;
        end
        for j = 1:sub_vertex_size
            % super vertex�� sub vertex�� ���� �߰�
            super_vertex_name = dic{words_idx(i, 1), 1};
            sub_vertex_name = [super_vertex_name sprintf('_%d', j)];
            edges_csv = [edges_csv; {super_vertex_name}, sub_vertex_name];        
            % subvertex image �߰�
            img = bowl{words_idx(i, 1)}(X(1, j), 1).bundle.img;
            img_name = [folder_name '/' sub_vertex_name '.jpg'];
            imwrite(img, img_name);
            vertices_csv = [vertices_csv; sub_vertex_name, cell(1, 9), 'Image', '3.5', cell(1, 1), ['./' img_name], cell(1, 8)];
        end
    end
    %% ���� �̹����� ��� �ϳ��� ����� (���� ����)
    filelist = dir([folder_name '/*.jpg']);
    for j = 1:length(filelist)
        filename = [folder_name '/' filelist(j).name];
        a = imread(filename);
        for k = j + 1:length(filelist)
            filename = [folder_name '/' filelist(k).name];
            b = imread(filename);
            if sum(size(a) == size(b)) == 3 && isempty(find((a == b) == false, 1))
                edges_csv = [edges_csv; {strtok(filelist(j).name, '.')}, {strtok(filelist(k).name, '.')}];
            end
        end
    end
    filelist = dir([folder_name '/*.jpg']);
    for j = 1:length(filelist)
        filename = [folder_name '/' filelist(j).name];
        if exist(filename) ~= 0
            a = imread(filename);
            same_img = [];
            for k = j + 1:length(filelist)
                filename = [folder_name '/' filelist(k).name];
                if exist(filename) ~= 0
                    b = imread(filename);
                    if sum(size(a) == size(b)) == 3 && isempty(find((a == b) == false, 1))
                        same_img = [same_img; {filelist(k).name}];
                    end
                end
            end
        end
        for k = 1:size(same_img, 1)
            delete([folder_name '/' same_img{k, 1}]);
        end            
        for k = 1:size(vertices_csv, 1)
            vertices_name = vertices_csv{k, 1};
            for l = 1:size(same_img, 1)
                img_name = strtok(same_img{l, 1}, '.');
                if strcmp(vertices_name, img_name)
                    vertices_csv{k, 1} = strtok(filelist(j).name, '.');
                    vertices_csv{k, 14} = ['./' folder_name '/' filelist(j).name];
                end
            end  
        end
        for k = 1:size(edges_csv, 1)
            edges_name1 = edges_csv{k, 1};
            edges_name2 = edges_csv{k, 2};
            for l = 1:size(same_img, 1)
                img_name = strtok(same_img{l, 1}, '.');
                if strcmp(edges_name1, img_name)
                    edges_csv{k, 1} = strtok(filelist(j).name, '.');                        
                end
                if strcmp(edges_name2, img_name)
                    edges_csv{k, 2} = strtok(filelist(j).name, '.');                        
                end
            end  
        end            
    end
    max_size = size(edges_csv, 1);
    idx = 1;
    while idx <= max_size
        if strcmp(edges_csv{idx, 1}, edges_csv{idx, 2})
            edges_csv(idx, :) = [];
            max_size = max_size - 1;
            idx = idx - 1;
        end
        idx = idx + 1;
    end
end

xlswrite([folder_name '\' 'edges.xls'], edges_csv);
xlswrite([folder_name '\' 'vertices.xls'], vertices_csv);
end

