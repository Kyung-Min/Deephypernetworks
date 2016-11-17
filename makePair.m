function tmplist = makePair()
run 'configure';
tmplist = zeros(10000, 1);
%% make directory for saving
mkdir(pair_path);

global content_name;
%% make space for each season
% img_folder_list = dir(image_path);

% for i = 3 : size(img_folder_list, 1)
%% get image list
%     img_folder_name = img_folder_list(i).name;

%% load smi per image
smi_file_path = [smi_path '\' content_name '.smi'];
text_info = extractTextFromSMI(smi_file_path);

%% caption directory and file name
caption_dir = [content_path_prefix '/Preprocessing/captions'];
mkdir(caption_dir);
caption_name = sprintf('%s/%s_caption.txt', caption_dir, content_name); 
file_id = fopen(caption_name, 'w');

%% get number of pair
pair_num = size(text_info, 2);

%% make space for each pair
pair = [];

%% insert text and img
img_common_path = [image_path '/' ];%img_folder_name '/'];% img_folder_name '_' ];
for j = 1:pair_num          
   %% erase brace
    text = removeBrace(text_info(j).text);
    split_str = splitStn(text);
   %% uncontract words
    str = [];
    for k = 1:size(split_str, 2)
        str = [str, unContract(split_str{1, k})'];
    end
   %% remove funtional words
    str = removeFuncitonalWord(str);
   %% bind a collection of words
    str = bindWord(str);
    %% make caption
    for k=1:size(str, 2)
        fprintf(file_id, '%s ', str{k});
    end
    fprintf(file_id, '\n');
    %% make pair
    if isempty(str) == false           
        img_path = [img_common_path content_name sprintf('_%d', text_info(1, j).frame) '.bmp'];
        img = imread(img_path);
        pair = [pair; {img}, {str}];
    end
end
%% save img and text
pair_name = sprintf([pair_path '/pair_' content_name '.mat']);
save(pair_name, 'pair', '-v7.3');
fclose(file_id);
end

%% function for erasing a [~] from input text
function outStn = removeBrace(inStn)

start_idx = find(ismember(inStn, '[') == 1);
end_idx = find(ismember(inStn, ']') == 1);
for i = 1:size(start_idx, 2)
    inStn([start_idx(i):end_idx(i)]) = ' ';
end
outStn = inStn;
end

%% function for extracting text from smi
function TextInfo = extractTextFromSMI(smi_filename)


if ~exist(smi_filename), error('No such a file.'); end
strs = textread(smi_filename,'%s', 'delimiter', '\n');

for i=1:length(strs)    
    one_line = strs{i};
    if isempty(one_line), continue; end
    [matchstr{i} splitstr{i}] = regexpi(one_line,'<sync [^>\n]*>','match', 'split');
end

i=2; k=1;
comp_str{1} = splitstr{1};
while i < length(strs)
    while isempty(matchstr{i}) && i < length(strs)     
        comp_str{k} = strcat(comp_str{k}, '<br>', splitstr{i});
        i=i+1;
    end
	comp_str{k} = strcat(comp_str{k}, '<br>', splitstr{i}{1});
    
    if i==length(strs), break; 
    else
        k=k+1;
        frame_str{k} = regexpi(matchstr{i},'(?<=sync [^>\n]*start[ ]*=[ ]*)\d+','match'); 
        comp_str{k} = splitstr{i}{2};
        i=i+1;
    end
end
comp_str{1} = ' ';
    

for k=1:length(comp_str)
    refined_str{k} = regexprep(comp_str{k}, '<br>',' ');
    refined_str{k} = regexprep(refined_str{k}, '<BR>',' ');
    refined_str{k} = regexprep(refined_str{k}, '��','');
    refined_str{k} = regexprep(refined_str{k}, '-lt','');
    refined_str{k} = regexprep(refined_str{k}, '-',' ');
    refined_str{k} = regexprep(refined_str{k}, '"','');
    refined_str{k} = regexprep(refined_str{k}, '?',' ');
    refined_str{k} = regexprep(refined_str{k}, '!',' ');
    refined_str{k} = regexprep(refined_str{k}, '~',' ');
    refined_str{k} = regexprep(refined_str{k}, '\...','');
    refined_str{k} = regexprep(refined_str{k}, '\.',' ');
    refined_str{k} = regexprep(refined_str{k}, '\,',' ');
    refined_str{k} = regexprep(refined_str{k}, '\..',' ');
    refined_str{k} = regexprep(refined_str{k}, '\...',' ');
    refined_str{k} = regexprep(refined_str{k}, '������','');
    refined_str{k} = regexprep(refined_str{k}, '  ',' ');
    refined_str{k} = regexprep(refined_str{k}, '''ll',' will');
    refined_str{k} = regexprep(refined_str{k}, '''m',' am');
    refined_str{k} = regexprep(refined_str{k}, '''re',' are');
    refined_str{k} = regexprep(refined_str{k}, '''ve',' have');
    refined_str{k} = regexprep(refined_str{k}, 'n''t',' not');
    refined_str{k} = regexprep(refined_str{k}, '<[^\n]*?>|[ ]*&[ \w;]*|<!--[^\e]*-->','');
    refined_str{k} = lower(refined_str{k});
end

i=1;
for k=2:length(comp_str)
    if isempty(refined_str{k}), continue;  end
    TextInfo(i).frame = str2double(frame_str{k}{1});
    if iscell(refined_str{k})
        TextInfo(i).text = refined_str{k}{1};
    else
        TextInfo(i).text = refined_str{k};
    end
    i=i+1;
end
end