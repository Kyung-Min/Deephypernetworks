function make_instance_mat
    %% make instance matrix for whole Pororo set
    % 900 dims for SIFT hist + 1000 dims for RGB hist + 1900 dims for word
    % count vec + 38 dims for characters

    global content_path;
    content_path = '/home/ci/ci/Documents/kkm/mirflickr';
    global content_name;
    content_name = 'MIRFLICKR_10000';
    tot_mat = [];
    
    for i=1:50
        tot_mat = make_inst_mat_for_ep(tot_mat, ['MIRFLICKR_10000_' num2str(i)]);
    end
    save('tot_flickr_instance.mat', 'tot_mat', '-v7.3');
end

function tot_mat = make_inst_mat_for_ep(tot_mat, ep_name)
    global content_path;
    global content_name;
    
    K = 300;
    COLOR_HIST_DIM = 1000;
    disp(ep_name);
    bundle_path = [content_path '/Preprocessing/Bundle'];
    load([bundle_path '/' content_name '/bundle_' ep_name '.mat']);
    cp_path = [content_path '/Preprocessing/CP'];
    load([cp_path '/' content_name '/cp_' ep_name '.mat']);
    pair_path = [content_path '/Preprocessing/Pair'];
    load([pair_path '/' content_name '/pair_' ep_name '.mat']);
    
    dic_path = [content_path '/Preprocessing/Dic'];
    load([dic_path '/dic.mat']);
    for i=1:size(bundle,1)
        img_vec = zeros(1, K*3 + COLOR_HIST_DIM*2);
        word_vec = zeros(1, size(dic, 1));
        char_vec = [];

        for j=1:size(bundle{i,1}, 2)
            img_vec = img_vec + bundle{i,1}(1,j).img_vector;
        end
        
        for j=1:size(pair{i,2}, 2)
            [~, idx] = ismember(pair{i,2}{1,j}, dic);
            if idx == 0
                continue;
            end
            word_vec(1, idx) = word_vec(1, idx) + 1;
        end
        
        char_vec = cp(i, 1:38);
        instance = [img_vec word_vec char_vec];
        tot_mat = [tot_mat; instance];
    end
end