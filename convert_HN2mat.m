load('Pororo/genPop/up3_13.mat');
load('dic.mat');

total_patch_num = 8053;

HN_matrix = cell(size(dic,1)+total_patch_num+1);

HN_matrix(2:size(dic,1)+1,1) = dic(:,1);
HN_matrix(1,2:size(dic,1)+1) = dic(:,1)';

cnt = 1;
for i=2+size(dic,1):2+size(dic,1)+total_patch_num
    HN_matrix{i,1} = cnt;
    HN_matrix{1,i} = cnt;
    cnt = cnt+1;
end

for i=1:size(pop,1)
    pop
end
