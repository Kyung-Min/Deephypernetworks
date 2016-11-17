%% function for getting words from the given text as cell array. 
function words = splitStn(text)

DEL_PUNC_LIST = '-.(),!?:;''';
%words = regexp(text,'\S+(?=\s+)','match'); 
words = regexp(text,'\S+(?=\s)','match'); 
words = regexp(text, '\s', 'split');

REG_del_punc_list_ending = ['[', DEL_PUNC_LIST, ']$'];
REG_del_punc_list_starting = ['^[', DEL_PUNC_LIST, ']'];
for i = 1:size(words,2)
    words(i) = regexprep(words(i), REG_del_punc_list_ending,'');   % -.,!?' 
    words(i) = regexprep(words(i), REG_del_punc_list_ending,'');   % -.,!?' 
    words(i) = regexprep(words(i), REG_del_punc_list_starting,'');   % -.,!?' 
    words(i) = regexprep(words(i), REG_del_punc_list_starting,'');   % -.,!?' 
    words(i) = lower(words(i));
end
end