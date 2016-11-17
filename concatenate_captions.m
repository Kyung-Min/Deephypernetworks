CORPUS_FILE_NAME = 'D:\kkm\project\Kidsvideo\Pororo\pororo_all_caption(17dvds).txt';
f = fopen(CORPUS_FILE_NAME, 'r');
sentence_cell = textscan(f,'%s','Delimiter','\n');
sentence_cell = sentence_cell{1,1};

tmp = cell(1,1);
tmp{1,1} = ' ';
for i=1:size(sentence_cell, 1) -2
    sentence_cell{i,1} = strcat(sentence_cell{i,1}, tmp, sentence_cell{i+1,1}, tmp, sentence_cell{i+2,1});%, tmp, sentence_cell{i+3,1});
end

conv_id = fopen('D:\kkm\project\Kidsvideo\Pororo\pororo_all_caption_3words(17dvds).txt', 'w');
for i=1:size(sentence_cell, 1)-2
    fprintf(conv_id, '%s\n', sentence_cell{i,1}{1,1});
end
fclose(f);