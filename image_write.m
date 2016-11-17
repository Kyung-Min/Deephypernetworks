load('/media/kmkim/BACKUP/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH2/Pororo_ENGLISH2_1/Preprocessing/Pair/pair_Pororo_ENGLISH2_1_ep3.mat');

for i=18:size(pair, 1)
    imwrite(pair{i,1}, sprintf('Generated_imgs_txt_answers/%d.jpg', i-17));
    
    f_id = fopen(['Generated_imgs_txt_answers/' num2str(i-17) '.txt'], 'wb');
    for j=1:size(pair{i,2}, 2)
        fprintf(f_id, '%s ', pair{i,2}{1,j}); 
    end
    fprintf(f_id, '\n');
    fclose(f_id);
end

