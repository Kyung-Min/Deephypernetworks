img_folder_name = dir(image_path);
img_num = [];
bad_num = [];
for i=3:size(img_folder_name, 1)
    idx = find(img_folder_name(i).name=='_');
    img_num(i-2,1) = str2num(img_folder_name(i).name(1:idx(1,1)-1));      
    if img_folder_name(i).bytes < 1
        bad_num = [bad_num;img_num(i-2,1)];
    else
        img_path = strcat(image_path, '/', img_folder_name(i).name);
        img = imread(img_path);
        num = size(img, 3);
        if num < 3
            bad_num = [bad_num;img_num(i-2,1)];
        end
    end       
end

