function expandImg(pop)

query = {'rabbit';};
for i = 1:size(query, 1)
    expandingImg(query{i, 1}, pop);
end
end

function expandingImg(query, pop)
selectedHE = [];
BUFF_SIZE = 100;

%% select hyperedges which has a quey in population
split_query = regexp(query, '\s', 'split');
buffer = cell(BUFF_SIZE, 1);
if length(split_query) == 1
    count = 1;
    for i = 1:size(pop, 1)
        if sum(ismember(split_query, pop(i, 1).text)) >= 1
            buffer{count, 1} = pop(i, 1);
            count = count + 1;
            if count == BUFF_SIZE + 1
                selectedHE = [selectedHE; buffer];
                count = 1;
            end
        end
    end
else
    count = 1;
    for i = 1:size(pop, 1)
        if sum(ismember(split_query, pop(i, 1).text)) >= length(split_query)
            buffer{count, 1} = pop(i, 1);
            count = count + 1;
            if count == BUFF_SIZE + 1
                selectedHE = [selectedHE; buffer];
                count = 1;
            end
        end
    end
end
selectedHE = [selectedHE; buffer(1:count - 1)];
temp = zeros(size(selectedHE, 1), 1);
for i = 1:size(selectedHE, 1)
    temp(i, 1) = selectedHE{i, 1}.weight;
end
[B, idx] = sort(temp, 'descend');
dir_name = ['./genImg/testrabbit/'];
mkdir(dir_name);
rabbit_words = selectedHE{idx(2), 1}.text;
name = sprintf([dir_name 'test_love.jpg']);
imwrite(selectedHE{idx(20), 1}.bundle.img, name);
expandingImgImg(selectedHE{idx(20), 1}.bundle, pop);
end

function expandingImgImg(bundleIdx, pop)
selectedHE = [];
BUFF_SIZE = 100;


buffer = cell(BUFF_SIZE, 1);
count = 1;
for i=1:size(pop, 1)
    aa = sum(ismember(bundleIdx.features, pop(i,1).bundle.features));
    bb = aa /size(pop(i,1).bundle.features,2);
    if aa >= 20 && bb > 0.4
        buffer{count, 1} = pop(i, 1);
         count = count + 1;
        if count == BUFF_SIZE + 1
            selectedHE = [selectedHE; buffer];
            count = 1;
        end
    end
end   
selectedHE = [selectedHE; buffer(1:count - 1)];
if isempty(selectedHE)
    disp(['not exist']);
else
    temp = zeros(size(selectedHE, 1), 1);
    for i = 1:size(selectedHE, 1)
        temp(i, 1) = selectedHE{i, 1}.weight;
    end
    [B, idx] = sort(temp, 'descend');
    dir_name = ['./genImg/i2itestrabbit/'];
    mkdir(dir_name);
    for i = 1:size(B, 1)
        name = sprintf([dir_name '%d.jpg'], i);
        imwrite(selectedHE{idx(i), 1}.bundle.img, name);
    end
end
end


